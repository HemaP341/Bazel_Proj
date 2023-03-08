# Load the Bazel C/C++ toolchain support.
# The Skylark library provides functions for building the C/C++ toolchain
# configuration (CcToolchainConfigInfo). The functionsa are documented at
# https://docs.bazel.build/versions/master/cc-toolchain-config-reference.html.
load(
  "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
  "action_config",
  "artifact_name_pattern",
  "feature",
  "flag_group",
  "flag_set",
  "tool",
)

# Load the name of all the C/C++ build actions.
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

# Configures the Keil MDK-ARM C/C++ toolchain. The function defines how to
# execute each of the C/C++ build actions.
def _impl(ctx):
  # Define the name of the toolchain.
  toolchain_identifier = "arm-none-keil"
  host_system_name = "local"
  target_system_name = "arm-none"
  target_cpu = "arm"
  target_libc = "unknown"
  compiler = "armcc"
  abi_version = "unknown"
  abi_libc_version = "unknown"

  # Define the path to the toolchain.
  tool_path = "C:/Program Files (x86)/Keil/ARM/ARMCC/bin"
  compiler_path = tool_path + "/armcc.exe"
  assembler_path = tool_path + "/armasm.exe"
  archiver_path = tool_path + "/armar.exe"
  linker_path = tool_path + "/armlink.exe"
  strip_path = tool_path + "/fromelf.exe"

  # Define the compilation of C code (".o" files from ".c" files).
  # The command line interface is defined by features. Features allow actions to
  # share common flags. The "implies" attribute enables the feature, but the
  # feature must also apply to the action. The "implies" attribute can be
  # removed if all features are enabled by default ("enabled" is True), but the
  # "implies" attribute makes the relationship more explicit.
  c_compile_action = action_config(
    action_name = ACTION_NAMES.c_compile,
    tools = [tool(path = compiler_path)],
    implies = [
      "source_file",
      "output_file",
      "dependency_file",
      "include_paths",
      "default_compile_flags",
      "user_compile_flags",
    ],
  )

  # Define the compilation of assembly code (".o" files from ".s" files).
  assemble_action = action_config(
    action_name = ACTION_NAMES.assemble,
    tools = [tool(path = assembler_path)],
    implies = [
      "source_file",
      "output_file",
    ],
  )

  # Define the archiving of libraries (".a" files from ".o" files).
  archive_action = action_config(
    action_name = ACTION_NAMES.cpp_link_static_library,
    tools = [tool(path = archiver_path)],
    implies = [
      "object_files",
      "output_file",
    ],
  )

  # Define the linking of executables (".exe" files from ".a" and ".o" files).
  link_action = action_config(
    action_name = ACTION_NAMES.cpp_link_executable,
    tools = [tool(path = linker_path)],
    implies = [
      "object_files",
      "output_file",
      "default_link_flags",
      "user_link_flags",
    ],
  )

  # Define the striping of debug symbols from executables.
  # The stripped executable is loaded onto the embedded device for performance.
  strip_action = action_config(
    action_name = ACTION_NAMES.strip,
    tools = [tool(path = strip_path)],
    implies = [
    ],
  )

  # Group the actions to minimize their scope.
  action_configs = [
    c_compile_action,
    assemble_action,
    archive_action,
    link_action,
    strip_action,
  ]

  # Define the input of the source file on the command line.
  # The C, C++, or assembly source file is the only unlabeled argument to the
  # compiler or assembler.
  source_file_feature = feature(
    name = "source_file",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.c_compile,
          ACTION_NAMES.assemble,
        ],
        flag_groups = [
          flag_group(
            flags = ["%{source_file}"],
          ),
        ],
      ),
    ],
  )

  # Define the output of the dependency file on the command line.
  # The dependency file lists all of the header files included by the source
  # file. The build system uses the dependencies to determine when the source
  # file needs to be re-compiled.
  dependency_file_feature = feature(
    name = "dependency_file",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.c_compile,
        ],
        flag_groups = [
          flag_group(
            flags = [
              "--depend", "%{dependency_file}",
              "--depend_format=unix_escaped",
              "--no_depend_system_headers",
            ]
          ),
        ],
      ),
    ],
  )

  # Define the input of the include paths on the command line.
  # The build system organizes the include paths into groups. All of the groups
  # are included for simplicity. However, experiments have shown that the
  # transitive includes are stored in system.
  include_paths_feature = feature(
    name = "include_paths",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.c_compile,
        ],
        flag_groups = [
          flag_group(
            iterate_over = "include_paths",
            flags = ["-I", "%{include_paths}"],
          ),
          flag_group(
            iterate_over = "quote_include_paths",
            flags = ["-I", "%{quote_include_paths}"],
          ),
          flag_group(
            iterate_over = "system_include_paths",
            flags = ["-I", "%{system_include_paths}"],
          ),
        ],
      ),
    ],
  )

  # Define the input of object files on the command line.
  # The object files are the only unlabeled argument to the archiver and linker.
  # The feature is designed to iterate over all of the object files in the
  # action.
  object_files_feature = feature(
    name = "object_files",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.cpp_link_static_library,
          ACTION_NAMES.cpp_link_executable,
        ],
        flag_groups = [
          flag_group(
            iterate_over = "libraries_to_link",
            flags = ["%{libraries_to_link.name}"],
          ),
        ],
      ),
    ],
  )

  # Define the output of files on the command line.
  # The "output" alias is more explicit, but is not supported by the assembler.
  # The object file uses a different build variable than the library file and
  # executable file.
  output_file_feature = feature(
    name = "output_file",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.c_compile,
          ACTION_NAMES.assemble,
        ],
        flag_groups = [
          flag_group(
            flags = ["-o", "%{output_file}"],
          ),
        ],
      ),
      flag_set(
        actions = [
          ACTION_NAMES.cpp_link_static_library,
        ],
        flag_groups = [
          flag_group(
            flags = ["--create", "%{output_execpath}"],
          ),
        ],
      ),
      flag_set(
        actions = [
          ACTION_NAMES.cpp_link_executable,
        ],
        flag_groups = [
          flag_group(
            flags = ["-o", "%{output_execpath}"],
          ),
        ],
      ),
    ],
  )

  # Define the default compilation on the command line.
  # The default flags configure language and static analsyis features that are
  # common to the whole code base.
  default_compile_flags_feature = feature(
    name = "default_compile_flags",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.assemble,
          ACTION_NAMES.c_compile,
        ],
        flag_groups = [
          flag_group(
            flags = [
              "-c",
              #"--warnings_are_errors",
            ],
          ),
        ],
      ),
    ],
  )

  # Define the custom compilation on the command line.
  # The user flags are defined by each library in the build rule. They are used
  # to configure features that only apply to one library. For example, to enable
  # a new language feature or supress a warning. The flags are not inherited by
  # dependecies. The feature is designed to iterate over all of the flags in the
  # action. If user flags are not specified, then the build varaible will not be
  # available.
  user_compile_flags_feature = feature(
    name = "user_compile_flags",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.assemble,
          ACTION_NAMES.c_compile,
        ],
        flag_groups = [
          flag_group(
            iterate_over = "user_compile_flags",
            expand_if_available = "user_compile_flags",
            flags = ["%{user_compile_flags}"],
          ),
        ],
      ),
    ],
  )

  # Define the default linking on the command line.
  # The default flags configure optimization and static analsyis features that
  # are common to the whole code base.
  default_link_flags_feature = feature(
    name = "default_link_flags",
    # flag_sets = [
    #   flag_set(
    #     actions = [ACTION_NAMES.cpp_link_executable],
    #     flag_groups = [
    #       flag_group(
    #         flags = [
    #           "--strict",
    #           "--warnings_are_errors",
    #           "--semihosting", # need your own startup code.
    #         ],
    #       ),
    #     ],
    #   ),
    # ],
  )

  # Define the custom linking on the command line.
  # The user flags are defined by each executable in the build file. They are
  # used configure features that only apply to one executable. For example, to
  # enable an optimization that may not be safe for all applications. The
  # feature is designed to iterate over all of the flags in the action.
  user_link_flags_feature = feature(
    name = "user_link_flags",
    flag_sets = [
      flag_set(
        actions = [ACTION_NAMES.cpp_link_executable],
        flag_groups = [
          flag_group(
            iterate_over = "user_link_flags",
            expand_if_available = "user_link_flags",
            flags = ["%{user_link_flags}"],
          ),
        ],
      ),
    ],
  )

  # Define the output of debug symbols on the command line.
  # The "dbg" feature is a built-in feature that is automatically enabled in
  # debug builds (-c dbg). The "--debug" alias is more explicit, but is not
  # supported by the assembler.
  dbg_feature = feature(
    name = "dbg",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.assemble,
          ACTION_NAMES.c_compile,
        ],
        flag_groups = [
          flag_group(
            flags = ["-g"],
          ),
        ],
      ),
    ],
  )

  # Define the output of optimizations on the command line.
  # The "opt" feature is a built-in feature that is automatically enabled in
  # optimized builds (-c opt).
  opt_feature = feature(
    name = "opt",
    flag_sets = [
      flag_set(
        actions = [
          ACTION_NAMES.c_compile,
        ],
        flag_groups = [
          flag_group(
            flags = ["-O2"],
          ),
        ],
      ),
    ],
  )

  # Remove all built-in actions so that they can be redefined. Otherwise,
  # actions are automatically added to the tool chain configuration and only
  # features can be redefined.
  no_legacy_features_feature = feature(name = "no_legacy_features")

  # Group the features to minimize their scope.
  features = [
    # Compiler features.
    output_file_feature,
    source_file_feature,
    dependency_file_feature,
    include_paths_feature,
    default_compile_flags_feature,
    user_compile_flags_feature,
    # Archiver features.
    object_files_feature,
    # Linker feature
    default_link_flags_feature,
    user_link_flags_feature,
    # Built-in features.
    opt_feature,
    dbg_feature,
    no_legacy_features_feature,
  ]

  # Return the configuration.
  return cc_common.create_cc_toolchain_config_info(
    ctx = ctx,
    toolchain_identifier = toolchain_identifier,
    host_system_name = host_system_name,
    target_system_name = target_system_name,
    target_cpu = target_cpu,
    target_libc = target_libc,
    compiler = compiler,
    abi_version = abi_version,
    abi_libc_version = abi_libc_version,
    action_configs = action_configs,
    features = features,
  )

# Configures the Keil MDK-ARM C/C++ toolchain.
# The rule defines the interface used in build files. The attributes used by the
# implementation above.
cc_toolchain_config = rule(
  implementation = _impl,
  provides = [CcToolchainConfigInfo],
)

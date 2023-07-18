# Load the Bazel C/C++ toolchain support.
# The Starlark library provides functions for building the C/C++ toolchain
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
    "with_feature_set",
)

# Load the name of all the C/C++ build actions.
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

# Configures the IAR ARM C/C++ toolchain. The function defines how to execute
# each of the C/C++ build actions with IAR.
def _impl(ctx):
    # Define the name of the toolchain.
    toolchain_identifier = "arm-none-iar"
    host_system_name = "local"
    target_system_name = "arm-none"
    target_cpu = "arm"
    target_libc = "unknown"
    compiler = "iccarm"
    abi_version = "unknown"
    abi_libc_version = "unknown"

    # Define the path to the toolchain.
    tool_path = "C:/Program Files/IAR Systems/Embedded Workbench 9.1"
    compiler_path = tool_path + "/arm/bin/iccarm.exe"
    assembler_path = tool_path + "/arm/bin/iasmarm.exe"
    archiver_path = tool_path + "/arm/bin/iarchive.exe"
    linker_path = tool_path + "/arm/bin/ilinkarm.exe"
    strip_path = tool_path + "/arm/bin/ielftool.exe"

    # Define the target architecture for compilation.
    compile_target_flags = [
        "--cpu=" + ctx.attr.cpu_flag,
        "--fpu=" + ctx.attr.fpu_flag,
    ]
  
    # Define the target architecture for assembler.
    assembler_tar_flag = [
        "--cpu",
        ctx.attr.cpu_flag,
        "--fpu=" + ctx.attr.fpu_flag,
    ]

    # Define the compilation of C code (".c" files to ".o" files).
    c_compile_action = action_config(
        action_name = ACTION_NAMES.c_compile,
        tools = [tool(path = compiler_path)],
        flag_sets = [
            # Flags defined for all compilation modes.
            flag_set(
                flag_groups = [
                    # The source files to be compiled
                    flag_group(
                        flags = ["%{source_file}"],
                    ),
                    # The source file is compiled to an object file.
                    flag_group(
                        flags = ["-o", "%{output_file}"],
                    ),
                    # Other compiler flags
                    flag_group(
                        flags = [
                            "--debug",
                            "--endian=little",
                        ],
                    ),
                    # Tune performance to the target architecture.
                    flag_group(
                        flags = compile_target_flags,
                    ),
                    # The default flags configure language and static analysis features that
                    # are common to the whole code base.
                    
                    flag_group(
                        flags = [
                            "-e",
                            "--warnings_are_errors",
                            "--silent",
                            "--no_fragments",
                        ],
                    ),
                    # The user flags are defined by each library in the build rule. They
                    # are used to configure features that only apply to one library. For
                    # example, to enable a new language feature or suppress a warning. The
                    # flags are not inherited by dependencies.
                    flag_group(
                        # The feature is designed to iterate over all of the flags in the
                        # action. If user flags are not specified, then the build variable
                        # will not be available.
                        iterate_over = "user_compile_flags",
                        expand_if_available = "user_compile_flags",
                        flags = ["%{user_compile_flags}"],
                    ),
                    # The dependency file lists all of the header files included by the
                    # source file. The build system uses the dependencies to determine
                    # when the source file needs to be re-compiled.
                    flag_group(
                        flags = [
                            "--dependencies=ms",
                            "%{dependency_file}",
                        ],
                    ),
                    # The build system organizes the include paths into groups. All of the
                    # groups are included for simplicity. However, experiments have shown
                    # that the transitive includes are stored in system.
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
            # Flags defined for optimized builds (--compilation-mode opt).
            flag_set(
                with_features = [with_feature_set(features = ["opt"])],
                flag_groups = [
                    flag_group(
                        flags = [
                            "-oh",
                            "--no_fragments",
                            "--NDEBUG",
                        ],
                    ),
                ],
            ),
        ],
    )

    # Define the compilation of assembly code (".s" files to ".o" files).
    assemble_action = action_config(
        action_name = ACTION_NAMES.assemble,
        tools = [tool(path = assembler_path)],
        flag_sets = [
            # Flags defined for all compilation modes.
            flag_set(
                flag_groups = [
                    flag_group(
                        flags = [
                            "-s+", 
                            "-M<>", 
                            "-w+",
                            "-r",
                        ],
                    ),
                    flag_group(
                        flags =
                            assembler_tar_flag,
                    ),
                    #Source files to be compiled
                    flag_group(
                        flags = ["%{source_file}"],
                    ),

                    # The assembly file is compiled to an object file.
                    flag_group(
                        flags = [
                            "-o",
                            "%{output_file}",
                        ],
                    ),
                ],
            ),
        ],
    )

    # Define the archiving of libraries (".o" files to ".a" files).
    archive_action = action_config(
        action_name = ACTION_NAMES.cpp_link_static_library,
        tools = [tool(path = archiver_path)],
        flag_sets = [
            flag_set(
                flag_groups = [
                    # Each object file is added to the archive.
                    flag_group(
                        iterate_over = "libraries_to_link",
                        flags = ["%{libraries_to_link.name}"],
                    ),
                    #output path to generate .a files
                    flag_group(
                        flags = [
                            "-o",
                            "%{output_execpath}",
                        ],
                    ),
                ],
            ),
        ],
    )

    # Define the linking of executables (".a" and ".o" files to ".exe" files).
    link_action = action_config(
        action_name = ACTION_NAMES.cpp_link_executable,
        tools = [tool(path = linker_path)],
        flag_sets = [
            # Flags defined for all compilation modes.
            flag_set(
                flag_groups = [
                    # Each object file is added to the executable.
                    flag_group(
                        iterate_over = "libraries_to_link",
                        flags = ["%{libraries_to_link.name}"],
                    ),
                    #redirecting standard library functions, 
                    #specifying alternative versions of these functions, 
                    #and suppressing the addition of an extension to the output file name.
                    flag_group(
                        flags = [
                            "--redirect",
                            "_Printf=_PrintfFullNoMb",
                            "--redirect",
                            "_Scanf=_ScanfFullNoMb",
                            # "--no_out_extension",
                        ],
                    ),
                    # The executable is output the given file.
                    flag_group(
                        flags = [
                            "-o",
                            "%{output_execpath}",
                        ],
                    ),

                    # The user flags are defined by each executable in the build file.
                    # They are used configure features that only apply to one executable.
                    # For example, to enable an optimization that may not be safe for all
                    # applications.
                    flag_group(
                        iterate_over = "user_link_flags",
                        expand_if_available = "user_link_flags",
                        flags = ["%{user_link_flags}"],
                    ),
                    flag_group(
                        flags = [
                            "--entry",
                            "__iar_program_start",
                            "--vfe",
                            "--text_out",
                            "locale",
                            "--semihosting",
                        ],
                    ),

                    # Tune performance to the target architecture.
                    flag_group(
                        flags = compile_target_flags,
                    ),
                ],
            ),
            # Flags defined for optimized builds (--compilation-mode opt).
            flag_set(
                with_features = [with_feature_set(features = ["opt"])],
                flag_groups = [
                    flag_group(
                        flags = [
                            "-oh",
                        ],
                    ),
                ],
            ),
        ],
    )

    # Define the striping of debug symbols from executables.
    # The stripped executable is loaded onto the embedded device for performance.
    strip_action = action_config(
        action_name = ACTION_NAMES.strip,
        tools = [tool(path = strip_path)],
        flag_sets = [
            flag_set(
                flag_groups = [
                    flag_group(
                        flags = [
                            "--hex",
                            "%{input_file}",
                        ],
                    ),
                    flag_group(
                        flags = [
                            "-o", "%{output_file}.hex",
                        ],
                    ),
                ],
            ),
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

    # Remove all built-in actions and features so that they can be redefined.
    no_legacy_features = feature(name = "no_legacy_features")

    # Enable support for optimized builds (--compilation_mode opt).
    optimization_feature = feature(name = "opt")

    # Enable output of the linker map file.
    # generate_exe_file_feature = feature(name = "generate_exe_file", enabled = True)

    artifact_name_patterns = [
        artifact_name_pattern(
            category_name = "executable",
            prefix = "",
            extension = ".exe",
        ),
    ]

    # Group the features to minimize their scope.
    features = [
        no_legacy_features,
        optimization_feature,
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
        artifact_name_patterns = artifact_name_patterns,
    )

# Configures the ARM C/C++ toolchain.
# The rule defines the interface used in build files. The attributes used by the
# implementation above.
cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "cpu_flag": attr.string(mandatory = True, values = ["cortex-m4", "cortex-m33", "Cortex-M0+"]),
        "fpu_flag": attr.string(mandatory = False, values = ["None", "VFPv4_sp"]),
    },
    provides = [CcToolchainConfigInfo],
)

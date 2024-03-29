# Configures the IAR ARM C/C++ toolchain for the all supported CPUs.

# Load the IAR ARM C/C++ toolchain support.
# The Starlark functions encapsulate how to call the compiler with the correct
# options.
load(":cc_toolchain_config.bzl", "cc_toolchain_config")

# Declare the toolchain without any file dependencies.
# The Bazel rule must declare the files that comprise the toolchain so that
# Bazel can setup sandboxing. No files are needed because the toolchain is
# pre-installed on the system.
filegroup(name = "empty")

cc_toolchain(
    name = "cortex_m4f",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    tags = ["no-ide"],
    toolchain_config = ":cortex_m4f_config",
)

# Define how to execute each build action.
cc_toolchain_config(
    name = "cortex_m4f_config",
    cpu_flag = "cortex-m4",
    fpu_flag = "VFPv4_sp",
)

# Toolchain for Corect M33f
cc_toolchain(
    name = "cortex_m33f",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    tags = ["no-ide"],
    toolchain_config = ":cortex_m33f_config",
)

# Define how to execute each build action.
cc_toolchain_config(
    name = "cortex_m33f_config",
    cpu_flag = "cortex-m33",
    fpu_flag = "VFPv4_sp",
)

# Toolchain for Corect M0+
cc_toolchain(
    name = "cortex_m0+",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    tags = ["no-ide"],
    toolchain_config = ":cortex_m0+_config",
)

# Define how to execute each build action.
cc_toolchain_config(
    name = "cortex_m0+_config",
    cpu_flag = "Cortex-M0+",
    fpu_flag = "None",
)

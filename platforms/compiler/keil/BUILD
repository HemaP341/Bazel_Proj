# Configures the Keil MDK-ARM C/C++ toolchain for all supported CPUs.

# Load the Keil MDK-ARM C/C++ toolchain support.
# The Skylark functions encapsulate how to call the compiler with the correct
# options.
load(":cc_toolchain_config.bzl", "cc_toolchain_config")

# Declare the toolchain without any file dependencies.
# The Bazel rule must declare the files that comprise the toolchain so that
# Bazel can setup sandboxing. No files are needed because the toolchain is
# pre-installed on the system.
filegroup(name = "empty")
cc_toolchain(
  name = "cortex_m4f",
  toolchain_config = ":cortex_m4f_config",
  all_files = ":empty",
  compiler_files = ":empty",
  dwp_files = ":empty",
  linker_files = ":empty",
  objcopy_files = ":empty",
  strip_files = ":empty",
  supports_param_files = 0,
  tags = ["no-ide"],
)

# Define how to execute each build action.
cc_toolchain_config(name = "cortex_m4f_config")

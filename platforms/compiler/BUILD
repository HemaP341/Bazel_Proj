# Package overview.
# How are compilers intended to be used and extended?
package(default_visibility = ["//visibility:public"])

# Explain The GNU Compiler Collection and all its features. What platforms this
# configuration supports. Linux? Windows with MSYS2?
constraint_value(
  name = "gcc",
  constraint_setting = "@bazel_tools//tools/cpp:cc_compiler",
)

constraint_value(
  name = "iar",
  constraint_setting = "@bazel_tools//tools/cpp:cc_compiler",
)

constraint_value(
  name = "keil",
  constraint_setting = "@bazel_tools//tools/cpp:cc_compiler",
)

# Package overview.
# How are compilers intended to be used and extended?

# Toolchains overview.
toolchain(
  name = "cortex_m4f_gcc_windows",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m4f",
    "//platforms/compiler:gcc",
  ],
  toolchain = "//platforms/compiler/gcc/windows:cortex_m4f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m4f_gcc_linux",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:linux",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m4f",
    "//platforms/compiler:gcc",
  ],
  toolchain = "//platforms/compiler/gcc/linux:cortex_m4f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m4f_iar",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m4f",
    "//platforms/compiler:iar",
  ],
  toolchain = "//platforms/compiler/iar:cortex_m4f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m4f_keil",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m4f",
    "//platforms/compiler:keil",
  ],
  toolchain = "//platforms/compiler/keil:cortex_m4f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m33f_gcc_windows",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m33f",
    "//platforms/compiler:gcc",
  ],
  toolchain = "//platforms/compiler/gcc/windows:cortex_m33f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m33f_gcc_linux",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:linux",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m33f",
    "//platforms/compiler:gcc",
  ],
  toolchain = "//platforms/compiler/gcc/linux:cortex_m33f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m33f_iar",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m33f",
    "//platforms/compiler:iar",
  ],
  toolchain = "//platforms/compiler/iar:cortex_m33f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m33f_keil",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m33f",
    "//platforms/compiler:keil",
  ],
  toolchain = "//platforms/compiler/keil:cortex_m33f",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

# Cortex_m0+
toolchain(
  name = "cortex_m0+_gcc_windows",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m0+",
    "//platforms/compiler:gcc",
  ],
  toolchain = "//platforms/compiler/gcc/windows:cortex_m0+",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m0+_gcc_linux",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:linux",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m0+",
    "//platforms/compiler:gcc",
  ],
  toolchain = "//platforms/compiler/gcc/linux:cortex_m0+",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m0+_iar",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m0+",
    "//platforms/compiler:iar",
  ],
  toolchain = "//platforms/compiler/iar:cortex_m0+",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
  name = "cortex_m0f_keil",
  exec_compatible_with = [
    "@platforms//cpu:x86_64",
    "@platforms//os:windows",
  ],
  target_compatible_with = [
    "//platforms/cpu:cortex_m0+",
    "//platforms/compiler:keil",
  ],
  toolchain = "//platforms/compiler/keil:cortex_m0+",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)



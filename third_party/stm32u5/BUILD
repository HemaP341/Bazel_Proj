# Package overview
# The STM32CubeF4 and where to get it.
load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:selects.bzl", "selects")

# Supported microcontrollers (MCUs).
config_setting(
    name = "stm32u585oi",
    constraint_values = ["//platforms/mcu:stm32u585oi"],
)

# Supported compilers.
config_setting(
    name = "gcc",
    constraint_values = ["//platforms/compiler:gcc"],
)
config_setting(
    name = "iar",
    constraint_values = ["//platforms/compiler:iar"],
)
config_setting(
    name = "keil",
    constraint_values = ["//platforms/compiler:keil"],
)

# Supported platforms.
selects.config_setting_group(
    name = "stm32u585xx",
    match_any = [":stm32u585oi"],
)
selects.config_setting_group(
    name = "stm32u585xx_gcc",
    match_all = [":stm32u585xx", ":gcc"],
)
selects.config_setting_group(
    name = "stm32u585xx_iar",
    match_all = [":stm32u585xx", ":iar"],
)
selects.config_setting_group(
    name = "stm32u585xx_keil",
    match_all = [":stm32u585xx", ":keil"],
)

# Library overview
# Summarize how the CMSIS abstractions provides a common register interface for
# peripherals.
cc_library(
    name = "cmsis",
    defines = select({
        ":stm32u585oi": ["STM32U5xx"],
         "//conditions:default": [],
    }),
    includes = [
        "Drivers/CMSIS/Include",
        "Drivers/CMSIS/Device/ST/STM32U5xx/Include",
    ],
    hdrs = glob([
        "Drivers/CMSIS/Include/*.h",
        "Drivers/CMSIS/Device/ST/STM32U5xx/Include/*.h",
    ]),
    visibility = ["//visibility:public"],
)

# Summarize how the Hardware Abstraction Layer (HAL) provides drivers that use
# the CMSIS registeres to interact with peripherals. CMSIS driver templates are
# also part of the specification, but are incomplete, less maintained, and are
# simply a layer of indirection that calls these vendor specific functions.
cc_library(
    name = "hal",
    includes = ["Drivers/STM32U5xx_HAL_Driver/Inc"],
    hdrs =
        glob(["Drivers/STM32U5xx_HAL_Driver/Inc/**/*.h"]) +
        [":hal_conf"],
    srcs = select({
        ":stm32u585oi": glob(["Drivers/STM32U5xx_HAL_Driver/Src/*.c"]),
         "//conditions:default": [],
    }),
    deps = [":cmsis"],
    visibility = ["//visibility:public"],
)

# Enables all features of the Hardware Abstraction Layer (HAL).
genrule(
    name = "hal_conf",
    srcs = ["Drivers/STM32U5xx_HAL_Driver/Inc/STM32U5xx_hal_conf_template.h"],
    outs = ["Drivers/STM32U5xx_HAL_Driver/Inc/STM32U5xx_hal_conf.h"],
    cmd = "cp $< $@",
)

TEMPLATES_PATH = "Drivers/CMSIS/Device/ST/STM32U5xx/Source/Templates"

cc_library(
    name = "startup",
    srcs = select({
        ":stm32u585xx_gcc": [
            paths.join(TEMPLATES_PATH, "gcc/startup_stm32u585xx.s")],
        ":stm32u585xx_iar": [
            paths.join(TEMPLATES_PATH, "iar/startup_stm32u585xx.s")],
        ":stm32u585xx_keil": [
            paths.join(TEMPLATES_PATH, "arm/startup_stm32u585xx.s")],
        "//conditions:default": [],
    }),
    deps = [":system"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "system",
    srcs = select({
        ":stm32u585oi": [paths.join(TEMPLATES_PATH, "system_stm32u5xx.c")],
        "//conditions:default": [],
    }),
    deps = [":cmsis"],
)

cc_library(
    name = "linker",
    linkopts = select({
        ":gcc": ["-T$(location " + paths.join(TEMPLATES_PATH, "linker.ld)")],
        "//conditions:default": [],
    }),
    deps = [paths.join(TEMPLATES_PATH, "linker.ld")],
    visibility = ["//visibility:public"],
)

genrule(
    name = "linker.ld",
    srcs = selects.with_or({
        ":stm32u585xx_gcc": [
            paths.join(TEMPLATES_PATH, "gcc/linker/STM32U585xx_flash.ld")],
        ":stm32u585xx_iar": [
            paths.join(TEMPLATES_PATH, "iar/linker/stm32u585xx_flash.icf")],
        (":stm32u585xx_keil",
        "//conditions:default"): [
            paths.join(TEMPLATES_PATH, "arm/linker/stm32u585xx_flash.sct")],
    }),
    outs = [paths.join(TEMPLATES_PATH, "linker.ld")],
    cmd = "cp $< $@",
)

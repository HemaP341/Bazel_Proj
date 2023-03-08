# Package overview.
# How are MCUs intended to be used and extended? Explain how they are shared
# between compilers and platforms.
package(default_visibility = ["//visibility:public"])

# MCU overview.
# MCUs are used to communicate with the deployment tools like JLink. It also is
# used to select simulation for desktop operating systems, or hardware drivers
# for specific microcontrollers.
constraint_value(
  name = "stm32f429zi",
  constraint_setting = "@platforms//os",
)

constraint_value(
  name = "stm32l552ze",
  constraint_setting = "@platforms//os",
)

constraint_value(
  name = "stm32u585oi",
  constraint_setting = "@platforms//os",
)

constraint_value(
  name = "stm32l041e6",
  constraint_setting = "@platforms//os",
)

constraint_value(
  name = "nRF52840_xxAA",
  constraint_setting = "@platforms//os",
)

# Package overview

# Configurations.
config_setting(
    name = "stm32f429xx",
    constraint_values = [":stm32f429zi"],
)

config_setting(
    name = "stm32l552xx",
    constraint_values = [":stm32l552ze"],
)

config_setting(
    name = "stm32u585xx",
    constraint_values = [":stm32u585oi"],
)

config_setting(
    name = "stm32l041xx",
    constraint_values = [":stm32l041e6"],
)
config_setting(
    name = "simulation",
    constraint_values = [
        "@platforms//os:windows",
        "@platforms//os:linux",
        "@platforms//os:macos",
    ],
)

# Support library overview
# Includes startup code and the peripherals dependencies, for any supported
# platform, including desktop.

cc_library(
    name = "microcontroller",
    deps = select({
        ":stm32f429zi" : [ "//third_party/stm32f4:startup","//third_party/stm32f4:linker"],
        ":stm32l552ze": ["//third_party/stm32l5:startup", "//third_party/stm32l5:linker"],
        ":stm32u585oi" : [ "//third_party/stm32U5:startup","//third_party/stm32U5:linker"],
        ":stm32l041e6": ["//third_party/stm32l0:startup", "//third_party/stm32l0:linker"],
    }),
    visibility = ["//visibility:public"],
)
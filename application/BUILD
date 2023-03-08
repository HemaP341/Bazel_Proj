# Target overview
cc_binary(
  name = "application",
  srcs = glob(["*.c"]),
  deps = [
    "//examples/algorithm",
    "//platforms/mcu:microcontroller",
  ],
)

genrule(
  name = "app",
  srcs = [":application"],
  outs = ["app.hex"],
  cmd = "objcopy -O ihex $(location :application) $(location :app.hex)" ,
  visibility = ["//visibility:public"],
)

# Embedded Tutorial

In this tutorial, you will learn how to build and test a simple application on
the STM32F429I Discovery Board (STM32F429ZI). This tutorial uses the command
line to emphasize core Bazel concepts. After this tutorial, head back to the
[Getting Started] guide to learn how to edit and debug in an integrated
development environment (IDE).

[Getting Started]: ../README.md#getting-started

## What you'll learn

After this tutorial, you'll know how to:

- Select an embedded compiler.
- Extend the build system to a new microcontroller.
- Design a cross platform peripheral interface.
- Run and debug an application on a microcontroller.
- Write and run automated tests.

## Before you begin

During this tutorial, you'll need the following tools.

- IAR, Keil, or GCC ARM compilers.
- GNU Debugger (GDB) with multi-architecture support (msys2 compatible)
- STM32F4 Discovery Board
- SEGGER J-Link software package
- SEGGAR STLinkReflash utility 
- PuTTY or tio (msys2 compatible)

Use a cross platform toolchain for consistency and vision
Installation instructions should be in each subsystem.
One can simply mention that other compiler and terminal applications can be used
in Windows, if the reader is familiar with them. 

## Review the application

The application calculates the distance between two Global Positioning System
(GPS) coordinates. The algorithm was chosen because it demonstrates a common use
case (floating point mathematics) and the use of hardware acceleration (floating
point unit). Take a look at the [C Implementation] for more information.

[C Implementation]: algorithm/function.c

Compile the algorithm for the host operating system. This will confirm that your
workspace is setup for C/C++ development. Instruct Bazel to show the individual
commands to illustrate how the compiler is used.

```
$ bazel build --subcommands //examples/algorithm
```

Run the application and compute the distance from Los Angeles (34.05, -118.24)
and New York City (40.73, -73.98). The application receives the coordinates via
standard input. It returns the distance and computation time via standard
output.

```
$ bazel run //examples/application
> 34.05,-118.24,40.73,-73.98
3937.60,0.123
```

Debug the application locally with the GNU Debugger (GDB). The debugger loads
the symbols from the executable file format. Demonstrate that you can run the
the application to a breakpoint. This will confirm that the application was
built correctly.

```
$ bazel build --compilation_mode=dbg //examples/application
$ gdb bazel-bin/examples/application/application
...
Reading symbols from bazel-bin/examples/application/application...done.
(gdb) break main
Breakpoint 1 at 0x6e2: file examples/application/main.c, line 14.
(gdb) run
Starting program: ... 
Breakpoint 1, main () at examples/application/main.c:14
14	  size_t input = 0;
(gdb)
```

## Cross compile the application

This project extends the Bazel build system to the GCC ARM compiler and
Cortex-M4 architecture. The extension teaches the build system how to run each
of the C/C++ build actions such as compile and link. The compiler is registered
with the build system as a C/C++ toolchain. The build system determines which
toolchain to used based on the constraints of the host and target platform. A
target platform must be defined for each microcontroller. After this tutorial,
take a look at [Rules], [Platforms], and [Toolchains] for more advanced Bazel
concepts.

[Rules]: https://docs.bazel.build/versions/master/skylark/rules.html
[Platforms]: https://docs.bazel.build/versions/master/platforms.html
[Toolchains]: https://docs.bazel.build/versions/master/toolchains.html

Cross compile the algorithm for the example microcontroller. Instruct Bazel to
show the individual commands and notice that the GCC ARM compiler is used. Bazel
is asked to find C/C++ toolchain that can be executed on the host operating
system, can generate code for the Cortex-M4, and is compatible with the GNU
Compiler Collection (GCC). If you're using Windows, cross compile the algorithm
with the IAR or Keil ARM compiler by choosing the associated platform.

```
bazel build 
    --platforms=//examples/microcontroller:platform-gcc
    --subcommands
    //examples/algorithm
```

The compiler and CPU architecture is enough to cross compile an algorithm
written in standard C/C++, but not an application. The microcontroller must 
provide: 

- **Start-up code** - All of the low-level initialization that needs to occur
before entering the main() function. The code is generic and will work for any
application. The ARM Cortex Microcontroller Software Interface Standard (CMSIS)
provides [Templates] for each CPU architectures, vendors, and compilers. The
example uses the templates without modification.

[Templates]: https://developer.arm.com/tools-and-software/embedded/cmsis
  
- **Linker Script** - The addresses and sizes of various memory sections used by
the application. The addresses of FLASH, RAM, heap, and stack will work for any
application, but the address of code may not. For example, an application may be
divided into boot and therapy code. The address of therapy code will be
different. The microcontroller must provide a template that the application can
customize. The example uses the template without modification.

- **Peripherals** - Cross platform interfaces that decouple the application from
the hardware. On the host operating system, the interfaces are simulated. For
example, with files instead of flash, sockets instead of buses, or software
implementations instead of hardware acceleration. On the microcontroller, the
the interfaces are implemented using vendor and family independent hardware
abstraction layers. The example uses the CMSIS and STM32 Cube driver libraries.

Cross compile the application for the example microcontroller. 

```
bazel build 
    --platforms=//examples/microcontroller:platform-gcc
    //examples/application
```

## Run the application 

Might include time to show that even though the clock is slow, the accelerator
kicks in to even things out.

```
bazel run //tools/run 
    --platforms=//examples/microcontroller:platform
    //examples/application
```

`34.05,-118.24,40.73,-73.98`

`3937.60` (Looking for full floating point precision for comparison)

## Debug the application

```
bazel run //tools/debug 
    --platforms=//examples/microcontroller:platform
    //examples/application
```

`gdb tcp:127.0.0.1:2331 bazel-bin/examples/application.elf`

`> run or break`

## Run automated tests

Introduce how to write automated tests. Reminder that any testing framework can
be used as long as it conforms to the [Bazel Test Encyclopedia]. The examples 
use Google Test. 

[Text](tests/function_tests.cpp)
[Text](tests/BUILD)

Introduce how to run them, setting the baseline experience.

`bazel test //examples/test`

Run the same tests on target. Wrapping together the deployment, command, and 

```
bazel test 
    --platforms=//examples/microcontroller:platform
    --run_under=//tools/test
```

# Run selected tests 

Demonstrate how to run specific tests.

```
bazel test 
    --platforms=//examples/microcontroller:platform
    --run_under=//tools/test
    --test_arg=--gtest_filter=TestSuite1.TestName
```

Cant demonstrate test selection because its specific to the testing framework 
like Google Test? No, it demonstrates how any testing framework can forward 
command line arguments.


 You will work with the algorithm on your host operating 
system, setup After this tutorial, you'll  

Algorithm, Application, Microcontroller, Interface (From simulation to hardware)



follow the [CLion Tutorial] or [Visual Stud40.7309,-73.9872io Code
Tutorial] to 40.741895,-73.989308

Add a new compiler or CPU architecture
Add a new microcontroller 
Design a cross-platform application
Load, Debug, View (Putty!) the application on the microcontroller
Automate testing frameworks

 
microcontroller
Cross platform libraries
Compilers
   
   
   how to build embedded application with the Bazel
build system. First, you'll build a simple algorithm on your  


This guide is designed to teach developers how to build embedded applications
with the Bazel build system. First, the developer will build a simple algorithm
on their desktop. This will demonstrate how to edit, compile, and debug on
desktop platforms. Next, the developer will deploy the algorithm on an embedded
discovery board. This will demonstrate how to extend Bazel to embedded compilers
and platforms. Finally, the developer will run automated tests and perform
static analysis. This will demonstrate how to extend Bazel to embedded testing
frameworks and analysis tools.

TODO: Record and link video demonstration with slides.

## Before you begin

Follow the [Bazel C++ Tutorial] learn the basics of building C/C++ applications 

First, [Install Bazel] for Windows, Linux, or Mac.  to learn key Bazel concepts Next, [Integrate Bazel with
an IDE] for source code editing and debugging. For this guide, [Install CLion] 
and [Install the Bazel Plugin]. Finally, if on Windows, install Visual Studio,     . For CLion or Visual Studio Code, install the Bazel plugin at
. For IAR, Keil, or GCC ARM,

### Build system

The Bazel build system supports Windows, Linux, or Mac. Install Bazel by 
following the instructions at [Installing Bazel].

[Installing Bazel]: https://docs.bazel.build/versions/master/install.html

### Compiler



### Editor

Bazel provides plugins for both CLion and Visual Studio Code. Install the
plugins by following the instructions at [Integrating Bazel with IDEs]. This
guide will use CLion. For help getting started with Visual Studio Code, try
[Bazel With Visual Studio Code].

[Integrating Bazel with IDEs]: https://docs.bazel.build/versions/master/ide.html
[Bazel With Visual Studio Code]: 
  https://shanee.io/blog/2019/05/28/bazel-with-visual-studio-code/





First, install Bazel by following the instructions at 
https://docs.bazel.build/versions/master/install.html This guide uses Bazel, CLion This guide requires Bazel, CLion, and  This guide uses the example application included with the build system. Please  

Starts with the installation of tools.
Includes Git, Bazel, Clion, and other tools referenced in the guide.
Ends when the build system is built on the command line for desktop.

References the Bazel documentation for each host operating system.

## Algorithm Development

Starts with a slice of interesting floating point math (C code). 
Ends with the example rule, describes its pieces.

Starts with the main functions, describing the entry point.
Includes the minor differences between Bazel rules.
Ends with running the application on the command line.

Starts with choosing an IDE (CLion or VSCode).
Introduces the "sync" interface that connects Bazel with the IDE.
Ends with a manual test through the debugger (Navigate, edit, build, debug)

References the guides in the editors subsystems for each editor.
Key idea is interoperability, getting the IDEs for free
Teach the build system about your algorithms, and develop them on your desktop.

## Embedded Development

Starts with teaching the build system about a new platform, similar to Windows
and Linux.
Includes introducing our compiler (IAR, Keil, GCC).
Ends with introducing our board (CMSIS, JLink, GDB, Terminal, Manual test)

Don't forget the simulation vision. Although the example only simulates serial
IO, the vision also includes flash and other peripherals. Its all about the
board library complexity.

Provide a platform, that defines the the CPU, lists support compilers, and gives
a configuration that others can use to tune their implementation for.

## Software Verification

Starts with automating the manual test presented during debugging.
Includes repeating the same test on the embedded device.
Ends with Unit, Integration, System, HIL vision all in one with Google Test.

Verification bridges tests and analysis

Starts with what we gain from our agnostic description (Windows, Linux) (Bottom)
Includes metrics that run on any Bazel code base (Coverity). (Top)
Ends with the vision for Churn, Coverage, Time, Cache.

Key idea is interoperability, getting the CI/CD for any Bazel code base.

## Continuous Integration

Would introduce the eventual GitFlow branching, Pull requests, and Jenkins jobs.
Its continuous because its monitoring activity, its integration because it is
helps two or more people collaborate.

Key idea is that the same activities run at the developers desk are simply run
in the cloud. Just need to teach the Tech Futures system when to run them. The 
repository defines the JenkinsFile to control the pipeline. Collaborator and 
GitLab/GitFlow are all rooted in the unique repository. Bazel handles all inter
repository dependencies as code.




--
Algorithm, Library, Application, Bazel, The doors flood open, Navigate, Edit,
Build, Debug (CLion, VSCode, Coverity, Churn, Coverage, Time, Cache, Windows,
Linux), but that's not embedded. What do we need?, IAR, Keil, GCC ARM, Board,
JLink, GDB, Terminal (Manual test). Now we're talking (IAR, CLion, VSCode,
Windows, Linux, etc Again!). But that's not automated. Test Local, Test Remote,
Windows, Linux.

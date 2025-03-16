# RustCE

This is a proof-of-concept for running Rust on the TI-84+ CE calculators

We're using a fork of [LLVM](https://github.com/llvm/llvm-project) from [jac0bly](https://github.com/jacobly0/llvm-project) and the [CE-Programming project](https://github.com/CE-Programming/llvm-project) to take care of codegen from C and/or Rust's generated LLVM-IR to eZ80 ASM.

We utilize the [CE-Programming project's existing Linux/macOS/Windows makefile toolchain](https://github.com/CE-Programming/toolchain) to build the calculator's .8xp file, by hacking in support for compilation with `rustc` (**no cargo, no cargo dependencies**).

It does this without upstream eZ80 Rust support, by first compiling the Rust code into LLVM IR for the `wasm32-unknown-unknown` target, then simply assuming that IR will work well enough when building the final eZ80 binary.

This uses the include files from the [CE-Programming toolchain](https://github.com/CE-Programming/toolchain) to get names for the syscalls

# Building

## Prerequisites
1. Install the [CE toolchains](https://github.com/CE-Programming/toolchain)<br>
2. Install (Rust and) the wasm32-unknown-unknown target<br>

## Building
- Add the CE toolchain's 'bin' folder to your path
- Run `make` within the project's folder to build
- Find your 8xp binary in the bin/ folder
    - The 8xp name can be changed at the top of the makefile
- `make clean` to clean up

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

## Release
A GitHub Actions workflow is included. It produces an artifact containing the built 8xp and either the README-calc.md file, or if missing, this README.md file.

# Getting LLVM Working

## Approaching the same LLVM

### CE-Programming/llvm-project
As of writing (Oct 2025), [CE-Programming/llvm-project](https://github.com/CE-Programming/llvm-project) is at commit c74f71c. The artifacts built in their CI, released as a part of their [toolchain](https://github.com/CE-Programming/toolchain).
```
$ .\ez80-clang.exe --version --verbose
clang version 15.0.0 (https://github.com/CE-Programming/llvm-project 23b78267b5d376b232475d0805a937e54b61e0d0)
Target: ez80
Thread model: posix

$ git log 23b78267b5d376b232475d0805a937e54b61e0d0
commit 23b78267b5d376b232475d0805a937e54b61e0d0
Author: Adrien Bertrand <bertrand.adrien@gmail.com>
Date:   Mon Jul 15 23:31:08 2024 -0600

    fix CI: split linuxmac/win and adjust things (no tests on win)
```

The earliest commit in upstream LLVM before branching is 
7c63cc1

As of writing, [Comparing 7c63cca with CE-Programming/llvm-project:z80](https://github.com/CE-Programming/llvm-project/compare/7c63cc1..z80) is showing 274 changed files with 79,560 additions and 1,708 deletions.

https://rustc-dev-guide.rust-lang.org/backend/updating-llvm.html

The Rust project's LLVM is kept tidy with upstream, with tags for specific LLVM versions. There are two for LLVM 15:
[rustc/15.0-2022-12-07 (fd949f3)](https://github.com/rust-lang/llvm-project/tree/rustc/15.0-2022-12-07)
[rustc/15.0-2022-08-09 (a1232c4)](https://github.com/rust-lang/llvm-project/tree/rustc/15.0-2022-08-09)

Checking for common ancestorship between rustc and CE-Programming reveals commit 7c63cc1 ()
```
$ git merge-base 23b7826 a1232c4
7c63cc198b6de1adc32e0336cde5f1fe78ddc454

$ git log 7c63cc198b6de1adc32e0336cde5f1fe78ddc454
commit 7c63cc198b6de1adc32e0336cde5f1fe78ddc454
Author: varconst <varconsteq@gmail.com>
Date:   Fri Jun 3 20:39:00 2022 -0700

    [libc++][ranges][NFC] Fix a patch link in ranges status.
```

# Alternative Solutions

## W2C2 (Rust -> Wasi -> C -> eZ80)
https://github.com/turbolent/w2c2

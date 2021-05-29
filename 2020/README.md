# [Advent of Code 2020](https://adventofcode.com/2020)
> Solutions written in C, Nim, Factor and... Zig

<p align="center">
    <a href="./zig"><img src="https://img.shields.io/badge/Zig-12%2F25-yellow"></a>
    <a href="./c"><img src="https://img.shields.io/badge/C-6%2F25-orange"></a>
    <a href="./nim"><img src="https://img.shields.io/badge/Nim-3%2F25-red"></a>
    <a href="./factor"><img src="https://img.shields.io/badge/Factor-2%2F25-red"></a>
</p>

This is an incomplete set of solutions to 2020's Advent of Code. I started with C, and then used the problems as a starting point for playing with Nim, Factor and Zig. Thus most of these solutions are probably not very idiomatic.

## Installation

#### C
Requires a C compiler and `make`. In the `c/` subdirectory, edit the [Makefile](./c/Makefile) to your satisfaction, and then run `make -r` to build all available solutions. You can build a particular day by specifying a number `make -r n`.

#### Nim
Requires [Nim](https://nim-lang.org/install.html). You can use `nimble build` from within the `nim/` subdirectory to build the executables. If you have `make` installed you can also use the provided Makefile to build all solutions (`make` or `make all`) or just a particular day (`make n`).

#### Zig
Requires [Zig](https://ziglang.org/learn/getting-started). To compile the solutions, run `zig build` from within the `zig/` sub-directory. This will create a `zig-cache/bin` directory containing the executables which can be run as described below (or alternatively, run `zig build n` to execute the *n*th day's solution). **Note**: requires Zig [0.8.0-dev](https://ziglang.org/download/) (the provided `build.zig` does not work prior to commit [1032a69](https://github.com/ziglang/zig/commit/1032a693211dd96abe349bfa76b43bb1f226cfda#diff-581e0ec2dae9e97448da6d140a75539dc6c79595dfc4c70df65b98c000f8e6f5)).

#### Factor
Requires [Factor](https://factorcode.org/). The easiest way to run the solutions is to copy the contents of the `factor/` subdirectory into the `work` root of your Factor installation (see [here](https://docs.factorcode.org/content/article-vocabs.roots.html) for further information on vocabulary roots in Factor). The solutions can either be run by factor, or deployed as binary executables:

```sh
factor -run="1"                               # run day 1 solution
factor -e='USING: tools.deploy ; "1" deploy'  # build day 1 solution as executable
```

Note this creates the executables in your Factor installation.

## Usage

Problem inputs are read from STDIN:

```sh
./n < input.txt
```

The solutions to both parts of the problem are then printed:

```
A) ... solution here ...
B) ... solution here ...
```

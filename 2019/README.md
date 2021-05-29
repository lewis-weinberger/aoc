# [Advent of Code 2019](https://adventofcode.com/2019)
> Solutions written in Rust and Scheme.

<p align="center">
    <a href="./rust"><img src="https://img.shields.io/badge/Rust-3%2F25-red"></a>
    <a href="./scheme"><img src="https://img.shields.io/badge/Scheme-3%2F25-red"></a>
</p>

## Installation

To run the Scheme implementations you'll need a working installation of [GNU Guile](https://www.gnu.org/software/guile/download/). To run the Rust implementations you'll need to install [Rust](https://www.rust-lang.org/tools/install). For each of the programs below, it is assumed that the Rust code has been compiled with:

```sh
cargo build
```
Note this needs to be run from the root of the Rust crate, e.g. for day 1 this should be run in `rust/day_1`. This would build the executable in the `rust/day_1/target/debug/` directory.

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

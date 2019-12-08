# [Advent of Code 2019](https://adventofcode.com/2019) -- solutions
> Solutions in Rust and Scheme.

## Installation

To run the Scheme implementations you'll need a working installation of [GNU Guile](https://www.gnu.org/software/guile/download/). To run the Rust implementations you'll need to install [Rust](https://www.rust-lang.org/tools/install). For each of the programs below, it is assumed that the Rust code has been compiled with:

```bash
cargo build 
```
Note this needs to be run from the root of the Rust crate, e.g. for day 1 this should be run in `rust/day_1`. This would build the executable in the `rust/day_1/target/debug/` directory.

## Day 1

Assuming you have your puzzle input stored in a text-formatted file, `input.txt`, you can calculate the total required fuel using:

```bash
cat input.txt | guile -e main -s scheme/day_1.scm  # scheme
cat input.txt | rust/day_1/target/debug/day_1      # rust
```

Both programs will print:
```
Total required fuel = X
```
where X is the total fuel required for your puzzle input parameters. 

## Day 2

Assuming you have your puzzle input stored in a text-formatted file, `input.txt`, you can determine the final program value with:

```bash
cat input.txt | rust/day_2/target/debug/day_2      # rust
```

This will print:
```
The value left at position 0 after the program halts = X
Noun = Y, verb = Z
100 * noun + verb = W
```
where, X and W are the desired results for day 2.

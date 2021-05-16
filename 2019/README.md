# [Advent of Code 2019](https://adventofcode.com/2019)
> Solutions written in Rust and Scheme.

The Rust implementations follow a broadly *imperative* approach (loops, mutable state, etc.), whilst the Scheme solutions instead use a more *functional* approach (recursion, immutable state, etc.).


**Table of contents**
1. [Installation](#installation)
2. [Day 1](#day1)
3. [Day 2](#day2)
4. [Day 3](#day3)
5. [License](#license)


<a name="installation"></a>
## Installation

To run the Scheme implementations you'll need a working installation of [GNU Guile](https://www.gnu.org/software/guile/download/). To run the Rust implementations you'll need to install [Rust](https://www.rust-lang.org/tools/install). For each of the programs below, it is assumed that the Rust code has been compiled with:

```bash
cargo build
```
Note this needs to be run from the root of the Rust crate, e.g. for day 1 this should be run in `rust/day_1`. This would build the executable in the `rust/day_1/target/debug/` directory.


<a name="day1"></a>
## Day 1

Assuming you have your puzzle input stored in a text-formatted file, `input.txt`, you can calculate the total required fuel using:

```bash
guile -e main -s scheme/day_1.scm < input.txt  # scheme
rust/day_1/target/debug/day_1 < input.txt      # rust
```

Both programs will print:
```
Part 1) Total required fuel = X
Part 2) Total required fuel = Y
```
where X and Y are the total fuel required for your puzzle input parameters.


<a name="day2"></a>
## Day 2

Assuming you have your puzzle input stored in a text-formatted file, `input.txt`, you can determine the final program value with either:

```bash
guile -e main -s scheme/day_2.scm < input.txt # scheme
rust/day_2/target/debug/day_2 < input.txt     # rust
```

These will both print:
```
Part 1) The value left at position 0 after the program halts = W
Part 2) Noun = X, verb = Y, 100 * noun + verb = Z
```
where W, X, Y, and Z are the desired results for day 2.


<a name="day3"></a>
## Day 3

Assuming you have your puzzle input stored in a text-formatted file, `input.txt`, you can determine the final program value with either:

```bash
guile -e main -s scheme/day_3.scm < input.txt # scheme
rust/day_3/target/debug/day_3 < input.txt     # rust
```

These will both print:
```
Part 1) The closest intersection is X away from the central port
Part 2) Y combined steps to reach nearest intersection
```
where X, and Y are the desired results for day 3.

<a name="license"></a>
## License

[MIT License](../LICENSE)

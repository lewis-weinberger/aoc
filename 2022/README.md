# [Advent of Code 2022](https://adventofcode.com/2022)
> Solutions written in Scheme

<p align="center">
    <a href="./scheme"><img src="https://img.shields.io/badge/Scheme-6%2F25-blue"></a>
    <a href="./scheme"><img src="https://img.shields.io/badge/C-1%2F25-blue"></a>
</p>


## Installation

#### Scheme
Requires a Scheme (R6RS) implementation, such as
[Chez](https://github.com/cisco/chezscheme).

#### C
Requires a C99-compliant compiler. Solutions can be built with the provided Makefile.

## Usage

Problem inputs are read from STDIN:

```sh
# Scheme solutions for day n
chezscheme --script n.ss < input.txt

# C solutions for day n
make day_n
./day_n < input.txt
```

The solutions to both parts of the problem are then printed:

```
... solution here ...
... solution here ...
```

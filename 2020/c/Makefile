# Makefile for Advent of Code 2020
# Should be run with the -r switch to disable built-in rules

.POSIX:

CC = gcc

CFLAGS = -ansi -pedantic -O2 -Wall -Wextra  -Wpointer-arith \
         -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes

EXEC = 1 2 3 4 5 6

all: $(EXEC)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

%: %.o aoc.o
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	rm -rf $(EXEC) *.o

.PHONY: clean

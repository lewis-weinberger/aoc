# Advent of Code 2022

.POSIX:

CC     = gcc
CFLAGS = -std=c99 -O3 -pedantic -Wall -Wextra

EXEC = day_7 day_8

all: $(EXEC)

day_%: day_%.o aoc.o
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c aoc.h
	$(CC) -D_POSIX_C_SOURCE=200809L $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(EXEC) *.o

.PHONY: clean

# Advent of Code 2022

.POSIX:

CC     = gcc
CFLAGS = -std=c99 -O3 -pedantic -Wall -Wextra

EXEC = day_7

all: $(EXEC)

day_%: day_%.o
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(EXEC) *.o

.PHONY: clean

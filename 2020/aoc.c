#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include "aoc.h"

int readint(int *p, int n)
{
    int m;

    for (m = 0; m < n && scanf("%d\n", p++) != EOF; m++);
    return m;
}

void panic(const char *s)
{
    perror(s);
    exit(1);
}

void *emalloc(size_t size)
{
    void *p;

    p = malloc(size);
    if (p == NULL)
        panic("malloc");
    return p;
}

void *erealloc(void *ptr, size_t size)
{
    void *p;

    p = realloc(ptr, size);
    if (p == NULL)
        panic("realloc");
    return p;
}

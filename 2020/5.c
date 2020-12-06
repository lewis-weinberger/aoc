#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "aoc.h"

static int parse(char *str)
{
    int i, d;

    for (i = 0, d = 0; i < 10; i++) {
        if (str[i] == 'B' || str[i] == 'R')
            d += (1 << (9 - i));
    }
    return d;
}

int main(void)
{
    int r, c, id, maxid, myid;
    char line[12];
    entry *k, *v, *p;

    hinit();
    maxid = myid = 0;

    while (fgets(line, 12, stdin) != NULL) {
        id = parse(line);
        k = newint(id);
        v = newint(id);
        hinsert(k, v);

        /* Part A */
        if (id > maxid)
            maxid = id;
    }

    /* Part B */
    for (r = 0; r < 127; r++) {
        for (c = 0; c < 7; c++) {
            id = r * 8 + c;
            k = newint(id - 1);
            v = newint(id);
            p = newint(id + 1);
            if (hlookup(k) != NULL && hlookup(p) != NULL
                && hlookup(v) == NULL)
                myid = id;
            free(k);
            free(v);
            free(p);
        }
    }
    hfree(free);

    printf("A) the highest seat id is %d\n", maxid);
    printf("B) the missing seat id is %d\n", myid);

    return 0;
}

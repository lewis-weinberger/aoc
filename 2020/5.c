#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "aoc.h"

/* to recur or not to recur */
static void parse(char *str, int *r, int *c)
{
    int i, lo, hi, d;

    for (i = 0, lo = 0, hi = 127; i < 7; i++) {
        d = ceil((hi - lo) / 2.0);
        if (str[i] == 'F')
            hi -= d;
        else
            lo += d;
    }
    *r = (str[6] == 'F') ? lo : hi;

    for (i = 7, lo = 0, hi = 7; i < 10; i++) {
        d = ceil((hi - lo) / 2.0);
        if (str[i] == 'L')
            hi -= d;
        else
            lo += d;
    }
    *c = (str[9] == 'L') ? lo : hi;
}

int main(void)
{
    int r, c, id, maxid, myid;
    char line[12];
    entry *k, *v, *p;

    hinit();
    maxid = myid = 0;

    while (fgets(line, 12, stdin) != NULL) {
        parse(line, &r, &c);
        id = r * 8 + c;
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

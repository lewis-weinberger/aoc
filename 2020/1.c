#include <stdio.h>
#include <stdlib.h>
#include "aoc.h"

enum {
    NBUF = 1024
};

int main(void)
{
    int in[NBUF], *p, n, i, j;
    entry *k, *v, x;

    hinit();
    x.type = HINT;

    /* Read expenses from STDIN into hash table (kudos sam-kirby) */
    for (n = 0, p = &in[0]; n < NBUF && scanf("%d\n", p++) != EOF; n++) {
        k = newint(in[n]);
        v = newint(in[n]);
        hinsert(k, v);
    }

    /* Part A */
    for (i = 0; i < n; i++) {
        x.f.i = 2020 - in[i];
        if (hlookup(&x) != NULL) {
            printf("A) %d * %d = %d\n", in[i], x.f.i, in[i] * x.f.i);
            break;
        }
    }

    /* Part B */
    for (i = 0; i < n; i++) {
        for (j = i + 1; j < n; j++) {
            x.f.i = 2020 - in[i] - in[j];
            if (hlookup(&x) != NULL) {
                printf("B) %d * %d * %d = %d\n", in[i], in[j], x.f.i,
                       in[i] * in[j] * x.f.i);
                i = j = n;
            }
        }
    }

    hfree(free);

    return 0;
}

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
    int id, maxid, myid;
    char line[12];

    hinit();
    maxid = myid = 0;

    while (fgets(line, 12, stdin) != NULL) {
        id = parse(line);
        hintinsert(id, id);

        /* Part A */
        if (id > maxid)
            maxid = id;
    }

    /* Part B */
    for (id = 1; id < 1023; id++) {
        if (hintlookup(id - 1) != NULL
            && hintlookup(id + 1) != NULL
            && hintlookup(id) == NULL)
            myid = id;
    }
    hfree(free);

    printf("A) the highest seat id is %d\n", maxid);
    printf("B) the missing seat id is %d\n", myid);

    return 0;
}

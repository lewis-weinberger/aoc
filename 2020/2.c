#include <stdio.h>
#include "aoc.h"

enum {
    NBUF = 256
};

int main(void)
{
    int i, j, na, nb, lo, hi;
    char c, line[NBUF], str[NBUF];

    na = nb = 0;
    while (fgets(line, NBUF, stdin) != NULL) {
        if (sscanf(line, "%d-%d %c: %s", &lo, &hi, &c, str) != EOF) {
            /* Part A */
            for (i = 0, j = 0; str[i]; i++)
                j += (str[i] == c);

            if (j >= lo && j <= hi)
                na++;

            /* Part B */
            if ((str[lo - 1] == c) != (str[hi - 1] == c))
                nb++;
        }
    }

    printf("A) %d valid passwords\n", na);
    printf("B) %d valid passwords\n", nb);

    return 0;
}

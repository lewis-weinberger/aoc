#include <stdio.h>
#include <stdlib.h>
#include "aoc.h"

static int parse(const char *str, int *x, int *y)
{
    int c, n, *p;

    hinit();
    n = *x = *y = 0;

    printf("%s\n", str);
    while (*str != '\0') {
        /* each person's answers are delimited by newlines */
        if (*str != '\n') {
            c = *str;
            p = hintlookup(c);
            if (p == NULL) {
                hintinsert(c, 1);
                (*x)++;
            } else
                (*p)++;
        } else
            n++;
        str++;
    }

    for (c = 'a'; c <= 'z'; c++) {
        p = hintlookup(c);
        if (p != NULL)
            *y += (*p == n) ? 1 : 0;
    }
    printf("x = %d, y = %d\n", *x, *y);

    hfree(free);
    return n;
}

int main(void)
{
    int i, c, p, na, nb, x, y;
    char group[1024];

    na = nb = p = i = 0;
    do {
        c = getchar();
        /* group entries are delimited by blank lines */
        if ((c == '\n' && p == '\n') || c == EOF) {
            group[i] = '\0';
            parse(group, &x, &y);
            na += x;
            nb += y;
            i = 0;
        } else {
            group[i] = c;
            i++;
        }
        p = c;
    } while (i < 1023 && c != EOF);

    printf("A) the sum of counts is %d\n", na);
    printf("B) the sum of counts is %d\n", nb);

    return 0;
}

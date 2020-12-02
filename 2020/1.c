#include <stdio.h>
#include "aoc.h"

int main(void)
{
    int in[1024], n, i, j, k;

    n = readint(&in[0], 1024);

    /* When in doubt, use brute force */
    for (i = 0; i < n; i++) {
        for (j = i + 1; j < n; j++) {
            if (in[i] + in[j] == 2020)
                printf("%d * %d = %d\n", in[i], in[j], in[i] * in[j]);

            for (k = j + 1; k < n; k++) {
                if (in[i] + in[j] + in[k] == 2020)
                    printf("%d * %d * %d = %d\n", in[i], in[j], in[k],
                           in[i] * in[j] * in[k]);
            }
        }
    }

    return 0;
}

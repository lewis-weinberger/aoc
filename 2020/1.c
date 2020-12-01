#include <stdio.h>
#include "aoc.h"

int
main(void)
{
    int in[1024], n, i, j, k;

    n = readint(&in[0], 1024);

    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            if (i == j)
                continue;

            if (in[i] + in[j] == 2020)
            {
                printf("%d * %d = %d\n", in[i], in[j], in[i] * in[j]);
                i = j = n;
            }
        }
    }

    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            if (i == j)
                continue;

            for (k = 0; k < n; k++)
            {
                if (i == k || j == k)
                    continue;

                if (in[i] + in[j] + in[k] == 2020)
                {
                    printf("%d * %d * %d = %d\n", in[i], in[j], in[k], in[i] * in[j] * in[k]);
                    i = j = n;
                }
            }
        }
    }

    return 0;
}

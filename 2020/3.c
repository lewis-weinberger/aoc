#include <stdio.h>

enum {
    NWIDTH = 31,
    NBUF = NWIDTH + 2
};

static int tree(char *s, int *x, int *y, int dx, int dy)
{
    int z;

    z = *x;
    if ((*y)++ % dy == 0) {
        *x += dx;
        if (s[z % NWIDTH] == '#')
            return 1;
    }
    return 0;
}

int main(void)
{
    char line[NBUF];
    int i;
    int x[5] = { 0, 0, 0, 0, 0 };
    int y[5] = { 0, 0, 0, 0, 0 };
    int n[5] = { 0, 0, 0, 0, 0 };
    int dx[5] = { 1, 3, 5, 7, 1 };
    int dy[5] = { 1, 1, 1, 1, 2 };

    while (fgets(line, NBUF, stdin) != NULL) {
        for (i = 0; i < 5; i++) {
            n[i] += tree(line, &x[i], &y[i], dx[i], dy[i]);
        }
    }

    printf("A) %d trees encountered\n", n[1]);
    printf("B) %d\n", n[0] * n[1] * n[2] * n[3] * n[4]);

    return 0;
}

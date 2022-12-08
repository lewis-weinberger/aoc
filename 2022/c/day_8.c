#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "aoc.h"

int  n;
char *grid;
int  *vis;

#define INDEX(I, J) (I * n + J)

void
visible(int j0, int dj, int j1)
{
	int i, j;
	char v, h;

	for(i = 0; i < n; i++){
		h = v = '/';
		j = j0;
		while(j != j1){
			/* horizontal lines of sight */
			if(grid[INDEX(i, j)] > h) {
				h = grid[INDEX(i, j)];
				vis[INDEX(i, j)] = 1;
			}

			/* vertical lines of sight */
			if(grid[INDEX(j, i)] > v) {
				v = grid[INDEX(j, i)];
				vis[INDEX(j, i)] = 1;
			}

			j += dj;
		}
	}
}

#define CHECK(Y, X, I, J) (grid[INDEX(Y, X)] >= grid[INDEX(I, J)])

int
viewing(int i, int j)
{
	int x, y, up, down, left, right;

	for(right = 0, x = j + 1; x < n; x++){
		right++;
		if(CHECK(i, x, i, j))
			break;
	}
	for(left = 0, x = j - 1; x >= 0; x--){
		left++;
		if(CHECK(i, x, i, j))
			break;
	}
	for(up = 0, y = i - 1; y >= 0; y--){
		up++;
		if(CHECK(y, j, i, j))
			break;
	}
	for(down = 0, y = i + 1; y < n; y++){
		down++;
		if(CHECK(y, j, i, j))
			break;
	}
	return up * down * right * left;
}

int
main(int argc, char **argv)
{
	UNUSED(argc);
	UNUSED(argv);
	char line[256];
	int i, j, a, b;

	if(fgets(line, sizeof(line), stdin) == NULL)
		die("fgets");
	line[strcspn(line, "\n")] = 0;
	n = strnlen(line, sizeof(line));

	grid = malloc(n * n);
	if(grid == NULL)
		die("malloc");
	memcpy(grid, line, n);

	vis = calloc(n * n, sizeof(*vis));
	if(vis == NULL)
		die("calloc");

	for(i = 1; i < n; i++){
		if(fgets(line, sizeof(line), stdin) == NULL)
			die("fgets");
		memcpy(&grid[i * n], line, n);
	}

	visible(0, 1, n);
	visible(n - 1, -1, -1);
	for(i = a = 0; i < n * n; i++)
		a += vis[i];
	printf("%d\n", a);

	for(i = b = 0; i < n; i++){
		for(j = 0; j < n; j++){
			a = viewing(i, j);
			if(a > b)
				b = a;
		}
	}
	printf("%d\n", b);

	free(grid);
	free(vis);
	return 0;
}

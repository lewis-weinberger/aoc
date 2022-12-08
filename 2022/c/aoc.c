#include <stdio.h>
#include <stdlib.h>

void
die(const char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

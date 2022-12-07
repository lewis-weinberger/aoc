#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STRLEN 64
#define UNUSED(X) (void)X

struct File
{
	char name[STRLEN];
	int size;
};

struct Dir
{
	struct Dir *parent;
	char name[STRLEN];
	int n;
	struct
	{
		short type;
		void *item;
	} *children;
};

typedef struct File File;
typedef struct Dir Dir;

void
die(const char *msg)
{
	perror(msg);
	exit(1);
}

Dir*
newdir(Dir *parent, const char *name)
{
	Dir *new;

	new = malloc(sizeof(Dir));
	if(new == NULL)
		die("malloc");
	new->parent = parent;
	strncpy(new->name, name, STRLEN);
	new->name[STRLEN - 1] = '\0';
	new->n = 0;
	new->children = NULL;
	return new;
}

File*
newfile(int size, const char *name)
{
	File *new;

	new = malloc(sizeof(File));
	if(new == NULL)
		die("malloc");
	strncpy(new->name, name, STRLEN);
	new->name[STRLEN - 1] = '\0';
	new->size = size;
	return new;
}

void
addchild(Dir *dir, short type, void *child)
{
	dir->children = realloc(dir->children, sizeof(*dir->children) * ++dir->n);
	if(dir->children == NULL)
		die("realloc");
	dir->children[dir->n - 1].type = type;
	dir->children[dir->n - 1].item = child;
}

void
freedir(Dir *dir)
{
	int i;

	for(i = 0; i < dir->n; i++){
		if(dir->children[i].type)
			freedir(dir->children[i].item);
		else
			free(dir->children[i].item);
	}
	free(dir->children);
	free(dir);
}

Dir *root;

Dir*
cd(Dir *current, const char *name)
{
	int i;
	Dir *child;

	if(name[0] == '/')
		current = root;
	else if(strncmp(name, "..", 2) == 0)
		current = current->parent;
	else{
		for(i = 0; i < current->n; i++){
			if(!current->children[i].type)
				continue;
			child = current->children[i].item;
			if(strncmp(child->name, name, STRLEN) == 0)
				current = child;
		}
	}
	return current;
}

int
dirsize(Dir *dir, int *a, int *b, int needed)
{
	int i, size;

	for(size = i = 0; i < dir->n; i++){
		if(dir->children[i].type)
			size += dirsize(dir->children[i].item, a, b, needed);
		else
			size += ((File *)dir->children[i].item)->size;
	}
	if(a && size < 100000)
		*a += size;
	if(b && size >= needed && size < *b)
		*b = size;
	return size;
}

int
main(int argc, char **argv)
{
	char line[STRLEN], name[STRLEN];
	Dir *current, *sub;
	File *file;
	int n, a, b;
	UNUSED(argc);
	UNUSED(argv);

	current = root = newdir(NULL, "/");
	while(fgets(line, STRLEN, stdin) != NULL){
		line[strcspn(line, "\n")] = 0;
		switch(line[0]){
		case '$':
			if(line[2] == 'c')
				current = cd(current, &line[5]);
			break;
		case 'd':
			memset(name, 0, STRLEN);
			if(sscanf(line, "dir %63s", name) == EOF)
				die("sscanf");
			sub = newdir(current, name);
			addchild(current, 1, sub);
			break;
		default:
			memset(name, 0, STRLEN);
			if(sscanf(line, "%d %63s", &n, name) == EOF)
				die("sscanf");
			file = newfile(n, name);
			addchild(current, 0, file);
			break;
		}
	}
	a = 0;
	b = dirsize(root, &a, NULL, 0);
	dirsize(root, NULL, &b, b - 40000000);
	printf("%d\n%d\n", a, b);
	free(root);
	return 0;
}

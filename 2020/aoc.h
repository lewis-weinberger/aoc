#include <stddef.h>

typedef struct hashentry {
    int key;
    int val;
    struct hashentry *next;
} hkv;

void hinit(void);
void hinsert(int, int);
int hlookup(int);
void hfree(void);

void panic(const char *);
void *emalloc(size_t);
void *erealloc(void *, size_t);

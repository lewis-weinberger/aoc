#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include "aoc.h"

enum {
    NHASH = 1024,
    MULTIPLIER = 37 /* somewhat magic */
};

typedef struct hashentry {
    entry *key;
    entry *val;
    struct hashentry *next;
} hkv;

hkv *htable[NHASH];

/* inthash: compute hash for integer keys */
static unsigned int inthash(int k)
{
    return k * (k + 3) % NHASH;
}

/* strhash: compute hash for string keys */
/* See "The Practice of Programming" (TPOP) by Kernighan and Pike */
static unsigned int strhash(char *str)
{
    unsigned int k;
    unsigned char *p;

    k = 0;
    for (p = (unsigned char *)str; *p != '\0'; p++)
        k = MULTIPLIER * k + *p;
    return k % NHASH;
}

/* hash: compute hash depending on key type */
static unsigned int hash(entry *k)
{
    switch (k->type) {
        case HINT:
            return inthash(k->f.i);
        case HSTR:
            return strhash(k->f.s);
        default:
            panic("hash type not set");
    }
    return 0;
}

/* keycmp: compare hash keys for equivalence */
static int keycmp(entry *p, entry *q)
{
    if (p->type != q->type)
        return -1;

    switch (p->type) {
        case HINT:
            return (p->f.i == q->f.i);
        case HSTR:
            return (strncmp(p->f.s, q->f.s, SNBUF) == 0) ? 1 : 0;
        default:
            panic("hash type not set");
    }
    return 0;
}

/* hinit: initialise the hash table */
void hinit(void)
{
    int i;

    for (i = 0; i < NHASH; i++)
        htable[i] = NULL;
}

/* hinsert: insert key-value pair in hash table (TPOP) */
void hinsert(entry *k, entry *v)
{
    int h;
    hkv *n;

    h = hash(k);
    n = emalloc(sizeof(hkv));
    n->key = k;
    n->val = v;
    n->next = htable[h];
    htable[h] = n;
}

/* hlookup: lookup key-value pair in hash table (TPOP) */
entry *hlookup(entry *k)
{
    int h;
    hkv *p;

    h = hash(k);
    for (p = htable[h]; p != NULL; p = p->next) {
        if (keycmp(k, p->key))
            return p->val;
    }
    return NULL;
}

/* hfree: free memory allocated for hash table */
void hfree(void (*efree)(void *))
{
    int i;
    hkv *p, *q;

    for (i = 0; i < NHASH; i++) {
        p = htable[i];
        while (p != NULL) {
            q = p->next;
            efree(p->key);
            efree(p->val);
            free(p);
            p = q;
        }
    }
}

/* panic: print error and exit */
void panic(const char *s)
{
    perror(s);
    exit(1);
}

/* emalloc: malloc which panics on failure */
void *emalloc(size_t size)
{
    void *p;

    p = malloc(size);
    if (p == NULL)
        panic("malloc");
    return p;
}

/* erealloc: realloc which panics on failure */
void *erealloc(void *ptr, size_t size)
{
    void *p;

    p = realloc(ptr, size);
    if (p == NULL)
        panic("realloc");
    return p;
}

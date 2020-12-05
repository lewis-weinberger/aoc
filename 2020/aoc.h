#include <stddef.h>

enum {
    SNBUF = 32
};

typedef enum {
    HSTR,
    HINT
} entry_type;

typedef struct {
    entry_type type;
    union {
        char s[SNBUF];
        int i;
    } f;
} entry;

entry *newint(int);
entry *newstr(const char *);

void hinit(void);
void hinsert(entry *, entry *);
entry *hlookup(entry *);
void hfree(void (*)(void *));

void panic(const char *);
void *emalloc(size_t);
void *erealloc(void *, size_t);

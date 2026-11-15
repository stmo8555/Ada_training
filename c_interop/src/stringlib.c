#include "stringlib.h"
#include <string.h>
int count_vowels(const char *s) {
    int n = 0;
    const char vowels[] = {'a', 'e', 'i', 'o', 'u', 'y'};
    for (; *s; s++) {
        for (int i = 0; i < (sizeof (vowels)) / sizeof(vowels[0]); i++) {
            if (*s == vowels[i]){
                n++;
                break;
            }
        }
    }
    return n;
}

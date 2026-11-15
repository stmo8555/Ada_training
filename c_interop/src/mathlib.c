#include <stdbool.h>
#include <stdio.h>
typedef struct {
    bool cool;
} cool_object;

cool_object init_cool(bool is_cool) {
    return (cool_object){.cool = is_cool};
}

void is_cool(const cool_object *c) {
   printf("%s\n", c->cool ? "Object is cool" : "Object is lame");
}

int add(int a, int b) {
    return a + b;
}

#include <stdio.h>

extern void greeting(const char* name);
typedef struct {
    int x;
    int y;
} point;

extern point init_point(int x, int y);

extern void adainit(void);
extern void adafinal(void);
int main () {
    adainit();
    greeting("Stefan");
    point p = init_point(1,2);
    printf("x: %d y: %d\n", p.x, p.y);
    adafinal();
    return 0;
}

#include "header.h"

int kernel_main() {
    draw_char(0, 0, 0x010F, 'A');
    draw_char(1, 0, 0x010F, 'B');
    draw_char(2, 0, 0x010F, 'C');
    int aaa = hemo(12345678, 5678, 78, 76543210, 7654, 76);
    aaa = asm_sample();
    fuga(aaa);
    return aaa;
}

#include "define.h"

void draw_pixel(int x, int y, byte color)
{
    if (x < 0 || x >= param_screen_x)
        return;
    if (y < 0 || y >= param_screen_y)
        return;
    uint addr = param_vram + param_screen_x * y + x;
    write_mem8(addr, color);
}

byte get_pixel(int x, int y)
{
    if (x < 0 || x >= param_screen_x)
        return 0;
    if (y < 0 || y >= param_screen_y)
        return 0;
    uint addr = param_vram + param_screen_x * y + x;
    return read_mem8(addr);
}

void draw_line(int x1, int y1, int x2, int y2, byte color)
{
    int delta_x = x1 > x2 ? x1 - x2 : x2 - x1;
    int delta_y = y1 > y2 ? y1 - y2 : y2 - y1;
    int delta = delta_x > delta_y ? delta_x : delta_y;
    int diff_x = x2 - x1;
    int diff_y = y2 - y1;
    for (int i = 0; i <= delta; i++) {
        draw_pixel(x1 + diff_x * i / delta, y1 + diff_y * i / delta, color);
    }
}

void draw_rect(int x, int y, int w, int h, byte color)
{
    for (int i = x; i < x + w; i++) {
        for (int j = y; j < y + h; j++) {
            draw_pixel(i, j, color);
        }
    }
}

void draw_char(int x, int y, char c, byte color)
{
    int index = c * 16;
    for (int i = 0; i < 16; i++) {
        byte data = param_font_adr[index + i];
        if ((data & 0x80) != 0) { draw_pixel(x + 0, y + i, color); }
        if ((data & 0x40) != 0) { draw_pixel(x + 1, y + i, color); }
        if ((data & 0x20) != 0) { draw_pixel(x + 2, y + i, color); }
        if ((data & 0x10) != 0) { draw_pixel(x + 3, y + i, color); }
        if ((data & 0x08) != 0) { draw_pixel(x + 4, y + i, color); }
        if ((data & 0x04) != 0) { draw_pixel(x + 5, y + i, color); }
        if ((data & 0x02) != 0) { draw_pixel(x + 6, y + i, color); }
        if ((data & 0x01) != 0) { draw_pixel(x + 7, y + i, color); }
    }
}

void draw_text(int x, int y, byte* text, byte color)
{
    for (int i = 0; *(text + i) != 0x00; i++) {
        draw_char(x + 8 * i, y, text[i], color);
    }
}

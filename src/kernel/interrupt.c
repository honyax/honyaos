#include "define.h"

#define PORT_KEYSTA             0x64
#define KEYSTA_SEND_NOTREADY    0x02
#define KEYCMD_WRITE_MODE       0x60
#define KBC_MODE                0x47
#define KEYCMD_SENDTO_MOUSE     0xD4
#define MOUSECMD_ENABLE         0xF4
#define PORT_KEYCMD             0x64

void init_pic()
{
    _out8(PIC0_IMR,  0xFF); // 全ての割り込みを受け付けない
    _out8(PIC1_IMR,  0xFF); // 全ての割り込みを受け付けない

    _out8(PIC0_ICW1, 0x11); // エッジトリガモード
    _out8(PIC0_ICW2, 0x20); // IRQ0-7は、INT20-27で受ける
    _out8(PIC0_ICW3, 0x04); // PIC1はIRQ2にて接続
    _out8(PIC0_ICW4, 0x01); // ノンバッファモード

    _out8(PIC1_ICW1, 0x11); // エッジトリガモード
    _out8(PIC1_ICW2, 0x28); // IRQ8-15は、INT28-2Fで受ける
    _out8(PIC1_ICW3, 0x02); // PIC1はIRQ2にて接続
    _out8(PIC1_ICW4, 0x01); // ノンバッファモード

    _out8(PIC0_IMR,  0xFB); // 11111011 PIC1以外は全て禁止
    _out8(PIC1_IMR,  0xFF); // 11111111 全ての割り込みを受け付けない
}

void wait_kbc_sendready()
{
    // キーボードコントローラがデータ送信可能になるのを待つ
    for (;;) {
        if ((_in8(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0) {
            break;
        }
    }
}

void enable_mouse_keyboard()
{
    _out8(PIC0_IMR, 0xF9);  // 11111001 PIC1, Keyboardを許可
    _out8(PIC1_IMR, 0xEF);  // 11101111 マウスを許可

    // キーボードコントローラの初期化
    wait_kbc_sendready();
    _out8(PORT_KEYCMD, KEYCMD_WRITE_MODE);
    wait_kbc_sendready();
    _out8(PORT_KEYDAT, KBC_MODE);

    // マウスの有効化
    wait_kbc_sendready();
    _out8(PORT_KEYCMD, KEYCMD_SENDTO_MOUSE);
    wait_kbc_sendready();
    _out8(PORT_KEYDAT, MOUSECMD_ENABLE);
}

// PIT(Programmable Interval Timer)
// ポート アドレス
#define PIT_REG_COUNTER0    0x0040
#define PIT_REG_CONTROL     0x0043
// 入力 クロック CLK 0
#define DEF_PIT_CLOCK       1193181.67
// counter mode
#define DEF_PIT_COM_MODE_SQUAREWAVE 0x06
// data transfer
#define DEF_PIT_COM_RL_DATA         0x30
// counter
#define DEF_PIT_COM_COUNTER0        0x00

void init_pit()
{
    int freq = 100;
    unsigned short count = (unsigned short)(DEF_PIT_CLOCK / freq);
    unsigned char command = DEF_PIT_COM_MODE_SQUAREWAVE | DEF_PIT_COM_RL_DATA | DEF_PIT_COM_COUNTER0;

    _out8(PIT_REG_CONTROL, command);
    _out8(PIT_REG_COUNTER0, (unsigned char)(count & 0xFF));
    _out8(PIT_REG_COUNTER0, (unsigned char)((count >> 8) & 0xFF));
}

void inthandler_default(int *esp)
{
    return;
}

extern FIFO32 key_input_data;
extern FIFO32 mouse_input_data;

void update_interrupt()
{
    _cli();
    if (key_input_data.len > 0 || mouse_input_data.len > 0) {
        for (int i = 0; i < key_input_data.len; i++) {
            char key_code[4];
            int pos_x = 16 + 24 * key_input_data.pos_r;
            sprintf(key_code, "%X", fifo32_get(&key_input_data));
            draw_rect(pos_x, 440, 16, 16, COL_BLACK);
            draw_text(pos_x, 440, key_code, COL_WHITE);
        }
        for (int i = 0; i < mouse_input_data.len; i++) {
            char mouse_code[4];
            int pos_x = 16 + 24 * mouse_input_data.pos_r;
            sprintf(mouse_code, "%X", fifo32_get(&mouse_input_data));
            draw_rect(pos_x, 460, 16, 16, COL_BLACK);
            draw_text(pos_x, 460, mouse_code, COL_WHITE);
        }
        _sti();
    } else {
        _stihlt();
    }

}

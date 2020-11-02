;************************************************************************
;	メモリイメージ
;************************************************************************

		;---------------------------------------
        ;            ____________
		;           |            | 
		;           |____________| 
		; 0000_1000 |       (4K) | パラメータ領域（一時展開）
		;           |____________| 
		; 0000_2000 |////////////|
		;           =            = 
		;           |____________| 
		; 0000_7A00 |      (512) | スタック
		;           |____________| 
		; 0000_7C00 |       (8K) | ブート
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0000_9C00 |       (8K) | カーネル（一時展開）
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0000_BC00 |////////////| 
		;           =            = 
		;           |____________| 
		; 0010_0000 |       (4K) | 割り込みディスクリプタテーブル
		;           |____________| 
		; 0010_1000 |       (4K) | パラメータ領域
		;           |____________| 
		; 0010_2000 |       (4K) | カーネルスタック
		;           |____________| 
		; 0010_3000 |       (8K) | カーネルプログラム
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0010_5000 |    (1004K) | スタック
		;           =            = 
		;           |____________| 
		; 0020_0000 |     (125M) | ヒープメモリ領域
		;           =            = 
		;           |____________| 
		; 07FF_0000 |      (64K) | ACPI data
		;           |____________| 
        ; 0800_0000                128MBメモリ

        BOOT_SIZE           equ     (1024 * 8)      ; ブートサイズ
        KERNEL_SIZE         equ     (1024 * 8)      ; カーネルサイズ

        BOOT_LOAD           equ     0x7C00          ; ブートプログラムのロード位置
		BOOT_END			equ		(BOOT_LOAD + BOOT_SIZE)

        PARAM_BASE_TEMP     equ     0x0000_1000     ; パラメータ領域（一時展開）の開始位置
        PARAM_BASE          equ     0x0010_1000     ; パラメータ領域の開始位置
        PARAM_FONT_ADR      equ     0x0000_0000     ; フォントアドレスのパラメータオフセット位置
        PARAM_SCREEN_X      equ     0x0004          ; 画面サイズ（横）のパラメータオフセット位置
        PARAM_SCREEN_Y      equ     0x0006          ; 画面サイズ（縦）のパラメータオフセット位置
        PARAM_VRAM          equ     0x0000_0008     ; VRAMアドレスのパラメータオフセット位置

        KERNEL_LOAD         equ     0x0010_3000     ; カーネルのロード位置（プロテクトモード）

        SECT_SIZE           equ     (512)           ; セクタサイズ

        BOOT_SECT           equ     (BOOT_SIZE   / SECT_SIZE)   ; ブートプログラムのセクタ数
		KERNEL_SECT			equ		(KERNEL_SIZE / SECT_SIZE)	; カーネルのセクタ数

		E820_RECORD_SIZE	equ		20

        ; 画面モード
        ;  0x100 :  640 x  400 x 8bitカラー
        ;  0x101 :  640 x  480 x 8bitカラー
        ;  0x103 :  800 x  600 x 8bitカラー
        ;  0x105 : 1024 x  768 x 8bitカラー
        ;  0x107 : 1280 x 1024 x 8bitカラー
        VBE_MODE            equ     (0x107)         ; 画面モード

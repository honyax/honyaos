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
		;           |            | 
		;           |____________| 
		; 0000_7A00 |      (512) | スタック
		;           |____________| 
		; 0000_7C00 |       (8K) | ブート
		;           |____________| 
		; 0000_9C00 |      (16K) | カーネル（一時展開）
		;           |            | 
		;           |____________| 
		; 0000_DC00 |////////////| 
		;           |____________| 
		; 0001_0000 |     (320K) | ファイルシステム（一時展開）
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0006_0000 |////////////| 
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0010_0000 |       (4K) | 割り込みディスクリプタテーブル
		;           |____________| 
		; 0010_1000 |       (4K) | パラメータ領域
		;           |____________| 
		; 0010_2000 |      (64K) | カーネルスタック
		;           |            | 
		;           |____________| 
		; 0011_2000 |      (16K) | カーネル
		;           |            | 
		;           |____________| 
		; 0011_6000 |      (40K) | カーネルbss領域
		;           |            | 
		;           |____________| 
		; 0012_0000 |     (320K) | ファイルシステム
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0017_0000 |////////////| 
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0020_0000 |       (4K) | カーネルページディレクトリ
		;           |____________| 
		; 0020_1000 |     (132K) | カーネルページテーブル（先頭128MB + VRAM 4MB）
		;           |            | ページテーブルは、最大4GB分のマッピングで4MBの領域が必要になるので、念の為多めに予備領域を確保しておく
		;           |____________| 
		; 0022_2000 |////////////|
		;           |            | 
		;           |            | 
		;           |____________| 
		; 0070_0000 |     (120M) | ヒープメモリ領域
		;           |            | 
		;           =            = 
		;           |            | 
		;           |____________| 
		; 07FF_0000 |      (64K) | ACPI data
		;           |            | 
		;           |____________| 
        ; 0800_0000                128MBメモリ

        BOOT_SIZE           equ     (1024 * 8)      ; ブートサイズ
        KERNEL_SIZE         equ     (1024 * 16)     ; カーネルサイズ
        FILESYSTEM_SIZE     equ     (1024 * 320)    ; ファイルシステムサイズ

        BOOT_LOAD           equ     0x7C00          ; ブートプログラムのロード位置
		BOOT_END			equ		(BOOT_LOAD + BOOT_SIZE)
        FILESYSTEM_LOAD_TEMP    equ 0x0001_0000     ; ファイルシステムのロード位置（一時領域）

        PARAM_BASE_TEMP     equ     0x0000_1000     ; パラメータ領域（一時展開）の開始位置
        PARAM_BASE          equ     0x0010_1000     ; パラメータ領域の開始位置

        KERNEL_LOAD         equ     0x0011_2000     ; カーネルのロード位置（プロテクトモード）
        FILESYSTEM_LOAD     equ     0x0012_0000     ; ファイルシステムのロード位置（プロテクトモード）
        KERNEL_PAGE_DIR     equ     0x0020_0000     ; カーネルのページディレクトリ
        KERNEL_PAGE_TABLE   equ     0x0020_1000     ; カーネルのページテーブル
        HEAP_MEMORY_START   equ     0x0070_0000     ; ヒープメモリの開始位置
        HEAP_MEMORY_END     equ     0x07FF_0000     ; ヒープメモリの終了位置

        SECT_SIZE           equ     (512)           ; セクタサイズ

        BOOT_SECT           equ     (BOOT_SIZE       / SECT_SIZE)   ; ブートプログラムのセクタ数
		KERNEL_SECT			equ		(KERNEL_SIZE     / SECT_SIZE)   ; カーネルのセクタ数
        FILESYSTEM_SECT     equ     (FILESYSTEM_SIZE / SECT_SIZE)   ; ファイルシステムのセクタ数

		E820_RECORD_SIZE	equ		20

        PARAM_FONT_ADR      equ     0x0000_0000     ; フォントアドレスのパラメータオフセット位置
        PARAM_SCREEN_X      equ     0x0004          ; 画面サイズ（横）のパラメータオフセット位置
        PARAM_SCREEN_Y      equ     0x0006          ; 画面サイズ（縦）のパラメータオフセット位置
        PARAM_VRAM          equ     0x0000_0008     ; VRAMアドレスのパラメータオフセット位置

        ; 画面モード
        ;  0x100 :  640 x  400 x 8bitカラー
        ;  0x101 :  640 x  480 x 8bitカラー
        ;  0x103 :  800 x  600 x 8bitカラー
        ;  0x105 : 1024 x  768 x 8bitカラー
        ;  0x107 : 1280 x 1024 x 8bitカラー
        VBE_MODE            equ     (0x107)         ; 画面モード

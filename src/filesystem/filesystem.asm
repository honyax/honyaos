;************************************************************************
;	ディスクイメージ
;************************************************************************
		;(SECT/SUM)  file img                 
		;                       ____________  
		;( 16/  0)   0000_0000 |       (8K) | ブート
		;                      =            = 
		;                      |____________| 
		;( 32/ 16)   0000_2000 |      (16K) | カーネル
		;                      =            = 
		;                      |____________| 
		;(256/ 48)   0000_6000 |     (128K) | FAT-1
		;                      |            | 
		;                      |            | 
		;                      =            = 
		;                      |____________| 
		;(256/304)   0002_6000 |     (128K) | FAT-2
		;                      |            | 
		;                      |            | 
		;                      =            = 
		;                      |____________| 
		;( 32/560)   0004_6000 |      (16K) | ルートディレクトリ領域
		;                      |            | (32セクタ/512エントリ)
		;                      =            = 
		;                      |____________| 
		;(   /592)   0004_A000 |            | データ領域
		;                      |            | 
		;                      =            = 
		;                      |            | 
		;                      |____________| 
		;(   /640)   0005_0000 |////////////| 
		;                      |            | 

;************************************************************************
;   マクロ
;************************************************************************
%include    "../boot/define.s"
%include    "../boot/macro.s"

;************************************************************************
;   define
;************************************************************************
		FAT_SIZE			equ		(1024 * 128)	; FAT-1/2
		ROOT_SIZE			equ		(1024 *  16)	; ルートディレクトリ領域

		ENTRY_SIZE			equ		32				; エントリサイズ

		FAT_OFFSET			equ		(BOOT_SIZE + KERNEL_SIZE)
		FAT1_START			equ		0
		FAT2_START			equ		(FAT1_START + FAT_SIZE)
		ROOT_START			equ		(FAT2_START + FAT_SIZE)
		FILE_START			equ		(ROOT_START + ROOT_SIZE)

		; ファイル属性
		ATTR_READ_ONLY		equ		0x01
		ATTR_HIDDEN			equ		0x02
		ATTR_SYSTEM			equ		0x04
		ATTR_VOLUME_ID		equ		0x08
		ATTR_DIRECTORY		equ		0x10
		ATTR_ARCHIVE		equ		0x20

;************************************************************************
;   FAT:FAT-1
;************************************************************************
		times (FAT1_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT1:
		db		0xFF, 0xFF												; クラスタ:0
		dw		0xFFFF													; クラスタ:1
		dw		0xFFFF													; クラスタ:2

;************************************************************************
;   FAT:FAT-2
;************************************************************************
		times (FAT2_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT2:
		db		0xFF, 0xFF												; クラスタ:0
		dw		0xFFFF													; クラスタ:1
		dw		0xFFFF													; クラスタ:2

;************************************************************************
;   FAT:ルートディレクトリ領域
;************************************************************************
		times (ROOT_START) - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FAT_ROOT:
		db		'BOOTABLE', 'DSK'										; + 0:ボリュームラベル
		db		ATTR_ARCHIVE | ATTR_VOLUME_ID							; +11:属性
		db		0x00													; +12:（予約）
		db		0x00													; +13:TS
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +14:作成時刻
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +16:作成日
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +18:アクセス日
		dw		0x0000													; +20:（予約）
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +22:更新時刻
		dw		( 0 <<  9) | ( 0 << 5) | ( 1)							; +24:更新日
		dw		0														; +26:先頭クラスタ
		dd		0														; +28:ファイルサイズ

		db		'SPECIAL ', 'TXT'										; + 0:ボリュームラベル
		db		ATTR_ARCHIVE											; +11:属性
		db		0x00													; +12:（予約）
		db		0x00													; +13:TS
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +14:作成時刻
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +16:作成日
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +18:アクセス日
		dw		0x0000													; +20:（予約）
		dw		( 0 << 11) | ( 0 << 5) | (0 / 2)						; +22:更新時刻
		dw		( 0 <<  9) | ( 1 << 5) | ( 1)							; +24:更新日
		dw		2														; +26:先頭クラスタ
		dd		FILE.end - FILE											; +28:ファイルサイズ

;************************************************************************
;	FAT:データ領域
;************************************************************************
		times FILE_START - ($ - $$)	db	0x00
;------------------------------------------------------------------------
FILE:	db		'hello, FAT!'
.end:	db		0

ALIGN 512, db 0x00



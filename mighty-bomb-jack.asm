; -----------------------------------------
; Mighty Bomb Jack disassembly
; -----------------------------------------

; ------------------------------
; Build settings
END_OF_ROM_PADDING		= $FF		; Padding used for empty space
; Use the weaker version of the copyright check:
; see https://www.nesdev.org/wiki/CNROM#Mapper_185
WEAK_COPYRIGHT_CHECK	= 1

; NES mapper used
NES_MAPPER_NUM			= 185	; CNROM (spicy)
CHR_ROM_BANKS			= 1


IFDEF REV_A
	END_OF_ROM_PADDING		= $00
	WEAK_COPYRIGHT_CHECK	= 0
ENDIF
IFDEF REV_US
	END_OF_ROM_PADDING		= $FF
	WEAK_COPYRIGHT_CHECK	= 0
	NES_MAPPER_NUM			= 3	; CNROM
	CHR_ROM_BANKS			= 4
	USE_MORE_ZP equ 1
ENDIF



; -----------------------------------------
; Enable "round select" on title screen.
; A: start at selected round
; start: normal game start
; left/right: change round
;ROUND_SELECT equ 1

IFDEF ROUND_SELECT
	; If the menu is enabled, always use better opcodes
	IFNDEF USE_MORE_ZP
		USE_MORE_ZP equ 1
	ENDIF
ENDIF


; -----------------------------------------
; Add iNES header

	INESPRG 2				; 2 x 16KB PRG pages
	INESCHR CHR_ROM_BANKS	; # x 8KB CHR-ROM pages
	INESMAP NES_MAPPER_NUM	; Mapper number
	INESMIR 0				; Horizontal

; -----------------------------------------
; Add macros
.include "src/macros.asm"

; Add definitions
.enum $0000
.include "src/defs.asm"
.ende

; Add RAM definitions
.enum $0000
.include "src/ram.asm"
.include "src/registers.asm"
.ende


.base $8000

; -----------------------------------------
; Mighty Bomb Jack nicely splits itself into two sections:
; Code
.include "src/prg.asm"

; -----------------------------------------
; Data
.include "src/data.asm"
.include "src/music-data.asm"

; -----------------------------------------
; Then whatever you wanna stick in before the end
.include "src/end-of-rom-injection.asm"


; -----------------------------------------
; Pad end of ROM; the value used depends on region
.pad $FFFA, END_OF_ROM_PADDING

; -----------------------------------------
; CPU vectors
.dw NMI
.dw RESET
.dw IRQ


; -----------------------------------------
; Include CHR-ROM
IFDEF REV_US
	.incbin "src/mbj-us.chr"
ELSE
	.incbin "src/mbj-jp.chr"
ENDIF

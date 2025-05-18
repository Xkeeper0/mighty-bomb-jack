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
	END_OF_ROM_PADDING		= $00
	WEAK_COPYRIGHT_CHECK	= 0
	NES_MAPPER_NUM			= 3	; CNROM
	CHR_ROM_BANKS			= 4
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


; -----------------------------------------
; Program code
.base $8000
.include "src/prg.asm"
.include "src/data.asm"
.include "src/music-data.asm"
.include "src/vectors.asm"

; Pad empty space
; .pad $FFFF, $FF

; -----------------------------------------
; Include CHR-ROM
IFDEF REV_US
	.incbin "src/mbj-us.chr"
ELSE
	.incbin "src/mbj-jp.chr"
ENDIF

; -----------------------------------------
; Mighty Bomb Jack disassembly
; -----------------------------------------
END_OF_ROM_PADDING = $FF
WEAK_COPYRIGHT_CHECK = 1
IFDEF REV_A
	END_OF_ROM_PADDING = $00
	WEAK_COPYRIGHT_CHECK = 0
ENDIF
IFDEF REV_US
	END_OF_ROM_PADDING = $00
	WEAK_COPYRIGHT_CHECK = 0
ENDIF

; -----------------------------------------
; Add iNES header

	.db "NES", $1a	; iNES header
	.db 2			; 16KB PRG-ROM pages
	.db 1			; 8KB CHR-ROM pages
	.db $90
	.db $B0
	.dsb 8, $00		; Reserved


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
.incbin "src/mbj-jp.chr"

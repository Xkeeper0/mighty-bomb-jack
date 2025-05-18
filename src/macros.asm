
MACRO Palette c1, c2, c3, c4
	.db c1, c2, c3, c4
ENDM Palette

; ---------------------------------------------------------------------------

MACRO SpriteData tile, attrib, xp, yp, spriteindex
	.db tile, attrib, xp, yp, spriteindex
ENDM SpriteData

; ---------------------------------------------------------------------------

MACRO SoundData ch, ofs
	.db ch
	.dw ofs
ENDM SoundData

; ---------------------------------------------------------------------------

MACRO EndingText start, len
	.db start, len
ENDM EndingText

; ---------------------------------------------------------------------------

MACRO Sprite xp, id, at, xp
	.db xp, id, at, xp
ENDM Sprite

; ---------------------------------------------------------------------------

MACRO ScoreValue digit, value
	.db digit, value
ENDM ScoreValue

; ---------------------------------------------------------------------------

MACRO RoomHeader pal, mus, unk
	.db pal, mus, unk
ENDM RoomHeader

; ---------------------------------------------------------------------------

MACRO Door pos, type
	.db pos, type
ENDM Door

; ---------------------------------------------------------------------------

MACRO SndJmpF0 target
	.db $F0
	.dw target
ENDM SndJmp

MACRO SndJmpF3 target
	.db $F3
	.dw target
ENDM SndJmp

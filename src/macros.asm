
MACRO Palette c1, c2, c3, c4
	.db c1, c2, c3, c4
ENDM Palette

; ---------------------------------------------------------------------------

MACRO SpriteData tile, attrib, xp, yp, spriteindex; (sizeof=0x5)
	.db tile, attrib, xp, yp, spriteindex
ENDM SpriteData

; ---------------------------------------------------------------------------

MACRO SoundData ch, ofs	; (sizeof=0x3)
	.db ch
	.dw ofs
ENDM SoundData

; ---------------------------------------------------------------------------

MACRO EndingText start, len ; (sizeof=0x2)
	.db start, len
ENDM EndingText

; ---------------------------------------------------------------------------

MACRO Sprite xp, id, at, xp; (sizeof=0x4)
	.db xp, id, at, xp
ENDM Sprite

; ---------------------------------------------------------------------------

MACRO ScoreValue digit, value ; (sizeof=0x2)
	.db digit, value
ENDM ScoreValue

; ---------------------------------------------------------------------------

MACRO RoomHeader pal, mus, unk; (sizeof=0x3)
	.db pal, mus, unk
ENDM RoomHeader

; ---------------------------------------------------------------------------

MACRO Door pos, type ; (sizeof=0x2)
	.db pos, type
ENDM Door

; ---------------------------------------------------------------------------

MACRO SndJmp b_F0, target ; (sizeof=0x3)
	.db b_F0
	.dw target
ENDM SndJmp

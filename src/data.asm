; ------------------------------------------
; Data section
; ------------------------------------------
; ------------------------------------------
; ------------------------------------------

; IFDEF REV_US
; 	PAD $BEAE, $00
; ENDIF

SpriteAnimationTable:
	.WORD SpriteAnimation_0_D_F
	.WORD SpriteAnimation_1		; 1
	.WORD SpriteAnimation_2		; 2
	.WORD SpriteAnimation_3		; 3
	.WORD SpriteAnimation_4		; 4
	.WORD SpriteAnimation_5		; 5
	.WORD SpriteAnimation_6		; 6
	.WORD SpriteAnimation_7		; 7
	.WORD SpriteAnimation_8		; 8
	.WORD SpriteAnimation_9		; 9
	.WORD SpriteAnimation_A		; $A
	.WORD SpriteAnimation_B		; $B
	.WORD SpriteAnimation_C		; $C
	.WORD SpriteAnimation_0_D_F	; $D
	.WORD SpriteAnimation_E		; $E
	.WORD SpriteAnimation_0_D_F	; $F
	.WORD SpriteAnimation_10	; $10

; first	byte: frame length
; second byte: frame #
; third	byte: attributes

SpriteAnimation_0_D_F:
	.BYTE    5,  $E, 3
	.BYTE    5, $F,   3		; 3 ; Mummy
	.BYTE $FF
SpriteAnimation_1:
	.BYTE 5, $10,   3
	.BYTE    5,	$11,   3		; 3 ; Mummy (falling)
	.BYTE $FF
SpriteAnimation_2:
	.BYTE 5, $13,   2
	.BYTE    5,	$12,   2		; 3 ; Hanezo (red bouncy guy)
	.BYTE    5,	$13,   6		; 6
	.BYTE $FF
SpriteAnimation_3:
	.BYTE 5,  $C,   2
	.BYTE    5, $D,   2		; 3 ; Geji Shogun (red bug)
	.BYTE $FF
SpriteAnimation_4:
	.BYTE 5, $16,   3
	.BYTE    5,	$17,   3		; 3 ; Gamedo (green turtle)
	.BYTE    5,	$18,   3		; 6
	.BYTE $FF
SpriteAnimation_5:
	.BYTE 5, $14,   3
	.BYTE    5,	$15,   3		; 3 ; Dokuron (green skull)
	.BYTE $FF
SpriteAnimation_6:
	.BYTE 5,	7,   0
	.BYTE    5, 7,   8		; 3 ; Desufa (red fireball)
	.BYTE $FF
SpriteAnimation_7:
	.BYTE 5,	8,   3
	.BYTE    5, 9,   3		; 3 ; Horus (green bird)
	.BYTE $FF
	.BYTE    5, 8,   7
	.BYTE    5, 9,   7		; 3
	.BYTE $FF
	.BYTE    5, $A,   3
	.BYTE    5, $B,   3		; 3
	.BYTE $FF
SpriteAnimation_8:
	.BYTE 5, $20,   1	 ; P coin
	.BYTE $FF
SpriteAnimation_9:
	.BYTE 4, $1B,   0
	.BYTE    4,	$1C,   0		; 3 ; E	coin
	.BYTE    4,	$1D,   0		; 6
	.BYTE $FF
SpriteAnimation_A:
	.BYTE 0, $1F,   0	 ; S coin
	.BYTE $FF
SpriteAnimation_B:
	.BYTE 0, $23,   3	 ; Captive
	.BYTE $FF
SpriteAnimation_C:
	.BYTE 0, $24,   0	 ; Balloon
	.BYTE $FF
SpriteAnimation_E:
	.BYTE 4, $19,   0
	.BYTE    4,	$1A,   0		; 3 ; B	coin
	.BYTE    4,	$1D,   0		; 6
	.BYTE $FF
SpriteAnimation_10:
	.BYTE  $10, 0,   1
	.BYTE  $28, 1,   1		; 3 ; Brother
	.BYTE $FF
EnemyInitialStatus:
	.BYTE      1
	.BYTE      1			; 1
	.BYTE      1			; 2
	.BYTE      1			; 3
	.BYTE      1			; 4
	.BYTE      1			; 5
	.BYTE      1			; 6
	.BYTE      1			; 7
	.BYTE %10001			; 8
	.BYTE %10001			; 9
	.BYTE %10101			; $A
	.BYTE %10101			; $B
	.BYTE %10001			; $C
	.BYTE %10001			; $D
	.BYTE %10001			; $E
	.BYTE %10001			; $F
	.BYTE %10101			; $10
DifficultyTable:
	.BYTE 0, $A0, $80, $40
	.BYTE    1,	$80, $70, $38		; 4 ; based on last bomb room
	.BYTE    1,	$70, $60, $30		; 8 ; (i.e. last "stage	x cleared")
	.BYTE    2,	$60, $50, $28		; $C ;
	.BYTE    2,	$58, $40, $20		; $10 ;	first byte: enemy speed
	.BYTE    3,	$50, $30, $18		; $14 ;	second byte: spawn timer
	.BYTE    3,	$48, $20, $10		; $18 ;	third/fourth: transform	timer
	.BYTE    4,	$40, $10,   8		; $1C ;
	.BYTE    4,	$40,   8,   8		; $20 ;	round 1/2 use 1st line,
	.BYTE    5,	$40,   8,   8		; $24 ;	round 3	uses 2nd line,
	.BYTE    1,	$30,   8,   8		; $28 ;	round 4	uses 3rd line, ...
	.BYTE    5,	$40,   8,   8		; $2C ;
	.BYTE    6,	$40,   8,   8		; $30 ;	the second transform timer
	.BYTE    6,	$40,   8,   8		; $34 ;	is used	in royal palace
	.BYTE    7,	$40,   8,   8		; $38 ;	(aka bomb) rooms
	.BYTE    2,	$40,   8,   8		; $3C
byte_C0CB:
	.BYTE $4C
	.BYTE  $48				; 1
	.BYTE  $44				; 2
	.BYTE  $40				; 3
	.BYTE  $3C				; 4
	.BYTE  $38				; 5
	.BYTE  $34				; 6
	.BYTE  $30				; 7
word_C0D3:
	.WORD $58
	.WORD  $70				; 1
	.WORD  $88				; 2
	.WORD  $A0				; 3
	.WORD  $B8				; 4
	.WORD  $D0				; 5
	.WORD  $E8				; 6
	.WORD $100				; 7
word_C0E3:
	.WORD	$380
	.WORD $37C				; 1
	.WORD $378				; 2
	.WORD $374				; 3
	.WORD $370				; 4
	.WORD $368				; 5
	.WORD $360				; 6
	.WORD $358				; 7
	.WORD $350				; 8
	.WORD $348				; 9
	.WORD $340				; $A
	.WORD $330				; $B
	.WORD $320				; $C
	.WORD $310				; $D
	.WORD $300				; $E
	.WORD $2F0				; $F
	.WORD $2E0				; $10
	.WORD $2D0				; $11
	.WORD $2C0				; $12
	.WORD $2B0				; $13
	.WORD $2A0				; $14
	.WORD $290				; $15
	.WORD $280				; $16
	.WORD $270				; $17
	.WORD $260				; $18
	.WORD $250				; $19
	.WORD $240				; $1A
	.WORD $230				; $1B
	.WORD $220				; $1C
	.WORD $210				; $1D
	.WORD $200				; $1E
	.WORD $1F0				; $1F
	.WORD $1E0				; $20
	.WORD $1D0				; $21
	.WORD $1C0				; $22
	.WORD $1B0				; $23
	.WORD $1A0				; $24
	.WORD $190				; $25
	.WORD $180				; $26
	.WORD $170				; $27
	.WORD $160				; $28
	.WORD $150				; $29
	.WORD $140				; $2A
	.WORD $130				; $2B
	.WORD $120				; $2C
	.WORD $110				; $2D
	.WORD $100				; $2E
	.WORD  $F0				; $2F
	.WORD  $E0				; $30
	.WORD  $D0				; $31
	.WORD  $C0				; $32
	.WORD  $B0				; $33
	.WORD  $A0				; $34
	.WORD  $90				; $35
	.WORD  $80				; $36
	.WORD  $70				; $37
	.WORD  $5E				; $38
	.WORD  $4C				; $39
	.WORD  $3A				; $3A
	.WORD  $28				; $3B
	.WORD  $10				; $3C
	.WORD    8				; $3D
	.WORD    2				; $3E
	.WORD    1				; $3F
word_C163:
	.WORD $F0
	.WORD $160				; 1
	.WORD  $A0				; 2
	.WORD  $D0				; 3
MainPalette:
	.BYTE  $21, $F, $26, $30
	.BYTE  $21, 8, $27, $38		; 4 ; background
	.BYTE  $21, $A, $1A, $39		; 8
	.BYTE  $21, $F, $16, $30		; $C

	.BYTE  $21,	$16, $16, $30		; sprites
	.BYTE  $21,	$30, $12, $16		; 4
	.BYTE  $21, 8, $16, $30		; 8
	.BYTE  $21, $F, $2B, $30		; $C
BackgroundPaletteSets:
	.BYTE   $A, $16, $26, $38
	.BYTE   $A, $F, $10, $30		; 4 ; set 0
	.BYTE   $A, $F, $16, $30		; 8

	.BYTE  $21, 8, $27, $38		; set 1
	.BYTE  $21, $A, $1A, $39		; 4
	.BYTE  $21, $F, $16, $30		; 8

	.BYTE    1,	$16, $26, $38		; set 2
	.BYTE    1, $F, $22, $30		; 4
	.BYTE    1, $F, $16, $30		; 8

	.BYTE    9,	$1A, $2A, $39		; set 3
	.BYTE    9, 8, $27, $30		; 4
	.BYTE    9, 8, $16, $30		; 8

	.BYTE   $A,	$1A, $2A, $39		; set 4
	.BYTE   $A,	$3F, $22, $30		; 4
	.BYTE   $A,	$3F, $16, $30		; 8

	.BYTE    4,	$1A, $2A, $39		; set 5
	.BYTE    4, $F, $32, $30		; 4
	.BYTE    4, $F, $16, $30		; 8

	.BYTE    8,	$16, $26, $38		; set 6
	.BYTE    8, $F, $2A, $39		; 4
	.BYTE    8, $F, $16, $30		; 8

	.BYTE   $C,	$16, $26, $38		; set 7
	.BYTE   $C, $F, $14, $34		; 4
	.BYTE   $C, $F, $16, $30		; 8

	.BYTE  $11,	$16, $26, $38		; set 8
	.BYTE  $11, $F, $10, $30		; 4
	.BYTE  $11,	$11, $16, $30		; 8
MightyLevelColors:
	.BYTE $16, $12, $26,	$2A
MightyLevelAPressesTable:
	.BYTE 1,  20,  30,	35 ; (1), 20, 30, 35
MusicOptionsTable:
	.BYTE	Music_MainWithIntro
	.BYTE Music_Main			; 1 ; usual stage music
	.BYTE Music_TreasureRoom		; 2
	.BYTE Music_SideRoom		; 3
	.BYTE Music_Labyrinth		; 4
	.BYTE Music_Outside1		; 5
	.BYTE Music_Outside2		; 6
	.BYTE Music_TortureRoom		; 7
DoorEntryXYPositionTable:
	.BYTE	$18, $20
	.BYTE  $18,	$E0			; 2
	.BYTE  $18,	$20			; 4
	.BYTE  $18,	$E0			; 6
	.BYTE  $E8,	$20			; 8
	.BYTE  $E8,	$E0			; $A
	.BYTE  $D8,	$20			; $C
	.BYTE  $D8,	$E0			; $E
	.BYTE  $30,	$C8			; $10
	.BYTE  $C0,	$F8			; $12
	.BYTE  $30,	$F8			; $14
	.BYTE  $C0,	$F8			; $16
	.BYTE  $30,	$38			; $18
	.BYTE  $C0, 8			; $1A
	.BYTE  $30, 8			; $1C
	.BYTE  $C0, 8			; $1E
VectorTable:
	.BYTE    1, 0
	.BYTE   -1, 0			; 2 ; RLUD (+1,	0 / -1,	0 /  0,-1 /  0,+1)
	.BYTE    0, -1			; 4
	.BYTE    0, 1			; 6
MaybeEntryTypeTable:
	.BYTE   $E, $A
	.BYTE    0, 9			; 2
	.BYTE   $D, 9			; 4
	.BYTE   $D, 9			; 6
	.BYTE    9, $D			; 8
	.BYTE    9, $D			; $A
	.BYTE   $A, $D			; $C
	.BYTE   $A, $E			; $E
	.BYTE   $E, 9			; $10
	.BYTE   $D, $A			; $12
	.BYTE   $E, $B			; $14
	.BYTE   $E, 1			; $16
	.BYTE   $A, $E			; $18
	.BYTE   $A, $E			; $1A
	.BYTE    9, 0			; $1C
	.BYTE   $E, 0			; $1E
SpritesTable:
	.BYTE  $44, $10, $10, $12,	$12
	.BYTE  $44,	$11, $11, $13, $13	; 5 ; 46 (#$2E)	entries
	.BYTE  $44,	$14, $14, $16, $16	; $A
	.BYTE  $44,	$15, $15, $17, $17	; $F
	.BYTE    0,	$1C, $1D, $1E, $1F	; $14
	.BYTE    0,	$1C, $1D, $20, $21	; $19
	.BYTE    0,	$18, $19, $1A, $1B	; $1E
	.BYTE    0,	$48, $49, $4A, $4B	; $23
	.BYTE    0,	$78, $79, $7A, $7B	; $28
	.BYTE    0,	$7C, $7D, $7E, $7F	; $2D
	.BYTE    0,	$D0, $D1, $D2, $D3	; $32
	.BYTE    0,	$D4, $D5, $D6, $D7	; $37
	.BYTE    0,	$C0, $C1, $C2, $C3	; $3C
	.BYTE    0,	$C4, $C5, $C6, $C7	; $41
	.BYTE    0,	$70, $71, $72, $73	; $46
	.BYTE    0,	$74, $75, $76, $77	; $4B
	.BYTE    0,	$60, $61, $62, $63	; $50
	.BYTE    0,	$64, $65, $66, $67	; $55
	.BYTE    0,	$5C, $5D, $5E, $5F	; $5A
	.BYTE    0,	$58, $59, $5A, $5B	; $5F
	.BYTE    0,	$68, $69, $6A, $6B	; $64
	.BYTE    0,	$6C, $6D, $6E, $6F	; $69
	.BYTE    0,	$A8, $A9, $AA, $AB	; $6E
	.BYTE    0,	$AC, $AD, $AE, $AF	; $73
	.BYTE    0,	$B8, $B9, $BA, $BB	; $78
	.BYTE    0,	$2A, $2B, $80, $81	; $7D
	.BYTE    0,	$2E, $2F, $84, $85	; $82
	.BYTE    0,	$22, $23, $28, $29	; $87
	.BYTE    0,	$26, $27, $2C, $2D	; $8C
	.BYTE    0,	$86,  $F, $87,	$F	; $91
	.BYTE    0,	$24, $25, $26, $27	; $96
	.BYTE  $33,	$A1, $8B, $8B, $A1	; $9B
	.BYTE    0,	$40, $41, $42, $43	; $A0
	.BYTE  $44,	$44, $44, $46, $46	; $A5
	.BYTE    0,	$82, $83,  $F,	$F	; $AA
	.BYTE  $44,	$A0, $A0, $A2, $A2	; $AF
	.BYTE    0,	$E0, $E1, $E2, $E3	; $B4
	.BYTE  $E4,	$8C, $8C, $8C, $8C	; $B9
	.BYTE    0,	$50, $51, $52, $53	; $BE
	.BYTE    0,	$54, $55, $56, $57	; $C3
	.BYTE  $44,	$45, $45, $47, $47	; $C8
	.BYTE  $44,	$4D, $4D, $4F, $4F	; $CD
	.BYTE  $40, $F,  $F, $8A, $8A	; $D2
	.BYTE    0,	$A4, $A5, $A6, $A7	; $D7
	.BYTE    0,	$B0, $B1, $B2, $B3	; $DC
	.BYTE    0,	$B4, $B5, $B6, $B7	; $E1
StringPointerTable:
	.WORD String_PushStartButton
	.WORD String_GameOver		; 1
	.WORD String_TimeOver		; 2
	.WORD String_YouAreGreedy		; 3
	.WORD String_GoToTheTortureRoom	; 4
	.WORD String_Round_Clear		; 5
	.WORD String_TimeBonus		; 6
	.WORD String_YouveGotten		; 7
	.WORD String_FireBombs		; 8
	.WORD String_SpecialBonus		; 9
	.WORD String_YourGDV		; $A
	.WORD String_C_Tecmo		; $B
	.WORD String_HighGDV		; $C
	.WORD String_TheCurseOfBelzebutHas	; $D
	.WORD String_BeenSolvedAndPeaceHas	; $E
	.WORD String_AgainComeToTheWorld	; $F
	.WORD String_JackWillBeHonored	; $10
	.WORD String_ForeverAsTheHeroWho	; $11
	.WORD String_RescuedTheKingAndQueen	; $12
	.WORD String_JackAndThePrincessGot	; $13
	.WORD String_MarriedAndABabyWasBorn	; $14
	.WORD String_HeIsDestinedToFight	; $15
	.WORD String_ForWorldPeaceSomeDay	; $16
	.WORD String_KingPameraWasMovedTo	; $17
	.WORD String_TearsWithPleasure	; $18
	.WORD String_SeeingItJackFoundOut	; $19
	.WORD String_AndShoutedFather	; $1A
String_PushStartButton:
	.WORD $1C8
	.BYTE _P,_U,_S,_H,__,_S,_T,_A,_R,_T,__,_B,_U,_T,_T,_O,_N
	.BYTE $FF
String_GameOver:
	.WORD $18C
	.BYTE _G,_A,_M,_E,__,_O,_V,_E,_R
	.BYTE $FF
String_TimeOver:
	.WORD $18C
	.BYTE _T,_I,_M,_E,__,_O,_V,_E,_R
	.BYTE $FF
String_YouAreGreedy:
	.WORD $109
	.BYTE _Y,_O,_U,__,_A,_R,_E,__,_G,_R,_E,_E,_D,_Y
	.BYTE $FF
String_GoToTheTortureRoom:
	.WORD	$1A4
	.BYTE _G,_O,__,_T,_O,__,_T,_H,_E,__,_T,_O,_R,_T,_U,_R,_E,__,_R,_O,_O,_M
	.BYTE $FF
String_Round_Clear:
	.WORD $109
	.BYTE _R,_O,_U,_N,_D,__,__,__,__,_C,_L,_E,_A,_R
	.BYTE $FF
String_TimeBonus:
	.WORD $1E7
	.BYTE _T,_I,_M,_E,__,_B,_O,_N,_U,_S
	.BYTE $FF
String_YouveGotten:
	.WORD $249
	.BYTE _Y,_O,_U,_ap,_V,_E,__,_G,_O,_T,_T,_E,_N
	.BYTE $FF
String_FireBombs:
	.WORD $2AC
	.BYTE _F,_I,_R,_E,__,_B,_O,_M,_B,_S
	.BYTE $FF
String_SpecialBonus:
	.WORD $305
	.BYTE _S,_P,_E,_C,_I,_A,_L,__,_B,_O,_N,_U,_S
	.BYTE $FF
String_YourGDV:
	.WORD $20A
	.BYTE _Y,_O,_U,_R,__,_G,_D,_V
	.BYTE $FF
String_C_Tecmo:
	.WORD $213
	.BYTE _cp,__,_T,_E,_C,_M,_O
	.BYTE $FF
String_HighGDV:
	.WORD  $56
	.BYTE _H,_I,__,_G,_D,_V
	.BYTE $FF
String_TheCurseOfBelzebutHas:
	.WORD  $64
	.BYTE _T,_H,_E,__,_C,_U,_R,_S,_E,__,_O,_F,__,_B,_E,_L,_Z,_E,_B,_U,_T,__,_H,_A,_S
	.BYTE $FF
String_BeenSolvedAndPeaceHas:
	.WORD  $A3
	.BYTE _B,_E,_E,_N,__,_S,_O,_L,_V,_E,_D,_cma,_A,_N,_D,__,_P,_E,_A,_C,_E,__,_H,_A,_S
	.BYTE $FF
String_AgainComeToTheWorld:
	.WORD  $E3
	.BYTE _A,_G,_A,_I,_N,__,_C,_O,_M,_E,__,_T,_O,__,_T,_H,_E,__,_W,_O,_R,_L,_D
	.BYTE $FF
String_JackWillBeHonored:
	.WORD	$66
	.BYTE _J,_A,_C,_K,__,_W,_I,_L,_L,__,_B,_E,__,_H,_O,_N,_O,_R,_E,_D
	.BYTE $FF
String_ForeverAsTheHeroWho:
	.WORD  $A5
	.BYTE _F,_O,_R,_E,_V,_E,_R,__,_A,_S,__,_T,_H,_E,__,_H,_E,_R,_O,__,_W,_H,_O
	.BYTE $FF
String_RescuedTheKingAndQueen:
	.WORD  $E3
	.BYTE _R,_E,_S,_C,_U,_E,_D,__,_T,_H,_E,__,_K,_I,_N,_G,__,_A,_N,_D,__,_Q,_U,_E,_E,_N
	.BYTE $FF
String_JackAndThePrincessGot:
	.WORD  $63
	.BYTE _J,_A,_C,_K,__,_A,_N,_D,__,_T,_H,_E,__,_P,_R,_I,_N,_C,_E,_S,_S,__,_G,_O,_T
	.BYTE $FF
String_MarriedAndABabyWasBorn:
	.WORD  $A2
	.BYTE _M,_A,_R,_R,_I,_E,_D,__,_A,_N,_D,__,_A,__,_B,_A,_B,_Y,__,_W,_A,_S,__,_B,_O,_R,_N
	.BYTE $FF
String_HeIsDestinedToFight:
	.WORD  $E5
	.BYTE _H,_E,__,_I,_S,__,_D,_E,_S,_T,_I,_N,_E,_D,__,_T,_O,__,_F,_I,_G,_H,_T
	.BYTE $FF
String_ForWorldPeaceSomeDay:
	.WORD $124
	.BYTE _F,_O,_R,__,_W,_O,_R,_L,_D,__,_P,_E,_A,_C,_E,__,_S,_O,_M,_E,__,_D,_A,_Y
	.BYTE $FF
String_KingPameraWasMovedTo:
	.WORD  $64
	.BYTE _K,_I,_N,_G,__,_P,_A,_M,_E,_R,_A,__,_W,_A,_S,__,_M,_O,_V,_E,_D,__,_T,_O
	.BYTE $FF
String_TearsWithPleasure:
	.WORD	$A6
	.BYTE _T,_E,_A,_R,_S,__,_W,_I,_T,_H,__,_P,_L,_E,_A,_S,_U,_R,_E
	.BYTE $FF
String_SeeingItJackFoundOut:
	.WORD  $E3
	.BYTE _S,_E,_E,_I,_N,_G,__,_I,_T,_cma,__,__,_J,_A,_C,_K,__,_F,_O,_U,_N,_D,__,_O,_U,_T
	.BYTE $FF
String_AndShoutedFather:
	.WORD $126
	.BYTE _A,_N,_D,__,_S,_H,_O,_U,_T,_E,_D,__,_ap,_F,_A,_T,_H,_E,_R,_ap
	.BYTE $FF
SpriteAttributeTable:
	.BYTE    0
	.BYTE  $27				; 1 ; maybe related to ending pyramid explosion?
	.BYTE  $55				; 2
	.BYTE  $8D				; 3
	.BYTE  $AA				; 4
	.BYTE  $72				; 5
	.BYTE  $FF				; 6
	.BYTE  $D8				; 7
TileAttributeTable:
	.BYTE %01010101
	.BYTE %01010101			; 1
	.BYTE %01010101			; 2
	.BYTE %01010101			; 3
	.BYTE %01010101			; 4
	.BYTE %01010101			; 5
	.BYTE %01010101			; 6
	.BYTE %01011010			; 7
	.BYTE %01010101			; 8
	.BYTE %01010111			; 9
	.BYTE %11101010			; $A
	.BYTE %10101011			; $B
	.BYTE %10101010			; $C
	.BYTE %00000000			; $D
	.BYTE %00001010			; $E
	.BYTE %10101010			; $F
	.BYTE %10101010			; $10
	.BYTE %10101000			; $11
	.BYTE %00110000			; $12
	.BYTE %11111111			; $13
	.BYTE %11010101			; $14
	.BYTE %10010110			; $15
	.BYTE %10101010			; $16
	.BYTE %10010101			; $17
	.BYTE %01100111			; $18
	.BYTE %11111111			; $19
	.BYTE %11111111			; $1A
	.BYTE %11111111			; $1B
	.BYTE %11111111			; $1C
	.BYTE %11111111			; $1D
	.BYTE %11111111			; $1E
	.BYTE %11111111			; $1F
	.BYTE %11111111			; $20
	.BYTE %11111110			; $21
	.BYTE %10000010			; $22
	.BYTE %10000000			; $23
	.BYTE %00000011			; $24
	.BYTE %11000000			; $25
	.BYTE %00000000			; $26
	.BYTE %00000000			; $27
SectionRoomsTable:
	.WORD	Section_1_1
	.WORD Section_2_1			; 1 ; 42 entries, seems	to be
	.WORD Section_3_1			; 2 ; based on which rooms are
	.WORD Section_4_1			; 3 ; "in the same section"
	.WORD Section_4_2			; 4 ; (e.g. 07 08 09 0A	%0 A8,
	.WORD Section_4_3			; 5 ; which includes the treasure,
	.WORD Section_4_4			; 6 ; but not the bomb room 91)
	.WORD Section_4_5			; 7
	.WORD Section_4_6			; 8
	.WORD Section_4_7			; 9
	.WORD Section_5_1			; $A
	.WORD Section_5_2			; $B
	.WORD Section_6_1			; $C
	.WORD Section_6_2			; $D
	.WORD Section_7_1			; $E
	.WORD Section_7_2			; $F
	.WORD Section_7_3			; $10
	.WORD Section_8_1			; $11
	.WORD Section_8_2			; $12
	.WORD Section_9_1			; $13
	.WORD Section_9_2			; $14
	.WORD Section_9_3			; $15
	.WORD Section_10_1			; $16
	.WORD Section_11_1			; $17
	.WORD Section_11_2			; $18
	.WORD Section_11_3			; $19
	.WORD Section_12_1			; $1A
	.WORD Section_13_1			; $1B
	.WORD Section_13_2			; $1C
	.WORD Section_13_3			; $1D
	.WORD Section_13_4			; $1E
	.WORD Section_14_1			; $1F
	.WORD Section_14_2			; $20
	.WORD Section_15_1			; $21
	.WORD Section_16_1			; $22
	.WORD Section_16_2			; $23
	.WORD Section_17_1			; $24
	.WORD Section_7_4			; $25
	.WORD Section_7_5			; $26
	.WORD Section_7_6			; $27
	.WORD Section_7_7			; $28
	.WORD Section_5_3			; $29
Section_1_1:
	.BYTE    1, 2,   3,   4, 5,   6,   0
Section_2_1:
	.BYTE    7, 8,   9,  $A,	$B, $A8,   0
Section_3_1:
	.BYTE   $C, $D,  $E,  $F, $A9,   0
Section_4_1:
	.BYTE  $10,	$11,   0
Section_4_2:
	.BYTE  $12,	$13, $14, $15, $16, $17, $AA, $AC,   0
Section_4_3:
	.BYTE  $18,	$19, $1A, $1B, $1C, $FA, $FB,	0
Section_4_4:
	.BYTE  $1D,	$1E,   0
Section_4_5:
	.BYTE  $1F,	$20, $21,   0
Section_4_6:
	.BYTE  $22,	$23, $24, $AD, $AE,   0
Section_4_7:
	.BYTE  $25,	$26, $27,   0
Section_5_1:
	.BYTE  $28,	$29, $2A, $2B, $2C, $2D, $AF, $B1,   0
Section_5_2:
	.BYTE  $2E,	$2F, $30, $31, $32, $B2, $FC, $FD,   0
Section_6_1:
	.BYTE  $33,	$34, $35, $36, $37, $38, $39, $B3,   0
Section_6_2:
	.BYTE  $3A,	$3B,   0
Section_7_1:
	.BYTE  $3C,	$3D,   0
Section_7_2:
	.BYTE  $3E,	$3F, $40, $41, 0
Section_7_3:
	.BYTE  $42,	$43, $44,   0
Section_8_1:
	.BYTE  $45,	$46, $47, $48, $49, $B6,   0
Section_8_2:
	.BYTE  $4A,	$4B,   0
Section_9_1:
	.BYTE  $4C,	$4D,   0
Section_9_2:
	.BYTE  $4E,	$4F, $50, $51, $52,   0
Section_9_3:
	.BYTE  $53,	$54, $55, $56, $57, $58, $59, $5A,   0
Section_10_1:
	.BYTE  $5B, $5C, $5D, $5E,	$5F, $60, $B9, 0
Section_11_1:
	.BYTE  $61, $62, $63, $64,	$65, $B4, $B5, 0
Section_11_2:
	.BYTE  $66, $67, $68, $BA, 0
Section_11_3:
	.BYTE  $69, $6A,	0
Section_12_1:
	.BYTE  $6B, $6C, $6D, $6E,	$E7, $E3, $ED, $F4,   0; Includes several rooms of the	"labyrinth"
Section_13_1:
	.BYTE  $6F, $70, $BB, $BC,	$AB,   0
Section_13_2:
	.BYTE  $71, $72,	0
Section_13_3:
	.BYTE  $73, $74, $75, $76, 0
Section_13_4:
	.BYTE  $77, $78, $79, $7A,	$7B, $7C, $7D, 0
Section_14_1:
	.BYTE  $7E, $7F,	0
Section_14_2:
	.BYTE  $80, $81, $82, $BD, 0
Section_15_1:
	.BYTE  $83, $84, $85, $86, 0
Section_16_1:
	.BYTE  $87, $88, $BE,   0
Section_16_2:
	.BYTE  $89, $8A, $8B, $8C,	$8D, $B0,   0
Section_17_1:
	.BYTE  $8E, $8F, $BF,   0
Section_7_4:
	.BYTE  $C0,	$C1, $C2, $C3, $C4,   0	; Crystal ball side path
Section_7_5:
	.BYTE  $C5,	$C6, $C7,   0
Section_7_6:
	.BYTE  $C8,	$C9,   0
Section_7_7:
	.BYTE  $CA,	$CB, $CC, $CD, $B7, $B8,   0
Section_5_3:
	.BYTE  $FE,	$FF,   0		; Secret 5-2 ->	11-3 warp
FireBombBonus:
	.BYTE  $10
	.BYTE  $20				; 1 ; $10, $20,	$30, $50 (thousand)
	.BYTE  $30				; 2
	.BYTE  $50				; 3
MultipliedScoreTable:
	.BYTE     Score_20,    Score_30, Score_40,    Score_50
	.BYTE    Score_200, Score_300,   Score_400,   Score_500; 4
	.BYTE    Score_400, Score_600,  Score_800a,  Score_1000; 8
	.BYTE    Score_600, Score_900,  Score_1200,  Score_1500; $C
	.BYTE   Score_1000, Score_1500,  Score_2000,  Score_2500; $10
	.BYTE   Score_1600, Score_2400,  Score_3200,  Score_4000; $14
	.BYTE   Score_2400, Score_3600,  Score_4800,  Score_6000; $18
	.BYTE   Score_4000, Score_6000,  Score_8000, Score_10000; $1C
ScoreAddTable:
	ScoreValue    0, $10 ;	 ;	DATA XREF: AddScore+24r
	ScoreValue    1, 1 ;		; 1 ; 00:     10
	ScoreValue    1, 2 ;		; 2 ; 01:    100
	ScoreValue    1, 3 ;		; 3 ; 02:    200
	ScoreValue    1, 5 ;		; 4 ; 03:    300
	ScoreValue    1, 8 ;		; 5 ; 04:    500
	ScoreValue    1,  $12 ;		; 6 ; 05:    800  *
	ScoreValue    1,  $20 ;		; 7 ; 06:   1200
	ScoreValue    1,  $10 ;		; 8 ; 07:   2000
	ScoreValue    2, 1 ;		; 9 ; 08:   1000
	ScoreValue    2,  $10 ;		; $A ; 09:  10000
	ScoreValue    2, 5 ;		; $B ; 0A: 100000
	ScoreValue    0,  $20 ;		; $C ; %0:  50000
	ScoreValue    0,  $30 ;		; $D ; 0C:     20
	ScoreValue    0,  $40 ;		; $E ; 0D:     30
	ScoreValue    0,  $50 ;		; $F ; 0E:     40
	ScoreValue    1, 4 ;		; $10 ;	0F:	50
	ScoreValue    1, 6 ;		; $11 ;	10:    400
	ScoreValue    1, 8 ;		; $12 ;	11:    600
	ScoreValue    1, 9 ;		; $13 ;	12:    800 (POI: dupe)
	ScoreValue    1,  $15 ;		; $14 ;	13:    900
	ScoreValue    1,  $25 ;		; $15 ;	14:   1500
	ScoreValue    1,  $16 ;		; $16 ;	15:   2500
	ScoreValue    1,  $24 ;		; $17 ;	16:   1600
	ScoreValue    1,  $32 ;		; $18 ;	17:   2400
	ScoreValue    1,  $40 ;		; $19 ;	18:   3200
	ScoreValue    1,  $36 ;		; $1A ;	19:   4000
	ScoreValue    1,  $48 ;		; $1B ;	1A:   3600
	ScoreValue    1,  $60 ;		; $1C ;	%1:   4800
	ScoreValue    1,  $80 ;		; $1D ;	1C:   6000
					; 1D:	8000
ItemToTileTable:
	.BYTE  $4D
	.BYTE  $4E				; 1 ; 00 4D   100 pt bag
	.BYTE  $4F				; 2 ; 01 4E   300 pt bag
	.BYTE  $47				; 3 ; 02 4F  1000 pt bag
	.BYTE  $49				; 4 ; 03 47  gold coin
	.BYTE  $27				; 5 ; 04 49  mighty drink
	.BYTE  $34				; 6 ; 05 27  bomb
	.BYTE  $48				; 7 ; 06 34  sphinx
	.BYTE  $8F				; 8 ; 07 48  tecmo plate
	.BYTE  $4C				; 9 ; 08 8F  mighty coin
	.BYTE  $4C				; $A ; 09 4C  crystal ball
	.BYTE  $63				; $B ; 0A 4C  crystal ball
	.BYTE  $91				; $C ; %0 63  king
	.BYTE  $90				; $D ; 0C 91  queen
	.BYTE  $50				; $E ; 0D 90  princess
	.BYTE  $2F				; $F ; 0E 50  belzebut mask
	.BYTE  $28				; $10 ;	0F 2F  (nothing)
	.BYTE  $4A				; $11 ;	10 28  red chest
	.BYTE    0				; $12 ;	11 4A  orange chest
	.BYTE    0				; $13
	.BYTE    0				; $14
	.BYTE    0				; $15
	.BYTE    0				; $16
	.BYTE    0				; $17
	.BYTE    0				; $18
	.BYTE    0				; $19
	.BYTE    0				; $1A
	.BYTE    0				; $1B
	.BYTE    0				; $1C
	.BYTE    0				; $1D
	.BYTE    0				; $1E
	.BYTE    0				; $1F
RoomHalfScreens:
	.BYTE 0,   1
	.BYTE  $34,	$22			; 2
	.BYTE  $35,	$23			; 4
	.BYTE  $36,	$24			; 6
	.BYTE  $37,	$25			; 8
	.BYTE  $38,	$26			; $A
	.BYTE  $39,	$27			; $C
	.BYTE  $54,	$5D			; $E
	.BYTE  $55,	$5E			; $10
	.BYTE  $56,	$5F			; $12
	.BYTE  $55,	$5E			; $14
	.BYTE  $57,	$60			; $16
	.BYTE  $46,	$4F			; $18
	.BYTE  $46,	$50			; $1A
	.BYTE  $47,	$50			; $1C
	.BYTE  $48,	$50			; $1E
	.BYTE  $46,	$4F			; $20
	.BYTE  $4B,	$51			; $22
	.BYTE  $38,	$26			; $24
	.BYTE  $3A,	$28			; $26
	.BYTE  $3A,	$30			; $28
	.BYTE  $35,	$31			; $2A
	.BYTE  $3B,	$28			; $2C
	.BYTE  $42,	$2D			; $2E
	.BYTE  $57,	$61			; $30
	.BYTE  $57,	$5D			; $32
	.BYTE  $58,	$5F			; $34
	.BYTE  $59,	$62			; $36
	.BYTE  $59,	$63			; $38
	.BYTE  $49,	$4F			; $3A
	.BYTE  $4A,	$51			; $3C
	.BYTE  $54,	$5D			; $3E
	.BYTE  $57,	$5F			; $40
	.BYTE  $57,	$62			; $42
	.BYTE  $3B,	$26			; $44
	.BYTE  $38,	$30			; $46
	.BYTE  $39,	$24			; $48
	.BYTE  $54,	$63			; $4A
	.BYTE  $59,	$62			; $4C
	.BYTE  $56,	$61			; $4E
	.BYTE  $56,	$64			; $50
	.BYTE  $59,	$61			; $52
	.BYTE  $5A,	$5F			; $54
	.BYTE  $58,	$61			; $56
	.BYTE  $5B,	$5D			; $58
	.BYTE  $5C,	$63			; $5A
	.BYTE  $4B,	$29			; $5C
	.BYTE  $40,	$2A			; $5E
	.BYTE  $40,	$2B			; $60
	.BYTE  $40,	$2B			; $62
	.BYTE  $41,	$2C			; $64
	.BYTE  $5A,	$62			; $66
	.BYTE  $5C,	$65			; $68
	.BYTE  $57,	$65			; $6A
	.BYTE  $5A,	$5D			; $6C
	.BYTE  $58,	$65			; $6E
	.BYTE  $56,	$5D			; $70
	.BYTE  $59,	$5D			; $72
	.BYTE  $39,	$30			; $74
	.BYTE  $34,	$26			; $76
	.BYTE  $42,	$2D			; $78
	.BYTE  $43,	$2E			; $7A
	.BYTE  $59,	$66			; $7C
	.BYTE  $56,	$5F			; $7E
	.BYTE  $58,	$64			; $80
	.BYTE  $57,	$61			; $82
	.BYTE  $4B,	$52			; $84
	.BYTE  $49,	$50			; $86
	.BYTE  $4C,	$53			; $88
	.BYTE  $3F,	$2D			; $8A
	.BYTE  $43,	$24			; $8C
	.BYTE  $42,	$31			; $8E
	.BYTE  $3D,	$30			; $90
	.BYTE  $44,	$2F			; $92
	.BYTE  $56,	$67			; $94
	.BYTE  $5C,	$63			; $96
	.BYTE  $6B,	$6A			; $98
	.BYTE  $79,	$7A			; $9A
	.BYTE  $7B,	$7C			; $9C
	.BYTE  $7D,	$7E			; $9E
	.BYTE  $7D,	$7E			; $A0
	.BYTE  $7D,	$7E			; $A2
	.BYTE  $7F,	$80			; $A4
	.BYTE  $79,	$7A			; $A6
	.BYTE  $81,	$6E			; $A8
	.BYTE  $81,	$6E			; $AA
	.BYTE  $81,	$6E			; $AC
	.BYTE  $81,	$6E			; $AE
	.BYTE  $81,	$6E			; $B0
	.BYTE  $81,	$6E			; $B2
	.BYTE  $6B,	$6A			; $B4
	.BYTE  $34,	$2C			; $B6
	.BYTE  $45,	$2F			; $B8
	.BYTE  $40,	$2B			; $BA
	.BYTE  $43,	$2A			; $BC
	.BYTE  $45,	$33			; $BE
	.BYTE  $42,	$2D			; $C0
	.BYTE  $3C,	$32			; $C2
	.BYTE  $3D,	$31			; $C4
	.BYTE  $3E,	$32			; $C6
	.BYTE  $3D,	$31			; $C8
	.BYTE  $3F,	$30			; $CA
	.BYTE  $5C,	$66			; $CC
	.BYTE  $58,	$67			; $CE
	.BYTE  $57,	$64			; $D0
	.BYTE  $44,	$32			; $D2
	.BYTE  $3F,	$30			; $D4
	.BYTE  $43,	$2C			; $D6
	.BYTE  $36,	$32			; $D8
	.BYTE  $3C,	$31			; $DA
	.BYTE  $39,	$30			; $DC
	.BYTE  $5A,	$62			; $DE
	.BYTE  $5C,	$63			; $E0
	.BYTE  $6C,	$6D			; $E2
	.BYTE  $6F,	$70			; $E4
	.BYTE  $7B,	$7C			; $E6
	.BYTE  $7D,	$7E			; $E8
	.BYTE  $7D,	$7E			; $EA
	.BYTE  $7F,	$80			; $EC
	.BYTE  $6F,	$70			; $EE
	.BYTE  $81,	$6E			; $F0
	.BYTE  $81,	$6E			; $F2
	.BYTE  $81,	$6E			; $F4
	.BYTE  $81,	$6E			; $F6
	.BYTE  $81,	$6E			; $F8
	.BYTE  $6C,	$6D			; $FA
	.BYTE  $3F,	$30			; $FC
	.BYTE  $43,	$2E			; $FE
	.BYTE  $4D,	$52			; $100
	.BYTE  $47,	$50			; $102
	.BYTE  $4E,	$53			; $104
	.BYTE  $3F,	$24			; $106
	.BYTE  $41,	$28			; $108
	.BYTE  $36,	$2D			; $10A
	.BYTE  $3B,	$2C			; $10C
	.BYTE  $56,	$67			; $10E
	.BYTE  $54,	$66			; $110
	.BYTE  $3C,	$32			; $112
	.BYTE  $3E,	$33			; $114
	.BYTE  $3C,	$32			; $116
	.BYTE  $43,	$33			; $118
	.BYTE  $42,	$2D			; $11A
	.BYTE  $56,	$64			; $11C
	.BYTE  $5C,	$5D			; $11E
	.BYTE    2, 3			; $120
	.BYTE    4, 5			; $122
	.BYTE    6, 7			; $124
	.BYTE    8, 9			; $126
	.BYTE   $A, $B			; $128
	.BYTE   $C, $D			; $12A
	.BYTE   $E, $F			; $12C
	.BYTE  $10,	$11			; $12E
	.BYTE  $12,	$13			; $130
	.BYTE  $14,	$15			; $132
	.BYTE  $1A,	$1B			; $134
	.BYTE  $18,	$19			; $136
	.BYTE  $16,	$17			; $138
	.BYTE  $1C,	$1D			; $13A
	.BYTE  $1E,	$1F			; $13C
	.BYTE  $20,	$21			; $13E
	.BYTE  $78,	$77			; $140
	.BYTE  $78,	$77			; $142
	.BYTE  $78,	$77			; $144
	.BYTE  $78,	$77			; $146
	.BYTE  $78,	$77			; $148
	.BYTE  $78,	$77			; $14A
	.BYTE   $A, $B			; $14C
	.BYTE   $A, $B			; $14E
	.BYTE   $A, $B			; $150
	.BYTE   $A,	$69			; $152
	.BYTE   $A, $B			; $154
	.BYTE   $A, $B			; $156
	.BYTE    6, 7			; $158
	.BYTE  $5A,	$61			; $15A
	.BYTE  $54,	$63			; $15C
	.BYTE   $A, $B			; $15E
	.BYTE   $A, $B			; $160
	.BYTE   $A,	$69			; $162
	.BYTE   $A, $B			; $164
	.BYTE   $A, $B			; $166
	.BYTE  $54,	$63			; $168
	.BYTE  $5A,	$61			; $16A
	.BYTE   $A,	$69			; $16C
	.BYTE  $72,	$74			; $16E
	.BYTE  $71,	$73			; $170
	.BYTE   $A, $B			; $172
	.BYTE   $A,	$69			; $174
	.BYTE   $A, $B			; $176
	.BYTE   $A, $B			; $178
	.BYTE   $A,	$69			; $17A
	.BYTE   $A, $B			; $17C
	.BYTE   $A, $B			; $17E
	.BYTE  $4B,	$52			; $180
	.BYTE  $37,	$30			; $182
	.BYTE  $34,	$31			; $184
	.BYTE  $3A,	$32			; $186
	.BYTE  $49,	$32			; $188
	.BYTE  $56,	$61			; $18A
	.BYTE  $58,	$60			; $18C
	.BYTE  $54,	$5D			; $18E
	.BYTE  $41,	$2C			; $190
	.BYTE  $39,	$29			; $192
	.BYTE  $57,	$64			; $194
	.BYTE  $5B,	$66			; $196
	.BYTE  $55,	$64			; $198
	.BYTE  $5C,	$63			; $19A
	.BYTE   $A, $B			; $19C
	.BYTE   $A, $B			; $19E
	.BYTE   $A, $B			; $1A0
	.BYTE   $A, $B			; $1A2
	.BYTE   $A, $B			; $1A4
	.BYTE   $A, $B			; $1A6
	.BYTE   $A, $B			; $1A8
	.BYTE   $A, $B			; $1AA
	.BYTE   $A, $B			; $1AC
	.BYTE   $A, $B			; $1AE
	.BYTE  $71,	$73			; $1B0
	.BYTE   $A, $B			; $1B2
	.BYTE  $71,	$73			; $1B4
	.BYTE   $A, $B			; $1B6
	.BYTE  $71,	$73			; $1B8
	.BYTE   $A, $B			; $1BA
	.BYTE  $72,	$74			; $1BC
	.BYTE   $A, $B			; $1BE
	.BYTE  $75,	$76			; $1C0
	.BYTE   $A, $B			; $1C2
	.BYTE  $75,	$76			; $1C4
	.BYTE   $A, $B			; $1C6
	.BYTE   $A, $B			; $1C8
	.BYTE   $A, $B			; $1CA
	.BYTE  $72,	$74			; $1CC
	.BYTE   $A, $B			; $1CE
	.BYTE  $75,	$76			; $1D0
	.BYTE   $A, $B			; $1D2
	.BYTE  $71,	$73			; $1D4
	.BYTE   $A, $B			; $1D6
	.BYTE  $71,	$73			; $1D8
	.BYTE   $A, $B			; $1DA
	.BYTE  $72,	$74			; $1DC
	.BYTE   $A, $B			; $1DE
	.BYTE  $72,	$74			; $1E0
	.BYTE   $A, $B			; $1E2
	.BYTE  $72,	$74			; $1E4
	.BYTE  $71,	$73			; $1E6
	.BYTE   $A, $B			; $1E8
	.BYTE   $A, $B			; $1EA
	.BYTE   $A, $B			; $1EC
	.BYTE   $A, $B			; $1EE
	.BYTE   $A, $B			; $1F0
	.BYTE  $72,	$74			; $1F2
	.BYTE  $39,	$27			; $1F4
	.BYTE  $38,	$25			; $1F6
	.BYTE  $5A,	$62			; $1F8
	.BYTE  $59,	$63			; $1FA
	.BYTE  $56,	$64			; $1FC
	.BYTE  $5C,	$63			; $1FE
HalfScreenLayouts:
	.BYTE    0,   0, $C2,	$C3, $C4, $C5, $C6,   0,   1,	2,   3, 4,   5,   7, 6,   0
	.BYTE    0, 0, $C7, $C8, $C9, $CA, $CB,	0,   8, 9,  $A,  $B,	$C,  $D,  $E,	0; $10 ; For whatever reason,
	.BYTE  $69,	$7B, $7B, $7B,	$F,  $F, $7B, $7B, $10,	$10, $10, $10, $7B, $7B, $7B, $69; $20 ; 55-5F = 60-6A.
	.BYTE  $69,	$43, $43, $11, $11, $43, $43, $12, $12,	$13, $14, $14, $43, $43, $43, $69; $30 ; (everything >=	#$60 is	- #$B)
	.BYTE  $69, $F,  $F,  $F, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7B,	$F,  $F,  $F, $69; $40 ; i'm not sure why this is
	.BYTE  $69,	$43, $43, $15, $15, $16, $16, $43, $43,	$16, $16, $15, $15, $43, $43, $69; $50
	.BYTE  $69,	$7B, $7B, $7B, $7B, $17, $17, $7B, $7B,	$17, $17, $7B, $7B, $7B, $7B, $69; $60
	.BYTE  $69,	$43, $43, $16, $16, $43, $43, $12, $12,	$43, $43, $16, $16, $43, $43, $69; $70
	.BYTE  $69,	$7B, $7B, $7B, $17, $17, $7B, $7B, $7B,	$7B, $17, $17, $7B, $7B, $7B, $69; $80
	.BYTE  $69,	$43, $43, $43, $16, $16, $43, $43, $43,	$43, $16, $16, $43, $43, $43, $69; $90
	.BYTE  $69,	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $69; $A0
	.BYTE  $69,	$43, $43, $43, $43, $43, $43, $43, $43,	$43, $43, $43, $43, $43, $43, $69; $B0
	.BYTE  $69, $F,  $F,  $F,	$F, $7B, $7B, $7B, $17,	$17, $18, $19, $19, $7B, $7B, $69; $C0
	.BYTE  $69,	$43, $43, $43, $1A, $1A, $1A, $1A, $1A,	$1A, $1B, $43, $43, $43, $43, $69; $D0
	.BYTE  $69,	$7B, $7B, $7B, $7B, $1C, $1C, $17, $17,	$1C, $1C, $7B, $7B, $7B, $7B, $69; $E0
	.BYTE  $69,	$43, $43, $43, $43, $15, $15, $14, $14,	$15, $15, $43, $43, $43, $43, $69; $F0
	.BYTE  $69,	$7B, $7B,  $F,	$F, $1D, $7B, $7B, $7B,	$7B, $1E,  $F,	$F, $7B, $7B, $69; $100
	.BYTE  $69,	$43, $43, $12, $12, $1F, $43, $43, $43,	$43, $20, $12, $12, $43, $43, $69; $110
	.BYTE  $69,	$7B, $7B, $7B, $7B, $7B, $21, $22, $23,	$7B, $7B, $7B, $7B, $7B, $7B, $69; $120
	.BYTE  $69,	$43, $43, $16, $16, $16, $16, $24, $25,	$15, $15, $43, $43, $43, $43, $69; $130
	.BYTE  $69,	$7B, $7B, $17, $17, $19, $19, $17, $17,	$19, $19, $17, $17, $7B, $7B, $69; $140
	.BYTE  $69,	$43, $43, $12, $12, $14, $14, $12, $12,	$14, $14, $12, $12, $43, $43, $69; $150
	.BYTE  $69, $F,  $F,  $F, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $27, $27, $27, $69; $160
	.BYTE  $69,	$28, $28, $28, $43, $43, $43, $43, $43,	$43, $43, $43, $29, $29, $29, $69; $170
	.BYTE  $69,	$7B, $7B, $7B, $2A, $17, $17, $17, $17,	$17, $17, $2B, $7B, $7B, $7B, $69; $180
	.BYTE  $69,	$43, $43, $43, $1B, $43, $43, $16, $16,	$43, $43, $2C, $43, $43, $43, $69; $190
	.BYTE  $69,	$7B, $7B, $2D, $7B, $2E, $2F,  $F,  $F,	$2F, $30, $7B, $31, $7B, $7B, $69; $1A0
	.BYTE  $69,	$43, $43, $32, $43, $33, $14, $12, $12,	$14, $47, $43, $34, $43, $43, $69; $1B0
	.BYTE  $69,	$7B, $7B, $35, $36, $36, $37, $37, $38,	$7B, $7B, $7B, $39, $7B, $7B, $69; $1C0
	.BYTE  $69,	$43, $43, $3A, $43, $43, $43, $3B, $14,	$14, $E2, $E2, $26, $43, $43, $69; $1D0
	.BYTE  $69,	$7B, $7B, $7B, $3C, $7B, $17, $17, $17,	$17, $7B, $3D, $7B, $7B, $7B, $69; $1E0
	.BYTE  $69,	$43, $43, $43, $1B, $43, $3E, $3E, $3E,	$3E, $43, $2C, $43, $43, $43, $69; $1F0
	.BYTE  $69,	$7B, $7B, $7B, $3F, $17, $17, $17, $7B,	$7B, $17, $40, $7B, $7B, $7B, $69; $200
	.BYTE  $69,	$43, $43, $43, $41, $3E, $43, $43, $3E,	$3E, $3E, $42, $43, $43, $43, $69; $210
	.BYTE  $62,	$63, $63, $63, $63, $64, $64, $64, $63,	$63, $63, $63, $63, $63, $63, $63; $220
	.BYTE  $63,	$63, $63, $63, $63, $63, $63, $63, $63,	$63, $63, $63, $63, $64, $64, $64; $230
	.BYTE  $63,	$63, $63, $63, $63, $63, $63, $63, $65,	$66, $67, $68, $69, $69, $69, $69; $240
	.BYTE  $69,	$69, $63, $63, $63, $63, $63, $63, $63,	$63, $63, $63, $63, $63, $63, $63; $250
	.BYTE  $62,	$63, $63, $67, $63, $63, $63, $63, $69,	$63, $63, $63, $63, $63, $63, $63; $260
	.BYTE  $63,	$63, $63, $63, $63, $63, $63, $63, $63,	$63, $63, $63, $64, $64, $64, $69; $270
	.BYTE  $6A,	$6A, $6A, $6A, $63, $63, $63, $63, $6A,	$6A, $6A, $6A, $63, $63, $63, $63; $280
	.BYTE  $63,	$63, $63, $63, $63, $6B, $6C, $6D, $63,	$63, $63, $6E, $6F, $70, $63, $69; $290
	.BYTE  $63,	$63, $6F, $63, $6C, $63, $63, $6F, $63,	$63, $6C, $63, $6F, $98, $98, $63; $2A0
	.BYTE  $63,	$63, $6F, $63, $63, $65, $66, $72, $66,	$65, $63, $63, $6F, $63, $63, $63; $2B0
	.BYTE  $62,	$63, $63, $63, $75, $63, $63, $6B, $6C,	$6D, $63, $63, $75, $63, $63, $63; $2C0
	.BYTE  $63,	$63, $63, $63, $75, $63, $63, $68, $68,	$63, $63, $75, $63, $63, $63, $62; $2D0
	.BYTE  $69,	$98, $98, $63, $63, $63, $63, $75, $63,	$63, $63, $63, $66, $66, $71, $66; $2E0
	.BYTE  $69,	$63, $63, $63, $75, $63, $63, $73, $74,	$74, $73, $63, $63, $75, $63, $63; $2F0
	.BYTE  $6A,	$6A, $6A, $6A, $6A, $6A, $6A, $6A, $6A,	$6A, $6A, $6A, $63, $63, $63, $69; $300
	.BYTE  $6A,	$6A, $6A, $6A, $6A, $6A, $6A, $6A, $6A,	$6A, $6A, $6A, $6A, $6A, $6A, $6A; $310
	.BYTE  $69,	$63, $63, $63, $6A, $6A, $6A, $6A, $6A,	$6A, $6A, $6A, $6A, $6A, $76, $6A; $320
	.BYTE  $6A,	$6A, $6A, $6A, $6A, $6A, $6A, $6A, $6A,	$6A, $6A, $6A, $6A, $63, $77, $63; $330
	.BYTE  $78,	$79, $7A, $7B, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7C, $7C, $7C, $7B, $7B; $340
	.BYTE  $7B,	$7E, $7E, $7E, $7B, $7B, $7B, $7C, $7C,	$7C, $7B, $7B, $7B, $7B, $7B, $7B; $350
	.BYTE  $7B,	$7B, $7B, $7E, $7E, $7E, $7E, $7E, $7B,	$7B, $7B, $7B, $7B, $7C, $81, $81; $360
	.BYTE  $81,	$81, $81, $81, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7E, $7E, $7E, $7B, $7B; $370
	.BYTE  $78,	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7D,	$7B, $7B, $7B, $7B, $7B, $7B, $7B; $380
	.BYTE  $7B,	$7B, $7C, $7C, $7C, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $7F, $7F, $7F, $78; $390
	.BYTE  $7C,	$7C, $7C, $7C, $82, $82, $82, $82, $7C,	$7C, $7C, $7C, $82, $82, $82, $82; $3A0
	.BYTE  $78,	$78, $82, $82, $7B, $7B, $7B, $7B, $7B,	$82, $7A, $7B, $7B, $7E, $7E, $7E; $3B0
	.BYTE  $80,	$7B, $7B, $7B, $7B, $7B, $7B, $7C, $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $7B; $3C0
	.BYTE  $7B,	$7B, $7B, $7B, $7E, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $7C, $7B, $7B, $7B; $3D0
	.BYTE  $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $7F, $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $7B; $3E0
	.BYTE  $7B,	$7B, $7B, $7B, $84, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $78; $3F0
	.BYTE  $7B,	$88, $89, $8A, $7B, $7B, $85, $86, $87,	$7B, $7B, $88, $89, $8A, $7B, $7B; $400
	.BYTE  $78,	$7B, $7B, $8F, $8F, $8F, $8F, $7B, $7B,	$82, $79, $79, $7A, $7B, $7B, $7B; $410
	.BYTE  $7B,	$7B, $7B, $91, $8F, $8F, $8F, $92, $8F,	$8F, $8F, $8F, $93, $7B, $7B, $78; $420
	.BYTE  $78,	$7B, $7B, $94, $7B, $7B, $91, $8F, $8F,	$92, $7B, $7B, $95, $95, $96, $97; $430
	.BYTE  $78,	$7B, $7B, $91, $8F, $8C, $8C, $8D, $8E,	$95, $95, $95, $7B, $7B, $7B, $7B; $440
	.BYTE  $90,	$90, $90, $90, $7B, $7B, $95, $95, $95,	$95, $7B, $7B, $7B, $7B, $7B, $7B; $450
	.BYTE  $99,	$9A, $9A, $9A, $9B, $9B, $9B, $9A, $9A,	$9D, $9E, $9A, $9A, $9A, $9A, $9A; $460
	.BYTE  $9B,	$9B, $9B, $9B, $A0, $A0, $A0, $A0, $9B,	$9B, $9B, $9B, $83, $83, $83, $83; $470
	.BYTE  $9B,	$9B, $9B, $9B, $A0, $A0, $9B, $9B, $9B,	$A0, $A0, $9B, $9B, $9B, $9B, $99; $480
	.BYTE  $99,	$A4, $A4, $9E, $9E, $9A, $9A, $9A, $9A,	$9A, $9A, $9A, $9E, $9E, $9C, $A4; $490
	.BYTE  $99,	$A4, $9A, $9A, $9A, $9A, $9B, $9B, $9B,	$9A, $9A, $9A, $9A, $9A, $9A, $99; $4A0
	.BYTE  $9A,	$9A, $99, $99, $99, $9E, $9A, $9A, $A1,	$A1, $A1, $9E, $9E, $9A, $A1, $99; $4B0
	.BYTE  $99,	$A2, $A2, $A2, $9A, $9A, $9A, $9A, $9A,	$A3, $9A, $9A, $9A, $9A, $9E, $9E; $4C0
	.BYTE  $9D,	$9A, $9A, $9A, $9A, $9A, $9E, $9D, $9D,	$9C, $9D, $9C, $9E, $9A, $9A, $99; $4D0
	.BYTE  $99,	$9A, $A2, $9D, $A5, $A6, $A7, $A8, $A9,	$9A, $9A, $A5, $A6, $A7, $A8, $A9; $4E0
	.BYTE  $AA,	$AB, $AB, $AB, $AC, $AC, $AC, $AC, $AC,	$AB, $AD, $AE, $AF, $B0, $B1, $AC; $4F0
	.BYTE  $B5,	$AB, $AB, $AC, $AB, $AB, $B6, $B7, $B8,	$B9, $BA, $BB, $BC, $AB, $AB, $AA; $500
	.BYTE  $AB,	$B6, $BF, $BC, $AB, $AB, $C0, $AB, $AB,	$B6, $B8, $B9, $BA, $BC, $AB, $C1; $510
	.BYTE  $B5,	$AB, $AB, $B2, $B2, $B3, $B3, $B3, $B3,	$B4, $B3, $B3, $B3, $B3, $B3, $C1; $520
	.BYTE  $C1,	$AB, $AD, $AE, $BD, $BD, $AF, $BE, $BE,	$B0, $B1, $AB, $AB, $C0, $AB, $B5; $530
	.BYTE  $D3,	$D3, $D5, $D5, $D4, $D5, $D5, $D5, $D5,	$D5, $D5, $D4, $D5, $D5, $D5,	0; $540
	.BYTE  $D5,	$D5, $D3, $D3, $D4, $D5, $D5, $D4, $D5,	$D5, $D5, $D5, $D5, $D5, $D5,	0; $550
	.BYTE  $D5,	$D5, $D5, $D5, $D4, $D7, $D7, $D5, $D5,	$D5, $D8, $D5, $D5, $D4, $D3,	0; $560
	.BYTE  $D4,	$D5, $D5, $D5, $D5, $D5, $D5, $D4, $D3,	$D5, $D5, $D5, $D5, $D3, $D3,	0; $570
	.BYTE  $D5,	$D5, $D5, $D5, $D5, $D6, $D6, $D6, $D5,	$D5, $D5, $D4, $D5, $D5, $D5,	0; $580
	.BYTE  $D3,	$D3, $D5, $D5, $D5, $D9, $D5, $D5, $D5,	$D5, $D5, $D5, $D5, $D5, $D5,	0; $590
	.BYTE  $D5,	$D5, $D5, $D5, $D5, $DA, $D5, $D5, $D5,	$D5, $D5, $D5, $D5, $DB, $D3,	0; $5A0
	.BYTE  $D5,	$D5, $D5, $D5, $DC, $DC, $DC, $DC, $DA,	$DC, $DC, $DC, $DC, $DC, $DA,	0; $5B0
	.BYTE  $D3,	$D3, $D5, $D5, $D5, $DD, $DD, $D5, $D5,	$D5, $D5, $DE, $D5, $D5, $D5,	0; $5C0
	.BYTE  $D3,	$D3, $CC, $CC, $CC, $CC, $CC, $CD, $CC,	$CC, $CC, $CC, $CC, $CC, $CD,	0; $5D0
	.BYTE  $CC,	$CC, $CC, $CC, $CC, $CD, $CC, $CC, $CC,	$CC, $D3, $D3, $CD, $CC, $CC,	0; $5E0
	.BYTE  $CC,	$CC, $CC, $CC, $CD, $D3, $D3, $CD, $CD,	$CC, $CC, $CD, $CD, $CC, $CC,	0; $5F0
	.BYTE  $CC,	$CC, $CE, $CC, $CC, $CD, $CC, $CC, $CC,	$CC, $CC, $CC, $D3, $D3, $D3,	0; $600
	.BYTE  $CC,	$CC, $CE, $CC, $CC, $D3, $CD, $CD, $CC,	$CC, $CC, $CC, $CC, $D3, $D3,	0; $610
	.BYTE  $CC,	$CC, $CC, $CC, $CC, $CC, $CC, $CC, $CE,	$CC, $CC, $CC, $CC, $CD, $D3,	0; $620
	.BYTE  $D3,	$D3, $CC, $CC, $CD, $CC, $CC, $CC, $CE,	$CC, $CD, $CC, $CC, $CC, $CD,	0; $630
	.BYTE  $CC,	$CC, $CC, $CD, $CC, $CC, $CC, $CC, $CC,	$CC, $CC, $CC, $CC, $DB, $D3,	0; $640
	.BYTE  $D1,	$D1, $CC, $CC, $CC, $CC, $CD, $D1, $D2,	$CC, $CC, $CC, $CD, $D1, $D1,	0; $650
	.BYTE  $D3,	$D3, $CC, $CC, $CC, $CC, $CC, $CC, $CF,	$CF, $CC, $CC, $CC, $D0, $D0,	0; $660
	.BYTE  $CC,	$CC, $CC, $CC, $CC, $CF, $CF, $D0, $D0,	$D0, $D0, $CD, $CD, $D3, $D3,	0; $670
	.BYTE  $69,	$43, $43, $43, $43, $43, $43, $43, $43,	$43, $43, $43, $43, $43, $43, $69; $680
	.BYTE  $69,	$43, $43, $43, $44, $45, $45, $45, $45,	$45, $45, $44, $43, $43, $43, $69; $690
	.BYTE  $8B,	$8B, $9F, $9F, $DF, $DF, $E0, $E0, $E0,	$E0, $E0, $E0, $E0, $E0, $E0, $E0; $6A0
	.BYTE    0, 0,   0,   0, 0,   0,   0,	0, $8B,	$8B, $9F, $9F, $DF, $DF, $E0, $E0; $6B0
	.BYTE  $E0,	$E0, $DF, $DF, $9F, $9F, $8B, $8B,   0, 0,   0,   0, 0,   0,   0,	0; $6C0
	.BYTE  $E0,	$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0,	$E0, $DF, $DF, $9F, $9F, $8B, $8B; $6D0
	.BYTE  $61,	$61, $61, $61, $61, $61, $61, $61, $61,	$61, $4E, $4F, $61, $61, $61, $61; $6E0
	.BYTE  $48,	$48, $4C, $4D, $48, $48, $48, $48, $48,	$48, $48, $48, $48, $48, $48, $49; $6F0
	.BYTE  $61,	$61, $61, $61, $61, $61, $61, $61, $61,	$61, $4E, $4F, $61, $61, $61, $4A; $700
	.BYTE  $69,	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $7B; $710
	.BYTE  $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $69; $720
	.BYTE  $69,	$43, $43, $43, $43, $43, $43, $43, $43,	$43, $43, $43, $43, $43, $43, $43; $730
	.BYTE  $43,	$43, $43, $43, $43, $43, $43, $43, $43,	$43, $43, $43, $43, $43, $43, $69; $740
	.BYTE  $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B,	$7B, $7B, $7B, $7B, $7B, $7B, $7B; $750
	.BYTE  $43,	$43, $43, $43, $43, $43, $43, $43, $43,	$43, $43, $43, $43, $43, $43, $43; $760
	.BYTE  $77,	$63, $63, $75, $63, $63, $73, $74, $74,	$73, $63, $63, $75, $63, $63, $77; $770
	.BYTE  $46,	$7B, $7B, $8F, $8F, $8F, $7B, $90, $90,	$7B, $8F, $8F, $8F, $7B, $7B, $46; $780
	.BYTE  $49,	$48, $48, $48, $48, $50, $51, $48, $48,	$48, $48, $48, $50, $51, $48, $48; $790
	.BYTE  $4A,	$61, $61, $61, $61, $61, $61, $61, $61,	$61, $61, $61, $61, $61, $61, $61; $7A0
	.BYTE  $48,	$52, $48, $48, $48, $48, $48, $48, $48,	$48, $53, $48, $48, $E1,   0,	0; $7B0
	.BYTE  $4B,	$4B, $4B, $4B, $4B, $54, $4B, $4B, $4B,	$4B, $4B, $4B, $4B, $E1,   0,	0; $7C0
	.BYTE  $48,	$48, $53, $48, $48, $48, $48, $48, $52,	$48, $48, $48, $48, $48, $48, $48; $7D0
	.BYTE  $4B,	$4B, $4B, $4B, $4B, $4B, $54, $4B, $4B,	$4B, $4B, $4B, $4B, $54, $4B, $4B; $7E0
	.BYTE  $49,	$48, $48, $48, $48, $48, $48, $52, $48,	$48, $48, $48, $48, $48, $48, $48; $7F0
	.BYTE  $49,	$4B, $4B, $4B, $4B, $54, $4B, $4B, $4B,	$4B, $4B, $4B, $4B, $54, $4B, $4B; $800
	.BYTE  $48,	$48, $4C, $4D, $48, $48, $48, $48, $48,	$48, $48, $48, $48, $48, $48, $48; $810
LayoutChunks:
	.BYTE    0,   0,	0,   0, 0,   0,   0, 0
	.BYTE    0, 0,   0,   0, 0,   0,   2,	1; 8 ; 8 bytes/entry (one tile/byte)
	.BYTE  $1E,	$1F,   0,   0, 0,   2,   4,	5; $10
	.BYTE  $20,	$1E, $1F,   0,	$C,   8,   7,	9; $18
	.BYTE  $20,	$20,   0,  $C,	$D,  $E,  $F,  $F; $20
	.BYTE  $22,	$22, $12,  $D,	$F,  $F,  $F,  $F; $28
	.BYTE    0, 0,   0,   0, $23, $24, $26, $25; $30
	.BYTE  $23,	$23, $24, $26, $25, $19, $19, $25; $38
	.BYTE    3, 0,   0,   0, 0,   0,   0,	0; $40
	.BYTE    6, 3,   0,   0, 0,   0,   0,	0; $48
	.BYTE    9, $A,  $B,   0, 0,   0,   0, $17; $50
	.BYTE   $F, $F, $10, $11, 0, $14, $15, $16; $58
	.BYTE   $F, $F,  $F, $10, $13, $18, $16, $16; $60
	.BYTE  $1C,	$1C, $1D, $1C, $19, $16, $16, $1A; $68
	.BYTE  $1C,	$1D, $1C, $19, $16, $16, $1A, $1B; $70
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $46, $2F, $2F; $78
	.BYTE  $2D,	$2D, $2F, $2F, $46, $2F, $2F, $2F; $80
	.BYTE  $2F,	$2F, $2F, $46, $2F, $2F, $2D, $2D; $88
	.BYTE  $2F,	$2F, $3B, $2F, $2F, $2F, $2D, $2D; $90
	.BYTE  $2F,	$2F, $3B, $2F, $3B, $2F, $2D, $2D; $98
	.BYTE  $2F,	$2F, $2F, $2F, $3B, $2F, $2D, $2D; $A0
	.BYTE  $3B,	$2F, $2F, $2F, $2F, $2F, $2D, $2D; $A8
	.BYTE  $2F,	$2F, $2F, $3B, $2F, $2F, $2D, $2D; $B0
	.BYTE  $2D,	$2D, $2F, $2F, $3B, $2F, $2F, $2F; $B8
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $43; $C0
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $3B; $C8
	.BYTE  $2F,	$46, $2F, $2F, $2F, $2F, $2D, $2D; $D0
	.BYTE  $3F,	$3F, $2F, $2F, $2F, $2F, $2D, $2D; $D8
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $46, $2F; $E0
	.BYTE  $2D,	$2D, $2F, $45, $3E, $40, $2F, $2F; $E8
	.BYTE  $2D,	$2D, $2F, $44, $3F, $41, $2F, $2F; $F0
	.BYTE  $2F,	$2F, $42, $3E, $3C, $2F, $2D, $2D; $F8
	.BYTE  $2F,	$2F, $43, $3F, $3D, $2F, $2D, $2D; $100
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $3B, $2F, $2F; $108
	.BYTE  $2D,	$2D, $2F, $46, $2F, $43, $41, $2F; $110
	.BYTE  $2D,	$2D, $2F, $46, $2F, $3B, $46, $2F; $118
	.BYTE  $43,	$41, $2F, $43, $41, $2F, $2D, $2D; $120
	.BYTE  $3B,	$46, $2F, $3B, $46, $2F, $2D, $2D; $128
	.BYTE  $3D,	$2F, $2F, $2F, $2F, $2F, $2D, $2D; $130
	.BYTE  $2D,	$2D, $2F, $2F, $46, $2F, $2F, $3B; $138
	.BYTE  $3B,	$2F, $2F, $3B, $2F, $2F, $2D, $2D; $140
	.BYTE  $2F,	$2F, $46, $2F, $2F, $2F, $2D, $2D; $148
	.BYTE  $2D,	$2D, $2F, $2F, $43, $3F, $3F, $3F; $150
	.BYTE  $2D,	$2D, $2F, $2F, $42, $3E, $3E, $3E; $158
	.BYTE  $3E,	$3E, $2F, $2F, $2F, $2F, $2D, $2D; $160
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $3F, $3F, $2F; $168
	.BYTE  $2D,	$2D, $2F, $3B, $2F, $2F, $2F, $3E; $170
	.BYTE  $2D,	$2D, $2F, $3B, $2F, $2F, $2F, $2F; $178
	.BYTE  $2D,	$2D, $2F, $3B, $2F, $2F, $2F, $3F; $180
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $3E, $3E, $2F; $188
	.BYTE  $2F,	$3F, $3F, $2F, $2F, $2F, $2D, $2D; $190
	.BYTE  $3E,	$2F, $2F, $2F, $3B, $2F, $2D, $2D; $198
	.BYTE  $2F,	$3E, $3E, $2F, $2F, $2F, $2D, $2D; $1A0
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $45; $1A8
	.BYTE  $2D,	$2D, $2F, $46, $2F, $2F, $2F, $46; $1B0
	.BYTE  $2D,	$2D, $2F, $46, $2F, $2F, $2F, $2F; $1B8
	.BYTE  $2D,	$2D, $2F, $44, $3F, $3F, $2F, $2F; $1C0
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $3F, $3F, $3F; $1C8
	.BYTE  $3E,	$3E, $3E, $2F, $2F, $2F, $2D, $2D; $1D0
	.BYTE  $2F,	$2F, $3E, $3E, $3C, $2F, $2D, $2D; $1D8
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $3F, $3F; $1E0
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $3E, $3E; $1E8
	.BYTE  $2F,	$2F, $2F, $46, $2F, $2F, $2D, $2D; $1F0
	.BYTE  $2D,	$2D, $2F, $2F, $43, $3F, $3F, $3F; $1F8
	.BYTE  $2D,	$2D, $2F, $2F, $42, $3E, $3E, $3E; $200
	.BYTE  $3F,	$3F, $3F, $41, $2F, $2F, $2D, $2D; $208
	.BYTE  $3E,	$3E, $3E, $40, $2F, $2F, $2D, $2D; $210
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $2F, $2D, $2D; $218
	.BYTE  $5B,	$5B, $5B, $5B, $5B, $5B, $2D, $2D; $220
	.BYTE  $5B,	$2F, $2F, $5B, $2F, $2F, $2D, $2D; $228
	.BYTE    0,	$2D, $30, $31, $31, $31, $31, $31; $230
	.BYTE  $3F,	$2F, $2F, $2F, $3B, $2F, $2D, $2D; $238
	.BYTE  $92, 0,   0,   0, 0,   0,   0,	0; $240
	.BYTE  $92,	$92, $92, $92, $92, $92, $92, $92; $248
	.BYTE  $92,	$92, $92, $92, $92, $5E,   0,	0; $250
	.BYTE    0, 0,   0,   0, 0,   0,   0, $92; $258
	.BYTE  $92, 0,   0,   0, $93,   0,   0,	0; $260
	.BYTE  $92, 0,   0,   0, $94,   0,   0,	0; $268
	.BYTE    0, 0,   0, $93, 0, $5E,   0,	0; $270
	.BYTE    0, 0,   0, $94, 0, $5E,   0,	0; $278
	.BYTE  $92, 0,   0,   0, 0,   0,   0, $93; $280
	.BYTE  $92, 0,   0,   0, 0,   0,   0, $94; $288
	.BYTE  $92, 0,   0, $93, $94,   0,   0,	0; $290
	.BYTE  $92, 0,   0,   0, 0,   0, $93, $94; $298
	.BYTE    0, 0,   0, $93, $94,   0,   0, $92; $2A0
	.BYTE  $3A,	$3B, $2F, $2F, $3D, $2F, $2F, $3C; $2A8
	.BYTE    0, 0,   0,   0, 0, $5E,   0,	0; $2B0
	.BYTE  $2D,	$2D, $2D, $2F, $2F, $2D, $2E, $2D; $2B8
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $2D, $2E, $2D; $2C0
	.BYTE  $2F,	$2D, $2F, $2F, $2F, $2D, $2E, $2D; $2C8
	.BYTE  $2F,	$2F, $2F, $2F, $2D, $2D, $2E, $2D; $2D0
	.BYTE  $2F,	$2F, $2F, $2D, $2D, $2D, $2E, $2D; $2D8
	.BYTE  $2F,	$2F, $2D, $2D, $2D, $2D, $2E, $2D; $2E0
	.BYTE  $2F,	$2D, $2D, $2D, $2D, $2D, $2E, $2D; $2E8
	.BYTE  $2D,	$2D, $2D, $2D, $2D, $2D, $2D, $2D; $2F0
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $5D, $5B, $2D; $2F8
	.BYTE  $2F,	$2F, $39, $2F, $2F, $2D, $2E, $2D; $300
	.BYTE  $2F,	$2F, $36, $37, $36, $2D, $2E, $2D; $308
	.BYTE  $2F,	$2F, $4B, $2F, $2F, $2D, $2E, $2D; $310
	.BYTE  $39,	$2F, $2F, $2F, $2F, $2D, $2E, $2D; $318
	.BYTE  $37,	$36, $37, $36, $37, $2D, $2E, $2D; $320
	.BYTE  $4B,	$2F, $2F, $2F, $2F, $2D, $2E, $2D; $328
	.BYTE  $31,	$31, $32, $2D, $2D, $2D, $2E, $2D; $330
	.BYTE  $37,	$36, $37, $2D, $2D, $2D, $2E, $2D; $338
	.BYTE  $2F,	$2F, $5A, $5A, $5A, $2D, $2E, $2D; $340
	.BYTE  $2F,	$2F, $5A, $2F, $2F, $2D, $2E, $2D; $348
	.BYTE  $30,	$31, $31, $31, $32, $2D, $2E, $2D; $350
	.BYTE  $2F,	$2F, $2F, $2D, $2F, $5D, $5B, $2D; $358
	.BYTE  $31,	$31, $31, $31, $32, $2D, $2E, $2D; $360
	.BYTE  $2D,	$2D, $2D, $2D, $2D, $2D, $2D, $2D; $368
	.BYTE  $2D,	$2D, $2D, $2D, $2D, $2F, $2F, $2F; $370
	.BYTE  $2D,	$2D, $2D, $2F, $2F, $2F, $2F, $2F; $378
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $2F; $380
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $2D; $388
	.BYTE  $2D,	$2D, $2F, $2F, $2D, $2D, $2D, $2D; $390
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2C, $2F, $2F; $398
	.BYTE  $2D,	$2D, $2F, $2F, $2D, $2F, $2F, $2F; $3A0
	.BYTE  $2D,	$2D, $2F, $2F, $2D, $2D, $2D, $2D; $3A8
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2D, $2D; $3B0
	.BYTE  $2D,	$2D, $2D, $2D, $2F, $2F, $2F, $2F; $3B8
	.BYTE  $59,	$59, $59, $57, $2F, $2F, $2F, $33; $3C0
	.BYTE  $2D,	$2D, $2F, $2D, $2F, $2F, $2F, $2F; $3C8
	.BYTE  $2D,	$2D, $2F, $2F, $39, $2F, $2F, $2F; $3D0
	.BYTE  $2D,	$2D, $2F, $2F, $36, $37, $36, $37; $3D8
	.BYTE  $2D,	$2D, $2F, $2F, $4B, $2F, $2F, $2F; $3E0
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $39; $3E8
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $37; $3F0
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $4B; $3F8
	.BYTE    0, 0,   0,   0, 0,   0, $2D, $2D; $400
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2A, $2A; $408
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2A, $2A, $2A; $410
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2A, $2A, $2F; $418
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $2A; $420
	.BYTE  $2D,	$2D, $2F, $2A, $2F, $2F, $2F, $2F; $428
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $29; $430
	.BYTE  $2D,	$2D, $5F, $5F, $60, $2F, $2F, $2A; $438
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2F, $2F, $2B; $440
	.BYTE  $2D,	$2D, $5F, $5F, $5F, $60, $2F, $2F; $448
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2A, $2F, $2F; $450
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2A, $30, $31; $458
	.BYTE  $2D,	$2D, $2F, $2F, $2F, $2B, $2F, $2F; $460
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $2D, $2E, $2D; $468
	.BYTE  $59,	$59, $59, $59, $59, $59, $59, $59; $470
	.BYTE  $59,	$58, $2F, $2F, $2F, $2F, $2F, $2F; $478
	.BYTE  $59,	$58, $2F, $2F, $2F, $2F, $2F, $33; $480
	.BYTE  $59,	$59, $58, $2F, $2F, $2F, $2F, $2F; $488
	.BYTE  $59,	$59, $59, $59, $58, $2F, $2F, $2F; $490
	.BYTE  $59,	$59, $59, $58, $2F, $2F, $2F, $2F; $498
	.BYTE    0, 0,   0,   0, $2D, $2D, $2D, $2D; $4A0
	.BYTE  $59,	$58, $2F, $2F, $57, $59, $59, $59; $4A8
	.BYTE  $59,	$58, $2F, $2F, $2F, $2F, $33, $2F; $4B0
	.BYTE  $59,	$58, $2F, $2F, $33, $2F, $2F, $2F; $4B8
	.BYTE  $59,	$58, $2F, $2F, $2F, $33, $2F, $2F; $4C0
	.BYTE  $59,	$59, $59, $59, $59, $58, $2F, $2F; $4C8
	.BYTE  $59,	$58, $2F, $2F, $2F, $2F, $51, $2F; $4D0
	.BYTE  $59,	$58, $2F, $2F, $51, $2F, $52, $2F; $4D8
	.BYTE  $59,	$58, $2F, $2F, $53, $54, $53, $54; $4E0
	.BYTE  $59,	$58, $2F, $2F, $56, $2F, $55, $2F; $4E8
	.BYTE  $59,	$58, $2F, $2F, $2F, $2F, $56, $2F; $4F0
	.BYTE  $59,	$59, $59, $2F, $2F, $57, $57, $59; $4F8
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $2F, $57,	0; $500
	.BYTE  $2F,	$2F, $2F, $2F, $57, $59, $59, $59; $508
	.BYTE  $2F,	$2F, $51, $2F, $2F, $2F, $57, $59; $510
	.BYTE  $51,	$2F, $52, $2F, $2F, $2F, $57, $59; $518
	.BYTE  $53,	$54, $53, $54, $54, $54, $57, $59; $520
	.BYTE  $56,	$2F, $55, $2F, $2F, $2F, $57, $59; $528
	.BYTE  $2F,	$2F, $56, $2F, $2F, $2F, $57, $59; $530
	.BYTE  $2F,	$2F, $57, $59, $59, $59, $59, $59; $538
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $61, $57, $59; $540
	.BYTE  $2F,	$2F, $33, $2F, $2F, $61, $57, $59; $548
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $57, $59, $59; $550
	.BYTE  $2F,	$2F, $2F, $51, $2F, $2F, $57, $59; $558
	.BYTE  $2F,	$2F, $2F, $52, $2F, $2F, $57, $59; $560
	.BYTE  $2F,	$51, $2F, $52, $2F, $2F, $57, $59; $568
	.BYTE  $2F,	$53, $54, $53, $54, $54, $57, $59; $570
	.BYTE  $2F,	$56, $2F, $55, $2F, $2F, $57, $59; $578
	.BYTE  $2F,	$2F, $2F, $55, $2F, $2F, $57, $59; $580
	.BYTE  $2F,	$2F, $2F, $56, $2F, $2F, $57, $59; $588
	.BYTE  $52,	$2F, $52, $2F, $2F, $2F, $57, $59; $590
	.BYTE  $55,	$2F, $55, $2F, $2F, $2F, $57, $59; $598
	.BYTE  $2F,	$2F, $2F, $53, $54, $54, $57, $59; $5A0
	.BYTE  $54,	$54, $54, $54, $54, $54, $57, $59; $5A8
	.BYTE  $59,	$59, $59, $59, $59, $59, $59, $59; $5B0
	.BYTE    0,	$64, $65, $66, $75, $68, $69, $6A; $5B8
	.BYTE    0,	$6D, $6E, $6F, $70, $71, $6D, $6D; $5C0
	.BYTE    0,	$64, $74, $75, $76, $65, $77, $74; $5C8
	.BYTE    0,	$7C, $7D, $7E, $7F, $80, $81, $7D; $5D0
	.BYTE    0,	$84, $85, $70, $71, $6E, $86, $85; $5D8
	.BYTE  $6B,	$6C,   0,   0, 0,   0,   0,	0; $5E0
	.BYTE    0,	$72,   0,   0, 0,   0,   0,	0; $5E8
	.BYTE    0,	$6A, $79, $74, $75, $7A, $7B,	0; $5F0
	.BYTE    0,	$82, $7C, $83, $7E, $7C, $7D,	0; $5F8
	.BYTE  $67,	$85, $6D, $6D, $70, $78, $6D,	0; $600
	.BYTE  $2F,	$2F, $2F, $2F, $2F, $2F, $2F, $33; $608
	.BYTE  $2F,	$2F, $2F, $2F, $33, $33, $33, $33; $610
	.BYTE  $33,	$33, $33, $2F, $2F, $2F, $2F, $33; $618
	.BYTE  $5E,	$5E, $5E, $5E, $5E, $5E, $5E, $33; $620
	.BYTE  $5E,	$5E, $2F, $2F, $2F, $2F, $2F, $33; $628
	.BYTE  $2F,	$2F, $33, $33, $33, $33, $33, $33; $630
	.BYTE  $2F,	$33, $33, $33, $33, $33, $33, $33; $638
	.BYTE  $33,	$33, $33, $33, $33, $33, $33, $33; $640
	.BYTE  $33,	$33, $33, $33, $2F, $2F, $2F, $2F; $648
	.BYTE  $33,	$2F, $2F, $2F, $2F, $2F, $2F, $2F; $650
	.BYTE  $33,	$33, $33, $2F, $33, $33, $2F, $2F; $658
	.BYTE  $33,	$33, $33, $33, $33, $33, $2F, $2F; $660
	.BYTE  $33,	$2F, $2F, $2F, $2F, $33, $33, $33; $668
	.BYTE  $33,	$2F, $2F, $33, $33, $33, $2F, $2F; $670
	.BYTE  $33,	$2F, $2F, $2F, $33, $2F, $2F, $33; $678
	.BYTE  $33,	$5D, $5D, $5D, $5D, $5D, $5D, $33; $680
	.BYTE  $33,	$2F, $2F, $2F, $2F, $2F, $2F, $33; $688
	.BYTE  $33,	$2F, $2F, $2F, $5E, $5E, $2F, $2F; $690
	.BYTE  $33,	$5E, $5E, $5E, $5E, $5E, $2F, $2F; $698
	.BYTE    0, 0, $2D, $2D, $2D, $2D, $2D, $2D; $6A0
	.BYTE  $2D,	$2D, $2D, $2D, $2D, $2D, $2D, $2D; $6A8
	.BYTE  $5E,	$5E, $5E, $5E, $5E, $5E, $5E, $5E; $6B0
	.BYTE  $3B,	$2F, $2F, $2F, $3B, $2F, $2D, $2D; $6B8
MetatileDefinitions:
	.BYTE  $24,	$24, $24, $24
	.BYTE  $45,	$50, $47, $47		; 4 ; 612 ($264) entries
	.BYTE  $24,	$24, $24, $46		; 8 ; 153 ( $99) tiles
	.BYTE  $24,	$24, $53, $24		; $C
	.BYTE  $46,	$4C, $4D, $4D		; $10
	.BYTE  $4C,	$4C, $4D, $4D		; $14
	.BYTE  $4C,	$53, $4D, $4D		; $18
	.BYTE  $4B,	$4B, $4E, $4B		; $1C
	.BYTE  $4A,	$4B, $4B, $4B		; $20
	.BYTE  $4B,	$4B, $4B, $4B		; $24
	.BYTE  $4B,	$5C, $4B, $4B		; $28
	.BYTE  $24,	$24, $5C, $24		; $2C
	.BYTE  $24,	$24, $24, $4A		; $30
	.BYTE  $4A,	$4E, $4E, $4E		; $34
	.BYTE  $4B,	$4E, $4E, $4E		; $38
	.BYTE  $4E,	$4E, $4E, $4E		; $3C
	.BYTE  $4E,	$5F, $4E, $4E		; $40
	.BYTE  $24,	$24, $5F, $24		; $44
	.BYTE  $45,	$50, $4D, $65		; $48
	.BYTE  $64,	$46, $70, $4D		; $4C
	.BYTE  $24,	$45, $46, $47		; $50
	.BYTE  $50,	$24, $47, $52		; $54
	.BYTE  $52,	$52, $52, $52		; $58
	.BYTE  $24,	$24, $24, $52		; $5C
	.BYTE  $4C,	$4C, $4D, $52		; $60
	.BYTE  $4D,	$4D, $4D, $52		; $64
	.BYTE  $52,	$58, $58, $58		; $68
	.BYTE  $58,	$58, $58, $58		; $6C
	.BYTE  $4D,	$4D, $4D, $4D		; $70
	.BYTE  $4D,	$4D, $4D, $60		; $74
	.BYTE  $80,	$81, $82, $83		; $78
	.BYTE  $84,	$85, $86, $87		; $7C
	.BYTE  $24,	$71, $24, $71		; $80
	.BYTE  $4D,	$71, $4D, $71		; $84
	.BYTE  $24,	$71, $4D, $71		; $88
	.BYTE  $4F,	$5A, $24, $61		; $8C
	.BYTE  $5A,	$5B, $61, $24		; $90
	.BYTE  $52,	$4D, $52, $58		; $94
	.BYTE  $5E,	$60, $74, $75		; $98
	.BYTE  $E0,	$E1, $E2, $E3		; $9C
	.BYTE  $E8,	$E9, $EA, $EB		; $A0
	.BYTE  $89,	$8C, $8B, $8E		; $A4
	.BYTE  $8C,	$8D, $8E, $8F		; $A8
	.BYTE  $8D,	$98, $8F, $9A		; $AC
	.BYTE  $8C,	$8D, $88, $88		; $B0
	.BYTE  $A0,	$A1, $A2, $A3		; $B4
	.BYTE  $A8,	$A9, $AA, $AB		; $B8
	.BYTE  $8A,	$8A, $8A, $8A		; $BC
	.BYTE  $A4,	$A5, $A6, $A7		; $C0
	.BYTE  $A6,	$A7, $A6, $A7		; $C4
	.BYTE  $A6,	$A7, $AC, $AD		; $C8
	.BYTE  $90,	$91, $92, $93		; $CC
	.BYTE    0, 1,   2,   3		; $D0
	.BYTE    0, 0,   0,   0		; $D4
	.BYTE  $25,	$30, $27, $32		; $D8
	.BYTE  $26,	$31, $2E, $2F		; $DC
	.BYTE  $29,	$29, $8A, $8A		; $E0
	.BYTE  $28,	$29, $8A, $8A		; $E4
	.BYTE  $99,	$99, $99, $99		; $E8
	.BYTE  $88,	$88, $8A, $8A		; $EC
	.BYTE  $8A,	$88, $8A, $8A		; $F0
	.BYTE  $88,	$8A, $8A, $8A		; $F4
	.BYTE  $8A,	$88, $8A, $88		; $F8
	.BYTE  $88,	$8A, $88, $8A		; $FC
	.BYTE  $8A,	$88, $88, $88		; $100
	.BYTE  $88,	$8A, $88, $88		; $104
	.BYTE  $88,	$88, $8A, $88		; $108
	.BYTE  $88,	$88, $88, $8A		; $10C
	.BYTE  $8A,	$8A, $88, $8A		; $110
	.BYTE  $8A,	$8A, $8A, $88		; $114
	.BYTE  $8A,	$8A, $88, $88		; $118
	.BYTE  $78,	$79, $7A, $7B		; $11C
	.BYTE  $76,	$77, $FA, $FB		; $120
	.BYTE  $3C,	$3D, $3E, $3F		; $124
	.BYTE  $99,	$9B, $EA, $EB		; $128
	.BYTE  $29,	$2B, $8A, $8A		; $12C
	.BYTE  $F0,	$F1, $F2, $F3		; $130
	.BYTE  $DE,	$DF, $F4, $F5		; $134
	.BYTE  $DE,	$DF, $F6, $F7		; $138
	.BYTE  $DE,	$DF, $F8, $F9		; $13C
	.BYTE  $E4,	$E5, $E6, $E7		; $140
	.BYTE  $62,	$63, $68, $69		; $144
	.BYTE  $63,	$66, $69, $6C		; $148
	.BYTE  $67,	$54, $6D, $6A		; $14C
	.BYTE  $BC,	$BD, $BE, $BF		; $150
	.BYTE  $55,	$56, $6B, $6E		; $154
	.BYTE  $56,	$57, $6E, $6F		; $158
	.BYTE  $9C,	$9D, $9E, $9F		; $15C
	.BYTE  $B4,	$B5, $B6, $B7		; $160
	.BYTE  $B0,	$B1, $B2, $B3		; $164
	.BYTE  $7C,	$7D, $7E, $7F		; $168
	.BYTE  $B8,	$B9, $BA, $BB		; $16C
	.BYTE  $AE,	$AF, $96, $97		; $170
	.BYTE  $40,	$40, $42, $42		; $174
	.BYTE  $72,	$73, $51, $59		; $178
	.BYTE  $41,	$44, $43, $48		; $17C
	.BYTE  $43,	$48, $51, $59		; $180
	.BYTE  $94,	$95, $96, $97		; $184
	.BYTE  $72,	$73, $41, $44		; $188
	.BYTE  $EC,	$ED, $EE, $EF		; $18C
	.BYTE  $24,	$C0, $24, $C2		; $190
	.BYTE  $C1,	$C4, $C3, $C6		; $194
	.BYTE  $C5,	$D0, $C7, $C7		; $198
	.BYTE  $24,	$D1, $24, $24		; $19C
	.BYTE  $D5,	$D0, $D0, $CA		; $1A0
	.BYTE  $24,	$D0, $D6, $CB		; $1A4
	.BYTE  $D1,	$D4, $24, $C7		; $1A8
	.BYTE  $D5,	$D0, $24, $D8		; $1AC
	.BYTE  $24,	$D0, $D4, $D9		; $1B0
	.BYTE  $24,	$C8, $24, $24		; $1B4
	.BYTE  $C9,	$CC, $24, $24		; $1B8
	.BYTE  $C8,	$C8, $24, $24		; $1BC
	.BYTE  $D8,	$D6, $24, $24		; $1C0
	.BYTE  $D9,	$C8, $24, $24		; $1C4
	.BYTE  $C8,	$24, $24, $24		; $1C8
	.BYTE  $DC,	$DD, $24, $24		; $1CC
	.BYTE  $D6,	$D3, $24, $C7		; $1D0
	.BYTE  $D2,	$D6, $C2, $24		; $1D4
	.BYTE  $D3,	$C0, $C7, $C7		; $1D8
	.BYTE  $C5,	$C0, $C7, $C7		; $1DC
	.BYTE  $D5,	$C8, $24, $24		; $1E0
	.BYTE  $D5,	$D2, $24, $C2		; $1E4
	.BYTE  $D5,	$D0, $24, $C2		; $1E8
	.BYTE  $24,	$D0, $24, $C2		; $1EC
	.BYTE  $24,	$CA, $24, $C7		; $1F0
	.BYTE  $D6,	$DB, $24, $C7		; $1F4
	.BYTE  $C7,	$24, $C7, $24		; $1F8
	.BYTE  $C7,	$C7, $C7, $C7		; $1FC
	.BYTE  $CE,	$CF, $CE, $CF		; $200
	.BYTE  $C7,	$CA, $C7, $C7		; $204
	.BYTE  $24,	$C7, $24, $C7		; $208
	.BYTE  $D6,	$CB, $24, $C7		; $20C
	.BYTE  $24,	$CD, $24, $24		; $210
	.BYTE  $D6,	$D9, $24, $24		; $214
	.BYTE  $C8,	$CD, $24, $24		; $218
	.BYTE  $38,	$39, $38, $39		; $21C
	.BYTE  $39,	$38, $39, $38		; $220
	.BYTE  $38,	$24, $38, $24		; $224
	.BYTE  $24,	$38, $24, $38		; $228
	.BYTE  $38,	$38, $39, $39		; $22C
	.BYTE  $39,	$39, $38, $38		; $230
	.BYTE  $38,	$38, $24, $24		; $234
	.BYTE  $24,	$24, $38, $38		; $238
	.BYTE    8, 9, $3A, $3B		; $23C
	.BYTE  $34,	$35, $36, $37		; $240
	.BYTE    4, 5,   6,   7		; $244
	.BYTE  $24,	$24, $24, $24		; $248
	.BYTE  $33,	$5D, $AF, $D7		; $24C
	.BYTE  $FC,	$FD, $FE, $FF		; $250
	.BYTE  $38,	$39, $38, $39		; $254
	.BYTE  $39,	$38, $39, $38		; $258
	.BYTE  $38,	$38, $39, $39		; $25C
	.BYTE  $39,	$39, $38, $38		; $260
AdjacentRoomsTable:
	.BYTE    1, 0,   0,   0,	0
	.BYTE   $E, 0,   0,   2, 0	; 5 ; flag, up,	down, right, left
	.BYTE    4, 0,   0,   3, 1	; $A ;
	.BYTE    4, 0,   0,   4, 2	; $F ; flag:
	.BYTE    4, 0,   0,   5, 3	; $14 ;	01: single-screen, no scroll
	.BYTE    4, 0,   0,   6, 4	; $19 ;	02: stop scrolling (bottom/right)
	.BYTE    6, 0,   0, $90, 5	; $1E ;	04: 1=horiz 0=vert
	.BYTE   $A, 0,   8,   0, $90	; $23 ;	08: top/left of	section
	.BYTE    0, 7,   9,   0, 0	; $28 ;
	.BYTE    0, 8,  $A,   0, $A8	; $2D ;	(08 and	02 are always combined)
	.BYTE    0, 9,  $B,   0, 0	; $32
	.BYTE    2, $A, $91,   0, 0	; $37
	.BYTE   $E, 0,   0,  $D, $91	; $3C
	.BYTE    4, 0,   0,  $E,	$C	; $41
	.BYTE    4, 0,   0,  $F,	$D	; $46
	.BYTE    6, 0, $A9, $92,	$E	; $4B
	.BYTE   $E, 0,   0, $11, $92	; $50
	.BYTE    6,	$18,   0, $12, $10	; $55
	.BYTE   $E, 0,   0, $13, $11	; $5A
	.BYTE    4, 0,   0, $14, $12	; $5F
	.BYTE    4, 0, $AA, $15, $13	; $64
	.BYTE    4, 0,   0, $16, $14	; $69
	.BYTE    4, 0,   0, $17, $15	; $6E
	.BYTE    6, 0,   0, $27, $16	; $73
	.BYTE    2,	$19, $11,   0, 0	; $78
	.BYTE    0,	$1A, $18,   0, 0	; $7D
	.BYTE    0,	$1B, $19,   0, 0	; $82
	.BYTE    0,	$1C, $1A, $1D, 0	; $87
	.BYTE   $A,	$FA, $1B,   0, 0	; $8C
	.BYTE   $E, 0,   0, $1E, $1B	; $91
	.BYTE    6, 0,   0, $1F, $1D	; $96
	.BYTE   $A, 0, $20,   0, $1E	; $9B
	.BYTE    0,	$1F, $21,   0, 0	; $A0
	.BYTE    2,	$20,   0, $22, 0	; $A5
	.BYTE   $E, 0,   0, $23, $21	; $AA
	.BYTE    4,	$AD,   0, $24, $22	; $AF
	.BYTE    6, 0,   0, $25, $23	; $B4
	.BYTE   $A, 0, $26,   0, $24	; $B9
	.BYTE    0,	$25, $27, $93, 0	; $BE
	.BYTE    2,	$26,   0,   0, $17	; $C3
	.BYTE    2,	$29,   0,   0, $93	; $C8
	.BYTE    0,	$2A, $28,   0, 0	; $CD
	.BYTE    0,	$2B, $29, $AF, 0	; $D2
	.BYTE    0,	$2C, $2A,   0, 0	; $D7
	.BYTE    0,	$2D, $2B,   0, 0	; $DC
	.BYTE   $A,	$2F, $2C,   0, 0	; $E1
	.BYTE    6,	$FC,   0,   0, $2F	; $E6
	.BYTE    4, 0, $2D, $2E, $30	; $EB
	.BYTE    4, 0,   0, $2F, $31	; $F0
	.BYTE    4,	$B2,   0, $30, $32	; $F5
	.BYTE   $E, 0,   0, $31, $94	; $FA
	.BYTE    2,	$34,   0, $94, 0	; $FF
	.BYTE    0,	$35, $33,   0, 0	; $104
	.BYTE    0,	$36, $34,   0, 0	; $109
	.BYTE    0,	$37, $35,   0, $B3	; $10E
	.BYTE    0,	$38, $36,   0, 0	; $113
	.BYTE    0,	$39, $37,   0, $3A	; $118
	.BYTE   $A,	$A7, $38,   0, 0	; $11D
	.BYTE    6, 0,   0, $38, $3B	; $122
	.BYTE   $E, 0,   0, $3A, $95	; $127
	.BYTE    6, 0,   0, $95, $3D	; $12C
	.BYTE   $E, 0, $3E, $3C, 0	; $131
	.BYTE   $A,	$3D, $3F,   0, 0	; $136
	.BYTE    0,	$3E, $40,   0, 0	; $13B
	.BYTE    0,	$3F, $41,   0, $C0	; $140
	.BYTE    2,	$40, $42,   0, 0	; $145
	.BYTE    6,	$41, $FB,   0, $43	; $14A
	.BYTE    4, 0,   0, $42, $44	; $14F
	.BYTE   $E, 0,   0, $43, $96	; $154
	.BYTE    6, 0,   0, $96, $46	; $159
	.BYTE    4, 0,   0, $45, $47	; $15E
	.BYTE    4,	$A6,   0, $46, $48	; $163
	.BYTE    4, 0,   0, $47, $49	; $168
	.BYTE   $E,	$4A,   0, $48, $B6	; $16D
	.BYTE    2,	$4B, $49,   0, 0	; $172
	.BYTE   $A, 0, $4A,   0, $97	; $177
	.BYTE    6, 0,   0, $97, $4D	; $17C
	.BYTE   $E,	$4E,   0, $4C, 0	; $181
	.BYTE    2,	$4F, $4D,   0, 0	; $186
	.BYTE    0,	$50, $4E,   0, 0	; $18B
	.BYTE    0,	$51, $4F,   0, 0	; $190
	.BYTE    0,	$52, $50,   0, 0	; $195
	.BYTE   $A,	$53, $51,   0, 0	; $19A
	.BYTE   $E, 0, $52, $54, 0	; $19F
	.BYTE    4, 0,   0, $55, $53	; $1A4
	.BYTE    4, 0,   0, $56, $54	; $1A9
	.BYTE    4, 0,   0, $57, $55	; $1AE
	.BYTE    4, 0,   0, $58, $56	; $1B3
	.BYTE    4, 0,   0, $59, $57	; $1B8
	.BYTE    4, 0,   0, $5A, $58	; $1BD
	.BYTE    6, 0,   0, $98, $59	; $1C2
	.BYTE   $E, 0, $CD, $5C, $98	; $1C7
	.BYTE    4, 0,   0, $5D, $5B	; $1CC
	.BYTE    4, 0,   0, $5E, $5C	; $1D1
	.BYTE    4, 0, $B9, $5F, $5D	; $1D6
	.BYTE    4, 0,   0, $60, $5E	; $1DB
	.BYTE    6, 0,   0, $99, $5F	; $1E0
	.BYTE   $E, 0, $A7, $62, $99	; $1E5
	.BYTE    4, 0,   0, $63, $61	; $1EA
	.BYTE    4, 0, $B4, $64, $62	; $1EF
	.BYTE    4, 0,   0, $65, $63	; $1F4
	.BYTE    6, 0,   0, $66, $64	; $1F9
	.BYTE   $A, 0, $67,   0, $65	; $1FE
	.BYTE    0,	$66, $68,   0, 0	; $203
	.BYTE    2,	$67, $69,   0, $BA	; $208
	.BYTE   $E,	$68,   0, $6A, 0	; $20D
	.BYTE    6, 0, $FF, $9A, $69	; $212
	.BYTE   $E, 0,   0, $6C, $9A	; $217
	.BYTE    4, 0, $CE, $6D, $6B	; $21C
	.BYTE    4, 0, $D5, $6E, $6C	; $221
	.BYTE    6, 0,   0, $9B, $6D	; $226
	.BYTE    2,	$70, $9B,   0, 0	; $22B
	.BYTE   $A, 0, $6F, $71, $BB	; $230
	.BYTE   $E, 0,   0, $72, $70	; $235
	.BYTE    6,	$73,   0,   0, $71	; $23A
	.BYTE    2,	$74, $72,   0, 0	; $23F
	.BYTE    0,	$75, $73,   0, 0	; $244
	.BYTE    0,	$76, $74,   0, 0	; $249
	.BYTE   $A,	$77, $75,   0, 0	; $24E
	.BYTE    6, 0, $76,   0, $78	; $253
	.BYTE    4, 0,   0, $77, $79	; $258
	.BYTE    4, 0,   0, $78, $7A	; $25D
	.BYTE    4, 0,   0, $79, $7B	; $262
	.BYTE    4, 0,   0, $7A, $7C	; $267
	.BYTE    4, 0,   0, $7B, $7D	; $26C
	.BYTE   $E, 0,   0, $7C, $9C	; $271
	.BYTE    6, 0,   0, $9C, $7F	; $276
	.BYTE   $E, 0, $80, $7E, 0	; $27B
	.BYTE    6,	$7F,   0,   0, $81	; $280
	.BYTE    4, 0, $BD, $80, $82	; $285
	.BYTE   $E, 0,   0, $81, $9D	; $28A
	.BYTE    6, 0,   0, $9D, $84	; $28F
	.BYTE    4, 0,   0, $83, $85	; $294
	.BYTE    4, 0, $B0, $84, $86	; $299
	.BYTE   $E, 0,   0, $85, $9E	; $29E
	.BYTE    2,	$88, $9E,   0, 0	; $2A3
	.BYTE   $A, 0, $87, $89, 0	; $2A8
	.BYTE   $E, 0,   0, $8A, $88	; $2AD
	.BYTE    4, 0,   0, $8B, $89	; $2B2
	.BYTE    4,	$BE,   0, $8C, $8A	; $2B7
	.BYTE    4, 0,   0, $8D, $8B	; $2BC
	.BYTE    6, 0,   0, $9F, $8C	; $2C1
	.BYTE    2,	$8F, $9F,   0, 0	; $2C6
	.BYTE   $A,	$A0, $8E, $BF, 0	; $2CB
	.BYTE    5, 0,   0,   7, 6	; $2D0
	.BYTE    5, $B,   0,  $C, 0	; $2D5
	.BYTE    5, 0,   0, $10,	$F	; $2DA
	.BYTE    5, 0,   0, $28, $26	; $2DF
	.BYTE    5, 0,   0, $32, $33	; $2E4
	.BYTE    5, 0,   0, $3B, $3C	; $2E9
	.BYTE    5, 0,   0, $44, $45	; $2EE
	.BYTE    5, 0,   0, $4B, $4C	; $2F3
	.BYTE    5, 0,   0, $5B, $5A	; $2F8
	.BYTE    5, 0,   0, $61, $60	; $2FD
	.BYTE    5, 0,   0, $6B, $6A	; $302
	.BYTE    5,	$6F,   0,   0, $6E	; $307
	.BYTE    5, 0,   0, $7D, $7E	; $30C
	.BYTE    5, 0,   0, $82, $83	; $311
	.BYTE    5,	$87,   0, $86, 0	; $316
	.BYTE    5,	$8E,   0,   0, $8D	; $31B
	.BYTE    5, 0, $8F,   0, $A1	; $320
	.BYTE    5, 0,   0, $A0, $A2	; $325
	.BYTE    5,	$A3,   0, $A1, 0	; $32A
	.BYTE    5, 0, $A2,   0, 0	; $32F
	.BYTE    5, 0,   0, $C8, $C7	; $334
	.BYTE    5,	$E7,   0,   0, 0	; $339
	.BYTE    5,	$C5, $47,   0, 0	; $33E
	.BYTE    5,	$61, $39,   0, 0	; $343
	.BYTE    5, 0,   0,   9, 0	; $348
	.BYTE    5, $F,   0,   0, 0	; $34D
	.BYTE    5,	$14, $AC,   0, 0	; $352
	.BYTE    5, 0,   0, $BC, 0	; $357
	.BYTE    5,	$AA,   0,   0, 0	; $35C
	.BYTE    2,	$AE, $23,   0, 0	; $361
	.BYTE   $A, 0, $AD,   0, 0	; $366
	.BYTE    5, 0,   0, $B1, $2A	; $36B
	.BYTE    5,	$85,   0,   0, 0	; $370
	.BYTE    5, 0,   0,   0, $AF	; $375
	.BYTE    5, 0, $31,   0, 0	; $37A
	.BYTE    5, 0,   0, $36, 0	; $37F
	.BYTE   $A,	$63, $B5,   0, 0	; $384
	.BYTE    2,	$B4,   0,   0, 0	; $389
	.BYTE    5, 0,   0, $49, 0	; $38E
	.BYTE    6, 0,   0, $CC, $B8	; $393
	.BYTE   $E, 0,   0, $B7, 0	; $398
	.BYTE    5,	$5E,   0,   0, 0	; $39D
	.BYTE    5, 0,   0, $68, 0	; $3A2
	.BYTE    5, 0,   0, $70, $BC	; $3A7
	.BYTE    5, 0,   0, $BB, $AB	; $3AC
	.BYTE    5,	$81,   0,   0, 0	; $3B1
	.BYTE    5, 0, $8B,   0, 0	; $3B6
	.BYTE    5, 0,   0,   0, $8F	; $3BB
	.BYTE    6, 0,   0, $40, $C1	; $3C0
	.BYTE    4, 0,   0, $C0, $C2	; $3C5
	.BYTE    4, 0,   0, $C1, $C3	; $3CA
	.BYTE    4, 0,   0, $C2, $C4	; $3CF
	.BYTE   $E, 0,   0, $C3, $C5	; $3D4
	.BYTE    2,	$C6, $A6, $C4, 0	; $3D9
	.BYTE    0,	$C7, $C5,   0, 0	; $3DE
	.BYTE   $A, 0, $C6, $A4, 0	; $3E3
	.BYTE   $E, 0,   0, $C9, $A4	; $3E8
	.BYTE    6, 0,   0, $CA, $C8	; $3ED
	.BYTE    2,	$CB,   0,   0, $C9	; $3F2
	.BYTE    0,	$CC, $CA,   0, 0	; $3F7
	.BYTE    0,	$CD, $CB,   0, $B7	; $3FC
	.BYTE   $A,	$5B, $CC,   0, 0	; $401
	.BYTE    5,	$6C, $CF,   0, 0	; $406
	.BYTE    5,	$CE, $D0,   0, 0	; $40B
	.BYTE    5,	$CF, $D1, $D7, 0	; $410
	.BYTE    5,	$D0, $D2,   0, 0	; $415
	.BYTE    5,	$D1, $D3,   0, 0	; $41A
	.BYTE    5,	$D2, $D4,   0, 0	; $41F
	.BYTE    5,	$D3,   0, $DB, 0	; $424
	.BYTE    5,	$6D, $D6,   0, 0	; $429
	.BYTE    5,	$D5,   0, $DC, 0	; $42E
	.BYTE    5, 0,   0, $DD, $D0	; $433
	.BYTE   $E, 0, $D9, $DE, 0	; $438
	.BYTE    5,	$D8, $DA,   0, 0	; $43D
	.BYTE   $E,	$D9,   0, $E0, 0	; $442
	.BYTE    5, 0,   0, $E1, $D4	; $447
	.BYTE   $E, 0, $DD, $E2, $D6	; $44C
	.BYTE    5,	$DC,   0,   0, $D7	; $451
	.BYTE    6, 0, $DF,   0, $D8	; $456
	.BYTE    5,	$DE,   0, $E5, 0	; $45B
	.BYTE    4, 0,   0, $E6, $DA	; $460
	.BYTE    5, 0,   0, $E7, $DB	; $465
	.BYTE    4, 0,   0, $E8, $DC	; $46A
	.BYTE    5, 0, $E4,   0, 0	; $46F
	.BYTE    5,	$E3, $E5,   0, 0	; $474
	.BYTE    5,	$E4,   0, $EB, $DF	; $479
	.BYTE    6, 0, $E7,   0, $E0	; $47E
	.BYTE    5,	$E6, $A5,   0, $E1	; $483
	.BYTE    4, 0,   0, $EE, $E2	; $488
	.BYTE    5, 0, $EA, $EF, 0	; $48D
	.BYTE   $E,	$E9,   0, $F0, 0	; $492
	.BYTE    5, 0, $EC,   0, $E5	; $497
	.BYTE   $E,	$EB, $ED, $F2, 0	; $49C
	.BYTE    5,	$EC,   0,   0, 0	; $4A1
	.BYTE    6, 0, $EF,   0, $E8	; $4A6
	.BYTE    5,	$EE,   0, $F5, $E9	; $4AB
	.BYTE    6, 0,   0, $F6, $EA	; $4B0
	.BYTE    5, 0, $F2, $F7, 0	; $4B5
	.BYTE    6,	$F1,   0, $F8, $EC	; $4BA
	.BYTE   $E, 0,   0, $F9, 0	; $4BF
	.BYTE    5, 0, $F5,   0, 0	; $4C4
	.BYTE    5,	$F4, $F6,   0, $EF	; $4C9
	.BYTE    5,	$F5, $F7,   0, $F0	; $4CE
	.BYTE    5,	$F6,   0,   0, $F1	; $4D3
	.BYTE    5, 0, $F9,   0, $F2	; $4D8
	.BYTE    6,	$F8,   0,   0, $F3	; $4DD
	.BYTE    6, 0, $1C,   0, $FB	; $4E2
	.BYTE   $E,	$42,   0, $FA, 0	; $4E7
	.BYTE    2,	$FD, $2E,   0, 0	; $4EC
	.BYTE   $A,	$FE, $FC,   0, 0	; $4F1
	.BYTE    2,	$FF, $FD,   0, 0	; $4F6
	.BYTE   $A,	$6A, $FE,   0, 0	; $4FB
EnemySpawnPositionTable:
	.BYTE	0,  0
	.BYTE   0,	0			; 2
	.BYTE $B1,$4A			; 4
	.BYTE $44,$2B			; 6
	.BYTE $53,$BD			; 8
	.BYTE $CC,	0			; $A
	.BYTE $62,$CB			; $C
	.BYTE $6C,$A3			; $E
	.BYTE $14,$9B			; $10
	.BYTE $4B,$D4			; $12
	.BYTE $4B,$E3			; $14
	.BYTE $B8,$4C			; $16
	.BYTE $66,$7D			; $18
	.BYTE $8A,	0			; $1A
	.BYTE $D4,$2B			; $1C
	.BYTE $80,$66			; $1E
	.BYTE $64,$B8			; $20
	.BYTE $A3,$5A			; $22
	.BYTE $C7,$CC			; $24
	.BYTE $63,$6B			; $26
	.BYTE $63,$6B			; $28
	.BYTE $43,$69			; $2A
	.BYTE $C6,$CE			; $2C
	.BYTE $66,$6C			; $2E
	.BYTE $C6,$18			; $30
	.BYTE $C4,$74			; $32
	.BYTE $A3,$4B			; $34
	.BYTE $DB,$45			; $36
	.BYTE $DE,$45			; $38
	.BYTE $B4,$7B			; $3A
	.BYTE $A3,$8C			; $3C
	.BYTE $A3,$DE			; $3E
	.BYTE $4B,$C5			; $40
	.BYTE $74,$DB			; $42
	.BYTE $C7,$C9			; $44
	.BYTE $CE,	0			; $46
	.BYTE $C3,$7C			; $48
	.BYTE $9E,$A3			; $4A
	.BYTE $78,$DB			; $4C
	.BYTE $1A,$C8			; $4E
	.BYTE $95,$31			; $50
	.BYTE $C8,$48			; $52
	.BYTE $4B,	0			; $54
	.BYTE $C8,$48			; $56
	.BYTE $DE,$6E			; $58
	.BYTE $DE,$3E			; $5A
	.BYTE $5A,$C3			; $5C
	.BYTE $6C,$62			; $5E
	.BYTE $37,$61			; $60
	.BYTE $6B,$61			; $62
	.BYTE $98,$64			; $64
	.BYTE $79,$16			; $66
	.BYTE $BC,$5C			; $68
	.BYTE $C5,$5E			; $6A
	.BYTE $DD,$6D			; $6C
	.BYTE $BD,$5D			; $6E
	.BYTE $96,$32			; $70
	.BYTE $DE,$6D			; $72
	.BYTE $CE,$64			; $74
	.BYTE $6D,$C7			; $76
	.BYTE $6C,$65			; $78
	.BYTE $4F,$C6			; $7A
	.BYTE $45,	0			; $7C
	.BYTE $31,$C1			; $7E
	.BYTE $2E,$A2			; $80
	.BYTE $4B,$C7			; $82
	.BYTE $58,	0			; $84
	.BYTE $8A,$54			; $86
	.BYTE $CF,$76			; $88
	.BYTE $88,$C1			; $8A
	.BYTE $4C,$67			; $8C
	.BYTE $6C,$66			; $8E
	.BYTE $1E,$13			; $90
	.BYTE $74,$79			; $92
	.BYTE $C8,$31			; $94
	.BYTE $D7,$27			; $96
	.BYTE $59,$95			; $98
	.BYTE $15,$1C			; $9A
	.BYTE   3,$97			; $9C
	.BYTE $17,$84			; $9E
	.BYTE $17,$84			; $A0
	.BYTE $17,$84			; $A2
	.BYTE $64,$CC			; $A4
	.BYTE $15,$1C			; $A6
	.BYTE $1B,$33			; $A8
	.BYTE $1B,$33			; $AA
	.BYTE $1B,$33			; $AC
	.BYTE $1B,$33			; $AE
	.BYTE $1B,$33			; $B0
	.BYTE $1B,$33			; $B2
	.BYTE $95,$3B			; $B4
	.BYTE $98,$6D			; $B6
	.BYTE $22,$9A			; $B8
	.BYTE $63,$6D			; $BA
	.BYTE $69,$4E			; $BC
	.BYTE $23,$48			; $BE
	.BYTE $C3,$6B			; $C0
	.BYTE $35,$3B			; $C2
	.BYTE $35,$3D			; $C4
	.BYTE $46,$3D			; $C6
	.BYTE $35,$3B			; $C8
	.BYTE $CE,$35			; $CA
	.BYTE   0,	0			; $CC
	.BYTE $45,$C8			; $CE
	.BYTE $2C,$C6			; $D0
	.BYTE $C3,$49			; $D2
	.BYTE $22,$2A			; $D4
	.BYTE $68,$4F			; $D6
	.BYTE $47,$5F			; $D8
	.BYTE $43,$4A			; $DA
	.BYTE $64,$3C			; $DC
	.BYTE $DB,$7A			; $DE
	.BYTE $DC,$78			; $E0
	.BYTE $79,$BD			; $E2
	.BYTE $15,$1B			; $E4
	.BYTE   3,$97			; $E6
	.BYTE $17,$84			; $E8
	.BYTE $17,$84			; $EA
	.BYTE $64,$CC			; $EC
	.BYTE $15,$1B			; $EE
	.BYTE $1B,$33			; $F0
	.BYTE $1B,$33			; $F2
	.BYTE $1B,$33			; $F4
	.BYTE $1B,$33			; $F6
	.BYTE $1B,$33			; $F8
	.BYTE $BD,$57			; $FA
	.BYTE $CC,$35			; $FC
	.BYTE $4E,$66			; $FE
	.BYTE $57,$94			; $100
	.BYTE $37,$A6			; $102
	.BYTE $3D,$36			; $104
	.BYTE $7C,$C3			; $106
	.BYTE $CC,$65			; $108
	.BYTE $87,$45			; $10A
	.BYTE $4E,$98			; $10C
	.BYTE $C8,$32			; $10E
	.BYTE $A2,$32			; $110
	.BYTE $C3,$4B			; $112
	.BYTE $43,$4B			; $114
	.BYTE $C2,$AE			; $116
	.BYTE $68,$4C			; $118
	.BYTE $65,$6B			; $11A
	.BYTE $31,$2C			; $11C
	.BYTE $A3,$87			; $11E
	.BYTE $45,$3A			; $120
	.BYTE $43,$4C			; $122
	.BYTE $35,$39			; $124
	.BYTE $34,$3B			; $126
	.BYTE $54,$5B			; $128
	.BYTE $43,$6A			; $12A
	.BYTE $55,$5A			; $12C
	.BYTE $44,$4C			; $12E
	.BYTE $46,$4A			; $130
	.BYTE $33,$3C			; $132
	.BYTE $26,$2A			; $134
	.BYTE $34,$3B			; $136
	.BYTE $43,$3C			; $138
	.BYTE $26,$7A			; $13A
	.BYTE $36,$39			; $13C
	.BYTE $36,$3A			; $13E
	.BYTE $63,$6C			; $140
	.BYTE $65,$6A			; $142
	.BYTE $64,$6B			; $144
	.BYTE $63,$6C			; $146
	.BYTE $65,$6C			; $148
	.BYTE $63,$6A			; $14A
	.BYTE   0,	0			; $14C
	.BYTE   0,	0			; $14E
	.BYTE $33,$3C			; $150
	.BYTE $35,$3D			; $152
	.BYTE $45,$DB			; $154
	.BYTE $D8,$DE			; $156
	.BYTE $35,$39			; $158
	.BYTE $19,$48			; $15A
	.BYTE $4C,$9C			; $15C
	.BYTE $D3,$DB			; $15E
	.BYTE $D2,$D8			; $160
	.BYTE $24,$DC			; $162
	.BYTE $33,$3A			; $164
	.BYTE   0,	0			; $166
	.BYTE $AE,$B1			; $168
	.BYTE $19,$C7			; $16A
	.BYTE $D3,$7B			; $16C
	.BYTE $D3,$DA			; $16E
	.BYTE $D5,$DB			; $170
	.BYTE $34,$3A			; $172
	.BYTE $33,$7B			; $174
	.BYTE $45,$4A			; $176
	.BYTE $D3,$2B			; $178
	.BYTE $74,$3E			; $17A
	.BYTE $35,$D9			; $17C
	.BYTE $D4,$D9			; $17E
	.BYTE $58,$93			; $180
	.BYTE $4B,$51			; $182
	.BYTE $6B,	0			; $184
	.BYTE $68,$62			; $186
	.BYTE $4A,$C2			; $188
	.BYTE $4B,$31			; $18A
	.BYTE $BB,$18			; $18C
	.BYTE $A2,$6D			; $18E
	.BYTE $64,$CD			; $190
	.BYTE $63,$7C			; $192
	.BYTE $C6,$2C			; $194
	.BYTE $E2,$37			; $196
	.BYTE $62,$2C			; $198
	.BYTE $9C,$3C			; $19A
	.BYTE $D4,$DB			; $19C
	.BYTE $45,$4B			; $19E
	.BYTE $D4,$DB			; $1A0
	.BYTE $D4,$3B			; $1A2
	.BYTE $D6,$DC			; $1A4
	.BYTE $D7,$3A			; $1A6
	.BYTE $D5,$DB			; $1A8
	.BYTE $D6,$48			; $1AA
	.BYTE $D6,$3A			; $1AC
	.BYTE $D5,$DB			; $1AE
	.BYTE $76,$7C			; $1B0
	.BYTE $D5,$DB			; $1B2
	.BYTE $66,$6C			; $1B4
	.BYTE $D5,$DB			; $1B6
	.BYTE $56,$5C			; $1B8
	.BYTE $55,$5B			; $1BA
	.BYTE $76,$7C			; $1BC
	.BYTE $54,$5B			; $1BE
	.BYTE $64,$6C			; $1C0
	.BYTE $54,$5B			; $1C2
	.BYTE $53,$5A			; $1C4
	.BYTE $D5,$DB			; $1C6
	.BYTE $D5,$DB			; $1C8
	.BYTE $D4,$DB			; $1CA
	.BYTE $53,$59			; $1CC
	.BYTE $D4,$DA			; $1CE
	.BYTE $53,$5A			; $1D0
	.BYTE $D5,$DB			; $1D2
	.BYTE $55,$5C			; $1D4
	.BYTE $D5,$DB			; $1D6
	.BYTE $55,$5C			; $1D8
	.BYTE $55,$5B			; $1DA
	.BYTE $54,$5A			; $1DC
	.BYTE $D3,$DA			; $1DE
	.BYTE $54,$5A			; $1E0
	.BYTE $D5,$DA			; $1E2
	.BYTE $54,$DA			; $1E4
	.BYTE $54,$5B			; $1E6
	.BYTE $D3,$3A			; $1E8
	.BYTE $D5,$D9			; $1EA
	.BYTE $D5,$59			; $1EC
	.BYTE $D6,$DA			; $1EE
	.BYTE $D5,$DA			; $1F0
	.BYTE $54,$5A			; $1F2
	.BYTE $C9,$64			; $1F4
	.BYTE $CD,$C6			; $1F6
	.BYTE   0,	0			; $1F8
	.BYTE   0,	0			; $1FA
	.BYTE   0,	0			; $1FC
	.BYTE   0,	0			; $1FE
RoomData_01:
	.BYTE  $E0, 0, $81, $8F, 0,   5, $85, $87
	.BYTE  $39,	$6B, $6D, $10, $C6, $11, $CC, $FF; 8
RoomData_02:
	.BYTE    6,	$41, $43, $67, $69, $8D, $8F, $18
	.BYTE  $C2,	$10, $C8, $18, $CE, $FF	; 8
RoomData_03:
	.BYTE  $98,	$9B,   4, $43, $47, $64, $66, $20
	.BYTE  $C2,	$18, $B8, $10, $5E, $FF	; 8
RoomData_04:
	.BYTE    5,	$65, $67, $69, $4B, $4D, $12, $C2
	.BYTE  $18,	$C8, $10, $CE, $FF	; 8
RoomData_05:
	.BYTE  $A0,	$48,   6, $B5, $95, $75, $55, $8B
	.BYTE  $8E,	$18, $C7, $2B, $C9, $FF	; 8
RoomData_06:
	.BYTE  $8A, 1,   6, $22, $44, $26, $48, $92
	.BYTE  $94,	$18, $63, $11, $C3, $10, $8E, $13; 8
	.BYTE  $CE,	$FF			; $10
RoomData_07:
	.BYTE  $E6, 0, $82, $8E, 0,   6, $75, $77
	.BYTE  $79,	$BA, $B8, $B6, $18, $6E, $11, $A1; 8
	.BYTE  $20,	$DE, $FF		; $10
RoomData_08:
	.BYTE    8,	$1E, $3E, $4A, $7A, $77, $47, $A4
	.BYTE  $A1,	$12, $11, $18, $17, $1C, $99, $FF; 8
RoomData_09:
	.BYTE  $E6, 1,   0, $8F, 4,   6, $1A, $15
	.BYTE  $97,	$95, $AC, $AE, $10, $31, $12, $3E; 8
	.BYTE  $16,	$C3,   0, $FF		; $10
RoomData_0A:
	.BYTE    6, 1,   4,   7, $A7, $A4, $A1, $18
	.BYTE  $4E,	$20, $9A, $33, $61, $FF	; 8
RoomData_0B:
	.BYTE  $86, 1,   6, $16, $34, $52, $97, $94
	.BYTE  $91,	$10, $19, $11, $74, $12, $BE, $35; 8
	.BYTE  $4D,	$FF			; $10
RoomData_0C:
	.BYTE  $E3, 0, $83, $8F, 0,   6, $64, $44
	.BYTE  $24,	$9B, $2C, $9D, $20, $B5, $10, $DA; 8
	.BYTE  $38,	$B7, $3B, $DB, $FF	; $10
RoomData_0D:
	.BYTE    5,	$32, $34, $36, $3C, $3F, $10, $D2
	.BYTE  $18,	$D7, $48, $DB, $38, $7F, $FF; 8
RoomData_0E:
	.BYTE  $61,	$79, $65, $B8, $96, $C8,   1,	5
	.BYTE  $C2,	$A2, $82, $C7, $CB, $11, $61, $18; 8
	.BYTE  $6E,	$13, $DE, $20, $89, $FF	; $10
RoomData_0F:
	.BYTE  $E3, 1,   0, $8B, 1, $86,  $C,	3
	.BYTE  $D4,	$A4, $CA, $12, $6B, $18, $6C, $20; 8
	.BYTE  $6D,	$14, $6E, $18, $5C, $11, $5D, $FF; $10
RoomData_10:
	.BYTE  $E4, 0, $84, $8F, 0, $94, $C6,	5
	.BYTE  $21,	$24, $27, $2D, $BD, $11, $7C, $18; 8
	.BYTE  $DB,	$FF			; $10
RoomData_11:
	.BYTE  $E4, 1,   0, $83, 1, $8B,   1, $A8
	.BYTE  $86, 6, $31, $51, $71, $27, $29, $8B; 8
	.BYTE  $14,	$DA, $FF		; $10
RoomData_12:
	.BYTE  $E0, 1,   5, $8F, 0, $64, $48, $9C
	.BYTE  $DD,	$99, $58,   5, $73, $55, $37, $5A; 8
	.BYTE  $7C,	$20, $CA, $34, $C5, $FF	; $10
RoomData_13:
	.BYTE  $9B,	$DD,   6, $80, $81, $82, $89, $8A
	.BYTE  $8B,	$10, $62, $12, $69, $33, $C6, $FF; 8
RoomData_14:
	.BYTE  $E0,	$19,   0, $87, $16, $92, $8F,	6
	.BYTE  $23,	$81, $82, $2B, $8A, $89, $18, $61; 8
	.BYTE  $33,	$69, $FF		; $10
RoomData_15:
	.BYTE  $94,	$51,   5, $24, $25, $26, $8B, $8D
	.BYTE  $10,	$68, $4B, $42, $FF	; 8
RoomData_16:
	.BYTE  $98,	$DD,   5, $24, $27, $6D, $6E, $6F
	.BYTE  $10,	$C5, $33, $4E, $35, $C7, $FF; 8
RoomData_17:
	.BYTE  $8B, 1, $61, $78, 3, $25, $29, $2D
	.BYTE  $11,	$C5, $12, $CA, $20, $88, $33, $C6; 8
	.BYTE  $FF				; $10
RoomData_18:
	.BYTE  $E6, 1,   6, $87, 0, $9B, $5D, $69
	.BYTE  $6D,	$96, $7D,   3, 6, $8B, $7B, $6B; 8
	.BYTE  $41,	$31, $21, $14, $C1, $18, $4E, $33; $10
	.BYTE  $75,	$FF			; $18
RoomData_19:
	.BYTE    5,	$97, $95, $93, $2E, $11, $13, $DD
	.BYTE  $18,	$63, $35, $C1, $FF	; 8
RoomData_1A:
	.BYTE    5,	$C1, $C3, $7B, $79, $43, $10, $A1
	.BYTE  $11,	$AE, $20, $49, $35, $3D, $FF; 8
RoomData_1B:
	.BYTE  $8B, 1, $92, $DC, 5, $D8, $DA, $74
	.BYTE  $94,	$B4, $14, $44, $33, $79, $FF; 8
RoomData_1C:
	.BYTE  $E6, 1,   0, $83, $1E, $92, $88,	3
	.BYTE  $72,	$74, $76, $10, $9D, $11, $DD, $39; 8
	.BYTE  $44,	$35, $79, $FF		; $10
RoomData_1D:
	.BYTE  $E3, 1,   7, $8F, 0,   5, $36, $38
	.BYTE  $3A,	$9B, $9D, $10, $B5, $11, $B7, $20; 8
	.BYTE  $DB,	$FF			; $10
RoomData_1E:
	.BYTE  $8A, 1, $AC, $77, $98, $BC,   5, $33
	.BYTE  $35,	$37, $39, $3B, $10, $A2, $12, $DC; 8
	.BYTE  $FF				; $10
RoomData_1F:
	.BYTE  $E7, 1,   8, $8E, 0,   6, $56, $76
	.BYTE  $96,	$A9, $C9, $E9, $18, $6D, $FF; 8
RoomData_20:
	.BYTE  $98,	$D3,   3,   6, $26, $46, $10, $62
	.BYTE  $14,	$AD, $FF		; 8
RoomData_21:
	.BYTE  $8B, 1,   6, $34, $37, $3A, $97, $95
	.BYTE  $93,	$10, $61, $12, $C1, $FF	; 8
RoomData_22:
	.BYTE  $E2, 1,   9, $8F, 0,   6, $25, $26
	.BYTE  $2F,	$4F, $8B, $8D, $10, $C5, $20, $CA; 8
	.BYTE  $18,	$CE, $FF		; $10
RoomData_23:
	.BYTE  $E2, 1,   0, $83, $26,   4, $53, $55
	.BYTE  $A8,	$AA, $14, $38, $FF	; 8
RoomData_24:
	.BYTE  $8A, 1, $96, $8E, 4,   3, $56, $58
	.BYTE  $5A,	$10, $63, $13, $C5, $FF	; 8
RoomData_25:
	.BYTE  $E6, 1,  $A, $8E, 0,   6, $66, $64
	.BYTE  $62,	$B7, $B9, $BB, $13, $79, $10, $DD; 8
	.BYTE  $FF				; $10
RoomData_26:
	.BYTE  $8B, 1, $9B, $DC, 4, $3A, $3C, $9A
	.BYTE  $98,	$11, $44, $FF		; 8
RoomData_27:
	.BYTE  $E6, 1,  $A, $8F, 0, $94, $41,	5
	.BYTE  $12,	$15, $6B, $6A, $69, $11, $4C, $10; 8
	.BYTE  $C3,	$13, $CD, $FF		; $10
RoomData_28:
	.BYTE  $E7, 0, $8B, $8F, 0,   6, $AB, $AC
	.BYTE  $AD,	$18, $16, $14, $14, $2D, $35, $45; 8
	.BYTE  $FF				; $10
RoomData_29:
	.BYTE    3,	$9C, $9A, $98, $12, $44, $38, $19
	.BYTE  $34,	$4C, $33, $C9, $43, $CC, $FF; 8
RoomData_2A:
	.BYTE  $E7, 1,   0, $8A, $2B, $96, $5A,	5
	.BYTE    6,	$72, $92, $B2, $17, $19, $1B, $18; 8
	.BYTE  $AD,	$3C, $44, $FF		; $10
RoomData_2B:
	.BYTE    6,	$96, $98, $9A, $22, $24, $26, $13
	.BYTE  $4D,	$3A, $CB, $FF		; 8
RoomData_2C:
	.BYTE    6,	$BA, $9A, $7A, $46, $66, $86, $14
	.BYTE  $6D,	$38, $74, $35, $DD, $FF	; 8
RoomData_2D:
	.BYTE  $83, 1,   3, $52, $72, $92, $10, $3C
	.BYTE  $10,	$DD, $1D, $79, $3B, $9D, $FF; 8
RoomData_2E:
	.BYTE  $E0, 1,   0, $83, $36, $94, $DA,	3
	.BYTE  $21,	$41, $61, $18, $59, $33, $96, $FF; 8
RoomData_2F:
	.BYTE  $E0, 1,  $C, $87, 0,   7, $69, $89
	.BYTE  $85,	$65, $33, $32, $31, $20, $C5, $10; 8
	.BYTE  $C9,	$38, $37, $FF		; $10
RoomData_30:
	.BYTE  $65,	$47, $94, $57, $6F, $67, $97, $77
	.BYTE    6,	$2D, $2C, $2B, $43, $42, $41, $18; 8
	.BYTE  $C1,	$33, $CA, $FF		; $10
RoomData_31:
	.BYTE  $E0, 1,   0, $83, $24, $69, $46, $96
	.BYTE  $56, 6,   6, $3E, $5E, $69, $89, $23; 8
	.BYTE  $21,	$11, $C1, $20, $CB, $38, $B5, $FF; $10
RoomData_32:
	.BYTE  $8F, 1, $67, $A8, $96, $B8,   4, $94
	.BYTE  $DA, 4, $2D, $3C, $49, $38, $10, $65; 8
	.BYTE  $38,	$C6, $FF		; $10
RoomData_33:
	.BYTE  $E6, 0, $8D, $8B, 0, $A8, $54,	6
	.BYTE  $85,	$83, $81, $2D, $2B, $29, $13, $D8; 8
	.BYTE  $12,	$D9, $11, $DA, $10, $DB, $FF; $10
RoomData_34:
	.BYTE    6,	$D5, $D3, $9C, $9A, $52, $82, $20
	.BYTE  $BE,	$14, $5D, $FF		; 8
RoomData_35:
	.BYTE    6,	$A8, $A6, $A4, $27, $25, $23, $12
	.BYTE  $C2,	$18, $BE, $FF		; 8
RoomData_36:
	.BYTE  $E6,	$41,   0, $8F, $3C,   6, $87, $85
	.BYTE  $83,	$4E, $3E, $2E, $14, $44, $10, $DE; 8
	.BYTE  $FF				; $10
RoomData_37:
	.BYTE  $92,	$55, $9B, $DB, 6, $9D, $9B, $2D
	.BYTE  $2B,	$53, $73, $18, $41, $14, $A1, $FF; 8
RoomData_38:
	.BYTE  $8E, 1, $65, $42, $94, $52,   3, $A9
	.BYTE  $89,	$69, $11, $C1, $10, $DE, $20, $6D; 8
	.BYTE  $FF				; $10
RoomData_39:
	.BYTE  $E6, 1,  $D, $83, 7,   3, $87, $85
	.BYTE  $83,	$14, $43, $13, $DD, $FF	; 8
RoomData_3A:
	.BYTE  $E2, 1,  $E, $8A, 0,   6, $9B, $99
	.BYTE  $97,	$25, $23, $21, $18, $62, $FF; 8
RoomData_3B:
	.BYTE  $8F, 1,   5, $3E, $3C, $3A, $25, $23
	.BYTE  $20,	$6C, $11, $C5, $10, $CB, $13, $CE; 8
	.BYTE  $FF				; $10
RoomData_3C:
	.BYTE  $E2, 0, $8F, $8B, 0, $61, $78,	4
	.BYTE  $2D,	$29, $25, $21, $12, $87, $10, $88; 8
	.BYTE  $14,	$C5, $20, $C6, $13, $B5, $18, $B6; $10
	.BYTE  $FF				; $18
RoomData_3D:
	.BYTE  $86, 1,   5, $9C, $9A, $98, $27, $25
	.BYTE  $10,	$4D, $1D, $67, $11, $C3, $13, $C9; 8
	.BYTE  $FF				; $10
RoomData_3E:
	.BYTE  $E7, 1, $10, $82, 0, $68, $8E, $96
	.BYTE  $9E, 8,   8, $49, $4B, $4D, $86, $84; 8
	.BYTE  $B9,	$BB, $BD, $18, $44, $FF	; $10
RoomData_3F:
	.BYTE  $AB,	$5B, $94, $4D, 6, $78, $79, $7A
	.BYTE  $B7,	$B6, $B5, $14, $32, $10, $3E, $11; 8
	.BYTE  $97,	$18, $AE, $FF		; $10
RoomData_40:
	.BYTE  $E0,	$49,   0, $8E, $46, $94, $3C,	5
	.BYTE  $37,	$5B, $77, $9B, $B7, $18, $A1, $11; 8
	.BYTE  $A3,	$FF			; $10
RoomData_41:
	.BYTE  $E7, 1, $10, $87, 1, $9B, $D5,	4
	.BYTE  $22,	$42, $92, $B2, $10, $4C, $13, $4D; 8
	.BYTE  $10,	$4E, $20, $74, $11, $75, $14, $76; $10
	.BYTE  $FF				; $18
RoomData_42:
	.BYTE  $E3,	$51, $11, $83, $4C, $86,   7,	4
	.BYTE  $2A,	$28, $26, $21, $14, $59, $18, $93; 8
	.BYTE  $FF				; $10
RoomData_43:
	.BYTE    4,	$3E, $3B, $39, $37, $13, $89, $20
	.BYTE  $D4,	$14, $D8, $20, $DA, $FF	; 8
RoomData_44:
	.BYTE  $8E, 1, $92, $8D, 4, $99, $97, $93
	.BYTE  $95,	$13, $78, $18, $D3, $18, $D5, $18; 8
	.BYTE  $D7,	$18, $D9, $FF		; $10
RoomData_45:
	.BYTE  $E0, 0, $92, $8B, 0, $9B, $97,	9
	.BYTE  $3D,	$3C, $3B, $68, $67, $66, $43, $42; 8
	.BYTE  $41,	$11, $C6, $10, $C9, $FF	; $10
RoomData_46:
	.BYTE  $62,	$AA, $9A, $5C, 8, $89, $87, $27
	.BYTE  $26,	$25, $61, $41, $21, $10, $4D, $10; 8
	.BYTE  $66,	$FF			; $10
RoomData_47:
	.BYTE  $E0, 0, $12, $83, 7,   4, $8B, $89
	.BYTE  $86,	$84, $18, $63, $18, $64, $18, $65; 8
	.BYTE  $18,	$69, $18, $6A, $18, $6B, $FF; $10
RoomData_48:
	.BYTE  $94,	$54,   4, $79, $76, $91, $94, $10
	.BYTE  $CC,	$11, $CD, $12, $CE, $FF	; 8
RoomData_49:
	.BYTE  $E0,	$59,   0, $82, 1, $8F, $54, $62
	.BYTE  $A8,	$63, $A9,   3, $3D, $3B, $39, $1D; 8
	.BYTE  $C3,	$13, $C5, $20, $C8, $14, $C9, $11; $10
	.BYTE  $B8,	$18, $B9, $FF		; $18
RoomData_4A:
	.BYTE  $E6, 1, $13, $86, 0, $98, $BD,	6
	.BYTE  $91,	$93, $B5, $B7, $8A, $8C, $14, $AE; 8
	.BYTE  $20,	$CA, $10, $33, $FF	; $10
RoomData_4B:
	.BYTE  $8E, 1,   7, $D2, $D4, $D6, $D8, $3A
	.BYTE  $38,	$36, $FF		; 8
RoomData_4C:
	.BYTE  $E8, 6, $94, $88, 0, $62, $4A, $63
	.BYTE  $69,	$65, $79, $94, $87, $94, $C2, $94; 8
	.BYTE  $5A, 1, $23, $FF		; $10
RoomData_4D:
	.BYTE  $82, 1,   6, $2E, $2B, $48, $45, $9B
	.BYTE  $9E,	$FF			; 8
RoomData_4E:
	.BYTE  $E8, 5, $95, $86, 0,   6, $43, $63
	.BYTE  $83,	$59, $39, $19, $FF	; 8
RoomData_51_VertOutside:
	.BYTE 4, $A7, $AB, $2D, $29,	$FF
RoomData_52:
	.BYTE  $82, 1,   6, $A7, $A5, $A3, $29, $2B
	.BYTE  $2D,	$FF			; 8
RoomData_53:
	.BYTE  $E8, 5, $96, $86, 0,   6, $43, $63
	.BYTE  $83,	$59, $39, $19, $FF	; 8
RoomData_54_HorizOutside:
	.BYTE 6, $57, $77, $97, $5E, $7E, $9E, $FF
RoomData_5A:
	.BYTE  $88, 1, $94, $69, $94, $C2,   1, $33
	.BYTE  $FF				; 8
RoomData_5B:
	.BYTE  $E2, 0, $97, $8F, 0, $87,   7,	6
	.BYTE  $64,	$44, $24, $39, $59, $79, $10, $C3; 8
	.BYTE  $1B,	$CA, $48, $6C, $35, $C6, $FF; $10
RoomData_5C:
	.BYTE  $61,	$A8, $98, $D8, 6, $41, $43, $67
	.BYTE  $69,	$2C, $2E, $10, $C1, $14, $C9, $43; 8
	.BYTE  $CB,	$FF			; $10
RoomData_5D:
	.BYTE  $62,	$B8, $94, $C8, 6, $44, $64, $84
	.BYTE  $59,	$79, $99, $40, $C3, $48, $CD, $FF; 8
RoomData_5E:
	.BYTE  $E2, 1,   0, $87, 2,   3, $35, $36
	.BYTE  $37,	$11, $68, $20, $C8, $33, $C3, $34; 8
	.BYTE  $CB,	$FF			; $10
RoomData_5F:
	.BYTE  $94,	$56,   4, $41, $43, $67, $69, $FF
RoomData_60:
	.BYTE  $8B, 1, $65, $79, 2, $22, $25, $28
	.BYTE  $C5,	$18, $C6, $18, $C9, $14, $CA, $10; 8
	.BYTE  $B5,	$11, $B6, $11, $B9, $10, $BA, $FF; $10
RoomData_61:
	.BYTE  $E6,	$F8, $98, $8E, 0, $86, $FC, $A8
	.BYTE  $77,	$10, $67, $18, $AE, $FF	; 8
RoomData_62:
	.BYTE  $13,	$44, $20, $6C, $FF
RoomData_63:
	.BYTE  $E6, 1,   0, $86, $5C, $94, $47, $15
	.BYTE  $C3,	$20, $AE, $FF		; 8
RoomData_64:
	.BYTE  $36,	$6C,  $B, $FF
RoomData_65:
	.BYTE  $8A, 1, $99, $34, $18, $CC, $FF
RoomData_66:
	.BYTE  $E0, 1, $19, $8E, 0,   9, $47, $49
	.BYTE  $4B,	$85, $83, $81, $BA, $BC, $BE, $FF; 8
RoomData_67:
	.BYTE  $63,	$BE, $94, $CE, 5, $2D, $2B, $29
	.BYTE  $8B,	$8D, $12, $41, $10, $A2, $FF; 8
RoomData_68:
	.BYTE  $E0,	$69,   0, $86, 1, $8E, $66,  $B
	.BYTE  $29,	$27, $25, $54, $56, $58, $AD, $AB; 8
	.BYTE  $A9,	$93, $91, $FF		; $10
RoomData_69:
	.BYTE  $E2, 1, $1A, $82, 0, $61, $66, $9A
	.BYTE  $76,	$10, $C1, $12, $AE, $FF	; 8
RoomData_6A:
	.BYTE  $E2, 1, $1A, $8A, 1, $87,   7, $14
	.BYTE  $CC,	$FF			; 8
RoomData_6B:
	.BYTE  $E0, 0, $9B, $8F, 0, $12, $C5, $10
	.BYTE  $B5,	$12, $7C, $33, $4E, $35, $67, $34; 8
	.BYTE  $69,	$38, $C6, $38, $B6, $48, $CA, $35; $10
	.BYTE  $CE,	$FF			; $18
RoomData_6C:
	.BYTE  $E0, 1,   0, $86, 7, $10, $43, $11
	.BYTE  $45,	$12, $47, $34, $44, $34, $46, $3B; 8
	.BYTE  $6D,	$38, $AE, $FF		; $10
RoomData_6D:
	.BYTE  $E0, 1,   0, $87, $6D, $96, $7B,  $D
	.BYTE  $FF				; 8
RoomData_6E:
	.BYTE  $8A, 1, $14, $63, $18, $CE, $34, $62
	.BYTE  $43,	$64, $3B, $CD, $FF	; 8
RoomData_6F:
	.BYTE  $E6, 0, $9C, $87, 0,   7, $72, $92
	.BYTE  $95,	$B5, $19, $1B, $1D, $10, $79, $14; 8
	.BYTE  $D8,	$11, $DA, $FF		; $10
RoomData_70:
	.BYTE  $E6,	$69,   0, $8A, 1, $8E, $64, $94
	.BYTE  $4C, 5, $C5, $C4, $42, $62, $82, $14; 8
	.BYTE  $79,	$10, $9E, $10, $DE, $FF	; $10
RoomData_71:
	.BYTE  $E8, 6, $1D, $8C, 0, $62, $67, $63
	.BYTE  $AB,	$94, $45, $94, $77,   1, $3C, $FF; 8
RoomData_72:
	.BYTE  $83, 1,   4, $61, $64, $99, $9C, $FF
RoomData_73:
	.BYTE  $E8, 5, $9E, $87, 0,   6, $43, $63
	.BYTE  $83,	$59, $39, $19, $FF	; 8
RoomData_76:
	.BYTE  $83, 1,   6, $A7, $A5, $A3, $29, $2B
	.BYTE  $2D,	$FF			; 8
RoomData_77:
	.BYTE  $E8, 5, $9F, $87, 0,   4, $61, $64
	.BYTE  $99,	$9C, $FF		; 8
RoomData_7D:
	.BYTE  $8C, 1, $6A, $88, $63, $98, $94, $66
	.BYTE  $94,	$AA, $98, $AB, $99, $A8,   1, $3C; 8
	.BYTE  $FF				; $10
RoomData_7E:
	.BYTE  $E0, 0, $A0, $8A, 0, $96, $DE,  $B
	.BYTE    9,	$4B, $49, $47, $68, $66, $64, $85; 8
	.BYTE  $83,	$81, $1C, $CE, $FF	; $10
RoomData_7F:
	.BYTE  $86,	$5B,   6, $6D, $8D, $AD, $27, $26
	.BYTE  $25,	$20, $C3, $14, $C8, $12, $CB, $FF; 8
RoomData_80:
	.BYTE  $E3, 1, $21, $82, 0,   5, $3B, $39
	.BYTE  $46,	$44, $64, $10, $93, $20, $99, $FF; 8
RoomData_81:
	.BYTE  $E3,	$79,   0, $86, $74, $12, $61, $14
	.BYTE  $63,	$18, $68, $14, $6A, $10, $D4, $18; 8
	.BYTE  $D5,	$11, $D6, $18, $D7, $20, $D8, $12; $10
	.BYTE  $DA,	$13, $DC, $FF		; $18
RoomData_82:
	.BYTE  $8E, 1, $63, $6F, 8, $57, $77, $97
	.BYTE  $B7,	$55, $75, $95, $B5, $10, $D2, $14; 8
	.BYTE  $DE,	$FF			; $10
RoomData_83:
	.BYTE  $E2, 0, $A2, $8A, 0, $9B, $B9,	4
	.BYTE  $5A,	$57, $54, $51, $10, $C2, $1C, $C6; 8
	.BYTE  $48,	$7E, $33, $C4, $FF	; $10
RoomData_84:
	.BYTE    5,	$2E, $4C, $21, $41, $61, $18, $64
	.BYTE  $10,	$66, $10, $C4, $12, $CE, $38, $63; 8
	.BYTE  $33,	$C7, $48, $CD, $FF	; $10
RoomData_85:
	.BYTE  $E2,	$79,   0, $86, $74, $92, $97,	4
	.BYTE  $2A,	$47, $24, $41, $18, $5E, $11, $C9; 8
	.BYTE  $10,	$CD, $4C, $88, $34, $C5, $FF; $10
RoomData_86:
	.BYTE  $8F, 1, $63, $84, $9B, $D7,   3, $3B
	.BYTE  $58,	$35, $15, $4D, $11, $C2, $14, $CE; 8
	.BYTE  $38,	$74, $33, $7C, $FF	; $10
RoomData_87:
	.BYTE  $E7, 0, $A3, $86, 0, $63, $BE, $92
	.BYTE  $DB,	$9A, $CE,   3, $2D, $2B, $29, $10; 8
	.BYTE  $31,	$20, $95, $12, $AC, $4B, $44, $FF; $10
RoomData_88:
	.BYTE  $8A, 1,   6, $BD, $CD, $DD, $4C, $5B
	.BYTE  $6A,	$20, $31, $12, $A1, $4D, $33, $35; 8
	.BYTE  $A3,	$FF			; $10
RoomData_89:
	.BYTE  $E0, 1, $24, $8E, 0, $A8, $77,	6
	.BYTE  $83,	$63, $43, $29, $49, $69, $18, $67; 8
	.BYTE  $12,	$C2, $48, $AE, $FF	; $10
RoomData_8A:
	.BYTE  $65,	$8E, $98, $9E, 4, $51, $34, $69
	.BYTE  $86,	$1B, $CD, $FF		; 8
RoomData_8B:
	.BYTE  $E0, 1,   0, $83, 2,   8, $91, $93
	.BYTE  $45,	$47, $49, $2F, $5F, $8F, $FF; 8
RoomData_8C:
	.BYTE    2,	$25, $27, $10, $4E, $13, $66, $44
	.BYTE  $67,	$3B, $CD, $FF		; 8
RoomData_8D:
	.BYTE  $8B, 1, $62, $74, $62, $84,   2, $91
	.BYTE  $B1,	$20, $C5, $12, $C6, $15, $C9, $14; 8
	.BYTE  $CA,	$20, $B9, $11, $BA, $4D, $CD, $FF; $10
RoomData_8E:
	.BYTE  $E6, 0, $A5, $86, 0, $63, $42, $62
	.BYTE  $52,	$96, $62,  $F, 4, $4B, $6B, $8B; 8
	.BYTE  $AB,	$12, $2E, $1D, $97, $1B, $D4, $FF; $10
RoomData_8F:
	.BYTE  $E6, 1,   0, $83, $85, $8B, $7D, $9A
	.BYTE  $7C, 7, $B9, $BB, $BD, $37, $32, $82; 8
	.BYTE  $87,	$14, $6E, $10, $6D, $FF	; $10
RoomData_90:
	.BYTE  $E5, 2,   0, $8E, 0, $8A,   3,	0
	.BYTE  $58,	$59, $5A, $5B, $7D, $8D, $9D, $AD; 8
	.BYTE  $72,	$82, $92, $A2, $23, $24, $25, $BB; $10
	.BYTE  $BA,	$B9, $D6, $D5, $D4, $2D, $2C, $2B; $18
	.BYTE  $FF				; $20
RoomData_91:
	.BYTE  $E0, 2,   0, $80, 0, $89,   3,	0
	.BYTE  $32,	$33, $34, $73, $74, $75, $A4, $A5; 8
	.BYTE  $A6,	$A9, $AA, $AB, $7A, $7B, $7C, $3B; $10
	.BYTE  $3C,	$3D, $49, $48, $47, $28, $27, $26; $18
	.BYTE  $FF				; $20
RoomData_92:
	.BYTE  $E2, 2,   0, $8D, 0, $89,   3,	0
	.BYTE  $A2,	$A3, $A4, $96, $76, $56, $59, $79; 8
	.BYTE  $99,	$AB, $AC, $AD, $39, $3A, $2C, $2D; $10
	.BYTE  $36,	$35, $23, $22, $D5, $D6, $D9, $DA; $18
	.BYTE  $FF				; $20
RoomData_93:
	.BYTE  $E5, 2,   0, $8D, 0, $89,   3,	0
	.BYTE  $A9,	$AA, $AB, $A6, $A5, $A4, $7B, $7C; 8
	.BYTE  $7D,	$74, $73, $72, $3A, $3B, $3C, $35; $10
	.BYTE  $34,	$33, $D2, $D3, $D4, $DB, $DC, $DD; $18
	.BYTE  $FF				; $20
RoomData_94:
	.BYTE  $E3, 2,   0, $89, 0, $8D,   3,	0
	.BYTE  $4C,	$5C, $6C, $9C, $AC, $BC, $49, $59; 8
	.BYTE  $69,	$96, $A6, $B6, $43, $53, $63, $93; $10
	.BYTE  $A3,	$B3, $99, $A9, $B9, $46, $56, $66; $18
	.BYTE  $FF				; $20
RoomData_95:
	.BYTE  $E6, 2,   0, $89, 0, $8D,   3,	0
	.BYTE  $64,	$63, $62, $82, $92, $A2, $B2, $BD; 8
	.BYTE  $AD,	$9D, $8D, $6D, $6C, $6B, $AB, $A9; $10
	.BYTE  $A6,	$A4, $39, $38, $23, $22, $2C, $2D; $18
	.BYTE  $FF				; $20
RoomData_96:
	.BYTE  $E7, 2,   0, $8A, 0, $8D,   3,	0
	.BYTE  $B9,	$C9, $D9, $79, $7A, $7B, $B6, $C6; 8
	.BYTE  $D6,	$76, $75, $74, $34, $35, $36, $39; $10
	.BYTE  $3A,	$3B, $B2, $C2, $D2, $BD, $CD, $DD; $18
	.BYTE  $FF				; $20
RoomData_97:
	.BYTE  $E0, 2,   0, $8A, 0, $8E,   3,	0
	.BYTE  $49,	$59, $69, $DB, $CB, $BB, $9D, $9C; 8
	.BYTE  $9B,	$94, $93, $92, $D4, $C4, $B4, $46; $10
	.BYTE  $56,	$66, $23, $33, $43, $2C, $3C, $4C; $18
	.BYTE  $FF				; $20
RoomData_98:
	.BYTE  $E5, 2,   0, $8E, 0, $89,   3,	0
	.BYTE  $55,	$45, $35, $33, $43, $53, $A4, $A5; 8
	.BYTE  $A6,	$79, $7A, $7B, $BA, $CA, $DA, $4D; $10
	.BYTE  $4C,	$4B, $BD, $CD, $DD, $2B, $2A, $29; $18
	.BYTE  $FF				; $20
RoomData_99:
	.BYTE  $E2, 2,   0, $8D, 0, $8A,   3,	0
	.BYTE  $3D,	$3C, $3B, $34, $33, $32, $65, $66; 8
	.BYTE  $69,	$6A, $9D, $9C, $9B, $94, $93, $92; $10
	.BYTE  $B5,	$B6, $B9, $BA, $DC, $DD, $D3, $D2; $18
	.BYTE  $FF				; $20
RoomData_9A:
	.BYTE  $E3, 2,   0, $8E, 0, $89,   3,	0
	.BYTE  $99,	$A9, $B9, $84, $74, $64, $AD, $8D; 8
	.BYTE  $6D,	$2B, $2A, $29, $26, $25, $24, $62; $10
	.BYTE  $82,	$A2, $6B, $7B, $8B, $B6, $A6, $96; $18
	.BYTE  $FF				; $20
RoomData_9B:
	.BYTE  $E6, 2,   0, $8E, 0, $81,   3,	0
	.BYTE  $3A,	$3B, $3C, $42, $62, $82, $83, $A3; 8
	.BYTE  $C3,	$35, $34, $33, $4D, $6D, $8D, $8C; $10
	.BYTE  $AC,	$CC, $A9, $89, $69, $66, $86, $A6; $18
	.BYTE  $FF				; $20
RoomData_9C:
	.BYTE  $E0, 2,   0, $8A, 0, $8E,   3,	0
	.BYTE  $22,	$32, $42, $63, $73, $93, $8C, $9C; 8
	.BYTE  $BC,	$BD, $CD, $DD, $D4, $D3, $D2, $2B; $10
	.BYTE  $2C,	$2D, $6C, $6D, $5D, $59, $57, $55; $18
	.BYTE  $FF				; $20
RoomData_9D:
	.BYTE  $E5, 2,   0, $8A, 0, $8E,   3,	0
	.BYTE  $5B,	$6B, $7B, $84, $94, $A4, $B5, $C5; 8
	.BYTE  $D5,	$67, $57, $47, $54, $53, $52, $BA; $10
	.BYTE  $BB,	$BC, $7D, $6D, $5D, $2A, $3A, $4A; $18
	.BYTE  $FF				; $20
RoomData_9E:
	.BYTE  $E3, 2,   0, $89, 0, $80,   3,	0
	.BYTE  $56,	$57, $58, $7C, $8C, $9C, $AC, $BC; 8
	.BYTE  $85,	$75, $65, $73, $83, $93, $A3, $B3; $10
	.BYTE  $6A,	$7A, $8A, $3C, $39, $38, $37, $33; $18
	.BYTE  $FF				; $20
RoomData_9F:
	.BYTE  $E7, 2,   0, $8F, 0, $80,   3,	0
	.BYTE  $39,	$49, $59, $8A, $9A, $AA, $55, $65; 8
	.BYTE  $75,	$A6, $B6, $C6, $2C, $3C, $4C, $BD; $10
	.BYTE  $CD,	$DD, $23, $33, $43, $B2, $C2, $D2; $18
	.BYTE  $FF				; $20
RoomData_A0:
	.BYTE  $E3, 3,   0, $87, 0, $8E,   6, $65
	.BYTE  $A8,	$7B, $C7, $33, $C2, $15, $C4, $14; 8
	.BYTE  $C5,	$3C, $CA, $48, $CB, $20, $B5, $3B; $10
	.BYTE  $27,	$40, $C1, $FF		; $18
RoomData_A1:
	.BYTE  $E3, 3,   0, $8A, 0, $8D,   6, $63
	.BYTE  $A6,	$63, $B6, $AB, $38, $7C, $C8, $14; 8
	.BYTE  $C5,	$12, $B5, $15, $A5, $18, $CD, $48; $10
	.BYTE  $CA,	$44, $BA, $FF		; $18
RoomData_A2:
	.BYTE  $E3, 3,   0, $89, 0, $80,   6, $65
	.BYTE  $A9,	$65, $B9, $7D, $C7, $34, $CB, $42; 8
	.BYTE  $96,	$1C, $97, $10, $98, $31, $99, $18; $10
	.BYTE  $C2,	$FF			; $18
RoomData_A3:
	.BYTE  $E3, 3,   0, $86, 0, $83, $A6, $63
	.BYTE  $A6,	$68, $A9, $65, $B9, $7E, $C7, $12; 8
	.BYTE  $96,	$11, $97, $11, $98, $18, $99, $4C; $10
	.BYTE  $87,	$3C, $88, $FF		; $18
RoomData_A4:
	.BYTE  $E3, 3,   0, $8E, 0, $89,   1, $63
	.BYTE  $A7,	$20, $96, $14, $97, $20, $98, $14; 8
	.BYTE  $99,	$10, $86, $10, $87, $10, $88, $10; $10
	.BYTE  $89,	$79, $C8, $FF		; $18
RoomData_A5:
	.BYTE  $E3, 3,   0, $81, 1, $65, $A9, $65
	.BYTE  $B9,	$38, $C1, $38, $C2, $38, $C4, $14; 8
	.BYTE  $C8,	$38, $B8, $20, $CB, $21, $CD, $22; $10
	.BYTE  $CE,	$7A, $C7, $FF		; $18
RoomData_A6:
	.BYTE  $E2, 3,   0, $80, 7, $85,   1, $FF
RoomData_A7:
	.BYTE  $E2, 3,   0, $80, 7, $85,   1, $FF
RoomData_A8:
	.BYTE  $E4, 3,   0, $89, 1, $18, $D1, $14
	.BYTE  $D4,	$2C, $D7, $11, $DA, $FF	; 8
RoomData_A9:
	.BYTE  $E0, 3, $40, $80, 1, $61, $85, $61
	.BYTE  $8A,	$61, $B7, $61, $B8, $10, $D2, $11; 8
	.BYTE  $D3,	$12, $DC, $10, $DD, $FF	; $10
RoomData_AA:
	.BYTE  $E5, 3,   0, $81, 1, $84,   1,	8
	.BYTE  $3C,	$6C, $93, $C3, $33, $63, $9C, $CC; 8
	.BYTE  $20,	$D6, $1B, $D9, $FF	; $10
RoomData_AB:
	.BYTE  $E0, 3,   0, $8A, 1, $18, $D1, $14
	.BYTE  $D2,	$20, $D3, $10, $D4, $1B, $C1, $12; 8
	.BYTE  $C2,	$11, $C3, $13, $B1, $11, $B2, $10; $10
	.BYTE  $A1,	$FF			; $18
RoomData_AC:
	.BYTE  $E6, 7,   0, $80, 7, $FF
RoomData_AD:
	.BYTE  $E0, 3,   0, $87, 1, $9B, $5D,	3
	.BYTE  $6A,	$68, $66, $10, $1A, $10, $47, $11; 8
	.BYTE  $4B,	$FF			; $10
RoomData_AE:
	.BYTE    7,	$BC, $BE, $B6, $96, $76, $53, $51
	.BYTE  $18,	$A2, $14, $3E, $1C, $7A, $20, $9D; 8
	.BYTE  $FF				; $10
RoomData_AF:
	.BYTE  $E0,	$C3,   0, $8E, 1, $89, $BC,	6
	.BYTE  $44,	$74, $A4, $4B, $7B, $AB, $38, $D1; 8
	.BYTE  $4B,	$D5, $3C, $D9, $33, $DD, $FF; $10
RoomData_B0:
	.BYTE  $E2, 3,   0, $80, 1, $12, $DB, $20
	.BYTE  $DC,	$14, $DD, $1B, $DE, $11, $CC, $18; 8
	.BYTE  $CD,	$18, $CE, $10, $BD, $18, $BE, $1C; $10
	.BYTE  $AE,	$FF			; $18
RoomData_B1:
	.BYTE  $E0, 3, $40, $8D, 1, $62, $89, $62
	.BYTE  $B5,	$1D, $74, $12, $A9, $20, $D5, $13; 8
	.BYTE  $DE,	$FF			; $10
RoomData_B2:
	.BYTE  $E4, 3,   0, $85, 1,   6, $54, $56
	.BYTE  $89,	$87, $CB, $CD, $18, $D2, $2A, $C2; 8
	.BYTE  $12,	$B2, $FF		; $10
RoomData_B3:
	.BYTE  $E4, 3,   0, $89, 1, $3C, $D1, $3C
	.BYTE  $D3,	$3C, $D5, $3C, $D7, $3C, $D9, $3C; 8
	.BYTE  $DB,	$3C, $DD, $FF		; $10
RoomData_B4:
	.BYTE  $E6, 3,   0, $82, 1,   6, $35, $55
	.BYTE  $75,	$9A, $BA, $DA, $FF	; 8
RoomData_B5:
	.BYTE    6,	$16, $36, $66, $73, $93, $B3, $1C
	.BYTE  $C9,	$38, $CA, $1B, $CB, $33, $CC, $12; 8
	.BYTE  $CD,	$3A, $CE, $FF		; $10
RoomData_B6:
	.BYTE  $E2, 3, $40, $89, 1, $62, $87, $63
	.BYTE  $88,	$63, $B5, $61, $BA, $1B, $D2, $12; 8
	.BYTE  $D5,	$20, $DD, $FF		; $10
RoomData_B7:
	.BYTE  $E7, 3,   0, $89, 1, $A4, $44, $98
	.BYTE  $5B,	$9C, $97, $9D, $D2, $FF	; 8
RoomData_B8:
	.BYTE  $1A,	$21, $15, $22, $12, $23, $11, $24
	.BYTE  $10,	$25, $34, $41, $38, $42, $3D, $43; 8
	.BYTE  $1C,	$61, $FF		; $10
RoomData_B9:
	.BYTE  $E0, 3,   0, $81, 1, $11, $D2, $12
	.BYTE  $D3,	$10, $D4, $18, $D5, $13, $D6, $13; 8
	.BYTE  $D7,	$18, $D8, $15, $D9, $11, $DA, $12; $10
	.BYTE  $DB,	$40, $DE, $FF		; $18
RoomData_BA:
	.BYTE  $E4, 3, $40, $8A, 1, $63, $8B, $63
	.BYTE  $9B,	$62, $AB, $63, $BA, $11, $A5, $13; 8
	.BYTE  $D1,	$18, $C1, $12, $D2, $10, $D5, $FF; $10
RoomData_BB:
	.BYTE  $E0,	$CB,   0, $8A, 1, $8D, $C4, $12
	.BYTE  $D4,	$18, $D7, $20, $D8, $10, $DB, $FF; 8
RoomData_BC:
	.BYTE  $E0,	$D3,   0, $89, 1, $8E, $CE, $20
	.BYTE  $D1,	$11, $D5, $12, $D8, $11, $DB, $FF; 8
RoomData_BD:
	.BYTE  $E6, 3, $40, $80, 1, $63, $8B, $65
	.BYTE  $9B,	$62, $B8, $12, $D5, $14, $C5, $13; 8
	.BYTE  $A5,	$18, $95, $FF		; $10
RoomData_BE:
	.BYTE  $E3, 3,   0, $85, 1,   9, $B4, $84
	.BYTE  $54,	$BC, $8C, $5C, $B8, $88, $58, $18; 8
	.BYTE  $D1,	$18, $D7, $FF		; $10
RoomData_BF:
	.BYTE  $E0, 3,   0, $8D, 1, $16, $DC, $10
	.BYTE  $1C,	$CC, $1D, $BC, $18, $AC, $15, $9C; 8
	.BYTE  $20,	$8C, $13, $7C, $12, $6C, $11, $5C; $10
	.BYTE  $10,	$4C, $FF		; $18
RoomData_C0:
	.BYTE  $E0, 3, $26, $8A, 0,   7, $5D, $7D
	.BYTE  $29,	$27, $21, $41, $61, $33, $99, $3B; 8
	.BYTE  $D2,	$FF			; $10
RoomData_C1:
	.BYTE  $92,	$61, $AA, $71, 4, $8B, $89, $47
	.BYTE  $45,	$38, $52, $35, $4C, $33, $CC, $33; 8
	.BYTE  $CD,	$33, $CE, $FF		; $10
RoomData_C2:
	.BYTE    6,	$2B, $29, $47, $45, $93, $91, $34
	.BYTE  $6D,	$FF			; 8
RoomData_C3:
	.BYTE  $94,	$7A,   4, $2B, $28, $23, $20, $38
	.BYTE  $69,	$33, $6A, $38, $C1, $FF	; 8
RoomData_C4:
	.BYTE  $8F, 1,   6, $3E, $38, $68, $98, $44
	.BYTE  $74,	$4C, $AE, $4A, $C3, $FF	; 8
RoomData_C5:
	.BYTE  $E0,	$DB, $27, $8B, 0, $86,   1, $92
	.BYTE  $42, 6, $8A, $88, $73, $71, $15, $13; 8
	.BYTE  $10,	$C8, $10, $CB, $11, $4E, $FF; $10
RoomData_C6:
	.BYTE  $94,	$CA,   4, $78, $7B, $22, $24, $12
	.BYTE  $19,	$11, $44, $18, $4D, $20, $A3, $10; 8
	.BYTE  $BE,	$FF			; $10
RoomData_C7:
	.BYTE  $8A,	$D5,   4, $C9, $CB, $96, $94, $20
	.BYTE  $31,	$10, $A1, $13, $DE, $FF	; 8
RoomData_C8:
	.BYTE  $E0, 3, $28, $8F, 0,   6, $24, $26
	.BYTE  $78,	$7A, $4D, $4F, $10, $C3, $12, $C6; 8
	.BYTE  $20,	$CA, $FF		; $10
RoomData_C9:
	.BYTE  $8B, 1,   5, $82, $84, $35, $37, $39
	.BYTE  $20,	$3E, $18, $64, $10, $C1, $20, $C8; 8
	.BYTE  $FF				; $10
RoomData_CA:
	.BYTE  $E0, 3, $29, $8F, 0,   6, $9A, $9B
	.BYTE  $9C,	$49, $47, $45, $11, $2D, $15, $61; 8
	.BYTE  $10,	$75, $FF		; $10
RoomData_CB:
	.BYTE  $61,	$47, $61, $57, $94, $67, $AB, $77
	.BYTE    6,	$C8, $CA, $CC, $5D, $5B, $59, $13; 8
	.BYTE  $74,	$1B, $D4, $FF		; $10
RoomData_CC:
	.BYTE  $E0,	$E3,   0, $8F, $DC,   6, $9A, $9C
	.BYTE  $9E,	$16, $14, $12, $11, $2E, $18, $61; 8
	.BYTE  $20,	$C8, $FF		; $10
RoomData_CD:
	.BYTE  $83, 1, $94, $89, 5, $35, $32, $62
	.BYTE  $92,	$95, $11, $78, $12, $7A, $10, $9E; 8
	.BYTE  $10,	$DE, $FF		; $10
RoomData_CE:
	.BYTE  $E5, 4,   0, $80, 1, $84,   1,	4
	.BYTE  $B4,	$44, $4B, $BB, $10, $D6, $10, $DD; 8
	.BYTE  $FF				; $10
RoomData_CF:
	.BYTE  $E5, 4,   0, $80, 1, $84,   1, $10
	.BYTE  $D7,	$10, $DC, $FF		; 8
RoomData_D0:
	.BYTE  $E5, 4,   0, $80, 1, $84,   0, $89
	.BYTE    0, 4, $A2, $52, $AD, $5D, $FF; 8
RoomData_D1:
	.BYTE  $E0, 4,   0, $80, 1, $85,   0, $14
	.BYTE  $D7,	$18, $C7, $18, $B7, $14, $A7, $1C; 8
	.BYTE  $97,	$15, $87, $13, $77, $12, $67, $11; $10
	.BYTE  $57,	$10, $47, $FF		; $18
RoomData_D2:
	.BYTE  $E5, 4,   0, $81, 1, $84,   1,	6
	.BYTE  $4B,	$8B, $CB, $44, $84, $C4, $FF; 8
RoomData_D3:
	.BYTE  $E5, 4,   0, $80, 1, $84,   1,	4
	.BYTE  $B4,	$44, $4B, $BB, $10, $D5, $10, $DD; 8
	.BYTE  $FF				; $10
RoomData_D4:
	.BYTE  $E5, 4,   0, $80, 1, $8A,   1,	4
	.BYTE  $44,	$66, $88, $AA, $20, $D1, $10, $D3; 8
	.BYTE  $FF				; $10
RoomData_D5:
	.BYTE  $E5, 4,   0, $81, 0, $84,   1,	4
	.BYTE  $B4,	$44, $4B, $BB, $10, $D5, $11, $DA; 8
	.BYTE  $FF				; $10
RoomData_D6:
	.BYTE  $E5, 4,   0, $80, 1, $8A,   1,	4
	.BYTE  $44,	$66, $88, $AA, $10, $D1, $10, $D3; 8
	.BYTE  $FF				; $10
RoomData_D7:
	.BYTE  $E5, 4,   0, $8D, 1, $89,   1,	5
	.BYTE  $3B,	$39, $37, $35, $33, $FF	; 8
RoomData_D8:
	.BYTE  $E4, 4,   0, $84, 1, $FF
RoomData_D9:
	.BYTE  $E5, 4,   0, $80, 1, $84,   1,	4
	.BYTE  $B4,	$44, $4B, $BB, $FF	; 8
RoomData_DA:
	.BYTE  $E4, 4,   0, $80, 1, $FF
RoomData_DB:
	.BYTE  $E5, 4,   0, $8E, 1, $89,   1,	4
	.BYTE  $AA,	$88, $66, $44, $10, $D3, $20, $D9; 8
	.BYTE  $FF				; $10
RoomData_DC:
	.BYTE  $E4, 4,   0, $8E, 1, $84,   1, $FF
RoomData_DD:
	.BYTE  $E5, 4,   0, $80, 1, $8D,   1, $11
	.BYTE  $D8,	$11, $DB, $11, $DE, $FF	; 8
RoomData_DE:
	.BYTE  $E4, 4,   0, $85, 1, $FF
RoomData_DF:
	.BYTE  $E5, 4,   0, $81, 1, $89,   1, $35
	.BYTE  $D1,	$33, $D3, $32, $D5, $FF	; 8
RoomData_E0:
	.BYTE $FF
RoomData_E1:
	.BYTE  $E5, 4,   0, $8A, 1, $8D,   1,	5
	.BYTE  $BC,	$9A, $78, $56, $34, $FF	; 8
RoomData_E2:
	.BYTE $FF
RoomData_E3:
	.BYTE  $E0, 4,   0, $84, 1, $14, $63, $20
	.BYTE  $66,	$14, $69, $14, $6C, $14, $56, $10; 8
	.BYTE  $59,	$FF			; $10
RoomData_E4:
	.BYTE  $E5, 4,   0, $80, 1, $84,   1,	4
	.BYTE  $B4,	$44, $4B, $BB, $10, $D6, $10, $DD; 8
	.BYTE  $FF				; $10
RoomData_E5:
	.BYTE  $E5, 4,   0, $80, 1, $8A,   1, $8D
	.BYTE    1,	$10, $64, $11, $6B, $11, $D6, $10; 8
	.BYTE  $D9,	$FF			; $10
RoomData_E6:
	.BYTE  $E4, 4,   0, $85, 1, $FF
RoomData_E7:
	.BYTE  $E5, 4,   0, $8E, 1, $85, $E6, $81
	.BYTE    1,	$10, $55, $11, $59, $18, $83, $12; 8
	.BYTE  $8B,	$13, $B5, $20, $B9, $FF	; $10
RoomData_E8:
	.BYTE $FF
RoomData_E9:
	.BYTE  $E5, 4,   0, $8A, 1, $84,   1,	6
	.BYTE  $4B,	$8B, $CB, $44, $84, $C4, $FF; 8
RoomData_EA:
	.BYTE  $E5, 4,   0, $80, 1, $FF
RoomData_EB:
	.BYTE  $E5, 4,   0, $8E, 1, $84,   1, $10
	.BYTE  $57,	$11, $77, $10, $97, $11, $B7, $10; 8
	.BYTE  $D7,	$FF			; $10
RoomData_EC:
	.BYTE  $E5, 4,   0, $80, 1, $84,   1, $FF
RoomData_ED:
	.BYTE  $E0, 4,   0, $80, 1, $12, $D2, $13
	.BYTE  $D4,	$18, $D6, $1B, $D8, $15, $DA, $14; 8
	.BYTE  $DC,	$10, $DE, $FF		; $10
RoomData_EE:
	.BYTE  $E4, 4,   0, $85, 1, $FF
RoomData_EF:
	.BYTE  $E5, 4,   0, $8E, 1, $81,   1, $89
	.BYTE    1,	$10, $64, $10, $6B, $20, $D6, $11; 8
	.BYTE  $D9,	$FF			; $10
RoomData_F0:
	.BYTE  $E5, 4,   0, $89, 1, $FF
RoomData_F1:
	.BYTE  $E5, 4,   0, $8A, 1, $85,   1,	6
	.BYTE  $4B,	$8B, $CB, $44, $84, $C4, $FF; 8
RoomData_F2:
	.BYTE  $E5, 4,   0, $81, 1, $89,   1, $FF
RoomData_F3:
	.BYTE  $90,	$61, $90, $71, $90, $81, $90, $91
	.BYTE  $90,	$A1, $90, $B1, $90, $C1, $96, $D1; 8
	.BYTE  $1C,	$FF			; $10
RoomData_F4:
	.BYTE  $E4, 4,   0, $85, 1, $14, $D7, $13
	.BYTE  $C7,	$14, $B7, $11, $A7, $14, $97, $18; 8
	.BYTE  $87,	$1B, $77, $12, $67, $FF	; $10
RoomData_F5:
	.BYTE  $E4, 4,   0, $81, 1, $8D,   1, $85
	.BYTE    1,	$10, $55, $11, $59, $11, $83, $20; 8
	.BYTE  $8B,	$20, $B5, $10, $B9, $FF	; $10
RoomData_F6:
	.BYTE  $E4, 4,   0, $81, 1, $8D,   1, $85
	.BYTE    1, 4, $4B, $BB, $B4, $44, $FF; 8
RoomData_F7:
	.BYTE  $E4, 4,   0, $81, 1, $8E,   1,	4
	.BYTE  $44,	$66, $88, $AA, $10, $D1, $20, $D3; 8
	.BYTE  $FF				; $10
RoomData_F8:
	.BYTE  $E4, 4,   0, $8D, 1, $85,   1,	6
	.BYTE  $4B,	$8B, $CB, $44, $84, $C4, $FF; 8
RoomData_F9:
	.BYTE  $E4, 4,   0, $81, 1, $FF
RoomData_FA:
	.BYTE  $E2, 3,   0, $87, 1, $11, $3D, $10
	.BYTE  $8D,	$10, $63, $FF		; 8
RoomData_FB:
	.BYTE  $E0,	$F1,   0, $82, $EE, $10, $C4, $10
	.BYTE  $CA,	$92, $81, $FF		; 8
RoomData_FC:
	.BYTE  $E0,	$FB,   0, $87, 1,   3, $3D, $3B
	.BYTE  $39,	$10, $78, $FF		; 8
RoomData_FD:
	.BYTE  $82,	$F5, $99, $4E, 5, $C7, $C5, $C3
	.BYTE  $78,	$7A, $20, $DD, $10, $9D, $3B, $44; 8
	.BYTE  $FF				; $10
RoomData_FE:
	.BYTE  $E0, 3, $2A, $86, 0, $63, $42, $99
	.BYTE  $52,	$92, $3D,   6, $89, $8B, $8D, $16; 8
	.BYTE  $14,	$12, $FF		; $10
RoomData_FF:
	.BYTE  $83, 1,   5, $9A, $98, $42, $62, $82
	.BYTE  $12,	$9D, $FF		; 8
RoomDataPointers:
	.WORD RoomData_01
	.WORD RoomData_02			; 1 ; 1-indexed	table;
	.WORD RoomData_03			; 2 ; the title	screen (room 00)
	.WORD RoomData_04			; 3 ; does not have any	objects
	.WORD RoomData_05			; 4
	.WORD RoomData_06			; 5
	.WORD RoomData_07			; 6
	.WORD RoomData_08			; 7
	.WORD RoomData_09			; 8
	.WORD RoomData_0A			; 9
	.WORD RoomData_0B			; $A
	.WORD RoomData_0C			; $B
	.WORD RoomData_0D			; $C
	.WORD RoomData_0E			; $D
	.WORD RoomData_0F			; $E
	.WORD RoomData_10			; $F
	.WORD RoomData_11			; $10
	.WORD RoomData_12			; $11
	.WORD RoomData_13			; $12
	.WORD RoomData_14			; $13
	.WORD RoomData_15			; $14
	.WORD RoomData_16			; $15
	.WORD RoomData_17			; $16
	.WORD RoomData_18			; $17
	.WORD RoomData_19			; $18
	.WORD RoomData_1A			; $19
	.WORD RoomData_1B			; $1A
	.WORD RoomData_1C			; $1B
	.WORD RoomData_1D			; $1C
	.WORD RoomData_1E			; $1D
	.WORD RoomData_1F			; $1E
	.WORD RoomData_20			; $1F
	.WORD RoomData_21			; $20
	.WORD RoomData_22			; $21
	.WORD RoomData_23			; $22
	.WORD RoomData_24			; $23
	.WORD RoomData_25			; $24
	.WORD RoomData_26			; $25
	.WORD RoomData_27			; $26
	.WORD RoomData_28			; $27
	.WORD RoomData_29			; $28
	.WORD RoomData_2A			; $29
	.WORD RoomData_2B			; $2A
	.WORD RoomData_2C			; $2B
	.WORD RoomData_2D			; $2C
	.WORD RoomData_2E			; $2D
	.WORD RoomData_2F			; $2E
	.WORD RoomData_30			; $2F
	.WORD RoomData_31			; $30
	.WORD RoomData_32			; $31
	.WORD RoomData_33			; $32
	.WORD RoomData_34			; $33
	.WORD RoomData_35			; $34
	.WORD RoomData_36			; $35
	.WORD RoomData_37			; $36
	.WORD RoomData_38			; $37
	.WORD RoomData_39			; $38
	.WORD RoomData_3A			; $39
	.WORD RoomData_3B			; $3A
	.WORD RoomData_3C			; $3B
	.WORD RoomData_3D			; $3C
	.WORD RoomData_3E			; $3D
	.WORD RoomData_3F			; $3E
	.WORD RoomData_40			; $3F
	.WORD RoomData_41			; $40
	.WORD RoomData_42			; $41
	.WORD RoomData_43			; $42
	.WORD RoomData_44			; $43
	.WORD RoomData_45			; $44
	.WORD RoomData_46			; $45
	.WORD RoomData_47			; $46
	.WORD RoomData_48			; $47
	.WORD RoomData_49			; $48
	.WORD RoomData_4A			; $49
	.WORD RoomData_4B			; $4A
	.WORD RoomData_4C			; $4B
	.WORD RoomData_4D			; $4C
	.WORD RoomData_4E			; $4D
	.WORD RoomData_51_VertOutside	; $4E
	.WORD RoomData_51_VertOutside	; $4F
	.WORD RoomData_51_VertOutside	; $50
	.WORD RoomData_52			; $51
	.WORD RoomData_53			; $52
	.WORD RoomData_54_HorizOutside	; $53
	.WORD RoomData_54_HorizOutside	; $54
	.WORD RoomData_54_HorizOutside	; $55
	.WORD RoomData_54_HorizOutside	; $56
	.WORD RoomData_54_HorizOutside	; $57
	.WORD RoomData_54_HorizOutside	; $58
	.WORD RoomData_5A			; $59
	.WORD RoomData_5B			; $5A
	.WORD RoomData_5C			; $5B
	.WORD RoomData_5D			; $5C
	.WORD RoomData_5E			; $5D
	.WORD RoomData_5F			; $5E
	.WORD RoomData_60			; $5F
	.WORD RoomData_61			; $60
	.WORD RoomData_62			; $61
	.WORD RoomData_63			; $62
	.WORD RoomData_64			; $63
	.WORD RoomData_65			; $64
	.WORD RoomData_66			; $65
	.WORD RoomData_67			; $66
	.WORD RoomData_68			; $67
	.WORD RoomData_69			; $68
	.WORD RoomData_6A			; $69
	.WORD RoomData_6B			; $6A
	.WORD RoomData_6C			; $6B
	.WORD RoomData_6D			; $6C
	.WORD RoomData_6E			; $6D
	.WORD RoomData_6F			; $6E
	.WORD RoomData_70			; $6F
	.WORD RoomData_71			; $70
	.WORD RoomData_72			; $71
	.WORD RoomData_73			; $72
	.WORD RoomData_51_VertOutside	; $73
	.WORD RoomData_51_VertOutside	; $74
	.WORD RoomData_76			; $75
	.WORD RoomData_77			; $76
	.WORD RoomData_54_HorizOutside	; $77
	.WORD RoomData_54_HorizOutside	; $78
	.WORD RoomData_54_HorizOutside	; $79
	.WORD RoomData_54_HorizOutside	; $7A
	.WORD RoomData_54_HorizOutside	; $7B
	.WORD RoomData_7D			; $7C
	.WORD RoomData_7E			; $7D
	.WORD RoomData_7F			; $7E
	.WORD RoomData_80			; $7F
	.WORD RoomData_81			; $80
	.WORD RoomData_82			; $81
	.WORD RoomData_83			; $82
	.WORD RoomData_84			; $83
	.WORD RoomData_85			; $84
	.WORD RoomData_86			; $85
	.WORD RoomData_87			; $86
	.WORD RoomData_88			; $87
	.WORD RoomData_89			; $88
	.WORD RoomData_8A			; $89
	.WORD RoomData_8B			; $8A
	.WORD RoomData_8C			; $8B
	.WORD RoomData_8D			; $8C
	.WORD RoomData_8E			; $8D
	.WORD RoomData_8F			; $8E
	.WORD RoomData_90			; $8F
	.WORD RoomData_91			; $90
	.WORD RoomData_92			; $91
	.WORD RoomData_93			; $92
	.WORD RoomData_94			; $93
	.WORD RoomData_95			; $94
	.WORD RoomData_96			; $95
	.WORD RoomData_97			; $96
	.WORD RoomData_98			; $97
	.WORD RoomData_99			; $98
	.WORD RoomData_9A			; $99
	.WORD RoomData_9B			; $9A
	.WORD RoomData_9C			; $9B
	.WORD RoomData_9D			; $9C
	.WORD RoomData_9E			; $9D
	.WORD RoomData_9F			; $9E
	.WORD RoomData_A0			; $9F
	.WORD RoomData_A1			; $A0
	.WORD RoomData_A2			; $A1
	.WORD RoomData_A3			; $A2
	.WORD RoomData_A4			; $A3
	.WORD RoomData_A5			; $A4
	.WORD RoomData_A6			; $A5
	.WORD RoomData_A7			; $A6
	.WORD RoomData_A8			; $A7
	.WORD RoomData_A9			; $A8
	.WORD RoomData_AA			; $A9
	.WORD RoomData_AB			; $AA
	.WORD RoomData_AC			; $AB
	.WORD RoomData_AD			; $AC
	.WORD RoomData_AE			; $AD
	.WORD RoomData_AF			; $AE
	.WORD RoomData_B0			; $AF
	.WORD RoomData_B1			; $B0
	.WORD RoomData_B2			; $B1
	.WORD RoomData_B3			; $B2
	.WORD RoomData_B4			; $B3
	.WORD RoomData_B5			; $B4
	.WORD RoomData_B6			; $B5
	.WORD RoomData_B7			; $B6
	.WORD RoomData_B8			; $B7
	.WORD RoomData_B9			; $B8
	.WORD RoomData_BA			; $B9
	.WORD RoomData_BB			; $BA
	.WORD RoomData_BC			; $BB
	.WORD RoomData_BD			; $BC
	.WORD RoomData_BE			; $BD
	.WORD RoomData_BF			; $BE
	.WORD RoomData_C0			; $BF
	.WORD RoomData_C1			; $C0
	.WORD RoomData_C2			; $C1
	.WORD RoomData_C3			; $C2
	.WORD RoomData_C4			; $C3
	.WORD RoomData_C5			; $C4
	.WORD RoomData_C6			; $C5
	.WORD RoomData_C7			; $C6
	.WORD RoomData_C8			; $C7
	.WORD RoomData_C9			; $C8
	.WORD RoomData_CA			; $C9
	.WORD RoomData_CB			; $CA
	.WORD RoomData_CC			; $CB
	.WORD RoomData_CD			; $CC
	.WORD RoomData_CE			; $CD
	.WORD RoomData_CF			; $CE
	.WORD RoomData_D0			; $CF
	.WORD RoomData_D1			; $D0
	.WORD RoomData_D2			; $D1
	.WORD RoomData_D3			; $D2
	.WORD RoomData_D4			; $D3
	.WORD RoomData_D5			; $D4
	.WORD RoomData_D6			; $D5
	.WORD RoomData_D7			; $D6
	.WORD RoomData_D8			; $D7
	.WORD RoomData_D9			; $D8
	.WORD RoomData_DA			; $D9
	.WORD RoomData_DB			; $DA
	.WORD RoomData_DC			; $DB
	.WORD RoomData_DD			; $DC
	.WORD RoomData_DE			; $DD
	.WORD RoomData_DF			; $DE
	.WORD RoomData_E0			; $DF
	.WORD RoomData_E1			; $E0
	.WORD RoomData_E2			; $E1
	.WORD RoomData_E3			; $E2
	.WORD RoomData_E4			; $E3
	.WORD RoomData_E5			; $E4
	.WORD RoomData_E6			; $E5
	.WORD RoomData_E7			; $E6
	.WORD RoomData_E8			; $E7
	.WORD RoomData_E9			; $E8
	.WORD RoomData_EA			; $E9
	.WORD RoomData_EB			; $EA
	.WORD RoomData_EC			; $EB
	.WORD RoomData_ED			; $EC
	.WORD RoomData_EE			; $ED
	.WORD RoomData_EF			; $EE
	.WORD RoomData_F0			; $EF
	.WORD RoomData_F1			; $F0
	.WORD RoomData_F2			; $F1
	.WORD RoomData_F3			; $F2
	.WORD RoomData_F4			; $F3
	.WORD RoomData_F5			; $F4
	.WORD RoomData_F6			; $F5
	.WORD RoomData_F7			; $F6
	.WORD RoomData_F8			; $F7
	.WORD RoomData_F9			; $F8
	.WORD RoomData_FA			; $F9
	.WORD RoomData_FB			; $FA
	.WORD RoomData_FC			; $FB
	.WORD RoomData_FD			; $FC
	.WORD RoomData_FE			; $FD
	.WORD RoomData_FF			; $FE

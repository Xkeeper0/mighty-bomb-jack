;
; Things to inject at the end of the ROM (like new code/patches)
;

IFDEF ROUND_SELECT

BypassStart:

	LDA Joypad1_Immediate
	BEQ +rts
	EOR Joypad1_ImmediateCopy
	CMP #JP_Start
	BNE +
	JMP loc_ADC0				; normal game start

+	CMP #JP_Right
	BNE +
	INC RoundSelectRound
	BPL +rts

+	CMP #JP_Left
	BNE +
	DEC RoundSelectRound
	BPL +rts

+	CMP #JP_A
	BEQ +start

+rts

	JSR RoundSelectDisplayHack	; halfway into DrawRoundIntroSprites
	LDA RoundSelectRound
	AND #$0F
	STA RoundSelectRound
	ADC #1						; C is set + 1 = start at 2
	CMP #10						; handle BCD-ificatino
	BCC +
	ADC #5
+	JSR WriteBCDDigitsSprites

	RTS

+start:
	; Init important game variables
	JSR GameState_0_Init

	LDA RoundSelectRound
	AND #$0F
	TAX
	ORA #$90
	STA LastBombRoomCleared
	
	LDA RoundJumpRooms, X
	STA CurrentRoomID
	LDA RoundJumpDoors, X
	STA EntryDoorType

	; LDA #1
	; STA GameState
	; STA InGameFlag
	;INC GameState
	INC InGameFlag

	JMP GameState_1_RoundIntro

RoundJumpRooms:
	;	 2    3    4    5    6    7    8    9    10   11   12   13   14   15   16   Final
	.db  $07, $0C, $10, $28, $33, $3C, $45, $4C, $5B, $99, $6B, $6F, $7E, $83, $87, $8E
RoundJumpDoors:
	; -> EntryDoorType
	.db  $0E, $0F, $0F, $0F, $0B, $0B, $0B, $08, $0F, $0E, $0F, $07, $0A, $0A, $06, $06


ENDIF




IF $ > $FFFA
	ERROR used too much space :(
ENDIF


	;.segment ROM
;     * = $8000

; =============== S U B	R O U T	I N E =======================================

	; public RESET
RESET:
	SEI
	CLD
	LDA #$10
	STA PPUCTRL

loc_8007:
	LDA PPUSTATUS
	BPL loc_8007

loc_800C:
	LDA PPUSTATUS
	BPL loc_800C
	LDA #6
	STA PPUMASK

_CopyProtectionCheck:
	LDA CopyProtectBank		; Copy protection test
	STA CopyProtectBank		; set chr bank $00
IF WEAK_COPYRIGHT_CHECK
	LDA #0				; PPU address $0000
	STA PPUADDR
	STA PPUADDR
	LDA PPUDATA			; bunk read to prime data bus
	LDA PPUDATA			; read value at	ppu address $0000
ELSE
	LDX #0
	STX PPUADDR
	INX
	STX PPUADDR
	LDA PPUDATA			; bunk read to prime data bus
	LDA PPUDATA			; read value at	ppu address $0000
	CMP #$3C
ENDIF
	BEQ _CopyProtectionCheck	; if $00, loop forever (lock up)
	LDA CopyProtectBank+1		; set chr bank $11
	STA CopyProtectBank+1
	LDX #$FF			; Initialize stack offset
	TXS
	LDY #0
	TYA
	DEY
	LDX #7
	STXc byte_1
	STYc byte_0

loc_8041:
	STA (byte_0),Y
	DEY
	BNE loc_8041
	DEX
	STXc byte_1
	BPL loc_8041
	LDA #6
	STA PPUMASK
	JSR ClearNametable
	JSR ClearAllSprites
	LDA #0
	STA DMC_RAW
	LDA #$F
	STA SND_CHN
	JSR RestoreDefaultPalettes
	LDA #0
	STA $1EFE		; POI: ??? $1EFE ($06FE, Object3Struct+4. ?????)
	LDA #$90
	JSR SetPPUCtrl

LoopForever:
	; "CPU meter" (tints screen after NMI finishes)
	; LDA PPUMaskMirror
	; ORA #%00100000	; red emphasis bit
	; STA PPUMASK
	JMP LoopForever
; End of function RESET

; ---------------------------------------------------------------------------
CopyProtectBank:
	.BYTE	0,$11

; ===========================================================================
; Interrupt handler(s) ...
; All game logic is handled during NMI; IRQ isn't used in this game.
IRQ:
NMI:
	STAc NMITemp_A				; save A
	LDAc PPUCtrlMirror			; Disable NMI
	AND #$7F
	JSR SetPPUCtrl
	LDAc PPUMaskMirror
	ORA #$18
	JSR SetPPUMask
	STYc NMITemp_Y				; save Y
	STXc NMITemp_X				; save X
	LDA #0						; _ Sprite DMA setup...
	STA OAMADDR					;  |
	LDA #2						;  |
	STA OAM_DMA					; _|
	LDA #0
	JSR SetPPUScroll
	LDA #1
	STA a:NMIRunFlag			; Unused, see def'n for more
	JSR HandlePPUUpdates
	JSR UpdateJoypads
	JSR MainLogicHandler
	JSR HandleSound
	LDA Joypad1_Immediate
	STA a:Joypad1_ImmediateCopy
	LDXc NMITemp_X				; load X
	LDYc NMITemp_Y				; load Y
	LDA PPUSTATUS
	LDAc PPUCtrlMirror			; Re-enable NMI
	ORA #$80
	JSR SetPPUCtrl
	LDAc NMITemp_A				; load A
	RTI
; End of function NMI

; =============== S U B	R O U T	I N E =======================================

HandlePPUUpdates:
	LDAc PPUUpdateFlag1
IFDEF REV_US
	BEQ loc_80E0
	LDAc UpdatePaletteFlag
	ORA a:PPUUpdateFlag2
	BEQ loc_80E0
	LDA UpdatePaletteFlag
	BEQ loc_80D5
ELSE
	BEQ loc_80D5
	LDA a:UpdatePaletteFlag
	BEQ loc_80D5
ENDIF

	JSR CopyPaletteToPPU

IFDEF REV_US
loc_80D5:
	LDA a:PPUUpdateFlag2
	BEQ locret_US_80EX
	JSR sub_9729
	JMP loc_815B
ELSE
	RTS

loc_80D5:
	LDA a:PPUUpdateFlag2
	BEQ loc_80E0
	JSR sub_9729
	JMP loc_815B
ENDIF
; ---------------------------------------------------------------------------
IFDEF REV_US
locret_US_80EX:
	RTS
ENDIF

loc_80E0:
	LDAc PPUUpdateFlag1
	ASL A
	TAX
	LDA off_81AB,X
	STAc byte_0
	LDA off_81AB+1,X
	STAc byte_1
	LDAc PPUUpdateFlag1
	BEQ loc_8129
	LDA #0
	STA byte_3EE
	LDA #$C0
	STA byte_3F0
	LDA #$40
	STA byte_3F1
	LDY #BasePointer_AttributeTableBuffer
	LDX #0
	LDA byte_3EF
	AND #8
	BEQ loc_8113
	INY
	LDX #8

loc_8113:
	TXA
	ORA #$23
	STA byte_3EF
	TYA
	JSR LoadPointerTo050		; attribute table buffer or ram5A3
	LDAc word_50
	STAc byte_0
	LDAc word_50+1
	STAc byte_1

loc_8129:
	LDY #0
	LDAc PPUCtrlMirror
	AND #$FB
	ORA byte_3EE
	JSR SetPPUCtrl
	LDA PPUSTATUS
	LDA byte_3EF
	STA PPUADDR
	LDA byte_3F0
	STA PPUADDR
	LDA byte_3F1
	BEQ loc_8156
	TAX
	LDY #0

loc_814D:
	LDA (byte_0),Y
	STA PPUDATA
	INY
	DEX
	BNE loc_814D

loc_8156:
	LDA #0
	STA byte_3F1

loc_815B:
	LDAc PPUCtrlMirror
	AND #$FA
	JSR SetPPUCtrl
	LDA PPUSTATUS
	LDA byte_3C2
	STA PPUSCROLL
	LDA byte_3C4
	STA PPUSCROLL
	RTS
; End of function HandlePPUUpdates

; =============== S U B	R O U T	I N E =======================================

CopyPaletteToPPU:
	LDX #0
	STX a:UpdatePaletteFlag
	LDY #$10
	JSR CopyPaletteToPPU2
	LDY #$10
	JSR CopyPaletteToPPU2
	JMP loc_815B
; End of function CopyPaletteToPPU

; =============== S U B	R O U T	I N E =======================================

; Copies $10 bytes of palette data to the PPU.
;
; POI: There is	one weird thing	about this --
; it's set up as if it can do EITHER BG OR SP palettes,
; but only ever	does both.

CopyPaletteToPPU2:
	LDA PPUSTATUS
	LDA #$3F
	STA PPUADDR			; 3F
	STX PPUADDR			; 00 / 10

loc_8190:
	LDA PaletteBuffer,X
	STA PPUDATA
	INX
	DEY
	BNE loc_8190
IFDEF REV_US
	LDA PPUSTATUS
ENDIF
	LDA #$3F
	STA PPUADDR
	LDA #0
	STA PPUADDR
	STA PPUADDR
	STA PPUADDR
	RTS
; End of function CopyPaletteToPPU2

; ---------------------------------------------------------------------------
off_81AB:
	.WORD PPUUpdateBuffer
	.WORD AttributeTableBuffer		; 1

; =============== S U B	R O U T	I N E =======================================

MainLogicHandler:
	LDAc InGameFlag
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD TitleScreenHandler
	.WORD GameHandler
; End of function MainLogicHandler

; =============== S U B	R O U T	I N E =======================================

GameHandler:
	LDAc GameState			; - Main jump table -
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD GameState_0_Init		; 0: game init
	.WORD GameState_1_RoundIntro	; 1 ; 1: stage intro screen
	.WORD GameState_2_LoadRoom		; 2 ; 2:
	.WORD GameState_3_DrawScreen	; 3 ; 3: draws to ppu
	.WORD GameState_4_EnterRoom		; 4 ; 4: entering screen animation, noises
	.WORD GameState_5_Main		; 5 ; 5: main game?
	.WORD GameState_6_TimeOver		; 6 ; 6: time over
	.WORD GameState_7_GoToTortureRoom	; 7 ; 7: go to torture room
	.WORD GameState_8_RoundClear	; 8 ; 8:
	.WORD GameState_9_ExitRoom		; 9 ; 9:
	.WORD GameState_A_GameOver		; $A ; A: game over
	.WORD GameState_B_AnimateDoorOpen	; $B ; B: open door anim, returns to 5
	.WORD GameState_C_Ending		; $C ; C: ending
; End of function GameHandler

; =============== S U B	R O U T	I N E =======================================

; init

GameState_0_Init:
	LDA #0
	STA MaybeTempCollectableFlag
	STA MaybeTempCollectableFlag2
	STA CheckpointRoomIDMaybe
	STA GoldCoinsCollected
	STA byte_364
	STA PlayerSecretCoins
	STA MaybeTempCollectableFlag2
	STA PlayerCrystalBallsCollected
	STA MaybeTempCollectableFlag
	STA byte_33C
	STA TortureRoomSceneFlag
	STA LastBombRoomCleared		; used in gdv and difficulty sel
	STA DoorCheckFlag_1F
	STA DoorCheckFlag_09
	STA ExtraLivesFound
	STA PlayerMightyCoins
	JSR QueueSound			; = 0
	JSR ClearNametable
	LDX #1
	STX CurrentRoomID		; init to room 1-1
	LDA #0
	TAX

loc_8219:
	STA a:PlayerScore,X
	INX
	CPX #4
	BNE loc_8219
	LDA #$F
	STA EntryDoorType
	LDA #3
	STA PlayerLives
	LDA #$47
	STA PlayerGDV
	INC a:GameState			; 0 -> 1
	RTS
; End of function GameState_0_Init

; =============== S U B	R O U T	I N E =======================================

InitPlayerStruct:
	LDA #0
	TAX

loc_8237:
	STA PlayerStruct,X
	INX
	CPX #$1F
	BNE loc_8237
	RTS
; End of function InitPlayerStruct

; =============== S U B	R O U T	I N E =======================================

GameState_3_DrawScreen:
	JSR ClearAllSprites
	LDA #0
	STA InitFlag_LoadedDifficulty
	STA a:RoomStatusFlags
	STA a:byte_F7
	STA a:EnemyCoinTimer
	STA a:EnemyCoinTimer+1
	STA DoorCheckFlag_19_1A
	STA MaybeHandleDoorFlag
	LDA CurrentRoomID		; bomb room check
	CMP #$90
	BCC loc_8281			; if (room >= #$90 && room < #$A0)...
	CMP #$A0
	BCS loc_8281			;   jump ahead
	LDX #RF_BombRoom
	STX a:RoomStatusFlags
	LDX #0
	STX PlayerMightyLevelPressesLeft
	STX PlayerMightyLevel
	LDX #$16
	STX PaletteBuffer+$17
	PHA
	LDA byte_364
	AND #$FD
	STA byte_364
	PLA

loc_8281:
	JSR MaybeLoadRoomFlags		; called with room id
	LDA #0
	TAX

loc_8287:
	STA Object0Struct,X
	INX
	BNE loc_8287
	LDA CurrentRoomID
	JSR LoadRoomStuff
	JSR DrawFullScreen
	LDA #1
	STA a:DrawScoreAndCoinsFlag	; ?? is	this ever zero?
	LDA #0
	STA byte_340
	LDX MaybeTempCollectableFlag
	STA MaybeTempCollectableFlag
	BEQ loc_82AB
	STA MaybeTempCollectableFlag2

loc_82AB:
	LDX #$18
	JSR RestoreDefaultPalettesLimited ; #$18
	LDA SomeLoadFlag
	LSR A
	BCC loc_82BE
	LDA #0
	STA SomeLoadFlag
	JSR SpawnBrotherRoomObjects

loc_82BE:
	INCc GameState			; 3 -> 4
	RTS
; End of function GameState_3_DrawScreen

; =============== S U B	R O U T	I N E =======================================

GameState_4_EnterRoom:
	LDA #1
	BIT byte_340
	BNE loc_8300
	STA byte_340
	LDA EntryDoorType
	ASL A
	TAX
	LDA DoorEntryXYPositionTable,X
	STA PlayerYPosHi
	LDA byte_3C2
	EOR #$FF
	TAY
	INY
	STY PlayerXPosHi
	LDA DoorEntryXYPositionTable+1,X
	CLC
	ADC PlayerXPosHi
	STA PlayerXPosHi
	LDA EntryDoorType
	AND #$C
	LSR A
	TAX
	JSR SetPlayerVelocityFromX
	STA PlayerSprite
	LDA #$21
	STA byte_3DD
	JSR DrawPlayer

loc_8300:
	LDA #2
	BIT byte_340
	BNE loc_8332
	LDA a:RoomPalette
	BEQ loc_8316
	AND #$F
	JSR LoadRoomPalette
	LDA #0
	STA a:RoomPalette

loc_8316:
	LDA byte_33C
	AND #$40
	BNE loc_8320
	JSR AnimateDoorOpen

loc_8320:
	LDA byte_340
	ORA #2
	STA byte_340
	LDA #$18
	STA byte_341
	LDA #0
	STA byte_3DD

loc_8332:
	LDA byte_341
	BEQ loc_8341
	DEC byte_341
	JSR ApplyPlayerXAndYVelocity
	JSR DrawPlayer
	RTS
; ---------------------------------------------------------------------------

loc_8341:
	LDA #4
	BIT byte_340
	BNE loc_83B8
	LDA byte_33C
	AND #$40
	BNE loc_8352
	JSR AnimateDoorClose

loc_8352:
	LDA a:RoomStatusFlags
	AND #RF_SingleScreen
	BEQ loc_835C

loc_8359:
	JMP loc_83E6
; ---------------------------------------------------------------------------

loc_835C:
	LDX EntryDoorType
	LDY #$48
	LDA a:RoomStatusFlags
	AND #RF_ScrollStop
	BEQ loc_8384
	CPX #8
	BCS loc_8359
	LDA a:RoomStatusFlags
	AND #RF_Horizontal|RF_SectionStart
	BEQ loc_837D
	PHP
	TXA
	PLP
	BPL loc_837A
	EOR #1

loc_837A:
	LSR A
	BCS loc_83E6

loc_837D:
	TXA
	AND #1
	LDY #$60
	BNE loc_839E

loc_8384:
	CPX #8
	BCC loc_83E6
	LDA a:RoomStatusFlags
	AND #RF_Horizontal|RF_SectionStart
	BEQ loc_8399
	PHP
	TXA
	PLP
	BPL loc_8396
	EOR #1

loc_8396:
	LSR A
	BCS loc_83E6

loc_8399:
	TXA
	AND #1
	ORA #2

loc_839E:
	STY byte_343
	TAX
	LDA DirectionOffsetTable,X	; (U, D, L, R)
	STA DirectionOffsetTemp
	LDA byte_340
	ORA #4
	STA byte_340
	LDA a:RoomStatusFlags
	AND #11110111b
	STA a:RoomStatusFlags		; clear	bit 3 (#$08)

loc_83B8:
	LDA byte_343
	BEQ loc_83E6
	DEC byte_343
	LDX DirectionOffsetTemp
	JSR SetPlayerVelocityFromX
	JSR ApplyPlayerXAndYVelocity
	JSR DrawPlayer
	LDA PlayerXVelHi
	EOR #$FF
	CLC
	ADC #1
	STA PlayerXVelHi
	LDA PlayerYVelHi
	EOR #$FF
	CLC
	ADC #1
	STA PlayerYVelHi
	JSR MainSub_3
	RTS
; ---------------------------------------------------------------------------

loc_83E6:
	LDX #0
	STX byte_340
	STX CollisionFlag		; = 0
	INX
	STX PlayerStruct
	INCc GameState			; 4 -> 5
	LDA a:MaybePauseFlag
	ORA #$40
	STA a:MaybePauseFlag
	LDX a:RoomMusic
	LDA MusicOptionsTable,X
	JSR QueueSound			; room backround music
	RTS
; End of function GameState_4_EnterRoom

; =============== S U B	R O U T	I N E =======================================

SetPlayerVelocityFromX:
	LDA VectorTable,X		; RLUD (+1, 0 /	-1, 0 / 0,-1 / 0,+1)
	STA PlayerYVelHi
	LDA VectorTable+1,X		; RLUD (+1, 0 /	-1, 0 / 0,-1 / 0,+1)
	STA PlayerXVelHi
	LDA #0
	STA PlayerYVelLo
	STA PlayerXVelLo
	RTS
; End of function SetPlayerVelocityFromX

; ---------------------------------------------------------------------------
DirectionOffsetTable:
	.BYTE    6
	.BYTE    4				; 1 ; (U, D, L,	R)
	.BYTE    0				; 2
	.BYTE    2				; 3

; =============== S U B	R O U T	I N E =======================================

GameState_5_Main:
	JSR MaybePause
	LDA a:MaybePauseFlag
	AND #$20
	BNE locret_8449
	JSR MainSub_1
	LDA TortureRoomSceneFlag
	BEQ loc_843D
	JSR GameState_7_GoToTortureRoom
	LDA a:TimerStatusMaybe
	ORA #$40
	STA a:TimerStatusMaybe

loc_843D:
	JSR HandleStageTimer
	JSR MainSub_3
	JSR HandleSpawnsAndMore
	JSR DrawScoreAndCoinCount

locret_8449:
	RTS
; End of function GameState_5_Main

; =============== S U B	R O U T	I N E =======================================

GameState_6_TimeOver:
	LDA a:TimerStatusMaybe
	BMI loc_8466
	ORA #$80
	STA a:TimerStatusMaybe
	LDA #$80
	STA a:TimeOverTimer
	JSR ClearNametable
	LDA #Strings_TimeOver
	JSR WriteStringToPPU		; time over
	LDA #Sound_Death
	JSR QueueSound			; death

loc_8466:
	DEC a:TimeOverTimer
	BNE locret_8473
	JSR LoseALifeMaybeGameOver	; 6 -> A or 1
	LDX #$10
	JSR RestoreDefaultPalettesLimited ; #$10

locret_8473:
	RTS
; End of function GameState_6_TimeOver

; =============== S U B	R O U T	I N E =======================================

GameState_7_GoToTortureRoom:
	LDX TortureRoomSceneFlag
	BNE loc_849C
	INX
	STX TortureRoomSceneFlag
	JSR ClearAllSprites
	JSR ClearNametable
	LDA #Strings_YouAreGreedy
	JSR WriteStringToPPU		; greedy
	LDA #Strings_GoToTheTortureRoom
	JSR WriteStringToPPU		; torture
	LDA #$C0
	STA TortureRoomMessageTimer
	LDA #Sound_Silence		; (nothing, silences music)
	JSR QueueSound			; Silence
	LDA #Sound_YouAreGreedy
	JSR QueueSound			; Greedy

loc_849C:
	LDA TortureRoomMessageTimer
	BEQ loc_84A5
	DEC TortureRoomMessageTimer
	RTS
; ---------------------------------------------------------------------------

loc_84A5:
	LDA #2
	BIT TortureRoomSceneFlag
	BNE loc_84C2
	ORA TortureRoomSceneFlag
	STA TortureRoomSceneFlag
	LDA #$AC
	STA CurrentRoomID		; -> torture room
	LDA #2
	STAc GameState			; 7 / ?	-> 2
IFDEF REV_US
	LDA #$50
ELSE
	LDA #$49
ENDIF
	STA GreedyJumpsRemaining
	RTS
; ---------------------------------------------------------------------------

loc_84C2:
	LDAc JustJumpedFlag
	BEQ loc_84F2
	LDA GreedyJumpsRemaining	; POI: They have BCDSub1FromA,
	SEC					; so I'm not sure why they
	SBC #1				; needed to reimplement	it here.
	PHA					; (But this subtracts 1
	AND #$F				; from the count in BCD.)
	CMP #$A
	BCC loc_84D8
	PLA
	SBC #6
	PHA

loc_84D8:
	PLA
	STA GreedyJumpsRemaining
	BNE loc_84F2
	STA TortureRoomSceneFlag
	LDA byte_33E
	STA CheckpointRoomIDMaybe
	LDA EntryDoorTypeBackup2
	STA EntryDoorTypeBackup
	JSR MaybeGoBackToOldRoom
	PLA
	PLA

loc_84F2:
	JSR DrawTimerOrTortureJumps	; maybe	draw torture jump count
	RTS
; End of function GameState_7_GoToTortureRoom

; =============== S U B	R O U T	I N E =======================================

GameState_8_RoundClear:
	LDA #1
	BIT a:GS8_Status			; not entirely understood but w/e
	BNE loc_8505
	STA a:GS8_Status			; not entirely understood but w/e
	LDA #0
	STA a:RoundClearState		; controls jumptable

loc_8505:
	LDA a:RoundClearState		; controls jumptable
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD RoundClear_0
	.WORD RoundClear_1
	.WORD RoundClear_2
	.WORD RoundClear_3
; ---------------------------------------------------------------------------

RoundClear_0:
	LDA a:RoomStatusFlags
	AND #$FD
	STA a:RoomStatusFlags		; clear	#RF_BombRoom
	LDA a:StageTimer
	ORA #$40
	STA a:TimerStatusMaybe
	LDA #$40
	STA RoundClearCountdownTimer
	JSR ClearAllSprites
	JSR DrawRoundIntroSprites
	LDA a:TimerStatusMaybe
	ORA #$80
	STA a:TimerStatusMaybe
	JSR DrawScore				; draw score sprites?
	JSR ClearNametable
	LDA #Strings_Round_Clear
	JSR WriteStringToPPU		; round	X clear
	LDA #Strings_TimeBonus
	JSR WriteStringToPPU		; time bonus
	LDA a:StageTimer
	STA a:StageTimerCopy
	JSR CopyNext5BytesToTempSprite
	SpriteData 0, $10,	$B0, $78, 0 ;
	LDX #2						; round	"X" sprite drawing
	JSR InitXSprites			; sets up (X) sprites with #00 idx/attrib
	LDA #$84
	STAc TempSpriteX
	LDA #$44
	STAc TempSpriteY
	LDA LastBombRoomCleared		; Get the last bomb room clear
	AND #$F						; 9x ->	0x
	CLC
	ADC #1						; Add 1
	CMP #$A						; If >=	#$A,
	BCC loc_8571				; add 5	for BCD-ness
	ADC #5

loc_8571:
	JSR WriteBCDDigitsSprites	; write	round "x" clear	sprite(s)
	JSR DrawTimeBonus
	LDA a:FireBombsCollected
	SEC
	SBC #20				; at least 20 bombs for	bonus
	BCC loc_85C2
	TAX
	LDA FireBombBonus,X		; $10, $20, $30, $50 (thousand)
	STA FireBombBonusPoints
	LDA #Strings_YouveGotten
	JSR WriteStringToPPU		; you've gotten
	LDA #Strings_FireBombs
	JSR WriteStringToPPU		; fire bombs
	LDA #Strings_SpecialBonus
	JSR WriteStringToPPU		; special bonus
	LDA #$B8
	STAc TempSpriteX
	LDA #$C0
	STAc TempSpriteY
	LDX #3
	JSR InitXSprites		; sets up (X) sprites with #00 idx/attrib
	LDA #$54
	STAc TempSpriteX
	LDA #$AC
	STAc TempSpriteY
	LDAc FireBombsCollected
	CLC
	ADC #$C
	JSR WriteBCDDigitsSprites
	JSR DrawFireBombBonus
	LDA a:GS8_Status			; not entirely understood but w/e
	ORA #2
	STA a:GS8_Status			; not entirely understood but w/e

loc_85C2:
	LDA #Music_RoundClear
	JSR QueueSound			; Round	clear
	INC a:RoundClearState		; controls jumptable
	RTS
; ---------------------------------------------------------------------------

RoundClear_1:
	LDA #4
	BIT a:GS8_Status			; not entirely understood but w/e
	BNE loc_85E1
	DEC RoundClearCountdownTimer
	BEQ loc_85D8
	RTS
; ---------------------------------------------------------------------------

loc_85D8:
	ORA a:GS8_Status			; not entirely understood but w/e
	STA a:GS8_Status			; not entirely understood but w/e
	INC RoundClearCountdownTimer

loc_85E1:
	DEC RoundClearCountdownTimer
	BEQ loc_85E7
	RTS
; ---------------------------------------------------------------------------

loc_85E7:
	LDA #6
	STA RoundClearCountdownTimer
	LDA a:StageTimerCopy
	BEQ loc_8603
	JSR BCDSub1FromA
	STA a:StageTimerCopy
	LDA #Score_100
	JSR AddScore
	JSR DrawScore			; draw score sprites?
	JSR DrawTimeBonus
	RTS
; ---------------------------------------------------------------------------

loc_8603:
	LDA #$40
	STA RoundClearCountdownTimer
	INC a:RoundClearState		; controls jumptable
	LDA #2
	BIT a:GS8_Status			; not entirely understood but w/e
	BNE locret_8615
	INC a:RoundClearState		; controls jumptable

locret_8615:
	RTS
; ---------------------------------------------------------------------------

RoundClear_2:
	LDA #8
	BIT a:GS8_Status			; not entirely understood but w/e
	BNE loc_862E
	DEC RoundClearCountdownTimer
	BEQ loc_8623
	RTS
; ---------------------------------------------------------------------------

loc_8623:
	ORA a:GS8_Status			; not entirely understood but w/e
	STA a:GS8_Status			; not entirely understood but w/e
	LDA #1
	INC RoundClearCountdownTimer

loc_862E:
	DEC RoundClearCountdownTimer
	BEQ loc_8634
	RTS
; ---------------------------------------------------------------------------

loc_8634:
	LDA #6
	STA RoundClearCountdownTimer
	LDA FireBombBonusPoints
	BEQ loc_8650
	JSR BCDSub1FromA
	STA FireBombBonusPoints
	LDA #Score_1000
	JSR AddScore
	JSR DrawScore			; draw score sprites?
	JSR DrawFireBombBonus
	RTS
; ---------------------------------------------------------------------------

loc_8650:
	LDA #$40
	STA RoundClearCountdownTimer
	INC a:RoundClearState		; controls jumptable
	RTS
; ---------------------------------------------------------------------------

RoundClear_3:
	; Are we done counting down?
	LDA RoundClearCountdownTimer
	BEQ +

	; If not, keep doing it and return
	DEC RoundClearCountdownTimer
	RTS

+	LDA #2
	STAc GameState					; -> 2
	DECc FireBombsCollected
	BNE +
	LDX LastBombRoomCleared			; used in gdv and difficulty sel
	CPX #$9F
	BEQ +
	INX
	STX CurrentRoomID				; end-of-round bomb rooms checks?
	TXA
	AND #$F
	ASL A
	TAX
	LDA MaybeEntryTypeTable,X
	STA EntryDoorType
RoundSelectInject:
	LDA #0
	STA a:TimerStatusMaybe

+	JSR ClearAllSprites
	LDA a:TimerStatusMaybe
	AND #~$40
	STA a:TimerStatusMaybe			; unset	$40
	LDA #0
	STA a:Collected1UPThisRoundFlag	; reset
	STA ScoreMultiplier				; reset
	STA DoorCheckFlag_1E_DeathCount	; reset
	STA DoorCheckFlag_1E_Unk		; reset
IFDEF REV_US
	JSR QueueSound					; sound 0
ENDIF
	RTS
; End of function GameState_8_RoundClear

; =============== S U B	R O U T	I N E =======================================

DrawTimeBonus:
	LDA #5
	STAc CurrentSpriteIndex
	LDA #$7C
	STAc TempSpriteY
	LDA #$AC
	STAc TempSpriteX
	LDAc StageTimerCopy
	JSR WriteBCDDigitsSprites
	RTS
; End of function DrawTimeBonus

; =============== S U B	R O U T	I N E =======================================

DrawFireBombBonus:
	LDA #$C
	STAc CurrentSpriteIndex
	LDA #$C4
	STAc TempSpriteY
	LDA #$B4
	STAc TempSpriteX
	LDA FireBombBonusPoints
	JSR WriteBCDDigitsSprites
	RTS
; End of function DrawFireBombBonus

; =============== S U B	R O U T	I N E =======================================

; A = game over

GameState_A_GameOver:
	LDA GameOverInitFlag
	BNE _GameOverAfterInit
	INC GameOverInitFlag
	JSR ClearAllSprites
	JSR ClearNametable
	LDA #Strings_GameOver
	JSR WriteStringToPPU		; game over
	LDA #Music_GameOver
	JSR QueueSound			; Game over
	LDA #Strings_YourGDV
	JSR WriteStringToPPU		; your gdv
	LDA LastBombRoomCleared		; get the last bomb room cleared
	AND #$F				; and divide by	two
	LSR A				; (max 7; 1 point every	2 after	first round)
	JSR AddAToGDV			; rounds clear bonus (0-7)
	LDA ExtraLivesFound		; 1 point every	2 lives
	LSR A
	JSR AddAToGDV			; extra	lives found bonus (0-?+)
	LDA a:PlayerScore+2		;   xx0000
	LDX a:PlayerScore+3		; xx000000
	BEQ loc_8704			; if you have >= 1,000,000 pts
	LDA #$A0

loc_8704:
	LSR A				; divide score by 200000
	LSR A				;   0-199k: 0
	LSR A				; 200-399k: 1
	LSR A				; 400-599k: 2
	LSR A				; 600-799k: 3
					; 800-999k: 4
					;  1000k+ : 5
	JSR AddAToGDV			; score	bonus (0-5)
	JSR CopyNext5BytesToTempSprite
	SpriteData 0, $10,	$A4, $84, 0 ;
	LDA PlayerGDV
	CMP HighGDV
	BCC loc_871F
	STA HighGDV

loc_871F:
	JSR WriteBCDDigitsSprites	; GDV

_GameOverAfterInit:
	DEC GameOverTimer
	BNE locret_8732
	LDA #0
	STA GameOverInitFlag
	STAc InGameFlag
	JSR RestoreDefaultPalettes

locret_8732:
	RTS
; End of function GameState_A_GameOver

; =============== S U B	R O U T	I N E =======================================

AddAToGDV:
	JSR BCDCheckFirstDigit
	CLC
	ADC PlayerGDV
	JSR BCDCheckFirstDigit
	STA PlayerGDV
	RTS
; End of function AddAToGDV

; =============== S U B	R O U T	I N E =======================================

BCDCheckFirstDigit:
	PHA					; push A
	AND #$F				;   check first	digit
	CMP #$A				;   check if >=	10
	BCC loc_874C			;   if no, jump	ahead
	PLA					; pull a
	ADC #5				; add 5	for bcd
	PHA					; push a

loc_874C:
	PLA					; pull a
	RTS
; End of function BCDCheckFirstDigit

; =============== S U B	R O U T	I N E =======================================

GameState_B_AnimateDoorOpen:
	JSR AnimateDoorOpen
	LDA #5
	STAc GameState			; B -> 5
	RTS
; End of function GameState_B_AnimateDoorOpen

; =============== S U B	R O U T	I N E =======================================

; Removes a life and resets some player	state stuff.
; If you have no more lives, transitions to Game Over.
; If you have lives left, transitions to Stage Restart

LoseALifeMaybeGameOver:
	LDA #$A				; Game over state
	DEC PlayerLives			; Remove a life
	BEQ _NoLivesLeft		; Are you outta	lives? jump ahead
	JSR MaybeGoBackToOldRoom	; Otherwise do stuff
	LDA #0
	STA PlayerMightyLevel		; like remove your Mighty values
	STA PlayerMightyLevelPressesLeft
	STA TortureRoomSceneFlag
	LDA #1				; Not the game over state

_NoLivesLeft:
	STAc GameState			; (6 or	?) -> A	or 1
	LDA #0
	STA a:TimerStatusMaybe
	RTS
; End of function LoseALifeMaybeGameOver

; =============== S U B	R O U T	I N E =======================================

MaybeGoBackToOldRoom:
	LDA CheckpointRoomIDMaybe
	STA CurrentRoomID
	LDA EntryDoorTypeBackup
	STA EntryDoorType
	LDA #2
	STAc GameState			; -> 2
	RTS
; End of function MaybeGoBackToOldRoom

; =============== S U B	R O U T	I N E =======================================

MaybePause:
	LDA Joypad1_Immediate
	AND #JP_Start
	BEQ _NoPause
	AND a:Joypad1_ImmediateCopy
	BNE _NoPause
	LDA a:MaybePauseFlag		; toggles bit #$20 here
	EOR #$20
	STA a:MaybePauseFlag
	LDX #Sound_Unpause		; unsilences music
	AND #$20
	BEQ _Unpaused
	DEX					; #Sound_Pause

_Unpaused:
	TXA
	JSR QueueSound			; pause

_NoPause:
	RTS
; End of function MaybePause

; =============== S U B	R O U T	I N E =======================================

HandleStageTimer:
	LDA a:TimerStatusMaybe		; 00 at	the start of a stage?
					; 01 after this, probably
	ASL A
	BPL loc_87B0
	RTS
; ---------------------------------------------------------------------------

loc_87B0:
	LDA #1
	BIT a:TimerStatusMaybe		; Check	if timer has been init
	BNE loc_87C4			; If (1	& (A8)), skip ahead
	STA a:TimerStatusMaybe		; Otherwise, set it to 1
	TAX					; X = 1
	DEX					; X = 0
	LDA #$60
	STA a:StageTimer			; Init to #$60
	STX a:TimerFrames			; = #$00

loc_87C4:
	DEC a:TimerFrames			; Every	256 frames, dec	one second
	BNE loc_87D3			; If non-0, skip ahead
	LDA a:StageTimer
	JSR BCDSub1FromA
	STA a:StageTimer
	RTS
; ---------------------------------------------------------------------------

loc_87D3:
	LDA a:StageTimer
	BNE loc_87E8
	STA a:TimerStatusMaybe
	LDA #6				; Time over
	STAc GameState			; -> 6
	LDA a:TimerStatusMaybe
	ORA #$40
	STA a:TimerStatusMaybe		; OR with #$40 - freezes timer

loc_87E8:
	JSR DrawTimerOrTortureJumps	; maybe	draw torture jump count
	RTS
; End of function HandleStageTimer

; =============== S U B	R O U T	I N E =======================================

; sets up (X) sprites with #00 idx/attrib

InitXSprites:
	LDAc CurrentSpriteIndex
	ASL A
	ASL A
	TAY

loc_87F2:
	LDAc TempSpriteY
	STA SpriteDMAArea,Y		; Y pos
	INY
	LDA #0
	STA SpriteDMAArea,Y		; Index
	INY
	LDA #0
	STA SpriteDMAArea,Y		; Attributes
	INY
	LDAc TempSpriteX
	STA SpriteDMAArea,Y		; X pos
	INY
	CLC
	ADC #8
	STAc TempSpriteX			; shift	right 8	pixels
	INCc CurrentSpriteIndex
	DEX
	BNE loc_87F2
	RTS
; End of function InitXSprites

; =============== S U B	R O U T	I N E =======================================

; Reads	both joypads into $308/$309
; combines both	into $308

UpdateJoypads:
	LDX #1
	STX JOY1
	DEX
	STX JOY1
	JSR ReadJoypad
	INX
	JSR ReadJoypad
	LDA Joypad1_Immediate
	ORA Joypad2_Immediate
	STA Joypad1_Immediate
	RTS
; End of function UpdateJoypads

; =============== S U B	R O U T	I N E =======================================

ReadJoypad:
	LDY #8

loc_8835:
	LDA JOY1,X
	STA byte_0
	LSR A
	ORA byte_0
	LSR A
	ROL Joypad1_Immediate,X
	DEY
	BNE loc_8835
	RTS
; End of function ReadJoypad

; =============== S U B	R O U T	I N E =======================================

MainSub_1:
	LDA #0
	STA PlayerYVelLo
	STA PlayerYVelHi
	LDA #$80
	BIT PlayerStruct
	BEQ _EnemyCoinTimerCheck
	LSR A
	BIT PlayerStruct
	BNE loc_8874
	ORA PlayerStruct
	STA PlayerStruct
	LDA #6
	STA MaybeDeathTimer
	LDA #$28
	STA PlayerSprite
	LDA #Sound_Silence		; (nothing, silences music)
	JSR QueueSound			; silence
	LDA #Sound_Death
	JSR QueueSound			; death

loc_8874:
	LDA #$20
	BIT PlayerStruct
	BEQ loc_8890
	LDA #$2A
	STA PlayerSprite
	DEC MaybeDeathTimer
	BNE loc_88A4
	JSR LoseALifeMaybeGameOver
	LDX #$10
	JSR RestoreDefaultPalettesLimited ; restore default sprite pal
	PLA
	PLA
	RTS
; ---------------------------------------------------------------------------

loc_8890:
	LDA #4
	BIT CollisionFlag		; checks against #$04
	BEQ loc_88A7
	LDA #$20
	ORA PlayerStruct
	STA PlayerStruct
	LDA #$40
	STA MaybeDeathTimer

loc_88A4:
	JMP loc_89EF
; ---------------------------------------------------------------------------

loc_88A7:
	DEC MaybeDeathTimer
	BNE loc_88B9
	LDA PlayerSprite
	EOR #1
	STA PlayerSprite
	LDA #6
	STA MaybeDeathTimer

loc_88B9:
	JMP loc_8970
; ---------------------------------------------------------------------------

_EnemyCoinTimerCheck:
	LDA a:EnemyCoinTimer
	ORA a:EnemyCoinTimer+1
	BEQ _MightyLevelAPressCheck
	DEC a:EnemyCoinTimer
	BEQ loc_88D5
	LDA a:EnemyCoinTimer
	CMP #$FF
	BNE _MightyLevelAPressCheck
	DEC a:EnemyCoinTimer+1
	BPL _MightyLevelAPressCheck

loc_88D5:
	LDA a:EnemyCoinTimer+1
	BNE _MightyLevelAPressCheck
	STA MaybeTempCollectableFlag
	STA MaybeTempCollectableFlag2
	LDX #$18
	JSR RestoreDefaultPalettesLimited ; last 2 sprite pals
	LDX a:RoomMusic
	BNE loc_88EB
	INX

loc_88EB:
	LDA MusicOptionsTable,X
	JSR QueueSound			; room music
	LDA #$20
	STA a:UnknownFlag_0FE		; = #$20

_MightyLevelAPressCheck:
	LDX #JP_A			; Check	for A presses
	LDA #RF_BombRoom
	BIT a:RoomStatusFlags		; #$2 =	royal (bomb) room?
	BEQ loc_8901			; If so, skip ahead
	LDX #JP_B|JP_A			; Otherwise, check B too

loc_8901:
	TXA
	AND Joypad1_Immediate
	BEQ loc_895A
	AND a:Joypad1_ImmediateCopy
	BNE loc_895A
	INC a:APressCounter
	LDX PlayerMightyLevel
	BEQ _NoMightyLevelDown
	DEC PlayerMightyLevelPressesLeft
	DEX
	LDA PlayerMightyLevelPressesLeft
	CMP MightyLevelAPressesTable,X	; (1), 20, 30, 35
	BCS _NoMightyLevelDown
	DEC PlayerMightyLevel
	JSR UpdateMightyPalette		; X = mighty level

_NoMightyLevelDown:
	LDA #2
	BIT PlayerStruct		; #$02 = on ground/can jump?
	SEC
	BNE _DontAddPoints
	ORA PlayerStruct
	STA PlayerStruct
	LDA #Sound_Jump
	STAc JustJumpedFlag
	JSR QueueSound			; jump
	CLC
	LDA TortureRoomSceneFlag	; Are you in the torture room?
	BNE _DontAddPoints		; If yes, no 10	points for you
	LDA #Score_10
	JSR AddScore			; 10 big points
	CLC

_DontAddPoints:
	LDA #0
	STA byte_3E6			; ??
	ROR A
	ROR A
	STA byte_3E7
	LDA #8
	ORA PlayerStruct
	STA PlayerStruct

loc_895A:
	LDA #JP_B
	AND Joypad1_Immediate
	BEQ loc_8970
	AND a:Joypad1_ImmediateCopy
	BNE loc_8970
	LDA #RF_BombRoom
	BIT a:RoomStatusFlags		; #$02 = royal (bomb) room
	BNE loc_8970
	JSR UseMightyCoin

loc_8970:
	LDA #2
	BIT PlayerStruct
	BNE loc_897A
	JMP loc_89EF
; ---------------------------------------------------------------------------

loc_897A:
	LDA #0
	JSR LoadObjectPointerA
	LDX Joypad1_Immediate
	LDA PlayerStruct
	BPL loc_8989
	LDX #0

loc_8989:
	JSR DoSomethingWithObjYVel
	LDA PlayerStruct
	BMI loc_899D
	LDY #1
	LDA byte_3E7
	ASL A
	BPL loc_899A
	INY

loc_899A:
	STY PlayerSprite

loc_899D:
	LDA #RF_SingleScreen|RF_ScrollStop
	BIT a:RoomStatusFlags
	BNE loc_89AB
	LDA #RF_AtScrollEdge
	BIT a:RoomStatusFlags
	BEQ loc_89D6

loc_89AB:
	JSR ApplyPlayerYVelocity
	LDA #RF_SingleScreen
	BIT a:RoomStatusFlags
	BNE loc_89D6
	LDA PlayerYPosHi
	CMP #$79
	PHP
	LDX PlayerYVelHi
	BPL loc_89C4
	PLA
	EOR #1
	PHA

loc_89C4:
	PLP
	BCC loc_89D6
	LDA #RF_ScrollStop
	BIT a:RoomStatusFlags
	BNE loc_89D6
	LDA a:RoomStatusFlags
	AND #$F7
	STA a:RoomStatusFlags		; clear	#RF_AtScrollEdge

loc_89D6:
	LDA PlayerYPosHi
	CMP #$E0
	BCC loc_89EC
	LDA PlayerStruct
	AND #$F9
	STA PlayerStruct
	LDA #0
	STA PlayerSprite
	LDA #$E0

loc_89EC:
	STA PlayerYPosHi

loc_89EF:
	LDA #0
	STA PlayerXVelLo
	STA PlayerXVelHi
	LDA PlayerStruct
	BMI loc_8A03
	LDA Joypad1_Immediate
	AND #JP_Right|JP_Left
	BNE loc_8A06

loc_8A03:
	JMP DrawPlayer
; ---------------------------------------------------------------------------

loc_8A06:
	LDX #1
	LDY #1
	LSR A
	BCS loc_8A10
	LDX #$FE
	INY

loc_8A10:
	TYA
	BIT CollisionFlag		; against either #$01 /	#$02 ?
	BNE loc_8A66
	STX PlayerXVelHi
	LDA #$80
	STA PlayerXVelLo
	TXA
	AND #$80
	EOR #$80
	ASL A
	ROL A
	ROL A
	ROL A
	STA byte_3DD
	LDA #RF_ScrollStop
	BIT a:RoomStatusFlags
	BEQ loc_8A3E
	LSR A
	BIT a:RoomStatusFlags		; #RF_SingleScreen
	BNE loc_8A3E
	LDA #RF_AtScrollEdge
	BIT a:RoomStatusFlags
	BEQ loc_8A66

loc_8A3E:
	JSR ApplyPlayerXVelocity
	LDA #RF_ScrollStop
	BIT a:RoomStatusFlags
	BEQ loc_8A66
	LSR A
	BIT a:RoomStatusFlags		; #RF_SingleScreen
	BNE loc_8A66
	LDA PlayerXPosHi
	CMP #$80
	PHP
	TXA
	BPL loc_8A5B
	PLA
	EOR #1
	PHA

loc_8A5B:
	PLP
	BCC loc_8A66
	LDA a:RoomStatusFlags
	AND #~RF_AtScrollEdge
	STA a:RoomStatusFlags		; clear	#RF_AtScrollEdge

loc_8A66:
	LDX #0
	LDA #2
	BIT PlayerStruct
	BEQ loc_8A78
	LDA byte_3E7
	CMP #$40
	BCC loc_8A78
	LDX #4

loc_8A78:
	TXA
	ORA PlayerStruct
	LSR A
	AND #3
	PHP
	AND #2
	CLC
	ADC #4
	PLP
	BNE loc_8A99
	INC byte_3DF
	STAc byte_0
	LDA byte_3DF
	LSR A
	LSR A
	LSR A
	LDAc byte_0
	ADC #0

loc_8A99:
	STA PlayerSprite
; End of function MainSub_1

; =============== S U B	R O U T	I N E =======================================

DrawPlayer:
	LDA PlayerSprite
	STAc TempSpriteTile
	LDA byte_3DD
	ORA #1
	STAc TempSpriteAttributesish
	LDA #0
	STAc CurrentSpriteIndex
	LDA PlayerXPosHi
	STAc TempSpriteX
	LDA PlayerYPosHi
	STAc TempSpriteY
	JSR WriteSprite
	RTS
; End of function DrawPlayer

; =============== S U B	R O U T	I N E =======================================

DoSomethingWithObjYVel:
	TXA
	AND #$C
	LSR A
	TAX
	LDA word_C163,X
	CLC
	LDY #EnemyStruct_18
	ADC (EnemyStructPointer),Y	; #$18
	STA (EnemyStructPointer),Y
	INY
	LDA word_C163+1,X
	ADC (EnemyStructPointer),Y	; #$19
	BPL loc_8AD8
	LDA #$7F

loc_8AD8:
	STA (EnemyStructPointer),Y
	JSR sub_8AE8
	TYA
	LDY #EnemyStruct_A_YVelHi
	STA (EnemyStructPointer),Y	; #$A
	DEY
	DEY
	TXA
	STA (EnemyStructPointer),Y	; #$8
	RTS
; End of function DoSomethingWithObjYVel

; =============== S U B	R O U T	I N E =======================================

sub_8AE8:
	CMP #$40
	PHP
	BCC loc_8AF1
	EOR #$FF
	AND #$3F

loc_8AF1:
	ASL A
	TAY
	LDX word_C0E3,Y
	INY
	LDA word_C0E3,Y
	TAY
	PLP
	BCS locret_8B01
	JSR NegateYYXX			; e.g. 2 -> FFFE

locret_8B01:
	RTS
; End of function sub_8AE8

; =============== S U B	R O U T	I N E =======================================

ApplyPlayerXAndYVelocity:
	JSR ApplyPlayerYVelocity
; End of function ApplyPlayerXAndYVelocity

; =============== S U B	R O U T	I N E =======================================

ApplyPlayerXVelocity:
	LDA PlayerXVelLo
	CLC
	ADC PlayerXPosLo
	STA PlayerXPosLo
	LDA PlayerXVelHi
	ADC PlayerXPosHi
	STA PlayerXPosHi
	RTS
; End of function ApplyPlayerXVelocity

; =============== S U B	R O U T	I N E =======================================

ApplyPlayerYVelocity:
	LDA PlayerYVelLo
	CLC
	ADC PlayerYPosLo
	STA PlayerYPosLo
	LDA PlayerYVelHi
	ADC PlayerYPosHi
	STA PlayerYPosHi
	RTS
; End of function ApplyPlayerYVelocity

; =============== S U B	R O U T	I N E =======================================

UseMightyCoin:
	LDA PlayerMightyCoins
	BEQ locret_8B5F
	LDA PlayerMightyLevel
	CMP #3
	BEQ locret_8B5F
	DEC PlayerMightyCoins
	INC PlayerMightyLevel
	LDX PlayerMightyLevel
	LDA MightyLevelAPressesTable,X	; (1), 20, 30, 35
	STA PlayerMightyLevelPressesLeft
	JSR UpdateMightyPalette		; X = mighty level
	LDA #Sound_UsedMightyCoin
	JSR QueueSound			; mighty coin
	LDA #0
	STA byte_333
	LDA PlayerMightyLevel
	CMP #3				; are we at level 3 now
	BNE locret_8B5F			; if no, exit
	JSR TurnEnemiesIntoCoins	; otherwise, turn enemies into coins

locret_8B5F:
	RTS
; End of function UseMightyCoin

; =============== S U B	R O U T	I N E =======================================

; X = mighty level

UpdateMightyPalette:
	LDA MightyLevelColors,X
	STA PaletteBuffer+$17
	INC a:UpdatePaletteFlag
	RTS
; End of function UpdateMightyPalette

; =============== S U B	R O U T	I N E =======================================

DrawScoreAndCoinCount:
	LDA a:DrawScoreAndCoinsFlag	; POI: is this EVER zero?
	BNE loc_8B70
	RTS
; ---------------------------------------------------------------------------

loc_8B70:
	LDA #$10
	STAc TempSpriteAttributesish
	JSR DrawScore			; draw score sprites?
	JSR DrawMightyCoinCountOrMultiplier ; maybe draw mighty	coin count
	RTS
; End of function DrawScoreAndCoinCount

; =============== S U B	R O U T	I N E =======================================

; draw score sprites?

DrawScore:
	JSR CopyNext5BytesToTempSprite
	SpriteData 0, $10,	$58, $10, $38 ;
	LDX #3
	STXc byte_0
	LDA #0
	STAc byte_1

loc_8B8E:
	LDXc byte_0
	LDA a:PlayerScore,X
	LSR A
	LSR A
	LSR A
	LSR A
	JSR DrawScoreDigitMaybe
	LDA a:PlayerScore,X
	AND #$F
	JSR DrawScoreDigitMaybe
	DECc byte_0
	BPL loc_8B8E
	RTS
; End of function DrawScore

; =============== S U B	R O U T	I N E =======================================

; maybe	handles	leading	zeroes?

DrawScoreDigitMaybe:
	PHP
	LDYc TempSpriteY
	PLP
	PHA
	BNE loc_8BBD
	TXA
	BEQ loc_8BBD
	LDAc byte_1
	BNE loc_8BC0
	LDY #$F8
	BNE loc_8BC0

loc_8BBD:
	INC a:byte_1

loc_8BC0:
	TYA
	LDYc CurrentSpriteIndex
	STA SpriteDMAArea,Y
	INY
	PLA
	STA SpriteDMAArea,Y
	INY
	LDA #0
	STA SpriteDMAArea,Y
	INY
	LDAc TempSpriteX
	STA SpriteDMAArea,Y
	INY
	STYc CurrentSpriteIndex
	LDAc TempSpriteX
	CLC
	ADC #8
	STAc TempSpriteX
	RTS
; End of function DrawScoreDigitMaybe

; =============== S U B	R O U T	I N E =======================================

; maybe	draw torture jump count

DrawTimerOrTortureJumps:
	JSR CopyNext5BytesToTempSprite
	SpriteData $E, $10, $3C, $1C, 9 ;
	LDA TortureRoomSceneFlag	; If not in torture room...
	BEQ loc_8BF9			;   skip ahead
	LDA #$F				; Otherwise, sprite tile = blank
	STAc TempSpriteTile		; (otherwise it	is the "T")

loc_8BF9:
	JSR WriteSprite
	LDAc TempSpriteX
	CLC
	ADC #$10
	STAc TempSpriteX
	LDA a:StageTimer
	LDX TortureRoomSceneFlag	; If not in the	torture	room...
	BEQ loc_8C1A			;   skip ahead
	LDA #$44
	STAc TempSpriteY			; to be	center of screen-ish
	LDA #$84
	STAc TempSpriteX			; remaining before release
	LDA GreedyJumpsRemaining

loc_8C1A:
	JSR WriteBCDDigitsSprites	; greedy jump counter
	RTS
; End of function DrawTimerOrTortureJumps

; =============== S U B	R O U T	I N E =======================================

; maybe	draw mighty coin count

DrawMightyCoinCountOrMultiplier:
	JSR CopyNext5BytesToTempSprite
	SpriteData $B, $10, $BC, $1C, $C ;
	LDA a:RoomStatusFlags
	AND #RF_BombRoom		; Check	for royal palace/bomb room
	BEQ loc_8C30
	INCc TempSpriteTile		; If so, tile M	-> x

loc_8C30:
	JSR WriteSprite
	LDAc TempSpriteX
	CLC
	ADC #8
	STAc TempSpriteX
	LDX #0
	LDA a:RoomStatusFlags
	AND #RF_BombRoom		; Check	for royal palace / bomb	room
	BEQ loc_8C46
	INX

loc_8C46:
	LDA PlayerMightyCoins,X		; (...or score multiplier)
	STAc TempSpriteTile
	TXA
	BEQ loc_8C52
	INCc TempSpriteTile

loc_8C52:
	JSR WriteSprite
	RTS
; End of function DrawMightyCoinCountOrMultiplier

; =============== S U B	R O U T	I N E =======================================

RestoreDefaultPalettes:
	LDX #0

; X = where to start (0~1F)
RestoreDefaultPalettesLimited:
	LDA MainPalette,X
	STA PaletteBuffer,X
	INX
	CPX #$20
	BNE RestoreDefaultPalettesLimited ; X =	where to start (0~1F)
	LDA #1
	STA a:UpdatePaletteFlag
	STAc PPUUpdateFlag1     ; these zero page changes are killing me
	RTS
; End of function RestoreDefaultPalettesLimited

; =============== S U B	R O U T	I N E =======================================

SetPPUCtrl:
	STAc PPUCtrlMirror
	STA PPUCTRL
	RTS
; End of function SetPPUCtrl

; =============== S U B	R O U T	I N E =======================================

SetPPUMask:
	STAc PPUMaskMirror
	STA PPUMASK
	RTS
; End of function SetPPUMask

; =============== S U B	R O U T	I N E =======================================

SetPPUScroll:
	STA PPUSCROLL
	STA PPUSCROLL
	RTS
; End of function SetPPUScroll

; =============== S U B	R O U T	I N E =======================================

ClearNametable:
	LDA #0
	LDX #$3F

loc_8C85:
	STA AttributeTableBuffer,X
	DEX
	BPL loc_8C85
	LDA PPUSTATUS
	LDAc PPUCtrlMirror
	ORA #$10
	AND #$F0
	JSR SetPPUCtrl
	LDA #6
	STA PPUMASK
	LDA #$28
	JSR loc_8CA4
	LDA #$20

loc_8CA4:
	STA PPUADDR
	LDA #0
	STA PPUADDR
	LDX #4
	LDY #$C0

loc_8CB0:
	LDA #$24
	STA PPUDATA
	DEY
	BNE loc_8CB0
	DEX
	BNE loc_8CB0
	TXA
	LDX #$40

loc_8CBE:
	STA PPUDATA
	DEX
	BNE loc_8CBE
	TXA
	JSR SetPPUScroll
	RTS
; End of function ClearNametable

; =============== S U B	R O U T	I N E =======================================

ClearAllSprites:
	LDX #$40
	LDY #0
; ---------------------------------------------------------------------------
	.BYTE $2C ;	,			; BIT
; ---------------------------------------------------------------------------

ClearFourSpritesInY:
	LDX #4
	LDA #$F8

loc_8CD2:
	STA SpriteDMAArea,Y
	INY
	INY
	INY
	INY
	DEX
	BNE loc_8CD2
	RTS
; End of function ClearAllSprites

; =============== S U B	R O U T	I N E =======================================

WriteStringToPPU:
	ASL A
	TAX
	LDA StringPointerTable,X
	STA byte_48
	LDA StringPointerTable+1,X
	STA byte_49
	LDA #6
	STA PPUMASK
	LDA PPUSTATUS
	LDY #1
	LDA (byte_48),Y
	ORA #$20
	STA PPUADDR
	DEY
	LDA (byte_48),Y
	STA PPUADDR
	INY
	INY

loc_8D02:
	LDA (byte_48),Y
	CMP #$FF
	BEQ loc_8D0E
	STA PPUDATA
	INY
	BNE loc_8D02

loc_8D0E:
	LDA #0
	JSR SetPPUScroll
	STA byte_3C2
	STA byte_3C4
	LDAc PPUCtrlMirror
	AND #$FD
	JSR SetPPUCtrl
	RTS
; End of function WriteStringToPPU

; =============== S U B	R O U T	I N E =======================================

; Turns	a positive 16-bit number in (YYXX)
; and negates it (i.e. "2" -> "FFFE")

NegateYYXX:
	TXA
	EOR #$FF
	TAX
	TYA
	EOR #$FF
	TAY
	INX
	BNE locret_8D2E
	INY

locret_8D2E:
	RTS
; End of function NegateYYXX

; =============== S U B	R O U T	I N E =======================================

BCDSub1FromA:
	SEC
	SBC #1
	PHA
	AND #$F
	CMP #$A
	BCC loc_8D3D
	PLA
	SBC #6
	PHA

loc_8D3D:
	PLA
	RTS
; End of function BCDSub1FromA

; =============== S U B	R O U T	I N E =======================================

WriteBCDDigitsSprites:
	PHA
	AND #$F
	STAc TempSpriteTile
	LDA #$10
	STAc TempSpriteAttributesish
	JSR WriteSprite
	PLA
	AND #$F0
	BNE loc_8D54
	LDA #$F0

loc_8D54:
	LSR A
	LSR A
	LSR A
	LSR A
	STAc TempSpriteTile
	LDAc TempSpriteX
	SEC
	SBC #8
	STAc TempSpriteX
	JSR WriteSprite
	RTS
; End of function WriteBCDDigitsSprites

; =============== S U B	R O U T	I N E =======================================

AnimateDoorOpen:
	LDX #$80
; ---------------------------------------------------------------------------
	.BYTE $2C ;	,			; sacrificial BIT
; End of function AnimateDoorOpen

; =============== S U B	R O U T	I N E =======================================

AnimateDoorClose:
	LDX #0
	JSR AnimateDoor
	LDA #1
	BIT MaybeDoorReturnTwiceFlag
	BEQ locret_8D79
	PLA
	PLA

locret_8D79:
	RTS
; End of function AnimateDoorClose

; =============== S U B	R O U T	I N E =======================================

JumpTable:
	ASL A
	TAY
	PLA
	STA JumpTablePointer
	PLA
	STA byte_31
	INY
	LDA (JumpTablePointer),Y
	STA JumpTableTarget
	INY
	LDA (JumpTablePointer),Y
	STA JumpTableTarget+1
	JMP (JumpTableTarget)
; End of function JumpTable

; =============== S U B	R O U T	I N E =======================================

QueueSound:
	INC SoundsQueued
	LDX SoundsQueued
	STA SoundQueue-1,X		; (SoundsQueued	- 1 because inc	x)
	RTS
; End of function QueueSound

; =============== S U B	R O U T	I N E =======================================

CalculateModulus:
	PHA					; Store	A
	TXA
	PHA					; Store	X
	LDA #0
	STAc Mod_Remainder
	LDX #$10
	ROLc Mod_Number
	ROLc Mod_Number+1

loc_8DA9:
	ROLc Mod_Remainder
	LDAc Mod_Remainder
	CMPc Mod_Modulus
	BCC loc_8DBA
	SBCc Mod_Modulus
	STAc Mod_Remainder

loc_8DBA:
	ROLc Mod_Number
	ROLc Mod_Number+1
	DEX
	BNE loc_8DA9
	PLA					; Load X
	TAX
	PLA					; Load A
	RTS
; End of function CalculateModulus

; =============== S U B	R O U T	I N E =======================================

LoadPointerTo050:
	ASL A
	TAX
	LDA PointerTable050,X
	STA word_50
	LDA PointerTable050+1,X
	STA word_50+1
	RTS
; ---------------------------------------------------------------------------
PointerTable050:
	.WORD SpritesTable
	.WORD AdjacentRoomsTable		; 1 ; 42 entries, seems	to be
	.WORD RoomHalfScreens		; 2 ; based on which rooms are
	.WORD LayoutChunks			; 3 ; "in the same section"
	.WORD MetatileDefinitions		; 4 ; (e.g. 07 08 09 0A	%0 A8,
	.WORD RoomDataPointers		; 5 ; which includes the treasure,
	.WORD HalfScreenLayouts		; 6 ; but not the bomb room 91)
	.WORD AttributeTableBuffer		; 7
	.WORD byte_5A3			; 8
	.WORD BackgroundPaletteSets		; 9
	.WORD SectionRoomsTable		; $A
	.WORD PlayerScore			; $B
	.WORD byte_786			; $C
	.WORD unk_30A			; $D
	.WORD EnemySpawnPositionTable	; $E
; End of function LoadPointerTo050

; =============== S U B	R O U T	I N E =======================================

WriteSprite:
	LDA CurrentSpriteIndex
	ASL A
	ASL A
	STA SpriteOffset		; offset into $200
	LDA #$10
	BIT TempSpriteAttributesish
	BEQ _WriteNormalSprite
	LDY a:SpriteOffset		; offset into $200
	LDA TempSpriteY
	SEC
	SBC #4
	STA SpriteDMAArea,Y
	LDA TempSpriteTile
	STA SpriteDMAArea+1,Y
	LDA TempSpriteAttributesish
	AND #$E3
	STA SpriteDMAArea+2,Y
	LDA TempSpriteX
	SEC
	SBC #4
	STA SpriteDMAArea+3,Y
	INC CurrentSpriteIndex
	RTS
; ---------------------------------------------------------------------------

_WriteNormalSprite:
	LDA TempSpriteAttributesish
	AND #$C
	LSR A
	TAX
	LDA SpriteAttributeTable,X
	STA byte_4E
	LDA SpriteAttributeTable+1,X
	STA byte_4F
	LDA #BasePointer_SpritesTable
	LDX TempSpriteTile
	BPL loc_8E38
	LDA #BasePointer_RAM_30A

loc_8E38:
	JSR LoadPointerTo050		; 0 or D (sprites / RAM30A)
	LDA TempSpriteTile
	BPL loc_8E41
	LDA #0

loc_8E41:
	STA byte_4D
	ASL A
	ASL A
	ADC byte_4D			; x5
	CLC
	ADC word_50
	STA byte_4C
	LDA word_50+1
	ADC #0
	STA byte_4D
	LDY #0
	LDA (byte_4C),Y
	EOR byte_4E
	STA byte_4E
	LDAc TempSpriteAttributesish
	AND #$23
	ASL A
	ASL A
	STA a:word_50
	INY
	STY a:byte_4B
	LDX a:SpriteOffset		; offset into $200

loc_8E6B:
	LDA TempSpriteY
	LSR byte_4F
	BCC loc_8E73
	ADC #$F7

loc_8E73:
	STA SpriteDMAArea,X
	LDY a:byte_4B
	LDA (byte_4C),Y
	INX
	STA SpriteDMAArea,X
	LDA a:word_50
	LSR byte_4E
	ROR A
	LSR byte_4E
	ROR A
	INX
	STA SpriteDMAArea,X
	INX
	LDA TempSpriteX
	LSR byte_4F
	BCC loc_8E95
	ADC #$F7

loc_8E95:
	STA SpriteDMAArea,X
	INC a:byte_4B
	INX
	LDA a:byte_4B
	CMP #5
	BNE loc_8E6B
	LDA CurrentSpriteIndex
	CLC
	ADC #4
	STA CurrentSpriteIndex
	RTS
; End of function WriteSprite

; ---------------------------------------------------------------------------
UnusedSpriteAttributeTable:
	.BYTE    0		 ; POI: not sure; no obvious xrefs,
	.BYTE  $CA				; 1 ; not maked	as read	in us ver either.
	.BYTE  $55				; 2 ; looks similar to used SpriteAttributeTable
	.BYTE  $C5				; 3
	.BYTE  $AA				; 4
	.BYTE  $3A				; 5
	.BYTE  $FF				; 6
	.BYTE  $35				; 7

; =============== S U B	R O U T	I N E =======================================

LoadRoomPalette:
	PHA					; A = 0-F
	LDA #BasePointer_BackgroundPaletteSets
	JSR LoadPointerTo050		; 9 (palettes)
	PLA
	ASL A				; x2
	ASL A				; x4
	PHA					; push again
	CLC
	ADC word_50			; add (A) x4 to	offset
	STA word_50
	LDA word_50+1
	ADC #0
	STA word_50+1
	PLA					; then pull A again
	ASL A				; x8
	CLC
	ADC word_50
	STA word_50
	LDA word_50+1
	ADC #0
	STA word_50+1
	LDY #0				; x4 + x8 = x12	(C)

loc_8ED7:
	LDA (word_50),Y
	STA PaletteBuffer+4,Y
	INY
	CPY #$C
	BNE loc_8ED7
	LDY #0
	LDA (word_50),Y

loc_8EE5:
	STA PaletteBuffer,Y
	INY
	INY
	INY
	INY
	CPY #$20
	BNE loc_8EE5
	STY a:UpdatePaletteFlag
	RTS
; End of function LoadRoomPalette

; =============== S U B	R O U T	I N E =======================================

AddScore:
	CMP #8				; if A >= 8...
	BCS _AddScoreIndex		;   ...just treat it like a score index
	LDX ScoreMultiplier		; If score mult	= x1,
	BEQ _AddScoreIndex		; skip all this
	TAY					; store	score index in Y
	LDA a:RoomStatusFlags
	AND #RF_BombRoom		; check	if royal palace	/ bomb room
	PHP					; Push result flags
	TYA					; restore score	index
	PLP					; restore result flags
	BEQ _AddScoreIndex		; if not a bomb	room, do normal	score
	DEX					; otherwise, mult - 1
	STXc byte_10			; store	mult
	ASL A				; score	index x2
	ASL A				; score	index x4
	CLC
	ADCc byte_10			; add mult
	TAX
	LDA MultipliedScoreTable,X	; load mult'd score

_AddScoreIndex:
	ASL A
	TAX
	LDA ScoreAddTable,X
	TAY
	LDA ScoreAddTable+1,X
	CLC

loc_8F20:
	ADC a:PlayerScore,Y
	TAX
	AND #$F
	CMP #$A
	BCC loc_8F2E
	TXA
	ADC #5
	TAX

loc_8F2E:
	TXA
	AND #$F0
	CMP #$A0
	TXA
	STA a:PlayerScore,Y
	BCC loc_8F49
	ADC #$5F
	STA a:PlayerScore,Y
	INY
	CPY #4
	BEQ loc_8F49
	LDA #0
	SEC
	JMP loc_8F20
; ---------------------------------------------------------------------------

loc_8F49:
	LDA ScoreMultiplier		; if you're already at x4,
	CMP #4				; just leave
	BEQ locret_8FB0
	LDA a:PlayerScore+2
	CMP a:PlayerScoreThousandsCopy
	STA a:PlayerScoreThousandsCopy
	BNE loc_8F7A
	LDA a:PlayerScore+1
	AND #$F0
	CMP #$50
	BCS loc_8F6D
	LDA byte_364
	AND #$FE
	STA byte_364
	RTS
; ---------------------------------------------------------------------------

loc_8F6D:
	LDA #1
	BIT byte_364
	BNE locret_8FB0
	ORA byte_364
	STA byte_364

loc_8F7A:
	LDA a:RoomStatusFlags
	AND #RF_BombRoom
	BEQ locret_8FB0
	LDA #2
	BIT byte_364
	BNE locret_8FB0
	ORA byte_364
	STA byte_364
	JSR sub_BA00
	LDX #EnemyType_E_BonusCoin
	LDA byte_364
	AND #4
	BEQ loc_8FA9
	LDX #EnemyType_9_ExtraCoin
	LDA byte_364
	AND #3
	STA byte_364
	LDA #0
	STA GoldCoinsCollected

loc_8FA9:
	TXA
	JSR InitEnemy
	JSR ChooseEnemySpawnPoint

locret_8FB0:
	RTS
; End of function AddScore

; =============== S U B	R O U T	I N E =======================================

; score	popups?

sub_8FB1:
	CLC
	ADC #$30
	STA byte_30B
	LDA #$30
	STA byte_30C
	LDX #$F
	STX byte_30D
	LDY ScoreMultiplier
	BEQ loc_8FD3
	LDA a:RoomStatusFlags
	AND #RF_BombRoom
	BEQ loc_8FD3
	DEY
	TYA
	CLC
	ADC #$3C
	TAX

loc_8FD3:
	STX byte_30E
	RTS
; End of function sub_8FB1

; =============== S U B	R O U T	I N E =======================================

; called with room id

MaybeLoadRoomFlags:
	STA off_3D
	LDA #BasePointer_AdjacentRoomsTable
	JSR LoadPointerTo050		; adj. rooms table
	LDA off_3D
	LDY #0
	STY off_3D+1
	ASL off_3D
	ROL off_3D+1
	ASL off_3D
	ROL off_3D+1
	CLC
	ADC off_3D
	BCC loc_8FF3
	INC off_3D+1

loc_8FF3:
	CLC
	ADC word_50
	STA off_3D
	LDA off_3D+1
	ADC word_50+1
	STA off_3D+1
	LDY #0
	LDX #0
	LDA (off_3D),Y
	LSR A
	BCC loc_9009
	LDX #RF_SingleScreen

loc_9009:
	AND #2
	BEQ loc_9011
	TXA
	ORA #RF_ScrollStop
	TAX

loc_9011:
	LDA a:RoomStatusFlags
	AND #~(RF_SingleScreen|RF_ScrollStop) ; clear #RF_SingleScreen #RF_ScrollStop

loc_9016:
	STA a:RoomStatusFlags
	TXA
	ORA a:RoomStatusFlags
	STA a:RoomStatusFlags		; Sets based on	room header?
	RTS
; End of function MaybeLoadRoomFlags

; =============== S U B	R O U T	I N E =======================================

LoadRoomStuff:
	PHA					; called with A=room id	sometimes?
	LDA #BasePointer_RoomHalfScreens
	JSR LoadPointerTo050		; 2 (half screens)
	PLA
	ASL A
	BCC loc_902E
	INCc word_50+1

loc_902E:
	CLC
	ADCc word_50
	STAc off_2
	LDAc word_50+1
	ADC #0
	STAc off_2+1
	RTS
; End of function LoadRoomStuff

; =============== S U B	R O U T	I N E =======================================

; another pointer thing

HandleDrawHalfRow:
	LDA #BasePointer_HalfScreenLayouts
	JSR LoadPointerTo050		; 6 (bg	rows)
	LDA #0
	STA off_4+1
	LDA (off_2),Y			; offset to row	index?
	ASL A				; x2
	ROL off_4+1
	ASL A				; x4
	ROL off_4+1
	ASL A				; x8
	ROL off_4+1
	ASL A				; x16
	ROL off_4+1
	CLC
	ADC word_50
	STA off_4
	LDA off_4+1
	ADC word_50+1
	STA off_4+1
	LDY byte_8
	LDA (off_4),Y		; If HalfScreenLayout # >= $60, subtract $B
	CMP #$60			; (see note about HalfScreenLayouts) 
	BCC loc_906A
	SBC #$B

loc_906A:
	PHA
	LDA #BasePointer_LayoutChunks
	JSR LoadPointerTo050		; 3 (layout chunks)
	LDA #0
	STA off_4+1
	PLA
	ASL A				; x2
	ROL off_4+1
	ASL A				; x4
	ROL off_4+1
	ASL A				; x8
	ROL off_4+1
	CLC
	ADC word_50
	STA off_4
	LDA off_4+1
	ADC word_50+1
	STA off_4+1
	RTS
; End of function HandleDrawHalfRow

; =============== S U B	R O U T	I N E =======================================

LoadLayoutChunk:
	PHA
	LDA #BasePointer_MetatileDefinitions
	JSR LoadPointerTo050		; 4 (metatile defs)
	LDA #0
	STA byte_7
	PLA
	ASL A
	ROL byte_7
	ASL A
	ROL byte_7
	ADC word_50
	STA byte_6
	LDA byte_7
	ADC word_50+1
	STA byte_7
	RTS
; End of function LoadLayoutChunk

; =============== S U B	R O U T	I N E =======================================

DrawFullScreen:
	LDY #0
	STY byte_3C1
	STY byte_3C2
	STY byte_3C3
	STY byte_3C4
	STY a:byte_F4
	LDAc PPUMaskMirror
	ORA #6
	STAc PPUMaskMirror
	LDA (off_3D),Y
	LSR A
	BCS loc_90EC
	AND #1
	BEQ loc_90EC
	LDA (off_3D),Y
	AND #8
	LSR A
	LSR A
	TAX
	LDA byte_9104,X
	ORA a:RoomStatusFlags
	STA a:RoomStatusFlags
	LDA (off_3D),Y
	AND #4
	BEQ loc_90EC
	LDAc PPUMaskMirror
	AND #$F9
	STAc PPUMaskMirror
	LDA byte_9105,X
	STA byte_3C2

loc_90EC:
	LDA (off_3D),Y
	AND #4
	TAX
	ORAc PPUCtrlMirror
	AND #$FD
	JSR SetPPUCtrl
	LDA #6
	STA PPUMASK
	TXA
	BNE loc_9108
	JMP loc_9192
; ---------------------------------------------------------------------------
byte_9104:
	.BYTE	$48
byte_9105:
	.BYTE	0
	.BYTE $88
	.BYTE $F8
; ---------------------------------------------------------------------------

loc_9108:
	LDA #0
	STA byte_1

loc_910C:
	LDA byte_1
	LSR A
	STA byte_8
	LDY #0
	STY byte_9
	LDA PPUSTATUS
	LDA #$20
	STA byte_3EF
	STA PPUADDR
	LDA byte_1
	STA byte_3F0
	STA PPUADDR
	LDY #0
	JSR HandleDrawHalfRow		; another pointer thing

loc_912D:
	LDY byte_9
	CPY #8
	BEQ loc_9152
	LDA (off_4),Y
	PHA
	JSR HandleTileAttributes
	PLA
	JSR LoadLayoutChunk
	LDA byte_1
	AND #1
	TAY
	LDA (byte_6),Y
	STA PPUDATA
	INY
	INY
	LDA (byte_6),Y
	STA PPUDATA
	INC byte_9
	BNE loc_912D

loc_9152:
	LDY #1
	JSR HandleDrawHalfRow		; another pointer thing

loc_9157:
	LDY byte_9
	CPY #$F
	BEQ loc_9180
	TYA
	AND #7
	TAY
	LDA (off_4),Y
	PHA
	JSR HandleTileAttributes
	PLA
	JSR LoadLayoutChunk
	LDA byte_1
	AND #1
	TAY
	LDA (byte_6),Y
	STA PPUDATA
	INY
	INY
	LDA (byte_6),Y
	STA PPUDATA
	INC byte_9
	BNE loc_9157

loc_9180:
	INC byte_1
	LDA byte_1
	CMP #$20
	BEQ loc_918B
	JMP loc_910C
; ---------------------------------------------------------------------------

loc_918B:
	JSR sub_9696
	JSR CopyAttributeTableToPPU
	RTS
; ---------------------------------------------------------------------------

loc_9192:
	LDA #0
	STA byte_1
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #0
	STA PPUADDR

loc_91A3:
	LDA #0
	STA byte_3F0
	LDA byte_1
	LSR A
	ROR byte_3F0
	LSR A
	ROR byte_3F0
	LSR A
	ROR byte_3F0
	STA byte_3EF
	LDA byte_1
	LSR A
	STA byte_8
	LDY #0
	STY byte_9
	JSR HandleDrawHalfRow		; another pointer thing

loc_91C5:
	LDA byte_9
	CMP #$10
	BEQ loc_91FD
	CMP #8
	BNE loc_91D9
	LDA byte_1
	LSR A
	STA byte_8
	LDY #1
	JSR HandleDrawHalfRow		; another pointer thing

loc_91D9:
	LDA byte_9
	AND #7
	TAY
	LDA (off_4),Y
	PHA
	JSR HandleTileAttributes
	PLA
	JSR LoadLayoutChunk
	LDA byte_1
	AND #1
	ASL A
	TAY
	LDA (byte_6),Y
	STA PPUDATA
	INY
	LDA (byte_6),Y
	STA PPUDATA
	INC byte_9
	BNE loc_91C5

loc_91FD:
	INC byte_1
	LDA byte_1
	CMP #$1E
	BNE loc_91A3
	LDA CurrentRoomID
	STA CurrentRoomIDBackup
	JSR sub_9696
	JSR CopyAttributeTableToPPU
	LDY #0
	LDA (off_3D),Y
	LSR A
	BCS loc_921F
	AND #5
	CMP #1
	BEQ loc_921F

locret_921E:
	RTS
; ---------------------------------------------------------------------------

loc_921F:
	LDY #1
	LDA (off_3D),Y
	BEQ locret_921E
	JSR LoadRoomStuff
	DEY
	STYc byte_9
	LDA #$E
	STAc byte_8
	JSR HandleDrawHalfRow		; another pointer thing
	LDA #$B
	STA byte_3EF
	LDA #$80
	STA byte_3F0

loc_923E:
	LDAc byte_9
	CMP #8
	BNE loc_924A
	LDY #1
	JSR HandleDrawHalfRow		; another pointer thing

loc_924A:
	LDAc byte_9
	AND #7
	TAY
	LDA (off_4),Y
	PHA
	JSR HandleTileAttributes
	PLA
	JSR sub_9716
	JSR sub_9729
	LDA byte_3F0
	CLC
	ADC #2
	STA byte_3F0
	INCc byte_9
	LDAc byte_9
	CMP #$10
	BNE loc_923E
	LDA #0
	STA byte_3EF
	RTS
; End of function DrawFullScreen

; =============== S U B	R O U T	I N E =======================================

sub_9276:
	TAX
	LDA byte_3C4
	CMP #$78
	BCC loc_9280
	ADC #$F

loc_9280:
	EOR #$FF
	STAc byte_F
	INCc byte_F
	TXA
	AND #$F0
	ORA #8
	CLC
	ADCc byte_F
	STA a:byte_92
	LDA byte_3C2
	EOR #$FF
	STAc byte_F
	INCc byte_F
	TXA
	ASL A
	ASL A
	ASL A
	ASL A
	ORA #8
	ADCc byte_F
	STAc byte_94
	RTS
; End of function sub_9276

; =============== S U B	R O U T	I N E =======================================

sub_92AD:
	JSR sub_92E2
	AND #$F
	ASL A
	ORA byte_3F0
	STA byte_3F0
	LDY #0
	LDA (off_3D),Y
	AND #4
	PHP
	TXA
	PLP
	BEQ loc_92C8
	LSR A
	LSR A
	LSR A
	LSR A

loc_92C8:
	AND #$F
	STAc byte_9
	LDA a:RoomStatusFlags
	AND #$30
	BNE locret_92E1
	LDA a:byte_F4
	BEQ locret_92E1
	LDA byte_3EF
	ORA #8
	STA byte_3EF

locret_92E1:
	RTS
; End of function sub_92AD

; =============== S U B	R O U T	I N E =======================================

sub_92E2:
	TAX
	LDA #0
	STA byte_3EF
	TXA
	AND #$F0
	ASL A
	ROL byte_3EF
	ASL A
	ROL byte_3EF
	STA byte_3F0
	TXA
	RTS
; End of function sub_92E2

; =============== S U B	R O U T	I N E =======================================

; A=room. double-returns if Z set

IfNotTitleScreenRoomDoThings:
	BNE loc_92FD
	PLA
	PLA
	RTS
; ---------------------------------------------------------------------------

loc_92FD:
	PHA
	JSR LoadRoomData
	PLA
	LDYc byte_5F
	BEQ loc_931F
	STYc byte_F
	LDY #0

loc_930C:
	CMP RoomDataRAM,Y
	BEQ loc_9330
	DECc byte_F
	BEQ loc_931F
	TAX
	TYA
	CLC
	ADC #$10
	TAY
	TXA
	BNE loc_930C

loc_931F:
	LDY #$80
	CMP RoomDataRAM,Y
	BEQ loc_9335
	STA RoomDataRAM,Y
	JSR ReadRoomData		; Parse	room data?
	LDY #$80
	BNE loc_9335

loc_9330:
	LDA #0
	STAc byte_683

loc_9335:
	INY
	INY
	STYc byte_5A
	LDA #0
	STAc byte_AC
	RTS
; End of function IfNotTitleScreenRoomDoThings

; =============== S U B	R O U T	I N E =======================================

GameState_2_LoadRoom:
	LDA #0
	STAc MaybeBombThing		; maybe	related	to all fire bombs
	STA a:RoomStatusFlags
	INCc GameState			; 2 -> 3
	LDA #BasePointer_RoomDataPointers
	JSR LoadPointerTo050		; 5 room data pointers
	LDA CurrentRoomID		; Load current room
	BEQ locret_9362			; If room == 0 (title),	skip ahead
	JSR LoadRoomData
	LDY #0
	LDA (off_58),Y			; This is a pointer to the room	now
	AND #$F0
	CMP #$E0
	BEQ _RoomHeaderPresent

locret_9362:
	RTS
; ---------------------------------------------------------------------------

_RoomHeaderPresent:
	LDA (off_58),Y			; First	byte is	1110 PPPP = #$Ex
	STA a:RoomPalette			; (higher bits masked off later)
	INY
	LDA (off_58),Y			; Second byte is music type
	AND #7
	STA a:RoomMusic
	INY
	LDA (off_58),Y			; Third	byte is	??
	BEQ locret_9362			; If 0,	exit
	AND #$40
	BEQ _SpecialBitSet		; If that is clear, jump ahead
	INC SomeLoadFlag		; Otherwise, inc this and leave
	RTS
; ---------------------------------------------------------------------------

_SpecialBitSet:
	LDA (off_58),Y			; Reload third byte
	LDX #0
	STX a:Unread_0A6			; POI: is this ever read? always 0
	LDX CurrentRoomID		; POI: Secret R5->R11 warp check
	CPX #$FC
	BEQ loc_9394
	STX CheckpointRoomIDMaybe	; R5->R11 warp
	LDX EntryDoorType
	STX EntryDoorTypeBackup

loc_9394:
	PHA
	LDA a:TimerStatusMaybe
	AND #~$40
	STA a:TimerStatusMaybe		; & ~#$40
	PLA
	BPL loc_93B5
	LDX #0
	STX a:TimerStatusMaybe
	LDX CurrentRoomID
	CPX #$FC
	BEQ loc_93B5
	STX byte_33E
	LDX EntryDoorType
	STX EntryDoorTypeBackup2

loc_93B5:
	AND #$7F
	TAY
	DEY
	LDA #BasePointer_SectionRoomsTable
	JSR LoadPointerTo050		; A (section rooms table)
	TYA
	ASL A
	TAY
	LDA (word_50),Y
	STAc byte_5A
	INY
	LDA (word_50),Y
	STAc byte_5B
	LDA #0
	STAc byte_5F

loc_93D1:
	LDA #0
	STAc byte_B
	LDYc byte_5F
	INY
	LDA (byte_5A),Y
	BEQ loc_93E2
	CMP #$90
	BCC loc_93EE

loc_93E2:
	DEY
	LDA (byte_5A),Y
	CMP #$90
	BCS loc_93EE
	LDA #2
	STAc byte_B

loc_93EE:
	LDYc byte_5F
	LDA (byte_5A),Y
	PHA
	BEQ loc_93F9
	JSR LoadRoomData

loc_93F9:
	LDAc byte_5F
	ASL A
	ASL A
	ASL A
	ASL A
	TAY
	PLA
	STA RoomDataRAM,Y
	BEQ locret_940F
	JSR ReadRoomData		; Parse	room data?
	INCc byte_5F
	BNE loc_93D1

locret_940F:
	RTS
; End of function GameState_2_LoadRoom

; =============== S U B	R O U T	I N E =======================================

; Parse	room data?

ReadRoomData:
	LDX #0
	STXc byte_C
	CMP #$90
	BCC loc_9420
	CMP #$A0
	BCS loc_9420
	INCc byte_C

loc_9420:
	INY
	LDA #0
	STAc byte_F
	STYc byte_E

loc_9429:
	LDYc byte_F
	LDA (off_58),Y
	CMP #$FF
	BNE loc_943A
	LDYc byte_E
	INY
	STA RoomDataRAM,Y
	RTS
; ---------------------------------------------------------------------------

loc_943A:
	INCc byte_F
	TAX					; X = byte read	from room data
	LDAc byte_AC
	BNE loc_9486
	TXA
	AND #$F0
	BNE loc_9496
	DEX
	TXA
	AND #$F
	STAc byte_AC
	LDAc byte_5F
	BNE loc_9466
	LDAc byte_E
	AND #$F0
	TAY
	LDA RoomDataRAM,Y
	CMP #$90
	BCS loc_9466
	LDA #1
	STAc byte_B

loc_9466:
	LDX #0
	LDAc byte_C
	BEQ loc_9496
	LDA #$18
	STAc byte_AC
	LDAc byte_F
	CLC
	ADCc off_58
	STA a:byte_90
	LDAc off_58+1
	ADC #0
	STA a:byte_91
	BNE loc_9496

loc_9486:
	LDX #0
	DECc byte_AC
	LDAc byte_B
	CMP #2
	BEQ loc_9498
	STXc byte_B
; ---------------------------------------------------------------------------
	.BYTE $2C				; BIT $0FE6
					; (uses	INC $F below as	its operand)
; ---------------------------------------------------------------------------

loc_9496:
	INC byte_F

loc_9498:
	STXc byte_D			; X = byte from	room data
	TXA
	JSR HandleRoomDataObject	; = when byte >= 0x80
	JMP loc_9429
; End of function ReadRoomData

; =============== S U B	R O U T	I N E =======================================

; = when byte >= 0x80

HandleRoomDataObject:
	LSR A
	LSR A
	LSR A
	LSR A
	CMP #$B
	BCS loc_94AD
	INCc byte_E

loc_94AD:
	JSR JumpTable
; ---------------------------------------------------------------------------
; this may have	something to do	with
; handling item/obj placements from
; room loading -- high byte of "item type"?
	.WORD JT_94AD_0
	.WORD JT_94AD_multi			; 1
	.WORD JT_94AD_multi			; 2
	.WORD JT_94AD_multi			; 3
	.WORD JT_94AD_multi			; 4
	.WORD JT_94AD_5_6			; 5
	.WORD JT_94AD_5_6			; 6
	.WORD JT_94AD_7			; 7
	.WORD JT_94AD_8_Door		; 8
	.WORD JT_94AD_multi			; 9
	.WORD JT_94AD_multi			; $A
	.WORD JT_94AD_rts			; $B
	.WORD JT_94AD_rts			; $C
	.WORD JT_94AD_rts			; $D
	.WORD JT_94AD_E			; $E
; End of function HandleRoomDataObject

; =============== S U B	R O U T	I N E =======================================

JT_94AD_0:
	LDYc byte_E
	LDA #5
	STA RoomDataRAM,Y
	LDXc byte_B
	BEQ locret_94E8
	DEX
	BEQ loc_94E3
	LDAc byte_AC
	BNE locret_94E8

loc_94E3:
	LDA #$85
	STA RoomDataRAM,Y

locret_94E8:
	RTS
; End of function JT_94AD_0

; =============== S U B	R O U T	I N E =======================================

JT_94AD_multi:
	LDYc byte_E
	LDX #$10
	LDAc byte_D
	AND #$F0
	CMP #$30
	BEQ loc_94FB
	CMP #$40
	BNE loc_94FC

loc_94FB:
	INX

loc_94FC:
	TXA
	STA RoomDataRAM,Y
	LDAc byte_D
	AND #$F
	CMP #6
	BNE loc_950C
	INCc byte_F

loc_950C:
	LDAc byte_D
	AND #$F0
	BPL locret_951B
	LDA #$20
	ORA RoomDataRAM,Y
	STA RoomDataRAM,Y

locret_951B:
	RTS
; End of function JT_94AD_multi

; =============== S U B	R O U T	I N E =======================================

JT_94AD_5_6:
	LDYc byte_E
	LDA #$33
	STA RoomDataRAM,Y
	RTS
; End of function JT_94AD_5_6

; =============== S U B	R O U T	I N E =======================================

JT_94AD_7:
	LDYc byte_F
	DEY
	DEY
	LDA (off_58),Y
	AND #$F
	LDYc byte_E
	STA RoomDataRAM,Y
	LDX #1
	CMP #9
	BEQ loc_953F
	INX
	CMP #$A
	BNE locret_954A

loc_953F:
	TXA
	BIT PlayerCrystalBallsCollected
	BEQ locret_954A
	LDA #$F
	STA RoomDataRAM,Y

locret_954A:
	RTS
; End of function JT_94AD_7

; =============== S U B	R O U T	I N E =======================================

JT_94AD_8_Door:
	LDYc byte_F			; bytes	into room data
	DEY
	LDA (off_58),Y			; load previous	room data byte
	AND #7				; lower	bits, "type" of	door?
	TAX
	LDA UnknownDoorTable97B0,X
	PHP
	LDXc byte_E
	STA RoomDataRAM,X
	PLP
	BPL locret_956C
	PHA
	LDA (off_58),Y
	LSR A
	LSR A
	LSR A
	TAX
	PLA
	STA MaybeSphinxFlags,X		; A=type X=index

locret_956C:
	RTS
; End of function JT_94AD_8_Door

; =============== S U B	R O U T	I N E =======================================

JT_94AD_rts:
	RTS
; End of function JT_94AD_rts

; =============== S U B	R O U T	I N E =======================================

JT_94AD_E:
	INCc byte_F
	RTS
; End of function JT_94AD_E

; =============== S U B	R O U T	I N E =======================================

LoadRoomData:
	TAY					; Y = A
	LDA #BasePointer_RoomDataPointers
	JSR LoadPointerTo050		; 5 -> RoomDataPointers
	DEY					; Y = Y	- 1
	TYA					; A = (A at start - 1)
	ASL A				; * 2 for index
	BCC loc_9580			; If overflow,
	INCc word_50+1			;   inc	high byte by one

loc_9580:
	TAY					; Y = (A-1)*2
	LDA (word_50),Y
	STAc off_58
	INY
	LDA (word_50),Y
	STAc off_58+1
	LDA #0
	STAc byte_AC			; = 0
	RTS
; End of function LoadRoomData

; =============== S U B	R O U T	I N E =======================================

; maybe	check room data	for objs

sub_9592:
	LDY #0
	STYc MaybeCollectedThing
	LDA (off_58),Y
	CMP #$FF
	BNE loc_95A5
	LDA #0
	STAc byte_AC
	PLA
	PLA
	RTS
; ---------------------------------------------------------------------------

loc_95A5:
	LDX #0
	STX a:byte_71
	TAX
	LDAc byte_AC
	BEQ loc_95BD
	STXc byte_70
	DECc byte_AC
	LDA #0
	STA a:byte_5C
	BEQ loc_95E1

loc_95BD:
	STX a:byte_5C
	INY
	LDA (off_58),Y
	STA a:UnknownDoorFlag
	STAc byte_70
	TXA
	AND #$F0
	BNE loc_95E1
	DEX
	TXA
	AND #$F
	STAc byte_AC
	LDA #RF_BombRoom
	BIT a:RoomStatusFlags
	BEQ loc_95E1
	LDA #$18
	STAc byte_AC

loc_95E1:
	INY
	STYc byte_0
	LDYc byte_5A
	LDA RoomDataRAM,Y
	STAc MaybeCollectedThing
	AND #$1F
	TAX
	LDA ItemToTileTable,X
	STAc MaybeTileCollected
	LDA a:byte_5C
	CMP #$16
	BEQ loc_9612
	CMP #$36
	BEQ loc_9612
	CMP #$96
	BEQ loc_9612
	AND #$F0
	CMP #$E0
	BEQ loc_961A
	CMP #$80
	BEQ loc_961F
	BNE loc_9677

loc_9612:
	LDYc byte_0
	LDA (off_58),Y
	STA SphinxCollectedMaybe

loc_961A:
	INCc byte_0
	BNE loc_9677

loc_961F:
	LDYc byte_5A
	LDA a:UnknownDoorFlag
	AND #7
	TAX
	LDA UnknownDoorTable97B0,X
	BPL loc_963F
	LDA RoomDataRAM,Y
	BPL loc_963F
	LDA a:UnknownDoorFlag
	LSR A
	LSR A
	LSR A
	TAX
	LDA MaybeSphinxFlags,X
	STA RoomDataRAM,Y

loc_963F:
	LDAc byte_5C
	AND #$F
	ASL A
	ASL A
	TAX
	LDA DoorPositionTileTable,X
	STAc byte_70
	LDA DoorPositionTileTable+1,X
	STAc byte_71
	LDA RoomDataRAM,Y
	LDY #2
	ASL A
	BMI loc_9660
	LDY #0
	BCC loc_9660
	INX

loc_9660:
	STYc byte_14
	CLC
	LDA DoorPositionTileTable+2,X
	ADCc byte_14
	STAc MaybeTileCollected
	LDA DoorPositionTileTable+2,X
	SEC
	ADCc byte_14
	STAc byte_73

loc_9677:
	LDAc byte_0
	CLC
	ADCc off_58
	STAc off_58
	LDAc off_58+1
	ADC #0
	STAc off_58+1
	LDAc byte_5C
	AND #$F0
	CMP #$B0
	BCS locret_9695
	INCc byte_5A

locret_9695:
	RTS
; End of function sub_9592

; =============== S U B	R O U T	I N E =======================================

sub_9696:
	LDA CurrentRoomID
	JSR IfNotTitleScreenRoomDoThings ; A=room. double-returns if Z set
	LDAc PPUCtrlMirror
	AND #$FB
	STA PPUCTRL
	STAc word_50+1

loc_96A7:
	JSR sub_9592
	LDX #0
	JSR sub_96B7
	LDX #1
	JSR sub_96B7
	JMP loc_96A7
; End of function sub_9696

; =============== S U B	R O U T	I N E =======================================

sub_96B7:
	JSR sub_96F5
	TXA
	PHA
	LDA a:byte_70,X
	JSR sub_92AD
	PLA
	TAX
	LDA a:MaybeTileCollected,X
	PHA
	JSR HandleTileAttributes
	PLA
	JSR sub_9716
	JSR sub_9729
; End of function sub_96B7

; =============== S U B	R O U T	I N E =======================================

; copies $40 bytes from	buffer area
; to PPU area at $23C0

CopyAttributeTableToPPU:
	LDX #0
	LDAc PPUCtrlMirror
	AND #$FB
	STA PPUCTRL
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$C0
	STA PPUADDR

loc_96E9:
	LDA PaletteBuffer,X
	STA PPUDATA
	INX
	CPX #$40
	BNE loc_96E9
	RTS
; End of function CopyAttributeTableToPPU

; =============== S U B	R O U T	I N E =======================================

sub_96F5:
	LDA a:byte_70,X
	BEQ loc_9713
	LDAc byte_5C
	AND #$F0
	CMP #$B0
	BCS loc_970C
	LDAc MaybeCollectedThing
	AND #$20
	BNE loc_9713
	BEQ locret_9715

loc_970C:
	CMP #$D0
	BNE loc_9713
	JSR sub_A270

loc_9713:
	PLA
	PLA

locret_9715:
	RTS
; End of function sub_96F5

; =============== S U B	R O U T	I N E =======================================

sub_9716:
	JSR LoadLayoutChunk
	LDY #0

loc_971B:
	LDA (byte_6),Y
	STA PPUUpdateBuffer,Y
	INY
	CPY #4
	BNE loc_971B
	INC a:PPUUpdateFlag2
	RTS
; End of function sub_9716

; =============== S U B	R O U T	I N E =======================================

sub_9729:
	LDY #0
	LDA PPUSTATUS
	LDA byte_3EF
	ORA #$20
	STA PPUADDR
	LDA byte_3F0
	STA PPUADDR
	LDA PPUUpdateBuffer,Y
	STA PPUDATA
	INY
	LDA PPUUpdateBuffer,Y
	STA PPUDATA
	LDA byte_3F0
	CLC
	ADC #$20
	PHA
	LDA byte_3EF
	ADC #$20
	STA PPUADDR
	PLA
	STA PPUADDR
	INY
	LDA PPUUpdateBuffer,Y
	STA PPUDATA
	INY
	LDA PPUUpdateBuffer,Y
	STA PPUDATA
	LDA #0
	STA a:PPUUpdateFlag2
	RTS
; End of function sub_9729

; ---------------------------------------------------------------------------
DoorPositionTileTable:
	.BYTE  $11, $12, $87, $95	 ;	DATA XREF: sub_9592+B5r
	.BYTE  $1D,	$1E, $87, $95		; 4 ; position Y,X Y,X
	.BYTE  $11,	$12, $87, $95		; 8 ; first tile (inactive)
	.BYTE  $1D,	$1E, $87, $95		; $C ; first tile (active)?
	.BYTE  $E1,	$E2, $87, $95		; $10
	.BYTE  $ED,	$EE, $87, $95		; $14
	.BYTE  $D1,	$D2, $87, $95		; $18
	.BYTE  $DD,	$DE, $87, $95		; $1C
	.BYTE  $2C,	$3C, $8B, $97		; $20
	.BYTE  $BF,	$CF, $8B, $97		; $24
	.BYTE  $2F,	$3F, $8B, $97		; $28
	.BYTE  $BF,	$CF, $8B, $97		; $2C
	.BYTE  $23,	$33, $8B, $97		; $30
	.BYTE  $B0,	$C0, $8B, $97		; $34
	.BYTE  $20,	$30, $8B, $97		; $38
	.BYTE  $B0,	$C0, $8B, $97		; $3C
UnknownDoorTable97B0:
	.BYTE $12
	.BYTE	$52			; 1 ; entry #2:
IFDEF REV_A
	; POI: not exactly sure why this change is here...
	; door type 2 is only used by two (broken? uopenable?)
	; doors in the JP version; in US they were switched
	.BYTE	$32
ELSE
	.BYTE	$72			; 2 ; #$72 here	/ #$32 in REV A	/ #$72 in US
ENDIF
	.BYTE	$92			; 3
	.BYTE	$92			; 4
	.BYTE	$B2			; 5
	.BYTE	$B2			; 6
	.BYTE	$32			; 7

; =============== S U B	R O U T	I N E =======================================

HandleSpawnsAndMore:
	JSR HandleEnemySpawnTimer
	JSR sub_A29C
	JSR MaybeDrawEnemySprites
	LDAc PPUUpdateFlag1
	BNE loc_97CA
	NOP					; POI: sus
	NOP
	NOP
	RTS
; ---------------------------------------------------------------------------

loc_97CA:
	LDA CurrentRoomID
	JSR MaybeLoadRoomFlags		; called with room id
	LDA ObjectPointers
	STAc off_78
	LDA ObjectPointers+1
	STAc off_78+1
	LDX #0
	STX byte_330
	STX byte_314
	JSR sub_99EA
	LDA byte_330
	BEQ loc_9805
	LDA #0
	JSR sub_9965
	LDA CollisionFlag
	JSR sub_A1EB
	LDA CollisionFlag
	AND #8
	BEQ loc_9801
	JSR sub_A1B9

loc_9801:
	NOP					; POI: sus
	NOP
	NOP

locret_9804:
	RTS
; ---------------------------------------------------------------------------

loc_9805:
	LDA PlayerStruct
	BMI locret_9804
	LDA #3
	JSR sub_9813
	JSR sub_B645
	RTS
; End of function HandleSpawnsAndMore

; =============== S U B	R O U T	I N E =======================================

sub_9813:
	STAc byte_11
	LDA #8
	STAc byte_10

loc_981B:
	LDX byte_332
	INX
	CPX #8
	BNE loc_9825
	LDX #0

loc_9825:
	STX byte_332
	TXA
	JSR LoadObjectPointerAPlus1
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	LSR A
	BCC loc_984F
	AND #2
	BNE loc_984F
	LDX byte_332
	INX
	TXA
	JSR sub_9965
	LDY #1
	LDA (off_78),Y
	AND #4
	BEQ loc_984A
	JSR sub_BA4E

loc_984A:
	DECc byte_11
	BEQ locret_9854

loc_984F:
	DECc byte_10
	BNE loc_981B

locret_9854:
	RTS
; End of function sub_9813

; =============== S U B	R O U T	I N E =======================================

CheckObjectCollision:
	LDA PlayerStruct
	BMI locret_986E
	LDA #0
	STA CollisionTestResult
	LDY #EnemyStruct_5_XPosHi
	JSR CheckIfPlayerWithin8Pixels
	LDY #EnemyStruct_B_YPosHi
	JSR CheckIfPlayerWithin8Pixels
	LDA CollisionTestResult
	BEQ CollidedWithThing

locret_986E:
	RTS
; ---------------------------------------------------------------------------

CollidedWithThing:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y	; A = status
	LDY #EnemyStruct_12		; Y = #$12
	AND #$30
	BNE loc_9890			; if either set, jump ahead
	LDA (EnemyStructPointer),Y	; +#$12
	BNE locret_986E
	LDA a:UnknownFlag_0FE
	BNE locret_986E
	LDA PlayerStruct
	ORA #$80
	STA PlayerStruct		; kill player
	LDA #0
	STA FireTilePlayerDiedTo	; = 0
	RTS
; ---------------------------------------------------------------------------

loc_9890:
	AND #$20
	BNE HandleCollectedItem
	LDA (EnemyStructPointer),Y
	BNE locret_986E

HandleCollectedItem:
	INY					; Y -> #$13
	LDA (EnemyStructPointer),Y	; A = object type
	PHA
	CMP #$A				; secret coin
	BEQ loc_98A3
	JSR RemoveEnemy			; removes from ptr $07A

loc_98A3:
	PLA
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD JT_98A4_multi
	.WORD JT_98A4_multi			; 1
	.WORD JT_98A4_multi			; 2
	.WORD JT_98A4_multi			; 3
	.WORD JT_98A4_multi			; 4
	.WORD JT_98A4_multi			; 5
	.WORD JT_98A4_multi			; 6
	.WORD JT_98A4_multi			; 7
	.WORD JT_98A4_8_PowerCoin		; 8
	.WORD JT_98A4_9_ExtraCoin		; 9
	.WORD JT_98A4_A_SecretCoin		; $A
	.WORD JT_98A4_B_BonusStatue		; $B
	.WORD JT_98A4_C			; $C
	.WORD JT_98A4_multi			; $D
	.WORD JT_98A4_E			; $E
	.WORD JT_98A4_multi			; $F
	.WORD JT_98A4_10_Brother		; $10
; End of function CheckObjectCollision

; =============== S U B	R O U T	I N E =======================================

JT_98A4_multi:
	LDA #Sound_CoinCollected
	JSR QueueSound			; coin
	LDX a:byte_54
	CPX #6
	BEQ loc_98D9
	INX
	STX a:byte_54

loc_98D9:
	LDY #$17
	INX
	TXA
	STA (EnemyStructPointer),Y
	JSR AddScore
	LDA byte_364
	AND #4
	BNE locret_98FB
	INC GoldCoinsCollected
	LDA GoldCoinsCollected
	CMP #40
	BCC locret_98FB
	LDA byte_364
	ORA #4
	STA byte_364

locret_98FB:
	RTS
; End of function JT_98A4_multi

; =============== S U B	R O U T	I N E =======================================

JT_98A4_9_ExtraCoin:
	JSR loc_9945
; End of function JT_98A4_9_ExtraCoin

; =============== S U B	R O U T	I N E =======================================

JT_98A4_10_Brother:
	LDA #$80
	STA a:MaybeCollectedThing2	; = #$80 (brother)
	LDA #Score_1E_INVALID		; POI: BUG: Invalid, ends up corrupting
					; player's Y subpixel. good work team
	JSR AddScore
	RTS
; End of function JT_98A4_10_Brother

; =============== S U B	R O U T	I N E =======================================

JT_98A4_A_SecretCoin:
	LDA PlayerMightyLevel		; Can only collect while
	CMP #3				; at mighty level 3
	BNE locret_9926
	JSR RemoveEnemy			; removes from ptr $07A
	LDA #Score_50000
	JSR AddScore
	LDA #Sound_CoinCollected
	JSR QueueSound			; (secret) coin
	INC PlayerSecretCoins
	LDA #1
	JSR AddAToGDV			; 1 point for S	coin

locret_9926:
	RTS
; End of function JT_98A4_A_SecretCoin

; =============== S U B	R O U T	I N E =======================================

JT_98A4_B_BonusStatue:
	LDA #Score_2000
	JSR AddScore
	LDA #Sound_BonusStatueCollected
	JSR QueueSound			; bonus	statue
	RTS
; End of function JT_98A4_B_BonusStatue

; =============== S U B	R O U T	I N E =======================================

JT_98A4_C:
	LDA #Sound_BombCollectedLit
	JSR QueueSound			; lit bomb
	LDA #Score_10000
	JSR AddScore
	RTS
; End of function JT_98A4_C

; =============== S U B	R O U T	I N E =======================================

JT_98A4_E:
	LDA #Score_1000
	JSR AddScore
	INC ScoreMultiplier

loc_9945:
	LDA byte_364
	AND #$FD
	STA byte_364
	LDA #Sound_CoinCollected
	JSR QueueSound			; coin
	RTS
; End of function JT_98A4_E

; =============== S U B	R O U T	I N E =======================================

CheckIfPlayerWithin8Pixels:
	LDA PlayerStruct,Y
	SEC
	SBC (EnemyStructPointer),Y
	BCS loc_995F
	EOR #$FF
	ADC #1

loc_995F:
	CMP #8				; if >=	8 pixels away
	ROL CollisionTestResult		; shift	in a 1 bit
	RTS
; End of function CheckIfPlayerWithin8Pixels

; =============== S U B	R O U T	I N E =======================================

sub_9965:
	STA a:byte_314
	PHA
	ASL A
	TAX
	LDA ObjectPointers,X
	STA a:off_78
	LDA ObjectPointers+1,X
	STA a:off_78+1
	LDA #0
	STA byte_30F
	PLA
	PHA
	BNE loc_9988
	LDA #$80
	ORA CollisionFlag
	STA CollisionFlag

loc_9988:
	LDY #$A
	LDX #3
	LDA (off_78),Y
	BPL loc_9992
	LDX #1

loc_9992:
	JSR sub_99EA
	PLA
	BNE loc_99AE
	LDX #7
	JSR sub_99EA
	LDX #5
	JSR sub_99EA
	LDA byte_30F
	ORA a:byte_312
	STA byte_30F
	JMP loc_99BB
; ---------------------------------------------------------------------------

loc_99AE:
	LDX #5
	LDY #4
	LDA (off_78),Y
	BMI loc_99B8
	LDX #7

loc_99B8:
	JSR sub_99EA

loc_99BB:
	LDY #1
	LDA (off_78),Y
	AND #$F0
	STA (off_78),Y
	LDA byte_30F
	AND #$AA
	LSR A
	STAc byte_0
	LDA byte_30F
	AND #$55
	ORAc byte_0
	STAc byte_0
	LDA #0
	LDX #4

loc_99DB:
	ASLc byte_0
	ASLc byte_0
	ROL A
	DEX
	BNE loc_99DB
	ORA (off_78),Y
	STA (off_78),Y
	RTS
; End of function sub_9965

; =============== S U B	R O U T	I N E =======================================

sub_99EA:
	LDA a:RoomStatusFlags
	AND #RF_ScrollStop
	BNE loc_99F4
	JMP loc_9A6B
; ---------------------------------------------------------------------------

loc_99F4:
	STX byte_1
	JSR sub_9A03
	LDA byte_1
	BEQ locret_9A02
	INC byte_1
	JSR sub_9A03

locret_9A02:
	RTS
; End of function sub_99EA

; =============== S U B	R O U T	I N E =======================================

sub_9A03:
	LDX #0
	LDA byte_1
	ASL A
	TAY
	LDA byte_A3D8,Y
	BPL loc_9A0F
	DEX

loc_9A0F:
	CLC
	ADC byte_3C2
	TAY
	TXA
	ADC #0
	STA byte_7
	TYA
	CLC
	LDY #5
	ADC (off_78),Y
	STA byte_0
	LDA byte_7
	ADC #0
	BEQ loc_9A39
	LDA #$10
	BIT a:RoomStatusFlags
	BNE loc_9A39
	LDX a:RoomStatusFlags
	BMI loc_9A39
	LDY #3
	LDA (off_3D),Y
	BNE loc_9A3C

loc_9A39:
	LDA CurrentRoomID

loc_9A3C:
	STA a:CurrentRoomIDBackup2
	JSR LoadRoomStuff
	LDA byte_1
	ASL A
	TAX
	LDA byte_A3D8+1,X
	LDY #$B
	CLC
	ADC (off_78),Y
	STA byte_9
	LDA #0
	JSR sub_9B39
	LDA byte_0
	LSR A
	LSR A
	LSR A
	LSR A
	STA byte_8
	LDA byte_9
	AND #$80
	ASL A
	ROL A
	TAY
	JSR HandleDrawHalfRow		; another pointer thing
	JSR sub_9B6A			; maybe	handle some tile collision ??
	RTS
; End of function sub_9A03

; ---------------------------------------------------------------------------

loc_9A6B:
	STX byte_1
	JSR sub_9A7A
	LDA byte_1
	BEQ locret_9A79
	INC byte_1
	JSR sub_9A7A

locret_9A79:
	RTS

; =============== S U B	R O U T	I N E =======================================

sub_9A7A:
	LDX #0
	LDA byte_1
	ASL A
	TAY
	INY
	LDA byte_A3D8,Y
	BPL loc_9A87
	DEX

loc_9A87:
	STA byte_0
	LDA a:RoomStatusFlags
	AND #RF_Horizontal|RF_SectionStart
	PHP
	LDY #$B
	LDA (off_78),Y
	PLP
	BNE loc_9A9D
	LDY byte_314
	BNE loc_9A9D
	LDA #$78

loc_9A9D:
	CLC
	ADC byte_0
	STA byte_0
	TXA
	ADC #0
	STA byte_7
	LDY #$F
	LDA byte_3C4
	CMP #$78
	BCC loc_9AC8
	ADC #$F
	CLC
	ADC byte_0
	TAX
	LDA byte_7
	ADC #0
	STA byte_7
	TXA
	CMP #$F0
	BCC loc_9ADB
	ADC #$EF
	NOP					; sus
	NOP
	JMP loc_9ADB
; ---------------------------------------------------------------------------

loc_9AC8:
	CLC
	ADC byte_0
	TAX
	LDA byte_7
	ADC #0
	STA byte_7
	TXA
	CMP #$F0
	BCC loc_9ADB
	ADC #$F
	INC byte_7

loc_9ADB:
	STA byte_0
	LDA CurrentRoomID
	LDX byte_7
	BEQ loc_9AF2
	LDX a:RoomStatusFlags
	BMI loc_9AF2
	LDY #2
	LDA (off_3D),Y
	BNE loc_9AF2
	LDA CurrentRoomID

loc_9AF2:
	STA a:CurrentRoomIDBackup2
	LDX byte_314
	BNE loc_9B0D
	CMP CurrentRoomIDBackup
	BEQ loc_9B0D
	STA CurrentRoomIDBackup
	LDA a:byte_F4
	EOR #1
	STA a:byte_F4
	LDA a:CurrentRoomIDBackup2

loc_9B0D:
	JSR LoadRoomStuff
	LDA byte_0
	LSR A
	LSR A
	LSR A
	LSR A
	STA byte_8
	LDA byte_1
	ASL A
	TAX
	LDA byte_A3D8,X
	CLC
	LDY #5
	ADC (off_78),Y
	STA byte_9
	LDA #1
	JSR sub_9B39
	LDA byte_9
	AND #$80
	ASL A
	ROL A
	TAY
	JSR HandleDrawHalfRow		; another pointer thing
	JSR sub_9B6A			; maybe	handle some tile collision ??
	RTS
; End of function sub_9A7A

; =============== S U B	R O U T	I N E =======================================

sub_9B39:
	LDX byte_1
	BNE locret_9B69
	LDX a:CurrentRoomIDBackup2
	STX a:CurrentRoomIDBackup3
	TAX
	LDA byte_0
	PHA
	STA a:PlayerX_Lo,X
	TXA
	EOR #1
	TAX
	LDA byte_9
	STA a:PlayerX_Lo,X
	JSR BigBeefySubHandlesBGColliding
	PLA
	STA byte_0
	LDA a:CurrentRoomIDBackup3
	CMP CurrentRoomIDBackup4
	BEQ locret_9B69
	STA CurrentRoomIDBackup4
	LDA #$80
	STA MaybeHandleDoorFlag		; |= #$80

locret_9B69:
	RTS
; End of function sub_9B39

; =============== S U B	R O U T	I N E =======================================

; maybe	handle some tile collision ??

sub_9B6A:
	LDA byte_9
	AND #$70
	LSR A
	LSR A
	LSR A
	LSR A
	TAY
	LDA (off_4),Y
	STA a:TilePlayerCollidedWith
	LDA a:RoomStatusFlags
	AND #RF_ScrollStop
	BNE loc_9B87
	LDX byte_0
	LDY byte_9
	STY byte_0
	STX byte_9

loc_9B87:
	LDY #1
	LDA (off_78),Y
	BPL loc_9BBB
	LDA byte_320
	BEQ loc_9BBB
	LDA a:CurrentRoomIDBackup2
	CMP a:CurrentRoomIDBackup3
	BNE loc_9BBB
	LDA byte_9
	AND #$F0
	STA byte_A
	LDA byte_0
	LSR A
	LSR A
	LSR A
	LSR A
	ORA byte_A
	STA byte_A
	LDY byte_320
	LDX #1

loc_9BAF:
	DEY
	BMI loc_9BBB
	CMP byte_320,X
	BEQ locret_9BBA
	INX
	BNE loc_9BAF

locret_9BBA:
	RTS
; ---------------------------------------------------------------------------

loc_9BBB:
	LDX a:TilePlayerCollidedWith	; POI: ??? tile	checks?
	LDA #0
	CPX #0				; nothing
	BEQ loc_9C05
	CPX #$2F
	BEQ loc_9C05
	CPX #$27
	BEQ loc_9C05
	LDY PlayerStruct		; if high bit set, skip
	BMI loc_9BEB
	CPX #$5C
	BCC loc_9BEB			; if <	5C, skip
	CPX #$63
	BCS loc_9BEB			; if >=	63, skip
	LDY byte_1			; ?
	BNE loc_9C05			; if not 0, skip
	STX FireTilePlayerDiedTo	; = tile collided with to die
	LDA PlayerStruct
	ORA #$80
	STA PlayerStruct		; | #$80 (dead)
	PLA
	PLA
	RTS
; ---------------------------------------------------------------------------

loc_9BEB:
	EOR #$FF
	CPX #$38
	BCC loc_9C05
	CPX #$4C
	BCS loc_9C05
	TXA
	SBC #$37
	LSR A
	TAX
	LDA byte_A3EA,X
	BCC loc_9C03
	ASL A
	ASL A
	ASL A
	ASL A

loc_9C03:
	AND #$F0

loc_9C05:
	STA byte_6
	LDY #2
	LDA byte_9
	AND #8
	BNE loc_9C11
	DEY
	DEY

loc_9C11:
	LDA byte_0
	AND #8
	BEQ loc_9C18
	INY

loc_9C18:
	ASL byte_6
	DEY
	BPL loc_9C18
	LDX byte_1
	DEX
	LDA byte_A406,X
	AND byte_30F
	STA byte_30F
	LDA #0

loc_9C2B:
	ROR A
	DEX
	BPL loc_9C2B
	ORA byte_30F
	STA byte_30F
	RTS
; End of function sub_9B6A

; =============== S U B	R O U T	I N E =======================================

BigBeefySubHandlesBGColliding:
	LDA a:PlayerY_Lo
	AND #$F0
	STA byte_A
	LDA a:PlayerX_Lo
	LSR A
	LSR A
	LSR A
	LSR A
	ORA byte_A
	STA byte_A
	LDX #0
	LDY #8
	LDA PlayerYVelHi
	BPL loc_9C54
	LDY #$F8
	DEX

loc_9C54:
	CLC
	TYA
	ADC a:PlayerY_Lo
	AND #$F0
	STA byte_B
	TXA
	ADC #0
	TAX
	LDA byte_A
	AND #$F
	ORA byte_B
	STA byte_B
	CMP byte_333
	STA byte_333
	BEQ loc_9C74
	INC byte_330

loc_9C74:
	TXA
	BEQ loc_9C7B
	LDA #0
	STA byte_B

loc_9C7B:
	LDY #8
	LDX #0
	LDA Joypad1_Immediate
	AND #JP_Right|JP_Left
	BNE loc_9C89
	LDA a:byte_EE

loc_9C89:
	STA a:byte_EE
	LSR A
	BCS loc_9C92
	LDY #$F8
	DEX

loc_9C92:
	CLC
	TYA
	ADC a:PlayerX_Lo
	TAY
	TXA
	ADC #0
	TAX
	TYA
	LSR A
	LSR A
	LSR A
	LSR A
	STA byte_E
	LDA byte_A
	AND #$F0
	ORA byte_E
	STA byte_E
	CMP byte_334
	STA byte_334
	BEQ loc_9CB6
	INC byte_330

loc_9CB6:
	TXA
	BEQ loc_9CBD
	LDA #0
	STA byte_E

loc_9CBD:
	LDA byte_330
	BNE loc_9CC3

locret_9CC2:
	RTS
; ---------------------------------------------------------------------------

loc_9CC3:
	LDA PlayerStruct
	BMI locret_9CC2
	LDA a:JustJumpedFlag
	BEQ loc_9CDB
	LDA #0
	STA a:JustJumpedFlag		; cleared
	LDA a:byte_F0
	BEQ loc_9CDB
	JSR MaybeOpenHiddenBlock
	RTS
; ---------------------------------------------------------------------------

loc_9CDB:
	LDA #0
	STA a:byte_312
	STA a:byte_F0
	STA byte_320
	LDA a:CurrentRoomIDBackup3
	JSR IfNotTitleScreenRoomDoThings ; A=room. double-returns if Z set
	LDA #0
	STA DoorIsAnimatingMaybe

loc_9CF1:
	JSR sub_9592
	LDX byte_320
	LDA a:byte_5C
	AND #$F0
	BPL loc_9D04
	CMP #$B0
	BCS loc_9CF1
	BCC loc_9D08

loc_9D04:
	CMP #$60
	BNE loc_9D1F

loc_9D08:
	LDAc MaybeCollectedThing
	AND #$20
	BNE loc_9D1F
	INX
	LDAc byte_70
	STA byte_320,X
	LDA a:byte_71
	BEQ loc_9D1F
	INX
	STA byte_320,X

loc_9D1F:
	STX byte_320
	LDAc byte_70
	CMP byte_A
	BEQ loc_9D88
	LDA #0
	STAc byte_310
	LDX byte_B
	BEQ loc_9D5A
	CPXc byte_70
	BEQ loc_9D43
	LDAc byte_71
	BEQ loc_9D5A
	CMP byte_B
	BNE loc_9D5A
	STAc byte_70

loc_9D43:
	LDAc MaybeCollectedThing
	AND #$1F
	CMP #$10
	BCC loc_9D88
	LDA #$C0
	LDX PlayerYVelHi
	BMI loc_9D82
	INC byte_310
	LDA #$30
	BNE loc_9D82

loc_9D5A:
	LDX byte_E
	BEQ loc_9CF1
	CPXc byte_70
	BEQ loc_9D6F
	LDAc byte_71
	BEQ loc_9CF1
	CMP byte_E
	BNE loc_9CF1
	STAc byte_70

loc_9D6F:
	LDAc MaybeCollectedThing
	AND #$1F
	CMP #$10
	BCC loc_9D88
	LDA a:byte_EE
	LSR A
	LDA #3
	BCS loc_9D82
	LDA #$C

loc_9D82:
	ORA byte_312
	STA byte_312

loc_9D88:
	LDAc MaybeCollectedThing
	AND #$1F
	CMP #$F
	BCS loc_9D99
	LDX byte_A
	CPXc byte_70
	BEQ loc_9D99
	RTS
; ---------------------------------------------------------------------------

loc_9D99:
	CMP #$F
	BNE loc_9DA0
	JMP loc_9CF1
; ---------------------------------------------------------------------------

loc_9DA0:
	DEC a:byte_5A
	LDAc MaybeCollectedThing
	AND #$1F
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD MaybePickupItem		; 00  4D   100 pt bag
	.WORD MaybePickupItem		; 01  4E   300 pt bag
	.WORD MaybePickupItem		; 02  4F  1000 pt bag
	.WORD MaybePickupItem		; 03  47  gold coin
	.WORD MaybePickupItem		; 04  49  mighty drink
	.WORD JTPickup_Bomb			; 05  27  bomb
	.WORD MaybePickupItem		; 06  34  sphinx
	.WORD MaybePickupItem		; 07  48  tecmo plate
	.WORD MaybePickupItem		; 08  8F  mighty coin
	.WORD MaybePickupItem		; 09  4C  crystal ball
	.WORD MaybePickupItem		; 0A  4C  crystal ball
	.WORD JTPickup_Family		; %0  63  king
	.WORD JTPickup_Family		; 0C  91  queen
	.WORD JTPickup_Family		; 0D  90  princess
	.WORD JTPickup_Beelzebub	; 0E  50  belzebut mask
	.WORD MaybePickupItem		; 0F  2F  (nothing(?))
	.WORD JTPickup_Chest		; 10  28  red chest
	.WORD JTPickup_Chest2		; 11  4A  orange chest
	.WORD JTPickup_Door			; 12
	.WORD JTPickup_Chest		; 13
; End of function BigBeefySubHandlesBGColliding

; =============== S U B	R O U T	I N E =======================================

MaybePickupItem:
	LDAc byte_70
	JSR sub_92AD
	LDA #$2F
	JSR HandleTileAttributes
	LDA #$2F
	JSR sub_9716
	LDYc byte_5A
	LDA RoomDataRAM,Y
	TAX
	LDA #$F
	STA RoomDataRAM,Y
	TXA
	AND #$1F			; shouldn't this be "AND #$F"?
	JSR JumpTable
; ---------------------------------------------------------------------------
; chest	item pickups?
	.WORD JTPickup_Bag100		; 0: bag, 100
	.WORD JTPickup_Bag300		; 1: bag, 300
	.WORD JTPickup_Bag1000		; 2: bag, 1000
	.WORD JTPickup_GoldCoin		; 3: gold coin
	.WORD JTPickup_MightyDrink	; 4: mighty drink
	.WORD JT_9DF2_rts			; 5: bomb
	.WORD JTPickup_Sphinx		; 6: sphinx
	.WORD JTPickup_TecmoPlate	; 7: tecmo plate
	.WORD JTPickup_MightyCoin	; 8: mighty coin
	.WORD JTPickup_CrystalBall1	; 9: crystal ball 1
	.WORD JTPickup_CrystalBall2	; A: crystal ball 2
	.WORD JT_9DF2_rts			; B: king
	.WORD JT_9DF2_rts			; C: queen
	.WORD JT_9DF2_rts			; D: princess
	.WORD JT_9DF2_rts			; E: beelzebub
	.WORD JT_9DF2_F_rts			; F: --
; End of function MaybePickupItem

; =============== S U B	R O U T	I N E =======================================

JT_9DF2_rts:
	RTS
; End of function JT_9DF2_rts

; =============== S U B	R O U T	I N E =======================================

JTPickup_Bag100:
	LDA #Score_100
	BNE loc_9E1F
; End of function JTPickup_Bag100

; =============== S U B	R O U T	I N E =======================================

JTPickup_Bag300:
	LDA #Score_300
; End of function JTPickup_Bag300

; ---------------------------------------------------------------------------
	.BYTE $2C				; useless BIT $xxxx instruction

; =============== S U B	R O U T	I N E =======================================

JTPickup_Bag1000:
	LDA #Score_1000

loc_9E1F:
	JSR AddScore
	LDA #Sound_BombCollectedLit
	JSR QueueSound			; lit bomb
	RTS
; End of function JTPickup_Bag1000

; =============== S U B	R O U T	I N E =======================================

JTPickup_GoldCoin:
	LDA #Score_500
	JSR AddScore
	INC GoldCoinsCollected
	LDA #Sound_CoinCollected
	JSR QueueSound			; coin
	RTS
; End of function JTPickup_GoldCoin

; =============== S U B	R O U T	I N E =======================================

JTPickup_MightyDrink:
	LDA #Score_1000
	JSR AddScore
	LDA #Sound_TimePickup		; mighty milk yum
	JSR QueueSound			; mighty drink
	LDAc StageTimer
	CLC
	ADC #$10
	STAc StageTimer
	CMP #$A0
	BCC locret_9E5A			; if over 99, go to torture room
; End of function JTPickup_MightyDrink

; =============== S U B	R O U T	I N E =======================================

GoToTheTortureRoom:
	LDA #0
	STA PlayerMightyCoins
	STA TortureRoomSceneFlag
	LDA #7
	STAc GameState			; -> 7

locret_9E5A:
	RTS
; End of function GoToTheTortureRoom

; =============== S U B	R O U T	I N E =======================================

JTPickup_Bomb:
	LDYc byte_5A
	LDA RoomDataRAM,Y
	LDX #1
	AND #$40
	BEQ loc_9E68
	INX

loc_9E68:
	STXc byte_0
	LDA MaybeTempCollectableFlag
	BNE loc_9E94
	TXA
	CLC
	ADC MaybeTempCollectableFlag2
	STA MaybeTempCollectableFlag2
	CMP #20
	BCC loc_9E94
	INC MaybeTempCollectableFlag
	LDY #Sound_BombChestBonus	; next chest opened contains power coin
	LDA a:RoomStatusFlags
	AND #2
	BEQ loc_9E8D
	JSR SpawnPowerCoin
	LDY #Sound_PowerCoinSpawn	; (bomb	room item that coins enemies)

loc_9E8D:
	TYA
	JSR QueueSound
	JMP loc_9E9D
; ---------------------------------------------------------------------------

loc_9E94:
	LDAc byte_0
	CLC
	ADC #6				; 7 / 8	are bomb pickup	sounds
	JSR QueueSound			; bomb pickup?

loc_9E9D:
	LDAc byte_0
	JSR AddScore
	LDA #0
	JSR sub_A270
	LDA a:RoomStatusFlags
	AND #RF_BombRoom
	BEQ loc_9EB2
	JMP loc_9F4B
; ---------------------------------------------------------------------------

loc_9EB2:
	LDA a:byte_F7
	BNE loc_9EDB
	INC a:byte_F7
	LDYc byte_5A
	LDA RoomDataRAM,Y
	BPL loc_9EC9
	LDA #1
	STA a:MaybeBombThing		; maybe	related	to all fire bombs
	BNE loc_9F1E

loc_9EC9:
	TYA
	AND #$F0
	TAX
	LDA RoomDataRAM,X
	CMP #$90
	BCS loc_9F1E
	LDA #0
	STA a:MaybeBombThing		; maybe	related	to all fire bombs
	BEQ loc_9F1E

loc_9EDB:
	LDYc byte_5A
	LDA RoomDataRAM,Y
	AND #$40
	BEQ loc_9F09
	LDA RoomDataRAM,Y
	BPL loc_9F1E
	LDA #1
	CMP a:MaybeBombThing		; maybe	related	to all fire bombs
	BNE loc_9F1E
	LDA a:MaybeBombThing		; maybe	related	to all fire bombs
	ORA #$80
	STA a:MaybeBombThing		; maybe	related	to all fire bombs
	LDA #Score_10000
	JSR AddScore
	LDA #Sound_BombBonus		; collected bombs in right order
	JSR QueueSound			; bomb bonus
	LDYc byte_5A
	JMP loc_9F1E
; ---------------------------------------------------------------------------

loc_9F09:
	TYA
	AND #$F0
	TAX
	LDA RoomDataRAM,X
	CMP #$90
	BCS loc_9F48
	LDA #2
	ORA a:MaybeBombThing		; maybe	related	to all fire bombs
	STA a:MaybeBombThing		; maybe	related	to all fire bombs
	BNE loc_9F48

loc_9F1E:
	LDX #$C

loc_9F20:
	INY
	LDA RoomDataRAM,Y
	CMP #$FF
	BEQ loc_9F31
	AND #$7F
	CMP #5
	BEQ loc_9F40
	DEX
	BNE loc_9F20

loc_9F31:
	TYA
	AND #$F0
	CLC
	ADC #$10
	TAY
	LDA RoomDataRAM,Y
	BEQ loc_9F48
	INY
	BNE loc_9F1E

loc_9F40:
	LDA RoomDataRAM,Y
	ORA #$40
	STA RoomDataRAM,Y

loc_9F48:
	JMP MaybePickupItem
; ---------------------------------------------------------------------------

loc_9F4B:
	LDA a:byte_F7
	BNE loc_9F60
	INC a:byte_F7
	LDY a:byte_5A
	LDX #0
	STXc FireBombsCollected
	STXc FireBombsCollected2
	BEQ loc_9F8C

loc_9F60:
	LDYc byte_5A
	LDA RoomDataRAM,Y
	AND #$40
	BEQ loc_9F6D
	INCc FireBombsCollected

loc_9F6D:
	INCc FireBombsCollected2
	LDAc FireBombsCollected2
	CMP #23				; bomb rooms have 23 bombs?
	BNE loc_9F82
	LDA #$F8
	STA SpriteDMAArea+$10
	JSR OpenBombRoomDoor
	JMP loc_9FAB
; ---------------------------------------------------------------------------

loc_9F82:
	LDA RoomDataRAM,Y
	AND #$40
	BEQ loc_9FAB
	LDYc byte_5A

loc_9F8C:
	INY
	LDA RoomDataRAM,Y
	CMP #$FF
	BNE loc_9F98
	LDY #$81
	BNE loc_9F8C

loc_9F98:
	CMP #5
	BNE loc_9F8C
	ORA #$40
	STA RoomDataRAM,Y
	TYA
	SEC
	SBC #$84
	TAY
	LDA (byte_90),Y
	JSR MaybeDrawFireBombSprite

loc_9FAB:
	JMP MaybePickupItem
; End of function JTPickup_Bomb

; =============== S U B	R O U T	I N E =======================================

JTPickup_Sphinx:
	LDA #Score_10000
	JSR AddScore
	LDX SphinxCollectedMaybe
	JMP HandleSphinxEvent		; X = id?
; End of function JTPickup_Sphinx

; =============== S U B	R O U T	I N E =======================================

JTPickup_TecmoPlate:
	LDA #Score_100000
	JSR AddScore
	LDA #$80
	STA a:MaybeCollectedThing2	; = #$80 (tecmo	plate)
	RTS
; End of function JTPickup_TecmoPlate

; =============== S U B	R O U T	I N E =======================================

JTPickup_MightyCoin:
	LDA #Score_1000
	JSR AddScore
	LDA #Sound_CoinCollected
	JSR QueueSound			; mighty coin
	INC PlayerMightyCoins
	LDA PlayerMightyCoins
	CMP #10
	BCC locret_9FDB
	JMP GoToTheTortureRoom
; ---------------------------------------------------------------------------

locret_9FDB:
	RTS
; End of function JTPickup_MightyCoin

; =============== S U B	R O U T	I N E =======================================

JTPickup_CrystalBall1:
	LDA #1
; End of function JTPickup_CrystalBall1

; ---------------------------------------------------------------------------
	.BYTE $2C				; useless BIT instruction

; =============== S U B	R O U T	I N E =======================================

JTPickup_CrystalBall2:
	LDA #2
	ORA PlayerCrystalBallsCollected
	STA PlayerCrystalBallsCollected
	LDA #Sound_CrystalBall
	JSR QueueSound			; crystal ball
	LDA #1
	JSR AddAToGDV			; 1 point for crystal ball
	RTS
; End of function JTPickup_CrystalBall2

; =============== S U B	R O U T	I N E =======================================

JTPickup_Family:
	LDYc byte_5A
	LDA RoomDataRAM,Y
	CLC
	ADC #6
	PHA
	JSR MaybePickupItem
	PLA
	TAX
	JMP loc_AACF
; End of function JTPickup_Family

; =============== S U B	R O U T	I N E =======================================

JTPickup_Beelzebub:
	LDA #Music_CollectedFullFamily
	JSR QueueSound			; full family collected
IFDEF REV_US
	LDA #Score_1000000
	JSR AddScore
ENDIF
	JMP JTPickup_Family
; End of function JTPickup_Beelzebub

; =============== S U B	R O U T	I N E =======================================

JT_9DF2_F_rts:
	RTS
; End of function JT_9DF2_F_rts

; =============== S U B	R O U T	I N E =======================================

JTPickup_Chest:
	LDAc MaybeCollectedThing
	AND #$20
	BEQ loc_A01F
	LDA byte_310
	BNE loc_A01F
	LDA #0
	STA byte_312
	RTS
; ---------------------------------------------------------------------------

loc_A01F:
	LDAc byte_70
	STA a:byte_F0
	LDAc byte_5C
	STA a:_MaybeBlockSpawningObj
	LDAc byte_5A
	STA a:byte_74
	LDA a:byte_F4
	STA byte_311
	LDAc MaybeCollectedThing
	STA byte_313
	LDA byte_310
	BNE locret_A05B
	LDA #0
	STA a:byte_F0
	LDA a:MaybeCollectedThing
	AND #$20
	BNE locret_A05B
	LDA PlayerMightyLevel
	CMP #2
	BCC locret_A05B
	LDAc byte_70
	JSR MaybeOpenHiddenBlock

locret_A05B:
	RTS
; End of function JTPickup_Chest

; =============== S U B	R O U T	I N E =======================================

JTPickup_Chest2:
	LDA PlayerMightyLevel
	BEQ locret_A064
	JMP JTPickup_Chest
; ---------------------------------------------------------------------------

locret_A064:
	RTS
; End of function JTPickup_Chest2

; =============== S U B	R O U T	I N E =======================================

JTPickup_Door:
	INC DoorIsAnimatingMaybe
	LDA a:UnknownDoorFlag
	STA a:UnknownDoorFlagCopy
	LDA a:MaybeCollectedThing
	AND #$20
	BEQ loc_A07B
	LDA #0
	STA byte_312
	RTS
; ---------------------------------------------------------------------------

loc_A07B:
	LDYc byte_5A
	LDA RoomDataRAM,Y
	AND #$40
	BEQ locret_A0A8
	LDA #0
	JSR QueueSound			; silence
	LDAc byte_5C
	AND #$F
	STA EntryDoorType
	LDA #9
	STAc GameState			; -> 9
	LDA a:UnknownDoorFlag
	LSR A
	BCS locret_A0A8
	LDYc byte_5A
	LDA #$BF
	AND RoomDataRAM,Y
	STA RoomDataRAM,Y

locret_A0A8:
	RTS
; End of function JTPickup_Door

; ---------------------------------------------------------------------------
	.BYTE $60
; =============== S U B	R O U T	I N E =======================================

OpenBombRoomDoor:
	LDA #$B
	STAc GameState			; -> B
	LDA CurrentRoomID
	AND #$F
	ASL A
	TAX
	LDA MaybeEntryTypeTable+1,X
	STA EntryDoorType
	LDY #$83
	LDA #$52
	STA RoomDataRAM,Y		; ~ $686... but	why like this?
	RTS
; End of function OpenBombRoomDoor

; =============== S U B	R O U T	I N E =======================================

MaybeDrawFireBombSprite:
	PHA
	AND #$F0
	SEC
	SBC #4
	STA SpriteDMAArea+$10
	PLA
	ASL A
	ASL A
	ASL A
	ASL A
	CLC
	ADC #8
	STA SpriteDMAArea+$13
	LDA #$D
	STA SpriteDMAArea+$11
	LDA #$12
	STA SpriteDMAArea+$12
	RTS
; End of function MaybeDrawFireBombSprite

; =============== S U B	R O U T	I N E =======================================

MaybeOpenHiddenBlock:
	STA a:byte_F0
	TAX
	LDA a:_MaybeBlockSpawningObj
	AND #$F0
	CMP #$60
	BEQ loc_A126
	JSR sub_A18E
	LDA a:byte_313
	AND #$20
	BEQ loc_A0FD
	LSR A
	BNE loc_A10F

loc_A0FD:
	LDA a:_MaybeBlockSpawningObj
	AND #$F
	STA a:_MaybeBlockSpawningObj
	CMP #9
	BCC loc_A10C			; if an	enemy(?), skip ahead?
	JSR MaybeSpawnThingFromObject

loc_A10C:
	LDA a:_MaybeBlockSpawningObj

loc_A10F:
	CMP #7
	BNE loc_A11A
	LDX a:Collected1UPThisRoundFlag
	BEQ loc_A11A
	LDA #8

loc_A11A:
	JSR sub_A1A6
	LDA MaybeTempCollectableFlag
	BEQ locret_A125
	JSR SpawnPowerCoin

locret_A125:
	RTS
; ---------------------------------------------------------------------------

loc_A126:
	CPX byte_336
	BEQ loc_A136
	STX byte_336
	LDA a:_MaybeBlockSpawningObj
	AND #$F
	STA byte_335

loc_A136:
	DEC byte_335
	BEQ loc_A141
	LDA #0
	STA a:byte_312
	RTS
; ---------------------------------------------------------------------------

loc_A141:
	JSR sub_A18E
	LDA #$F
	STA byte_336
	JSR sub_A1A6
	LDA #Sound_SecretBlockRevealed	; and/or revealed
	JSR QueueSound			; secret block revealed
	RTS
; End of function MaybeOpenHiddenBlock

; =============== S U B	R O U T	I N E =======================================

MaybeSpawnThingFromObject:
	CMP #EnemyType_9_ExtraCoin	; POI: this might replace
					; 1ups with mighty coins?
	BNE _NotExtraCoin
	LDX a:Collected1UPThisRoundFlag
	BEQ _No1UPYet
	LDA #8				; mighty coin?
	STA a:_MaybeBlockSpawningObj
	RTS
; ---------------------------------------------------------------------------

_No1UPYet:
	PHA
	LDA #Sound_BonusCoinSpawn
	JSR QueueSound			; bonus	coin spawned
	PLA

_NotExtraCoin:
	STAc byte_12
	LDA #$F
	STA a:_MaybeBlockSpawningObj
	JSR sub_BA00
	LDA a:byte_F0
	JSR sub_9276
	LDAc byte_12
	JSR InitEnemy
	LDY #EnemyStruct_5_XPosHi
	LDAc byte_94
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_B_YPosHi
	LDAc byte_92
	STA (EnemyStructPointer),Y
	RTS
; End of function MaybeSpawnThingFromObject

; =============== S U B	R O U T	I N E =======================================

sub_A18E:
	LDA a:byte_F4
	PHA
	LDA a:byte_311
	STA a:byte_F4
	TXA
	JSR sub_92AD
	PLA
	STA a:byte_F4
	LDA #0
	STA a:byte_312
	RTS
; End of function sub_A18E

; =============== S U B	R O U T	I N E =======================================

sub_A1A6:
	LDY a:byte_74
	STA RoomDataRAM,Y
	TAX
	LDA ItemToTileTable,X
	PHA
	JSR HandleTileAttributes
	PLA
	JSR sub_9716
	RTS
; End of function sub_A1A6

; =============== S U B	R O U T	I N E =======================================

sub_A1B9:
	LDA a:byte_314
	BNE loc_A1E2
	LDA PlayerStruct
	ORA #2
	STA PlayerStruct
	LDA #$40
	STA byte_3E7
	LDA a:RoomStatusFlags
	AND #RF_ScrollStop
	BNE loc_A1E2
	LDA a:RoomStatusFlags
	AND #RF_Horizontal|RF_SectionStart
	BNE loc_A1E2
	LDA byte_3C4
	ORA #7
	STA byte_3C4
	RTS
; ---------------------------------------------------------------------------

loc_A1E2:
	LDY #$B
	LDA (off_78),Y
	ORA #7
	STA (off_78),Y
	RTS
; End of function sub_A1B9

; =============== S U B	R O U T	I N E =======================================

sub_A1EB:
	AND #4
	BNE loc_A20A
	LDA CollisionFlag		; turn off bit 4 (#$10)
	AND #11101111b
	STA CollisionFlag
	LDA #2
	BIT PlayerStruct
	BNE locret_A209
	ORA PlayerStruct
	STA PlayerStruct
	LDA #$40
	STA byte_3E7

locret_A209:
	RTS
; ---------------------------------------------------------------------------

loc_A20A:
	LDA PlayerStruct
	AND #$F9
	STA PlayerStruct
	LDA #$10
	BIT CollisionFlag		; checks against #$10
	BNE loc_A224
	ORA CollisionFlag		; turns	on bit 4 (#$10)
	STA CollisionFlag
	LDA #0
	STA byte_333

loc_A224:
	LDA byte_3C4
	AND #$F8
	STA byte_3C4
	LDA a:RoomStatusFlags
	AND #$20
	BNE loc_A23A
	LDA a:RoomStatusFlags
	AND #$C0
	BEQ loc_A242

loc_A23A:
	LDA PlayerYPosHi
	AND #$F8
	STA PlayerYPosHi

loc_A242:
	LDA #0
	STA PlayerSprite
	RTS
; End of function sub_A1EB

; =============== S U B	R O U T	I N E =======================================

unusedMaybe_A248:
	BEQ loc_A253			; POI: Unused pair of routines?
	LDA #2
	ORA CollisionFlag		; Toggles bit 1	(#$02) on/off
	STA CollisionFlag
	RTS
; ---------------------------------------------------------------------------

loc_A253:
	LDA CollisionFlag
	AND #~2
	STA CollisionFlag
	RTS
; End of function unusedMaybe_A248

; =============== S U B	R O U T	I N E =======================================

unusedMaybe_A25C:
	BEQ loc_A267			; POI: Unused pair of routines?
	LDA #1
	ORA CollisionFlag		; Toggles bit 0	(#$01) on/off
	STA CollisionFlag
	RTS
; ---------------------------------------------------------------------------

loc_A267:
	LDA CollisionFlag
	AND #~1
	STA CollisionFlag
	RTS
; End of function unusedMaybe_A25C

; =============== S U B	R O U T	I N E =======================================

sub_A270:
	LDA #BasePointer_RAM_786
	JSR LoadPointerTo050		; C (786)
	LDXc byte_5A
	LDA RoomDataRAM,X
	LDX #1
	AND #$40
	BEQ loc_A282
	INX

loc_A282:
	STX byte_787
	LDAc byte_70
	JSR sub_9276
	LDAc byte_94
	STA byte_789
	LDAc byte_92
	STA byte_78B
	LDA #$80
	STA byte_786
; End of function sub_A270

; =============== S U B	R O U T	I N E =======================================

sub_A29C:
	JSR MaybeAward1UP
	LDA #4
	BIT byte_786
	BNE loc_A2B1
	ORA byte_786
	STA byte_786
	LDA #4
	STA byte_78D

loc_A2B1:
	DEC byte_78D
	BNE loc_A2C3
	LDA #3
	STA byte_78D
	LDA SpriteDMAArea+$11
	EOR #2
	STA SpriteDMAArea+$11

loc_A2C3:
	LDA byte_786
	LSR A
	BCS loc_A2D8
	SEC
	ROL A
	BMI loc_A2CE
	RTS
; ---------------------------------------------------------------------------

loc_A2CE:
	STA byte_786
	LDY #6
	LDA #$20
	STA byte_78C

loc_A2D8:
	LDA #2
	BIT byte_786
	BNE loc_A2F3
	LDA #$25
	DEC byte_78C
	BNE loc_A30B
	LDA #2
	ORA byte_786
	STA byte_786
	LDA #$20
	STA byte_78C

loc_A2F3:
	DEC byte_78C
	BNE loc_A303
	LDA #0
	STA byte_786
	LDY #$14
	JSR ClearFourSpritesInY
	RTS
; ---------------------------------------------------------------------------

loc_A303:
	LDA byte_787
	JSR sub_8FB1			; score	popups?
	LDA #$80

loc_A30B:
	STAc TempSpriteTile
	LDA #0
	STAc TempSpriteAttributesish
	LDA #5
	STAc CurrentSpriteIndex
	JSR sub_A32B
	LDA byte_789
	STAc TempSpriteX
	LDA byte_78B
	STAc TempSpriteY
	JSR WriteSprite
	RTS
; End of function sub_A29C

; =============== S U B	R O U T	I N E =======================================

sub_A32B:
	LDA a:RoomStatusFlags
	AND #$10
	BEQ loc_A333
	RTS
; ---------------------------------------------------------------------------

loc_A333:
	LDY #2
	LDX #0
	JSR sub_A33E
	LDY #4
	LDX #2
; End of function sub_A32B

; =============== S U B	R O U T	I N E =======================================

sub_A33E:
	LDA a:byte_98,X
	CLC
	ADC byte_786,Y
	STA a:byte_786,Y
	INY
	LDA a:byte_99,X
	PHP
	LDX #0
	PLP
	BPL loc_A353
	DEX

loc_A353:
	ADC byte_786,Y
	STA a:byte_786,Y
	TXA
	ADC #0
	BEQ locret_A364
	LDY #0
	TYA
	STA a:byte_786,Y

locret_A364:
	RTS
; End of function sub_A33E

; =============== S U B	R O U T	I N E =======================================

MaybeAward1UP:
	LDA #1
	BIT a:MaybeCollectedThing2	; If lowest bit	is set...
	BNE _Draw1UPSprite		;   skip ahead
	ORA a:MaybeCollectedThing2	; Otherwise, or	with #$01
	BMI loc_A372			; If #$80 (highest bit)	set, continue
	RTS					; else,	exit
; ---------------------------------------------------------------------------

loc_A372:
	STA a:MaybeCollectedThing2	; save the low bit being set now
	INC PlayerLives
	INC ExtraLivesFound
	LDA #Sound_1UP_Captive
	JSR QueueSound			; 1up captive
	INC a:Collected1UPThisRoundFlag
	LDA #$40
	STA Show1UPSpriteTimer

_Draw1UPSprite:
	LDA PlayerYPosHi
	SEC
	SBC #$10
	STAc TempSpriteY
	LDA PlayerXPosHi
	SBC #8
	STAc TempSpriteX
	LDA #$82
	DEC Show1UPSpriteTimer
	BNE loc_A3A7
	LDX #0
	STX MaybeCollectedThing2
	LDA #$F

loc_A3A7:
	JSR Draw1UPSprite
	RTS
; End of function MaybeAward1UP

; =============== S U B	R O U T	I N E =======================================

Draw1UPSprite:
	LDX #$58
	STA SpriteDMAArea+1,X
	CMP #$F
	BEQ loc_A3B7
	CLC
	ADC #1

loc_A3B7:
	STA SpriteDMAArea+5,X
	LDAc TempSpriteY
	STA SpriteDMAArea,X
	STA SpriteDMAArea+4,X
	LDA #0
	STA SpriteDMAArea+2,X
	STA SpriteDMAArea+6,X
	LDAc TempSpriteX
	STA SpriteDMAArea+3,X
	CLC
	ADC #8
	STA SpriteDMAArea+7,X
	RTS
; End of function Draw1UPSprite

; ---------------------------------------------------------------------------
byte_A3D8:
	.BYTE 0,	0
	.BYTE   -4, -8			; 2 ;  0,  0
	.BYTE    4, -8			; 4 ; -4, -8
	.BYTE   -4, 8			; 6 ; +4, -8
	.BYTE    4, 8			; 8 ; -4, +8
	.BYTE   -8, -4			; $A ; -8, -4
	.BYTE   -8, 4			; $C ; -8, +4
	.BYTE    8, -4			; $E ; +8, -4
	.BYTE    8, 4			; $10 ;	+8, +4
byte_A3EA:
	.BYTE	$CC
	.BYTE $FC
	.BYTE $48
	.BYTE $5A
	.BYTE $7B
	.BYTE $DE
	.BYTE $21
	.BYTE $35
	.BYTE $AC
	.BYTE $3C
ObjectPointers:
	.WORD PlayerStruct
	.WORD Object0Struct			; 1
	.WORD Object1Struct			; 2
	.WORD Object2Struct			; 3
	.WORD Object3Struct			; 4
	.WORD Object4Struct			; 5
	.WORD Object5Struct			; 6
	.WORD Object6Struct			; 7
	.WORD Object7Struct			; 8
byte_A406:
	.BYTE %01001111
	.BYTE %10001111			; 1
	.BYTE %00011111			; 2
	.BYTE %00101111			; 3
	.BYTE %11110111			; 4
	.BYTE %11111011			; 5
	.BYTE %11111101			; 6
	.BYTE %11111110			; 7

; =============== S U B	R O U T	I N E =======================================

MainSub_3:
	JSR MaybeHandleDoorOpening
	LDA #0
	STAc byte_98
	STAc byte_99
	STAc byte_9A
	STAc byte_9B
	LDA CurrentRoomID
	JSR MaybeLoadRoomFlags		; called with room id
	LDA #1
	STAc PPUUpdateFlag1
	LDAc RoomStatusFlags
	AND #RF_SingleScreen
	BEQ loc_A442
	LDAc PPUMaskMirror
	ORA #6
	STAc PPUMaskMirror
	LDA #0
	STA byte_3C2
	STA byte_3C4
	RTS
; ---------------------------------------------------------------------------

loc_A442:
	LDA #RF_AtScrollEdge
	BITc RoomStatusFlags
	BEQ loc_A44A
	RTS
; ---------------------------------------------------------------------------

loc_A44A:
	LDAc RoomStatusFlags
	AND #RF_ScrollStop
	BNE loc_A454
	JMP loc_A63C
; ---------------------------------------------------------------------------

loc_A454:
	LDAc PPUMaskMirror
	AND #~(PPUMask_ShowLeft8Pixels_BG|PPUMask_ShowLeft8Pixels_SPR)
	STAc PPUMaskMirror
	LDA PlayerXVelHi
	BNE loc_A46F
	LDA MaybeRoomIDCopyAgain
	BNE locret_A46E
	LDAc RoomStatusFlags
	ORA #RF_AtScrollEdge
	STAc RoomStatusFlags

locret_A46E:
	RTS
; ---------------------------------------------------------------------------

loc_A46F:
	PHP
	LDA #0
	STAc PPUUpdateFlag1
	PLP
	BMI loc_A47B
	JMP loc_A505
; ---------------------------------------------------------------------------

loc_A47B:
	LDA a:RoomStatusFlags
	BPL loc_A498
	LDA byte_3C2
	CMP #$F9
	BCS loc_A498
	LDA #$F8
	STA byte_3C2
	LDAc RoomStatusFlags
	ORA #RF_AtScrollEdge
	STAc RoomStatusFlags
	INCc PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A498:
	JSR sub_A843
	LDA CurrentRoomID
	STA MaybeRoomIDCopyAgain
	LDA PlayerXVelLo
	CLC
	ADC byte_3C1
	STA byte_3C1
	LDA PlayerXVelHi
	ADC byte_3C2
	STA byte_3C2
	BCS loc_A4E3
	LDAc RoomStatusFlags
	AND #~RF_Horizontal
	STAc RoomStatusFlags
	LDY #0
	LDA (off_3D),Y
	AND #2
	BEQ loc_A4CC
	LDA (off_3D),Y
	AND #8
	BNE loc_A4D2

loc_A4CC:
	LDY #4
	LDA (off_3D),Y
	BNE loc_A4DD

loc_A4D2:
	LDAc RoomStatusFlags
	ORA #RF_SectionStart
	STA a:RoomStatusFlags

loc_A4DA:
	JMP loc_A58C
; ---------------------------------------------------------------------------

loc_A4DD:
	STA CurrentRoomID
	STA MaybeRoomIDCopyAgain

loc_A4E3:
	LDAc RoomStatusFlags
	BMI loc_A4DA			; #RF_SectionStart set
	LDA byte_3C2
	CLC
	ADC #8
	BCS loc_A4F3
	JMP loc_A58C
; ---------------------------------------------------------------------------

loc_A4F3:
	LDA CurrentRoomID
	JSR MaybeLoadRoomFlags		; called with room id
	LDY #3
	LDA (off_3D),Y
	BEQ loc_A56A
	STA MaybeRoomIDCopyAgain
	JMP loc_A58C
; ---------------------------------------------------------------------------

loc_A505:
	LDA a:RoomStatusFlags
	ASL A
	BPL loc_A51C			; #RF_Horizontal clear
	LDA #0
	STA byte_3C2
	LDA a:RoomStatusFlags
	ORA #RF_AtScrollEdge
	STAc RoomStatusFlags
	INCc PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A51C:
	JSR sub_A843
	LDY #3
	LDA (off_3D),Y
	BNE loc_A531
	LDAc RoomStatusFlags
	ORA #RF_Horizontal
	STAc RoomStatusFlags
	INCc PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A531:
	STA MaybeRoomIDCopyAgain
	LDA PlayerXVelLo
	CLC
	ADC byte_3C1
	STA byte_3C1
	LDA PlayerXVelHi
	ADC byte_3C2
	STA byte_3C2
	BCC loc_A581
	LDAc RoomStatusFlags
	BMI loc_A57A			; #RF_SectionStart set
	LDY #3
	LDA (off_3D),Y
	BNE loc_A55E

loc_A554:
	LDAc RoomStatusFlags
	ORA #RF_Horizontal
	STAc RoomStatusFlags
	BNE loc_A58C

loc_A55E:
	STA CurrentRoomID		; breakpoint triggered when
					; walking across first two rooms
					; and room id 01 -> 02
	JSR MaybeLoadRoomFlags		; called with room id
	LDY #0
	LDA (off_3D),Y
	AND #2

loc_A56A:
	BEQ loc_A572
	LDA (off_3D),Y
	AND #8
	BEQ loc_A554

loc_A572:
	LDY #3
	LDA (off_3D),Y
	BNE loc_A589
	BEQ loc_A554

loc_A57A:
	AND #<~RF_SectionStart
	; AND #$80
	STAc RoomStatusFlags		; clear	#RF_SectionStart
	BPL loc_A58C			; (always taken)

loc_A581:
	LDAc RoomStatusFlags
	BPL loc_A58C			; if #RF_SectionStart clear
	LDA CurrentRoomID

loc_A589:
	STA MaybeRoomIDCopyAgain

loc_A58C:
	LDA byte_3C2
	STA byte_8
	LDX PlayerXVelHi
	BPL loc_A59B
	CLC
	ADC #8
	STA byte_8

loc_A59B:
	LDA MaybeRoomIDCopyAgain
	JSR LoadRoomStuff
	LDA byte_8
	AND #$F8
	LSR A
	LSR A
	LSR A
	LSR A
	STA byte_8
	ROL A
	AND #1
	PHA
	LDY #0
	STY byte_9
	JSR HandleDrawHalfRow		; another pointer thing
	LDA #4
	STA byte_3EE
	LDA #$20
	STA byte_3EF
	LDA byte_3C2
	LDX PlayerXVelHi
	BPL loc_A5CB
	CLC
	ADC #8

loc_A5CB:
	LSR A
	LSR A
	LSR A
	STA byte_3F0
	LDA #$1D
	STA byte_3F1
	LDA byte_3C8
	TAX
	LDA PlayerXVelHi
	STA byte_3C8
	TXA
	EOR PlayerXVelHi
	BMI loc_A5F3
	LDA byte_3F0
	CMP byte_3CA
	BNE loc_A5F3
	INCc PPUUpdateFlag1
	PLA
	RTS
; ---------------------------------------------------------------------------

loc_A5F3:
	LDA byte_3F0
	STA byte_3CA

loc_A5F9:
	LDA #BasePointer_MetatileDefinitions
	JSR LoadPointerTo050		; 4 (metatile defs)
	LDA #0
	STA byte_7
	LDA byte_9
	AND #7
	TAY
	LDA (off_4),Y
	PHA
	JSR HandleTileAttributes
	PLA
	JSR LoadLayoutChunk
	LDA byte_9
	ASL A
	TAX
	PLA
	PHA
	TAY
	LDA (byte_6),Y
	STA PPUUpdateBuffer,X
	INY
	INY
	LDA (byte_6),Y
	STA unk_3F3,X
	INC byte_9
	LDA byte_9
	CMP #8
	BNE loc_A631
	LDY #1
	JSR HandleDrawHalfRow		; another pointer thing

loc_A631:
	LDA byte_9
	CMP #$F
	BNE loc_A5F9
	PLA
	JSR sub_A85F
	RTS
; ---------------------------------------------------------------------------

loc_A63C:
	LDA #0
	STAc PPUUpdateFlag1
	LDA a:PPUMaskMirror
	ORA #6
	STA a:PPUMaskMirror
	LDA PlayerYVelHi
	ORA PlayerYVelLo
	BEQ loc_A66B
	LDA PlayerYVelHi
	BMI loc_A659
	JMP loc_A6FC
; ---------------------------------------------------------------------------

loc_A659:
	LDAc RoomStatusFlags
	BPL loc_A66F			; if #RF_SectionStart clear
	LDA #0
	STA byte_3C4
	LDAc RoomStatusFlags
	ORA #RF_AtScrollEdge
	STAc RoomStatusFlags		; | #RF_AtScrollEdge

loc_A66B:
	INC a:PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A66F:
	JSR sub_A851
	LDAc RoomStatusFlags
	AND #~RF_Horizontal
	STAc RoomStatusFlags		; & #~RF_Horizontal
	CLC
	LDA PlayerYVelLo
	ADC byte_3C3
	STA byte_3C3
	LDA byte_3C4
	STA byte_3C6
	ADC PlayerYVelHi
	STA byte_3C4
	PHP
	TAX
	CMP #$F0
	BCC loc_A69C
	ADC #$EF
	TAX
	PLP
	CLC
	PHP

loc_A69C:
	PLP
	BCS loc_A6CF
	LDY #0
	LDA (off_3D),Y
	AND #2
	BEQ loc_A6AD
	LDA (off_3D),Y
	AND #8
	BNE loc_A6B3

loc_A6AD:
	LDY #1
	LDA (off_3D),Y
	BNE loc_A6C4

loc_A6B3:
	LDAc RoomStatusFlags
	ORA #RF_SectionStart
	STAc RoomStatusFlags		; | #RF_SectionStart
	LDA #0
	STA byte_3C4

loc_A6C0:
	INCc PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A6C4:
	STA CurrentRoomID
	LDA a:PPUCtrlMirror
	EOR #2
	STA a:PPUCtrlMirror

loc_A6CF:
	STX byte_3C4
	LDY #0
	LDA byte_3C4
	SEC
	SBC #$10
	CMP #$F0
	TAX
	LDA CurrentRoomID
	BCC loc_A6F1
	TXA
	SBC #$10
	TAX
	LDA #2
	STA byte_E
	LDY #1
	LDA (off_3D),Y
	BEQ loc_A6C0
	INY

loc_A6F1:
	STA MaybeRoomIDCopyAgain
	STX byte_3C6
	STY byte_E
	JMP loc_A784
; ---------------------------------------------------------------------------

loc_A6FC:
	LDA a:RoomStatusFlags		; if #RF_Horizontal clear...
	ASL A
	BPL loc_A716
	LDA #0
	STA byte_3C3
	STA byte_3C4
	LDAc RoomStatusFlags
	ORA #RF_AtScrollEdge
	STAc RoomStatusFlags		; | #RF_AtScrollEdge
	INCc PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A716:
	JSR sub_A851
	LDAc RoomStatusFlags
	AND #<~RF_SectionStart
	STAc RoomStatusFlags		; & #~RF_SectionStart
	CLC
	LDA PlayerYVelLo
	ADC byte_3C3
	STA byte_3C3
	LDA PlayerYVelHi
	ADC byte_3C4
	TAX
	PHP
	CMP #$F0
	BCC loc_A73D
	ADC #$F
	TAX
	PLP
	SEC
	PHP

loc_A73D:
	STX byte_3C4
	STX byte_3C6
	PLP
	BCC loc_A768
	LDAc PPUCtrlMirror
	EOR #2
	STAc PPUCtrlMirror
	LDY #2
	LDA (off_3D),Y
	BEQ loc_A773
	STA CurrentRoomID
	JSR MaybeLoadRoomFlags		; called with room id
	LDY #0
	LDA (off_3D),Y
	AND #2
	BEQ loc_A768
	LDA (off_3D),Y
	AND #8
	BEQ loc_A773

loc_A768:
	LDY #2
	LDA (off_3D),Y
	BEQ loc_A773
	STA MaybeRoomIDCopyAgain
	BNE loc_A784

loc_A773:
	LDAc RoomStatusFlags
	ORA #RF_Horizontal
	STAc RoomStatusFlags		; | #RF_Horizontal
	LDA #0
	STA byte_3C4
	INCc PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A784:
	LDA MaybeRoomIDCopyAgain
	JSR LoadRoomStuff
	LDA byte_3C6
	LSR A
	LSR A
	LSR A
	LSR A
	STA byte_8
	LDY #0
	STY byte_9
	JSR HandleDrawHalfRow		; another pointer thing
	LDA #0
	STA byte_3EE
	LDA byte_3C6
	JSR sub_92E2
	LDA #2
	LDX PlayerYVelHi
	BPL loc_A7AE
	LDA byte_E

loc_A7AE:
	EOR a:PPUCtrlMirror
	ASL A
	ASL A
	AND #8
	ORA #$20
	ORA byte_3EF
	STA byte_3EF
	LDA #$40
	STA byte_3F1
	LDA byte_3C9
	TAX
	LDA PlayerYVelHi
	STA byte_3C9
	TXA
	EOR PlayerYVelHi
	BMI loc_A7E6
	LDA byte_3EF
	CMP byte_3CA
	BNE loc_A7E6
	LDA byte_3F0
	CMP byte_3CB
	BNE loc_A7E6
	INC a:PPUUpdateFlag1
	RTS
; ---------------------------------------------------------------------------

loc_A7E6:
	LDA byte_3EF
	STA byte_3CA
	LDA byte_3F0
	STA byte_3CB

loc_A7F2:
	LDA #BasePointer_MetatileDefinitions
	JSR LoadPointerTo050		; 4 (metatile defs)
	LDA #0
	STA byte_7
	LDA byte_9
	AND #7
	TAY
	LDA (off_4),Y
	PHA
	JSR HandleTileAttributes
	PLA
	JSR LoadLayoutChunk
	LDA byte_9
	ASL A
	TAX
	LDY #0
	LDA (byte_6),Y
	STA PPUUpdateBuffer,X
	INY
	LDA (byte_6),Y
	STA unk_3F3,X
	INY
	TXA
	CLC
	ADC #$20
	TAX
	LDA (byte_6),Y
	STA PPUUpdateBuffer,X
	INY
	LDA (byte_6),Y
	STA unk_3F3,X
	INC byte_9
	LDA byte_9
	CMP #8
	BNE loc_A839
	LDY #1
	JSR HandleDrawHalfRow		; another pointer thing

loc_A839:
	LDA byte_9
	CMP #$10
	BNE loc_A7F2
	JSR sub_A85F
	RTS
; End of function MainSub_3

; =============== S U B	R O U T	I N E =======================================

sub_A843:
	LDX PlayerXVelLo
	LDY PlayerXVelHi
	JSR NegateYYXX			; e.g. 2 -> FFFE
	STX byte_98
	STY byte_99
	RTS
; End of function sub_A843

; =============== S U B	R O U T	I N E =======================================

sub_A851:
	LDX PlayerYVelLo
	LDY PlayerYVelHi
	JSR NegateYYXX			; e.g. 2 -> FFFE
	STX byte_9A
	STY byte_9B
	RTS
; End of function sub_A851

; =============== S U B	R O U T	I N E =======================================

sub_A85F:
	LDA MaybeRoomIDCopyAgain
	JSR IfNotTitleScreenRoomDoThings ; A=room. double-returns if Z set

loc_A865:
	JSR sub_9592
	LDX #0
	JSR sub_A875
	LDX #1
	JSR sub_A875
	JMP loc_A865
; End of function sub_A85F

; =============== S U B	R O U T	I N E =======================================

sub_A875:
	LDAc RoomStatusFlags		; if #RF_ScrollStop...
	AND #RF_ScrollStop
	BNE loc_A87F
	JMP loc_A8D0
; ---------------------------------------------------------------------------

loc_A87F:
	LDA a:byte_70,X
	BEQ locret_A8CF
	AND #$F
	STA byte_9
	LDA byte_3C2
	LDY PlayerXVelHi
	BPL loc_A893
	CLC
	ADC #8

loc_A893:
	STA byte_A
	LSR A
	LSR A
	LSR A
	LSR A
	CMP byte_9
	BNE locret_A8CF
	JSR sub_96F5
	LDA a:byte_70,X
	LSR A
	LSR A
	LSR A
	LSR A
	STA byte_9
	PHA
	LDA a:MaybeTileCollected,X
	PHA
	JSR HandleTileAttributes
	PLA
	JSR LoadLayoutChunk
	LDY #0
	LDA #8
	BIT byte_A
	BEQ loc_A8BE
	INY

loc_A8BE:
	PLA
	AND #$F
	ASL A
	TAX
	LDA (byte_6),Y
	STA PPUUpdateBuffer,X
	INY
	INY
	LDA (byte_6),Y
	STA unk_3F3,X

locret_A8CF:
	RTS
; ---------------------------------------------------------------------------

loc_A8D0:
	LDA a:byte_70,X
	BEQ locret_A919
	AND #$F0
	STA byte_9
	LDA byte_3C6
	AND #$F0
	CMP byte_9
	BNE locret_A919
	JSR sub_96F5
	LDA a:byte_70,X
	AND #$F
	PHA
	STA byte_9
	LDA a:MaybeTileCollected,X
	PHA
	JSR HandleTileAttributes
	PLA
	JSR LoadLayoutChunk
	LDY #0
	PLA
	ASL A
	TAX
	LDA (byte_6),Y
	STA PPUUpdateBuffer,X
	INY
	LDA (byte_6),Y
	STA unk_3F3,X
	TXA
	CLC
	ADC #$20
	TAX
	INY
	LDA (byte_6),Y
	STA PPUUpdateBuffer,X
	INY
	LDA (byte_6),Y
	STA unk_3F3,X

locret_A919:
	RTS
; End of function sub_A875

; =============== S U B	R O U T	I N E =======================================

SpawnBrotherRoomObjects:
	LDA #0
	STA a:BrotherSpawnerCounter

loc_A91F:
	LDA a:BrotherSpawnerCounter
	JSR LoadObjectPointerAPlus1
	LDX a:BrotherSpawnerCounter
	LDA BrotherRoomObjects,X
	JSR InitEnemy
	LDX a:BrotherSpawnerCounter
	JSR SetBrotherRoomObjectPosition
	INC a:BrotherSpawnerCounter
	LDA a:BrotherSpawnerCounter
	CMP #3
	BNE loc_A91F
	RTS
; End of function SpawnBrotherRoomObjects

; =============== S U B	R O U T	I N E =======================================

SetBrotherRoomObjectPosition:
	LDA #$D8
	LDY #EnemyStruct_B_YPosHi
	STA (EnemyStructPointer),Y
	LDA BrotherRoomXPositions,X
	LDY #EnemyStruct_5_XPosHi
	STA (EnemyStructPointer),Y
	RTS
; End of function SetBrotherRoomObjectPosition

; ---------------------------------------------------------------------------
BrotherRoomObjects:
	.BYTE   $B,	$B, $10
BrotherRoomXPositions:
	.BYTE  $68, $A8, $88	 ; =============== S U B	R O U T	I N E =======================================

MaybeHandleDoorOpening:
	LDA MaybeHandleDoorFlag		; if lowest bit	set...
	LSR A
	BCS CheckAndMaybeOpenDoor	; ...check doors
	SEC					; otherwise, set carry
	ROL A				; then rotate left again
					; (sets	lowest bit)
	BMI loc_A95E			; if *highest* bit set,	continue
	RTS					; otherwise return
; ---------------------------------------------------------------------------

loc_A95E:
	STA MaybeHandleDoorFlag		; save w/ lowest bit set
	LDA CurrentRoomIDBackup4
	JSR LoadRoomData
	LDY #0
	LDA (off_58),Y
	AND #$F0
	CMP #$E0
	BEQ loc_A977			; if room header, continue

_ClearDoorFlagAndExit:
	LDA #0				; otherwise, clear and exit
	STA MaybeHandleDoorFlag		; = 0
	RTS
; ---------------------------------------------------------------------------

loc_A977:
	LDA #$20
	LDX CurrentRoomIDBackup4
	CPX #$61
					; one with the R11->R6 warp
	BEQ loc_A988			; #$20 = special warp (-1 later)
	INY					; Y = 1(?)
	LDA (off_58),Y			; UUUUUMMM
	LSR A				; .UUUUUMM / 2
	LSR A				; ..UUUUUM / 4
	LSR A				; ...UUUUU / 8
	BEQ _ClearDoorFlagAndExit	; ...00000 = exit

loc_A988:
	SEC
	SBC #1				; then subtract	by 1
	STA MaybeDoorTypeOrSphinx

CheckAndMaybeOpenDoor:
	LDA MaybeDoorTypeOrSphinx
	JSR JumpTable
; ---------------------------------------------------------------------------
IFDEF REV_US
	; US version door table
	.WORD DoorCond_rts				; 00 00 (unused?)
	.WORD DoorCond_rts				; 01 don't open
	.WORD DoorCond_02_JumpedOn		; 02 just jumped
	.WORD DoorCond_rts				; 03 don't open
	.WORD DoorCond_rts				; 04 don't open
	.WORD DoorCond_rts				; 05 don't open
	.WORD DoorCond_rts				; 06 don't open
	.WORD DoorCond_XX_Mighty3		; 07 player at mighty level 3
	.WORD DoorCond_rts				; 08 don't open
	.WORD DoorCond_09_FBWarp2		; 09 R4->R7 to crystal door reverse path
	.WORD DoorCond_rts				; 0A* don't open (diff from jp)
	.WORD DoorCond_rts				; 0B don't open
	.WORD DoorCond_0C_AllFireBombs	; 0C if (MaybeBombThing $0F8 & 80)
	.WORD DoorCond_rts				; 0D don't open
	.WORD DoorCond_XX_Mighty3		; 0E timer == 60
	.WORD DoorCond_rts				; 0F don't open
	.WORD DoorCond_rts				; 10 don't open
	.WORD DoorCond_rts				; 11 (unused?)
	.WORD DoorCond_rts				; 12 (unused?)
	.WORD DoorCond_rts				; 13 (unused?)
	.WORD DoorCond_rts				; 14
	.WORD DoorCond_rts				; 15 (unused?)
	.WORD DoorCond_rts				; 16 (unused?)
	.WORD DoorCond_XX_Mighty3		; 17 player at mighty level 3
	.WORD DoorCond_XX_Mighty3		; 18 player at mighty level 3
	.WORD DoorCond_1D_FBWarp1		; 19* room FB warp door (diff from jp)
	.WORD DoorCond_1A_US_rts		; 1A* rts?
	.WORD DoorCond_XX_Mighty3		; 1B player at mighty level 3
	.WORD DoorCond_rts				; 1C don't open
	.WORD DoorCond_1D_FBWarp1		; 1D room FB warp door
	.WORD DoorCond_1E_R5R11Warp		; 1E round 5->11 warp (rm#$FC)
	.WORD DoorCond_1F_R11WarpBack	; 1F round 11->6 warp (rm#$61)
	.WORD DoorCond_20_US			; 20* ? (jp doesn't exist)


ELSE
	; JP version door table
	.WORD DoorCond_rts				; 00 00 (unused?)
	.WORD DoorCond_rts				; 01 don't open
	.WORD DoorCond_02_JumpedOn		; 02 just jumped
	.WORD DoorCond_rts				; 03 don't open
	.WORD DoorCond_rts				; 04 don't open
	.WORD DoorCond_rts				; 05 don't open
	.WORD DoorCond_rts				; 06 don't open
	.WORD DoorCond_XX_Mighty3		; 07 player at mighty level 3
	.WORD DoorCond_rts				; 08 don't open
	.WORD DoorCond_09_FBWarp2		; 09 R4->R7 to crystal door reverse path
	.WORD DoorCond_0A_Timer30		; 0A timer == 30
	.WORD DoorCond_rts				; 0B don't open
	.WORD DoorCond_0C_AllFireBombs	; 0C if (MaybeBombThing $0F8 & 80)
	.WORD DoorCond_rts				; 0D don't open
	.WORD DoorCond_0E_Timer60		; 0E timer == 60
	.WORD DoorCond_rts				; 0F don't open
	.WORD DoorCond_rts				; 10 don't open
	.WORD DoorCond_rts				; 11 (unused?)
	.WORD DoorCond_rts				; 12 (unused?)
	.WORD DoorCond_rts				; 13 (unused?)
	.WORD DoorCond_rts				; 14
	.WORD DoorCond_rts				; 15 (unused?)
	.WORD DoorCond_rts				; 16 (unused?)
	.WORD DoorCond_XX_Mighty3		; 17 player at mighty level 3
	.WORD DoorCond_XX_Mighty3		; 18 player at mighty level 3
	.WORD DoorCond_19_TensScore30	; 19 tens part of score ==	30
	.WORD DoorCond_1A_TensScore70	; 1A tens part of score ==	70
	.WORD DoorCond_XX_Mighty3		; 1B player at mighty level 3
	.WORD DoorCond_rts				; 1C don't open
	.WORD DoorCond_1D_FBWarp1		; 1D room FB warp door
	.WORD DoorCond_1E_R5R11Warp		; 1E round 5->11 warp (rm#$FC)
	.WORD DoorCond_1F_R11WarpBack	; 1F round 11->6 warp (rm#$61)

; =============== S U B	R O U T	I N E =======================================
DoorCond_unused:
	LDA a:FireBombsCollected		; POI: unreferenced/unused
ENDIF
; End of function MaybeHandleDoorOpening

	CMP #23
	BCC DoorCond_rts		; don't open
	JMP HandleOpenDoorMaybe
; End of function DoorCond_unused

; =============== S U B	R O U T	I N E =======================================

; just jumped

DoorCond_02_JumpedOn:
	JSR MaybeDontOpenDoors		; double-rts sometimes
	LDAc JustJumpedFlag
	BEQ DoorCond_rts		; don't open
	JMP HandleOpenDoorMaybe
; End of function DoorCond_02_JumpedOn

; =============== S U B	R O U T	I N E =======================================

; R4->R7 warp door crystal warp
;
; the other door in the	4->7 warp door

DoorCond_09_FBWarp2:
	LDA DoorCheckFlag_09
	BMI DoorCond_rts		; don't open
	LSR A
	BCC DoorCond_rts		; don't open
	LDA #$80
	STA DoorCheckFlag_09		; = #$80
	JMP HandleOpenDoorMaybe
; End of function DoorCond_09_FBWarp2

IFNDEF REV_US
; =============== S U B	R O U T	I N E =======================================
; timer	== 30
DoorCond_0A_Timer30:
	JSR MaybeDontOpenDoors		; double-rts sometimes
	LDA a:StageTimer
	CMP #$30
	BNE DoorCond_rts		; don't open
	JMP HandleOpenDoorMaybe
; End of function DoorCond_0A_Timer30
ENDIF

; =============== S U B	R O U T	I N E =======================================

; if ($0F8 & 80)

DoorCond_0C_AllFireBombs:
	LDAc MaybeBombThing		; checks if #$80 set, unsets it
	BPL DoorCond_rts		; don't open
	AND #$7F
	STAc MaybeBombThing		; maybe	related	to all fire bombs
	JMP HandleOpenDoorMaybe
; End of function DoorCond_0C_AllFireBombs

; =============== S U B	R O U T	I N E =======================================

; don't open

DoorCond_rts:
	RTS
; End of function DoorCond_rts

IFNDEF REV_US
; =============== S U B	R O U T	I N E =======================================
; timer	== 60
DoorCond_0E_Timer60:
	JSR MaybeDontOpenDoors		; double-rts sometimes
	LDA a:StageTimer
	CMP #$60
	BNE DoorCond_rts		; don't open
	JMP HandleOpenDoorMaybe
; End of function DoorCond_0E_Timer60
ENDIF

; =============== S U B	R O U T	I N E =======================================

; player at mighty level 3

DoorCond_XX_Mighty3:
	JSR MaybeDontOpenDoors		; double-rts sometimes
	LDA PlayerMightyLevel
	CMP #3
	BNE DoorCond_rts		; don't open
	JMP HandleOpenDoorMaybe
; End of function DoorCond_XX_Mighty3

IFNDEF REV_US
; =============== S U B	R O U T	I N E =======================================
; tens part of score ==	30
DoorCond_19_TensScore30:
	LDA DoorCheckFlag_19_1A
	BNE DoorCond_rts		; don't open
	INC DoorCheckFlag_19_1A
	LDA a:PlayerScore
	CMP #$30
	BNE DoorCond_rts		; don't open
	JMP HandleOpenDoorMaybe
; End of function DoorCond_19_TensScore30
ENDIF

; =============== S U B	R O U T	I N E =======================================

; room FB warp door

DoorCond_1D_FBWarp1:
	LDAc RoomStatusFlags		; check	#RF_AtScrollEdge
	AND #RF_AtScrollEdge
	BEQ locret_AAB3			;   if not, no warp
	LDA PlayerMightyCoins		; any mighty coins?
	BNE locret_AAB3			;   if yes, no warp
	LDAc StageTimer			; still	have time left?
	BNE locret_AAB3			;   if yes, no warp
	LDA PlayerSprite		; what sprite does jack	have
	CMP #6				;   "falling to	the side" sprite?
	BNE locret_AAB3			;   if not, no warp
	LDA #0				; otherwise, you pass;
	STAc TimerStatusMaybe		; reset	timer to 60 ticks,
	LDA #1				; and open the door
	STA DoorCheckFlag_09		; = #01
	JMP HandleOpenDoorMaybe
; End of function DoorCond_1D_FBWarp1

; =============== S U B	R O U T	I N E =======================================

; round	5->11 warp (rm#$FC)

DoorCond_1E_R5R11Warp:
	LDA DoorCheckFlag_1E_Unk	; if non-zero, exit
	BNE locret_AAB3
	LDA DoorCheckFlag_1E_DeathCount	; if not 2, skip ahead
	CMP #2
	BNE _DoorCond_1E_Cnd
	LDA PlayerStruct		; check	player status...
	BMI locret_AAB3			;   if dead, exit
	INC DoorCheckFlag_1E_Unk	; Unk =	1
	LDA #0
	STA DoorCheckFlag_1E_DeathCount	; deaths = 0
	STA DoorCheckFlag_1E_Unk	; Unk =	0
	BEQ HandleOpenDoorMaybe		; always taken

_DoorCond_1E_Cnd:
	LDA PlayerStruct		; check	player status...
	BPL locret_AAB3			;   if dead, exit
	LDA FireTilePlayerDiedTo	; otherwise, check if they died	to
	CMP #$5D
	BNE locret_AAB3			;   if no, exit
	INC FireTilePlayerDiedTo	; inc (to make not match any more)
	INC DoorCheckFlag_1E_DeathCount	; inc death count
	BNE locret_AAB3			; ...and exit
; End of function DoorCond_1E_R5R11Warp

; =============== S U B	R O U T	I N E =======================================

; round	11->6 warp (rm#$61)

DoorCond_1F_R11WarpBack:
	LDA DoorCheckFlag_1F		; Opens	one time, ever
	BNE locret_AAB3
	INC DoorCheckFlag_1F
	BNE HandleOpenDoorMaybe
; End of function DoorCond_1F_R11WarpBack

IFNDEF REV_US
; =============== S U B	R O U T	I N E =======================================
; tens part of score ==	70
DoorCond_1A_TensScore70:
	LDA DoorCheckFlag_19_1A
	BNE locret_AAB3
	INC DoorCheckFlag_19_1A
	LDA a:PlayerScore
	CMP #$70
	BNE locret_AAB3
	JMP HandleOpenDoorMaybe
; ---------------------------------------------------------------------------
ENDIF

DoorCond_1A_US_rts:
locret_AAB3:
	RTS
; End of function DoorCond_1A_TensScore70

; =============== S U B	R O U T	I N E =======================================

; double-rts sometimes

MaybeDontOpenDoors:
	LDA DoorIsAnimatingMaybe	; if this is zero...
	BEQ _DoubleReturn		; effectively double return
	LDA a:UnknownDoorFlagCopy
	LSR A
	LSR A
	LSR A
	CMP MaybeDoorTypeOrSphinx
	BEQ locret_AAC6

_DoubleReturn:
	PLA
	PLA

locret_AAC6:
	RTS
; End of function MaybeDontOpenDoors

; =============== S U B	R O U T	I N E =======================================

HandleOpenDoorMaybe:
	LDX MaybeDoorTypeOrSphinx

HandleSphinxEvent:
	LDA MaybeSphinxFlags,X		; X = id?
	BPL locret_AB18

loc_AACF:
IFDEF REV_US
	TXA
	PHA
	LDA #Sound_Door
	JSR QueueSound
	PLA
	TAX
ENDIF
	LDA #$52
	STA MaybeSphinxFlags,X		; = #$52
	LDA UnknownDoorTable,X		; A = table...
	TAX					; save value in	X
	AND #$10			; >= $10?
	BEQ _DoorTableEntryBelow10	; if no, jump ahead
	TXA					; restore original value
	AND #$F				; mask off upper bits
	STAc byte_10
	LDA CurrentRoomIDBackup4
	JSR IfNotTitleScreenRoomDoThings ; A=room. double-returns if Z set

loc_AAE8:
	JSR sub_9592			; maybe	check room data	for objs
	LDA a:byte_5C
	AND #$F0
	BEQ locret_AB18
	CMP #$80
	BNE loc_AAE8
	LDA a:byte_5C
	AND #$F
	CMPc byte_10
	BNE loc_AAE8
	STA EntryDoorType
	LDA #$52
	LDYc byte_5A
	DEY
	STA RoomDataRAM,Y
	LDA #$B
	STAc GameState			; = B

IFNDEF REV_US
	BNE locret_AB18
_DoorTableEntryBelow10:
	LDA #Sound_Door			; door opens/closes
	JSR QueueSound			; door
ELSE
_DoorTableEntryBelow10:
ENDIF

locret_AB18:
	RTS
; End of function HandleOpenDoorMaybe

; =============== S U B	R O U T	I N E =======================================

HandleTileAttributes:
	PHA
	LSR A
	LSR A
	TAX
	LDA TileAttributeTable,X
	STA byte_B
	PLA
	AND #3
	TAX
	BEQ loc_AB2F

loc_AB28:
	ASL byte_B
	ASL byte_B
	DEX
	BNE loc_AB28

loc_AB2F:
	LDA #0
	ASL byte_B
	ROL A
	ASL byte_B
	ROL A
	STA byte_B
	LDX #BasePointer_AttributeTableBuffer
	LDA byte_3EF
	AND #8
	BEQ loc_AB43
	INX

loc_AB43:
	TXA
	JSR LoadPointerTo050		; 7/8 (attribute buffer	or 5A3)
	LDY #0
	LDA (off_3D),Y
	AND #4
	BEQ loc_AB7E
	LDA byte_9
	ASL A
	ASL A
	AND #$F8
	STA byte_C
	LDA byte_3F0
	AND #$1F
	LSR A
	LSR A
	CLC
	ADC byte_C
	ADC word_50
	STA byte_C
	LDA word_50+1
	ADC #0
	STA byte_D
	LDY #0
	LDA byte_9
	LSR A
	BCC loc_AB74
	INY
	INY

loc_AB74:
	LDA byte_3F0
	AND #2
	BEQ loc_ABB7
	INY
	BNE loc_ABB7

loc_AB7E:
	LDA byte_3F0
	AND #$80
	STA byte_C
	LDA byte_3EF
	AND #3
	LSR A
	ROR byte_C
	LSR A
	ROR byte_C
	LSR A
	ROR byte_C
	LSR A
	ROR byte_C
	LDA byte_9
	LSR A
	CLC
	ADC byte_C
	ADC word_50
	STA byte_C
	LDA word_50+1
	ADC #0
	STA byte_D
	LDY #0
	LDA byte_3F0
	AND #$40
	BEQ loc_ABB1
	INY
	INY

loc_ABB1:
	LDA byte_9
	LSR A
	BCC loc_ABB7
	INY

loc_ABB7:
	TYA

loc_ABB8:
	DEY
	BMI loc_ABC2
	ASL byte_B
	ASL byte_B
	JMP loc_ABB8
; ---------------------------------------------------------------------------

loc_ABC2:
	INY
	TAX
	LDA byte_AD19,X			; 1110 1101 1011 0111 (2 nib per #)
	AND (byte_C),Y
	ORA byte_B
	STA (byte_C),Y
	RTS
; End of function HandleTileAttributes

; =============== S U B	R O U T	I N E =======================================

AnimateDoor:
	LDA #1
	BIT MaybeDoorReturnTwiceFlag
	BNE loc_ABEA
	TXA
	ORA #1
	STA MaybeDoorReturnTwiceFlag
	LDA #$20
	STA byte_338
	LDA #0
	STA byte_339
	LDA #Sound_Door			; door opens/closes
	JSR QueueSound			; door

loc_ABEA:
	DEC byte_338
	BEQ loc_ABF0
	RTS
; ---------------------------------------------------------------------------

loc_ABF0:
	INC byte_339
	LDX byte_339
	CPX #3
	BNE loc_AC00
	LDA #0
	STA MaybeDoorReturnTwiceFlag
	RTS
; ---------------------------------------------------------------------------

loc_AC00:
	LDA #8
	CPX #1
	BEQ loc_AC08
	LDA #$20

loc_AC08:
	STA byte_338
	DEX
	LDY #0
	LDA MaybeDoorReturnTwiceFlag
	BPL loc_AC19
	TXA
	EOR #1
	TAX
	LDY #2

loc_AC19:
	STXc byte_0
	STYc byte_1
	LDA EntryDoorType
	ASL A
	ASL A
	TAY
	CLC
	ADCc byte_0
	TAX
	LDA DoorPositionTileTable,X
	PHA
	LDA DoorPositionTileTable+2,Y
	CLC
	ADCc byte_1
	ADCc byte_0
	STAc byte_1
	PLA
	JSR sub_92AD
	LDAc byte_1
	JSR sub_9716
	LDAc byte_1
	JSR HandleTileAttributes
	RTS
; End of function AnimateDoor

; =============== S U B	R O U T	I N E =======================================

GameState_9_ExitRoom:
	LDA #1
	BIT byte_340
	BNE loc_AC5B
	STA byte_340
	LDY #0
	JSR ClearFourSpritesInY

loc_AC5B:
	JSR AnimateDoorClose
	LDA a:CurrentRoomIDBackup3
	JSR MaybeLoadRoomFlags		; called with room id
	LDA EntryDoorType
	LSR A
	LSR A
	TAY
	INY
	LDA (off_3D),Y
	LDX CurrentRoomID
	STA CurrentRoomID
	LDA #2
	STAc GameState			; -> 2 (load room)
	CPX #$90
	BCC loc_AC8D			; 90 <=	x < A0
	CPX #$A0
	BCS loc_AC8D
	LDA #8
	STAc GameState			; -> 8 (round clear)
	LDA #0
	STA a:GS8_Status			; not entirely understood but w/e
	STX LastBombRoomCleared		; used in gdv and difficulty sel

loc_AC8D:
	LDA CurrentRoomID
	CMP #$AC
	BNE loc_AC97
	JSR GoToTheTortureRoom

loc_AC97:
	CPX #$A0
	BCC loc_ACA2
	CPX #$A4
	BCS loc_ACA2
	JSR EndingDoorChecks

loc_ACA2:
	LDA CurrentRoomID
	JSR IfNotTitleScreenRoomDoThings ; A=room. double-returns if Z set
	LDY #0

loc_ACAA:
	JSR sub_9592			; maybe	check room data	for objs
	LDA a:byte_5C
	TAX
	AND #$F0
	BEQ loc_ACD9
	CMP #$80
	BNE loc_ACAA
	TXA
	AND #$F
	STAc byte_1
	LDA EntryDoorType
	EOR #4
	CMPc byte_1
	BEQ loc_ACD0
	EOR #2
	CMPc byte_1
	BNE loc_ACAA

loc_ACD0:
	STA EntryDoorType
	LDAc MaybeCollectedThing
	STA byte_33C

loc_ACD9:
	LDA #0
	STA byte_340
	RTS
; End of function GameState_9_ExitRoom

; =============== S U B	R O U T	I N E =======================================

EndingDoorChecks:
	TXA					; X = room id (A0~A3)
	AND #3
	STA EndingType			; 0-3 (worst, good, great, best)
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD _EndCheckCrystalBall1
	.WORD _EndCheckCrystalBall2
	.WORD _EndCheck5SecretCoins
	.WORD _EndGame
; End of function EndingDoorChecks

; =============== S U B	R O U T	I N E =======================================

_EndCheckCrystalBall1:
	LDA PlayerCrystalBallsCollected
	BEQ _EndGame			; If no	balls, end
	RTS
; End of function _EndCheckCrystalBall1

; =============== S U B	R O U T	I N E =======================================

_EndCheckCrystalBall2:
	LDA PlayerCrystalBallsCollected
	CMP #3				; If not both balls, end
	BNE _EndGame
	RTS
; End of function _EndCheckCrystalBall2

; =============== S U B	R O U T	I N E =======================================

_EndCheck5SecretCoins:
	LDA PlayerSecretCoins
	CMP #5				; If not at least 5 coins, end
	BCC _EndGame
	RTS
; End of function _EndCheck5SecretCoins

; =============== S U B	R O U T	I N E =======================================

_EndGame:
	JSR RestoreDefaultPalettes
	LDA #$C
	STA a:GameState			; -> C (ending)
	LDA #0
	STA a:EndingState
	LDA #3
	JSR AddAToGDV			; +3 points for	reaching ending
	RTS
; End of function _EndGame

; ---------------------------------------------------------------------------
byte_AD19:
	.BYTE %11111100
	.BYTE %11110011			; 1 ; 1110 1101	1011 0111 (2 nib per #)
	.BYTE %11001111			; 2
	.BYTE %00111111			; 3
UnknownDoorTable:
	.BYTE  $1F
	.BYTE    6				; 1
	.BYTE  $17				; 2
	.BYTE    3				; 3
	.BYTE    3				; 4
	.BYTE  $1A				; 5
	.BYTE    3				; 6
	.BYTE  $1F				; 7
	.BYTE   $E				; 8
	.BYTE    3				; 9
IFDEF REV_US
	.BYTE  $0F				; $A
ELSE
	.BYTE  $1F				; $A
ENDIF
	.BYTE  $16				; $B
	.BYTE  $1E				; $C
	.BYTE  $17				; $D
	.BYTE  $16				; $E
	.BYTE   $B				; $F
	.BYTE    3				; $10
	.BYTE  $1E				; $11
	.BYTE  $1D				; $12
	.BYTE  $10				; $13
	.BYTE  $13				; $14
	.BYTE  $1A				; $15
	.BYTE  $11				; $16
	.BYTE  $19				; $17
	.BYTE  $1D				; $18
	.BYTE  $1E				; $19
	.BYTE   $A				; $1A
	.BYTE  $1F				; $1B
	.BYTE    5				; $1C
	.BYTE  $12				; $1D
	.BYTE    3				; $1E
	.BYTE  $16				; $1F

; =============== S U B	R O U T	I N E =======================================

TitleScreenHandler:
	; POI/Revision:	US has additional states here,
	; related to a new copyright screen added
	LDA a:TitleScreenState		
	JSR JumpTable

IFDEF REV_US
	.WORD TitleScreen_US_0
	.WORD TitleScreen_US_1
ENDIF
	.WORD TitleScreen_0
	.WORD TitleScreen_1

IFDEF ROUND_SELECT
	.WORD BypassStart
ELSE
	.WORD TitleScreen_2
ENDIF
	.WORD TitleScreen_3
; End of function TitleScreenHandler

; =============== S U B	R O U T	I N E =======================================
IFDEF REV_US
TitleScreen_US_0:
	JSR ClearAllSprites
	JSR ClearNametable
	LDA #$1C
	JSR WriteStringToPPU
	LDA #$1D
	JSR WriteStringToPPU
	LDA #$1E
	JSR WriteStringToPPU
	LDA #$1F
	JSR WriteStringToPPU
	LDA #$84
	STA TempSpriteX
	LDA #$63
	STA TempSpriteY
	LDA #$87
	JSR WriteBCDDigitsSprites
	LDA #$74
	STA TempSpriteX
	LDA #$19
	JSR WriteBCDDigitsSprites
	INC TitleScreenState
	LDA #0
	STA CopyrightScreenTimer
	JMP TitleScreen_US_0_Jump

TitleScreen_US_1:
	LDA Joypad1_Immediate
	AND #JP_Start
	BNE +
	DEC CopyrightScreenTimer
	BNE ++
+	LDA #2
	STA TitleScreenState		; (-> 0 JP)
++	RTS
ENDIF

TitleScreen_0:
	JSR DrawTitleScreen
	LDA #Strings_PushStartButton
	JSR WriteStringToPPU		; push start button
	LDA #Strings_C_Tecmo
	JSR WriteStringToPPU		; (c) tecmo
	LDA #Strings_HighGDV
	JSR WriteStringToPPU		; high gdv
IFDEF REV_US
	LDA #$1B					; @TODO string fix
	JSR WriteStringToPPU		; high gdv
ENDIF
	JSR DrawScore			; draw score sprites?
	LDA #$CC
	STAc TempSpriteX
	LDA #$1C
	STAc TempSpriteY
	LDA HighGDV
	JSR WriteBCDDigitsSprites
IFDEF REV_US
	LDA #$93
	STA TempSpriteY
	LDA #$CC
	STA TempSpriteX
	LDA #$87
	JSR WriteBCDDigitsSprites
	LDA #$BC
	STA TempSpriteX
	LDA #$19
	JSR WriteBCDDigitsSprites
	LDA #0
	STA TitleScreenTimer
	STA TitleScreenTimer+1
ENDIF
	INCc TitleScreenState		; 00 ->	01
	RTS
; End of function TitleScreen_0

; =============== S U B	R O U T	I N E =======================================

DrawTitleScreen:
	JSR ClearAllSprites
	LDA #BasePointer_AdjacentRoomsTable ; (1)
	STAc PPUUpdateFlag1
	JSR LoadPointerTo050		; 1 (adjacent rooms table)
	LDAc word_50
	STA a:off_3D
	LDAc word_50+1
	STA a:off_3D+1
	LDA #0
	STA CurrentRoomID
	JSR LoadRoomStuff
	JSR DrawFullScreen
TitleScreen_US_0_Jump:
	LDAc PPUMaskMirror
	ORA #6
	STAc PPUMaskMirror
	RTS
; End of function DrawTitleScreen

; =============== S U B	R O U T	I N E =======================================

TitleScreen_1:
	JSR InitPlayerStruct
	LDA #$78
	STA PlayerYPosHi
	LDA #$28
	STA PlayerXPosHi
	JSR DrawPlayer
	INCc TitleScreenState		; 01 ->	02
	RTS
; End of function TitleScreen_1

; =============== S U B	R O U T	I N E =======================================

TitleScreen_2:
	LDA Joypad1_Immediate
	AND #JP_Start
	BEQ +
	AND a:Joypad1_ImmediateCopy
	BEQ loc_ADC0
IFDEF REV_US
+	DEC TitleScreenTimer
	BNE +
	INC TitleScreenTimer+1
	LDA TitleScreenTimer+1
	CMP #2
	BNE +
	LDA #0
	STA TitleScreenState
ENDIF

locret_ADBF:
+	RTS
; ---------------------------------------------------------------------------

loc_ADC0:
	LDA #0
	JSR LoadObjectPointerA
	JSR sub_BB1C
	LDA #$80
	STA PlayerXVelLo
	LDA #3
	STA PlayerSprite
	INC a:TitleScreenState		; 02 ->	03
	LDA #0
	RTS
; End of function TitleScreen_2

; =============== S U B	R O U T	I N E =======================================

TitleScreen_3:
	LDA #8
	JSR sub_B0AF			; maybe	apply x/y vel +	draw player
	LDA PlayerYPosHi
	CMP #$D8
	BCC locret_ADF5
	JSR ClearNametable
	JSR ClearAllSprites
	LDA #0
	STAc TitleScreenState		; 03 ->	00
	STAc GameState
	INCc InGameFlag

locret_ADF5:
	RTS
; End of function TitleScreen_3

; =============== S U B	R O U T	I N E =======================================

GameState_1_RoundIntro:
	LDA GameState1Flag
	BNE +
	INC GameState1Flag
	JSR ClearAllSprites
	JSR ClearNametable
	JSR DrawRoundIntroSprites

+	DEC a:GameState1WaitTimer
	BNE +ret
	INCc GameState			; 1 -> 2
	JSR ClearAllSprites
	LDA #0
	STAc GameState1Flag

+ret:
	RTS
; ---------------------------------------------------------------------------

DrawRoundIntroSprites:
	JSR CopyNext5BytesToTempSprite
	SpriteData  $C, $10, $84, $60, $24 ;; "x"
	JSR WriteSprite
	JSR CopyNext5BytesToTempSprite
	SpriteData   0,   1, $70, $60, $20 ;; Bomb Jack
	JSR WriteSprite
	LDA #$60
	STA a:GameState1WaitTimer
	JSR CopyNext5BytesToTempSprite
	SpriteData   0, $10, $94, $60, $25 ;; Lives counter
	LDA PlayerLives
	JSR WriteBCDDigitsSprites
					; POI: draws this as if	it is BCD.
					; nothing else treats the life count
					; like BCD, so when you	(somehow) get
					; 15 lives, it says nothing, then 10.
	RTS
; End of function GameState_1_RoundIntro

; =============== S U B	R O U T	I N E =======================================

; ending

GameState_C_Ending:
	LDA a:EndingState
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD EndingState_0
	.WORD EndingState_1
	.WORD EndingState_2
	.WORD EndingState_3
	.WORD EndingState_4
; End of function GameState_C_Ending

; =============== S U B	R O U T	I N E =======================================

EndingState_0:
	JSR DrawTitleScreen
	JSR InitPlayerStruct
	LDA #0
	TAX

loc_AE5B:
	STA AttributeTableBuffer,X	; delete title text
	INX
	CPX #$1F
	BNE loc_AE5B
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #0
	STA PPUDATA
	TAY
	LDX #2
	LDA #$24

loc_AE75:
	STA PPUDATA
	DEY
	BNE loc_AE75
	DEX
	BNE loc_AE75
	LDA #$78
	STA PlayerXPosHi
	LDA #$E8
	STA PlayerYPosHi
	INC a:EndingState
	RTS
; End of function EndingState_0

; =============== S U B	R O U T	I N E =======================================

EndingState_3:
	LDA EndingType			; 0-3 (worst, good, great, best)
	ASL A
	TAX
	LDA EndingStringTable,X
	STA byte_0
	LDA EndingStringTable+1,X
	STA byte_1

loc_AE9B:
	LDA byte_0
	JSR WriteStringToPPU
	INC byte_0
	DEC byte_1
	BNE loc_AE9B
	LDX EndingType			; 0-3 (worst, good, great, best)
	LDA EndingPyramidDigTable,X

loc_AEAC:
	STA byte_37B
	LDA #$40
	STA byte_3E7
	LDA #Music_Ending
	JSR QueueSound			; ending
	INC a:EndingState
	RTS
; End of function EndingState_3

; ---------------------------------------------------------------------------
EndingPyramidDigTable:
	.BYTE $90,$A0,$B0,$C0	 ;	DATA XREF: EndingState_3+1Dr
					; maybe	how far	down to	dig the
					; pyramid out during the ending?

; =============== S U B	R O U T	I N E =======================================

EndingState_4:
	LDA byte_37B
	CMP PlayerYPosHi
	BCS loc_AED1
	LDA #$40
	STA byte_3E7
	NOP					; POI: hmm
	NOP
	NOP

loc_AED1:
	JSR sub_B0AF			; maybe	apply x/y vel +	draw player
	LDA Joypad1_Immediate
	AND #JP_Start
	BEQ locret_AEE8
	AND a:Joypad1_ImmediateCopy
	BNE locret_AEE8
	STAc TitleScreenState		; = 0
	LDA #$A
	STAc GameState

locret_AEE8:
	RTS
; End of function EndingState_4

; =============== S U B	R O U T	I N E =======================================

EndingState_1:
	LDA #1
	STA PlayerSprite
	LDA #8
	JSR sub_B0AF			; maybe	apply x/y vel +	draw player
	LDA byte_3E7
	CMP #$40
	BCC locret_AF21
	INC a:EndingState
	LDX EndingType			; 0-3 (worst, good, great, best)
	LDA EndingPyramidDestroyDepth,X
	STA byte_372
	LDA #0
	STA byte_373
	LDA #$E
	STA byte_374
	LDA #$22
	STA byte_375
	LDX #2
	STX byte_376
	DEX
	STX byte_379
	STX byte_37C

locret_AF21:
	RTS
; End of function EndingState_1

; =============== S U B	R O U T	I N E =======================================

EndingState_2:
	LDA #0
	STA byte_10
	LDA #$10
	STA byte_11
	LDA byte_372
	BEQ loc_AF3E
	DEC byte_379
	BNE loc_AF3E
	LDA #8
	STA byte_379
	DEC byte_372
	INC byte_10

loc_AF3E:
	LDA #1
	JSR LoadObjectPointerA
	LDA #0
	STA byte_37A
	LDA #$E
	STA byte_13

loc_AF4C:
	LDY #0
	LDA (EnemyStructPointer),Y
	LSR A
	BCC loc_AF59
	JSR sub_B024
	JMP loc_AF79
; ---------------------------------------------------------------------------

loc_AF59:
	LDA byte_11
	TAY
	JSR ClearFourSpritesInY
	LDA byte_11
	CLC
	ADC #$10
	STA byte_11
	LDA byte_10
	BEQ loc_AF76
	BMI loc_AF76
	ORA #$80
	STA byte_10
	JSR sub_AFA9
	JMP loc_AF79
; ---------------------------------------------------------------------------

loc_AF76:
	INC byte_37A

loc_AF79:
	LDA a:EnemyStructPointer
	CLC
	ADC #$C
	STA a:EnemyStructPointer
	LDA a:EnemyStructPointer+1
	ADC #0
	STA a:EnemyStructPointer+1
	DEC byte_13
	BNE loc_AF4C
	LDA byte_37A
	CMP #$E
	BNE loc_AF98
	INC a:EndingState

loc_AF98:
	DEC byte_37C
	BNE locret_AFA8
	LDA #Sound_BombBonus		; collected bombs in right order
	JSR QueueSound			; bomb bonus
	LDA Object0Struct+$B
	STA byte_37C

locret_AFA8:
	RTS
; End of function EndingState_2

; =============== S U B	R O U T	I N E =======================================

sub_AFA9:
	LDY #0
	LDA #1
	STA (EnemyStructPointer),Y
	TYA

loc_AFB0:
	INY
	STA (EnemyStructPointer),Y
	CPY #$B
	BNE loc_AFB0
	LDA byte_374
	CLC
	ADC byte_373
	STA byte_3F0
	TAX
	LDA byte_375
	STA byte_3EF
	AND #3
	STA byte_0
	TXA
	ASL A
	ASL A
	ASL A
	LDY #2
	STA (EnemyStructPointer),Y
DoorCond_20_US:
	TXA
	LSR byte_0
	ROR A
	LSR byte_0
	ROR A
	AND #$F8
	INY
	STA (EnemyStructPointer),Y
	LDA #0
	INY
	STA (EnemyStructPointer),Y
	INY
	STA (EnemyStructPointer),Y
	INC byte_373
	LDA byte_373
	CMP byte_376
	BNE loc_B011
	LDA #0
	STA byte_373
	LDA byte_376
	CLC
	ADC #2
	STA byte_376
	LDA byte_374
	ADC #$1F
	STA byte_374
	LDA byte_375
	ADC #0
	STA byte_375

loc_B011:
	LDA #1
	STA byte_3F1
	LDA #$24
	STA PPUUpdateBuffer
	LDA #0
	STA byte_3EE
	STA a:PPUUpdateFlag1
	RTS
; End of function sub_AFA9

; =============== S U B	R O U T	I N E =======================================

sub_B024:
	LDY #EnemyStruct_A_YVelHi
	LDA (EnemyStructPointer),Y
	CLC
	ADC #2
	STA (EnemyStructPointer),Y
	CMP #$80
	BCS loc_B07A
	STA (EnemyStructPointer),Y
	JSR sub_8AE8
	TYA
	PHA
	LDY #6
	TAX
	CLC
	ADC (EnemyStructPointer),Y
	STA (EnemyStructPointer),Y
	INY
	PLA
	ADC (EnemyStructPointer),Y
	STA (EnemyStructPointer),Y
	STA byte_0
	LDY #4
	LDA #$80
	CLC
	ADC (EnemyStructPointer),Y
	STA (EnemyStructPointer),Y
	LDA #1
	INY
	ADC (EnemyStructPointer),Y
	STA (EnemyStructPointer),Y
	LDY #2
	CLC
	ADC (EnemyStructPointer),Y
	STA byte_1
	JSR sub_B080
	LDY #2
	LDA (EnemyStructPointer),Y
	LDY #5
	SEC
	SBC (EnemyStructPointer),Y
	STA byte_1
	JSR sub_B080
	LDY #$B
	LDA (EnemyStructPointer),Y
	SEC
	ADC #0
	STA (EnemyStructPointer),Y
	RTS
; ---------------------------------------------------------------------------

loc_B07A:
	LDY #0
	TYA
	STA (EnemyStructPointer),Y
	RTS
; End of function sub_B024

; =============== S U B	R O U T	I N E =======================================

sub_B080:
	LDY #EnemyStruct_3_XPosLo
	LDA (EnemyStructPointer),Y
	CLC
	ADC byte_0
	JSR sub_B094
	LDA (EnemyStructPointer),Y
	CLC
	ADC byte_0
	SEC
	LDY #EnemyStruct_B_YPosHi
	SBC (EnemyStructPointer),Y
; End of function sub_B080

; fall through

; =============== S U B	R O U T	I N E =======================================

sub_B094:
	LDX byte_11
	STA SpriteDMAArea,X
	LDA #$8E
	STA SpriteDMAArea+1,X
	LDA #2
	STA SpriteDMAArea+2,X
	LDA byte_1
	STA SpriteDMAArea+3,X
	TXA
	CLC
	ADC #4
	STA byte_11
	RTS
; End of function sub_B094

; =============== S U B	R O U T	I N E =======================================

; maybe	apply x/y vel +	draw player

sub_B0AF:
	PHA
	LDA #0
	JSR LoadObjectPointerA
	PLA
	TAX
	JSR DoSomethingWithObjYVel
	JSR ApplyPlayerXAndYVelocity
	LDA #$20
	STA byte_3DD
	JSR DrawPlayer
	RTS
; End of function sub_B0AF

; =============== S U B	R O U T	I N E =======================================

; bytes:
; 00 - tile index to use
; 01 - attribute?
; 02 -
; 03 - sprite index
; Attributes: noreturn

CopyNext5BytesToTempSprite:
	PLA					; Pull return address
	TAY
	CLC
	INY					; Add 1	to get actual address
	BNE loc_B0CD
	SEC

loc_B0CD:
	STY TempPointer_0C0
	PLA					; Get high byte	of address
	ADC #0				; Handle overflow
	STA TempPointer_0C0+1
	LDY #0
	LDX #0

loc_B0D8:
	LDA (TempPointer_0C0),Y
	STA a:TempSpriteTile,X		; Copy 5 bytes here
	INX
	INY
	CPX #5
	BNE loc_B0D8
	TYA
	CLC
	ADC TempPointer_0C0		; Add the bytes	to the indirect	offset
	BCC loc_B0EB			; and handle overflow
	INC TempPointer_0C0+1

loc_B0EB:
	STA TempPointer_0C0
	JMP (TempPointer_0C0)		; Then jump back to where we came from + 5
; End of function CopyNext5BytesToTempSprite

; ---------------------------------------------------------------------------
EndingStringTable:
	EndingText Strings_Ending1A, 3 ;
	EndingText Strings_Ending2A,   3 ;	; 1
	EndingText Strings_Ending3A,   4 ;	; 2
	EndingText Strings_Ending4A,   4 ;	; 3
EndingPyramidDestroyDepth:
	.BYTE 12
	.BYTE 30				; 1
	.BYTE 56				; 2
	.BYTE 90				; 3

; =============== S U B	R O U T	I N E =======================================

.include "src/music-engine.asm"

; =============== S U B	R O U T	I N E =======================================

HandleEnemySpawnTimer:
	LDA PlayerStruct
	BPL loc_B576
	RTS
; ---------------------------------------------------------------------------

loc_B576:
	LDA a:EnemyCoinTimer
	ORA a:EnemyCoinTimer+1
	BEQ loc_B57F			; If enemies are not turned into coins,
					; then continue
	RTS
; ---------------------------------------------------------------------------

loc_B57F:
	LDX InitFlag_LoadedDifficulty
	BNE _AfterDiffInit
	INC InitFlag_LoadedDifficulty
	LDA LastBombRoomCleared		; Get last bomb	room cleared(?)
	AND #$F				; Shave	off only the bottom digit
	ASL A
	ASL A				; Multiply by 4	(0-F ->	0-3F)
	STA DifficultyModifier
	JSR LoadDifficultySettings
	LDA #0
	STA AliveEnemyCount		; = 0

_AfterDiffInit:
	DEC EnemySpawnTimer
	BNE locret_B5A6
	JSR LoadDifficultySettings
	LDA AliveEnemyCount		; CMP #4
	CMP #4				; Maximum of 4 enemies alive
	BCC _SpawnEnemy			; If less than 4, spawn	new one

locret_B5A6:
	RTS
; ---------------------------------------------------------------------------

_SpawnEnemy:
	JSR sub_BA00
	INC AliveEnemyCount		; inc
	LDA #0
	JSR InitEnemy
	JSR ChooseEnemySpawnPoint
	JSR OrEnemyStatusWith08		; also sets +$12 = #$20
	RTS
; End of function HandleEnemySpawnTimer

; =============== S U B	R O U T	I N E =======================================

; POI: enemy initialization

InitEnemy:
	PHA					; A = type; push
	LDY #0
	TYA

loc_B5BC:
	STA (EnemyStructPointer),Y	; init all vars	to 0
	INY
	CPY #$1C
	BNE loc_B5BC
	LDY #EnemyStruct_E_Sprite
	LDA #$25
	STA (EnemyStructPointer),Y
	PLA					; restore enemy	type
	JSR RunEnemyInit
	RTS
; End of function InitEnemy

; =============== S U B	R O U T	I N E =======================================

; A = enemy type

RunEnemyInit:
	TAX					; A -> X
	LDA EnemyInitialStatus,X
	LDY #EnemyStruct_0_Status
	STA (EnemyStructPointer),Y
	TYA					; A = 0
	LDY #EnemyStruct_1B
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_10_AnimOffset
	STA (EnemyStructPointer),Y
	INY					; Y = #$11
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_14
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_SpeedMod	; from difficulty
	LDA a:EnemySpeedModifier
	STA (EnemyStructPointer),Y
	TXA					; X -> A
	LDY #EnemyStruct_13_Type	; 0-7=enemy
	STA (EnemyStructPointer),Y
	JSR JumpTable			; seems	to be called
					; when an enemy	spawns or transforms
; ---------------------------------------------------------------------------
	.WORD ObjInit_0_Mummy		; 0	Mummy
	.WORD Obj_null			; 1 ; 1	Unknown
	.WORD ObjInit_2_Hanezo		; 2 ; 2	Hanezo
	.WORD ObjCode_3_GejiShogun		; 3 ; 3	GejiShogun
	.WORD ObjInit_4_Gameido		; 4 ; 4	Gameido
	.WORD ObjInit_5_Dokuron		; 5 ; 5	Dokuron
	.WORD ObjInit_6_Desufa		; 6 ; 6	Desufa
	.WORD ObjInit_7_Horus		; 7 ; 7	Horus
	.WORD ObjInit_8_PowerCoin		; 8 ; 8	PowerCoin
	.WORD ObjInit_9_E_ExtraBonusCoin	; 9 ; 9	ExtraCoin
	.WORD Obj_null			; $A ; A SecretCoin
	.WORD Obj_null			; $B ; B Captive
	.WORD ObjInit_C_Balloon		; $C ; C Balloon
	.WORD ObjInit_D_F_MummyAlt		; $D ; D Mummy1
	.WORD ObjInit_9_E_ExtraBonusCoin	; $E ; E BonusCoin
	.WORD ObjInit_D_F_MummyAlt		; $F ; F Mummy2
	.WORD ObjInit_10_Brother		; $10 ;	10 Brother
; End of function RunEnemyInit

; =============== S U B	R O U T	I N E =======================================

LoadDifficultySettings:
	LDX DifficultyModifier		; (last	bomb room & #$0F) << 4
	LDA DifficultyTable,X		; (0 ~ 3F)
	STA EnemySpeedModifier
	INX
	LDA DifficultyTable,X
	STA EnemySpawnTimer
	INX
	LDA a:RoomStatusFlags		; if bit 1 (#$02) clear, bump up diff
	AND #2
	BNE loc_B62F
	INX

loc_B62F:
	LDA DifficultyTable,X
	STA EnemyTransformTimer
	RTS
; End of function LoadDifficultySettings

; =============== S U B	R O U T	I N E =======================================

; also sets +$12 = #$20

OrEnemyStatusWith08:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	ORA #8
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_12
	LDA #$20
	STA (EnemyStructPointer),Y
	RTS
; End of function OrEnemyStatusWith08

; =============== S U B	R O U T	I N E =======================================

sub_B645:
	LDA #8
	STA byte_12
	LDA #4
	STA byte_13

loc_B64D:
	LDA byte_BA
	JSR LoadObjectPointerAPlus1
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y	; load status
	LSR A				; check	lowest bit?
	BCC loc_B66A			; if unset, jump ahead
	JSR DrawEnemies
	JSR RunEnemyLogic
	JSR CheckObjectCollision
	JSR MaybeRemoveIfOffscreen
	DEC a:byte_13
	BEQ loc_B679

loc_B66A:
	LDX byte_BA
	INX
	CPX #8
	BNE loc_B673
	LDX #0

loc_B673:
	STX byte_BA
	DEC byte_12
	BNE loc_B64D

loc_B679:
	LDA a:UnknownFlag_0FE
	BEQ locret_B681
	DEC a:UnknownFlag_0FE

locret_B681:
	RTS
; End of function sub_B645

; =============== S U B	R O U T	I N E =======================================

MaybeDrawEnemySprites:
	LDA PlayerStruct
	BPL loc_B688
	RTS
; ---------------------------------------------------------------------------

loc_B688:
	LDA a:byte_56
	CLC
	ADC #$18
	STA a:CurrentSpriteIndex
	LDA #0

loc_B693:
	PHA
	JSR LoadObjectPointerAPlus1
	LDA a:CurrentSpriteIndex
	CMP #$38
	BNE loc_B6A3
	LDA #$18
	STA a:CurrentSpriteIndex

loc_B6A3:
	LDY #0
	LDA (EnemyStructPointer),Y
	LSR A
	BCC loc_B6C7
	JSR sub_B7B4
	LDA a:PPUUpdateFlag1
	BEQ loc_B6DE
	LDY #6
	LDA (EnemyStructPointer),Y
	BNE loc_B6C7
	LDY #$C
	LDA (EnemyStructPointer),Y
	BNE loc_B6C7
	JSR CopyEnemyToTempSprite
	JSR WriteSprite
	JMP loc_B6DE
; ---------------------------------------------------------------------------

loc_B6C7:
	LDA a:PPUUpdateFlag1
	BEQ loc_B6DE
	INC MaybeTempSpriteIndex	; used for rotating sprites?
	LDX MaybeTempSpriteIndex	; i.e. flickering
	LDA a:CurrentSpriteIndex
	STA MaybeTempSpriteIndex,X
	CLC
	ADC #4
	STA a:CurrentSpriteIndex

loc_B6DE:
	PLA
	CLC
	ADC #1
	CMP #8
	BNE loc_B693
	LDA a:PPUUpdateFlag1
	BEQ locret_B70D

loc_B6EB:
	LDX MaybeTempSpriteIndex
	BEQ loc_B6FE
	LDA MaybeTempSpriteIndex,X
	DEC MaybeTempSpriteIndex
	ASL A
	ASL A
	TAY
	JSR ClearFourSpritesInY
	BEQ loc_B6EB

loc_B6FE:
	LDA a:byte_56
	CLC
	ADC #4
	CMP #$20
	BNE loc_B70A
	LDA #0

loc_B70A:
	STA a:byte_56

locret_B70D:
	RTS
; End of function MaybeDrawEnemySprites

; =============== S U B	R O U T	I N E =======================================

RunEnemyLogic:
	LDY #EnemyStruct_1
	LDA (EnemyStructPointer),Y
	AND #$F
	STA TempPointer_0C0+1
	LDY #EnemyStruct_13_Type	; 0-7=enemy
	LDA (EnemyStructPointer),Y
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD ObjCode_0_Mummy		; 0	Mummy
	.WORD Obj_null			; 1 ; 1	Unknown
	.WORD ObjCode_2_Hanezo		; 2 ; 2	Hanezo
	.WORD ObjCode_3_GejiShogun		; 3 ; 3	GejiShogun
	.WORD ObjCode_4_Gameido		; 4 ; 4	Gameido
	.WORD ObjCode_5_Dokuron		; 5 ; 5	Dokuron
	.WORD ObjCode_6_Desufa		; 6 ; 6	Desufa
	.WORD ObjCode_7_Horus		; 7 ; 7	Horus
	.WORD ObjCode_8_PowerCoin		; 8 ; 8	PowerCoin
	.WORD ObjCode_9_E_ExtraBonusCoin	; 9 ; 9	ExtraCoin
	.WORD Obj_null			; $A ; A SecretCoin
	.WORD Obj_null			; $B ; B Captive
	.WORD Obj_null			; $C ; C Balloon
	.WORD ObjCode_0_Mummy		; $D ; D Mummy1
	.WORD ObjCode_9_E_ExtraBonusCoin	; $E ; E BonusCoin
	.WORD ObjCode_0_Mummy		; $F ; F Mummy2
	.WORD ObjCode_10_Brother		; $10 ;	10 Brother
; End of function RunEnemyLogic

; =============== S U B	R O U T	I N E =======================================
LoadObjectPointerAPlus1:
	CLC
	ADC #1

	LoadObjectPointerA:
	ASL A
	TAX
	LDA ObjectPointers,X
	STA EnemyStructPointer
	LDA ObjectPointers+1,X
	STA EnemyStructPointer+1
	RTS
; End of function LoadObjectPointerA

; =============== S U B	R O U T	I N E =======================================
; removes from ptr $07A
RemoveEnemy:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	LSR A
	BCC +ret			; if bit 1 not set, rts
	TYA					; A=0
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_13_Type	; 0-7=enemy
	LDA (EnemyStructPointer),Y
	CMP #8
	BCS +ret
	DEC AliveEnemyCount		; dec

+ret
	RTS
; End of function RemoveEnemy

; ---------------------------------------------------------------------------
	.BYTE $60
; =============== S U B	R O U T	I N E =======================================

sub_B765:
	LDY #EnemyStruct_SpeedMod	; from difficulty
	LDA (EnemyStructPointer),Y
	ASL A
	TAX
	LDA word_C0D3,X
	STA Mod_Number
	LDA word_C0D3+1,X
	STA Mod_Number+1
	RTS
; End of function sub_B765

; =============== S U B	R O U T	I N E =======================================

MaybeRemoveIfOffscreen:
	LDY #EnemyStruct_6		; maybe	"offscreen x"
	JSR MaybeConsiderOffscreen
	LDY #EnemyStruct_C		; maybe	"offscreen y"
	JSR MaybeConsiderOffscreen
	RTS
; End of function MaybeRemoveIfOffscreen

; =============== S U B	R O U T	I N E =======================================

MaybeConsiderOffscreen:
	LDA (EnemyStructPointer),Y
	BEQ +ret
	LDY #EnemyStruct_13_Type	; 0-7=enemy
	LDA (EnemyStructPointer),Y
	CMP #8
	BNE +RemoveDoubleRet
	LDA #0
	STA MaybeTempCollectableFlag	; cleared
	STA MaybeTempCollectableFlag2	; cleared

+RemoveDoubleRet:
	JSR RemoveEnemy			; removes from ptr $07A
	PLA
	PLA

+ret:
	RTS
; End of function MaybeConsiderOffscreen

; =============== S U B	R O U T	I N E =======================================

CopyEnemyToTempSprite:
	LDY #EnemyStruct_5_XPosHi
	LDA (EnemyStructPointer),Y
	STA TempSpriteX
	LDY #EnemyStruct_B_YPosHi
	LDA (EnemyStructPointer),Y
	STA TempSpriteY
	LDY #EnemyStruct_E_Sprite
	LDA (EnemyStructPointer),Y
	STA TempSpriteTile
	LDY #EnemyStruct_F
	LDA (EnemyStructPointer),Y
	STA TempSpriteAttributesish
	RTS
; End of function CopyEnemyToTempSprite

; =============== S U B	R O U T	I N E =======================================

sub_B7B4:
	LDY #2
	LDX #0
	JSR sub_B7BF
	LDX #2
	LDY #8				; fallthrough
; End of function sub_B7B4

; =============== S U B	R O U T	I N E =======================================

sub_B7BF:
	TYA
	PHA
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #$20
	BNE loc_B7CF
	LDA (EnemyStructPointer),Y
	AND #8
	BEQ loc_B7D7

loc_B7CF:
	LDA #0
	STA byte_0
	STA byte_1
	BEQ loc_B7E4

loc_B7D7:
	PLA
	TAY
	PHA
	LDA (EnemyStructPointer),Y
	STA byte_0
	INY
	INY
	LDA (EnemyStructPointer),Y
	STA byte_1

loc_B7E4:
	LDA a:byte_98,X
	CLC
	ADC byte_0
	STA byte_0
	LDA a:byte_99,X
	ADC byte_1
	STA byte_1
	PLA
	TAY
	INY
	LDA byte_0
	CLC
	ADC (EnemyStructPointer),Y
	STA (EnemyStructPointer),Y
	INY
	INY
	LDX #0
	LDA byte_1
	BPL loc_B806
	DEX

loc_B806:
	ADC (EnemyStructPointer),Y
	STA (EnemyStructPointer),Y
	TXA
	INY
	ADC (EnemyStructPointer),Y
	STA (EnemyStructPointer),Y
	RTS
; End of function sub_B7BF

; =============== S U B	R O U T	I N E =======================================

InitPowerCoin:
	LDA a:RoomStatusFlags
	AND #RF_BombRoom
	BEQ loc_B822
	LDA #$78
	STA byte_92
	LDA #$80
	STA byte_94
	BNE loc_B82E

loc_B822:
	LDA a:byte_F0
	JSR sub_9276
	LDY #EnemyStruct_17
	LDA #$10
	STA (EnemyStructPointer),Y

loc_B82E:
	LDY #EnemyStruct_5_XPosHi
	LDA byte_94
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_B_YPosHi
	LDA byte_92
	STA (EnemyStructPointer),Y
	RTS
; End of function InitPowerCoin

; =============== S U B	R O U T	I N E =======================================

ChooseEnemySpawnPoint:
	LDA #BasePointer_EnemySpawnPositionTable
	JSR LoadPointerTo050		; E (enemy spawn pos table)
	LDA a:CurrentRoomIDBackup3	; Get room ID,
	ASL A				; and calc offset to data
	BCC loc_B848
	INC word_50+1

loc_B848:
	CLC
	ADC word_50
	STA word_50
	LDA word_50+1
	ADC #0
	STA word_50+1
	LDY #0				; Load the first byte
	LDA (word_50),Y			; If the first byte is 00
	BNE _ContinueSpawn		; un-spawn and exit

_AbortSpawn:
	JSR RemoveEnemy			; removes from ptr $07A
	RTS
; ---------------------------------------------------------------------------

_ContinueSpawn:
	JSR SpawnLocFunc1
	LDX #0
	JSR SpawnLocFunc2		; called w X=0,	2
	LDY #1
	LDA (word_50),Y
	BEQ loc_B894
	JSR SpawnLocFunc1
	LDX #2
	JSR SpawnLocFunc2		; called w X=0,	2
	LDA byte_E
	BNE loc_B87B
	LDY byte_C
	BEQ _AbortSpawn

loc_B87B:
	LDY byte_C
	BEQ loc_B894
	LDX #0
	CMP byte_C
	PHP
	LDA a:RoomStatusFlags
	AND #RF_SingleScreen
	BEQ loc_B88F
	PLA
	EOR #1
	PHA

loc_B88F:
	PLP
	BCS loc_B894
	LDX #2

loc_B894:
	LDA a:byte_8,X
	LDY #EnemyStruct_5_XPosHi
	STA (EnemyStructPointer),Y
	LDA a:byte_9,X
	LDY #EnemyStruct_B_YPosHi
	STA (EnemyStructPointer),Y
	RTS
; End of function ChooseEnemySpawnPoint

; =============== S U B	R O U T	I N E =======================================

SpawnLocFunc1:
	LDY #2				; A = spawn pos	byte
	STA byte_0
	TAX
	LDA #$18
	BIT a:RoomStatusFlags
	BNE loc_B8CE
	LDA #$20
	BIT a:RoomStatusFlags
	BEQ loc_B8C0
	ASL byte_0
	ASL byte_0
	ASL byte_0
	ASL byte_0
	LDY #0

loc_B8C0:
	LDA byte_0
	EOR byte_3C2,Y
	BMI loc_B8CE
	LDA #0
	STA byte_94
	STA byte_92
	RTS
; ---------------------------------------------------------------------------

loc_B8CE:
	TXA
	JSR sub_9276
	RTS
; End of function SpawnLocFunc1

; =============== S U B	R O U T	I N E =======================================

; called w X=0,	2

SpawnLocFunc2:
	LDA byte_94
	BEQ loc_B901
	STA a:byte_8,X
	LDA a:byte_92
	BEQ loc_B901
	STA a:byte_9,X
	LDA PlayerXPosHi
	SEC
	SBC byte_94
	BCS loc_B8EE
	EOR #$FF
	ADC #1

loc_B8EE:
	STA a:byte_C,X
	LDA PlayerYPosHi
	SEC
	SBC byte_92
	BCS loc_B8FD
	EOR #$FF
	ADC #1

loc_B8FD:
	CLC
	ADC a:byte_C,X

loc_B901:
	STA a:byte_C,X
	RTS
; End of function SpawnLocFunc2

; =============== S U B	R O U T	I N E =======================================

DrawEnemies:
	LDA a:EnemyCoinTimer
	ORA a:EnemyCoinTimer+1
	BEQ _DrawEnemy
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #$10
	BNE _DrawEnemy
	LDA (EnemyStructPointer),Y
	ORA #$20
	STA (EnemyStructPointer),Y
	LDA #$21
	LDY #EnemyStruct_E_Sprite
	STA (EnemyStructPointer),Y
	INY
	LDA #2
	LDX a:EnemyCoinTimer+1
	BNE loc_B93F
	LDX a:EnemyCoinTimer
	CPX #$40
	BCS loc_B93F			; when coin timer almost up
	LDA (EnemyStructPointer),Y
	AND #$FC
	STA byte_0
	LDA (EnemyStructPointer),Y
	TAX
	INX
	TXA
	AND #3
	ORA byte_0

loc_B93F:
	STA (EnemyStructPointer),Y
	RTS
; ---------------------------------------------------------------------------

_DrawEnemy:
	LDA (EnemyStructPointer),Y
	AND #$DF
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_12
	LDA (EnemyStructPointer),Y
	BEQ loc_B96C
	SEC
	SBC #1
	STA (EnemyStructPointer),Y
	TAX
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #8
	BEQ loc_B974
	CPX #$10
	BCC loc_B974
	LDY #EnemyStruct_E_Sprite
	LDA #$25
	STA (EnemyStructPointer),Y
	INY
	LDA #0
	STA (EnemyStructPointer),Y
	RTS
; ---------------------------------------------------------------------------

loc_B96C:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #$F7
	STA (EnemyStructPointer),Y

loc_B974:
	LDY #EnemyStruct_11
	LDA (EnemyStructPointer),Y
	BEQ loc_B980
	TAX
	DEX
	TXA
	STA (EnemyStructPointer),Y
	RTS
; ---------------------------------------------------------------------------

loc_B980:
	LDY #EnemyStruct_13_Type	; 0-7=enemy
	LDA (EnemyStructPointer),Y
	LDX #0
	CMP #7
	BNE loc_B98C
	LDX #1

loc_B98C:
	STX byte_CF
	ASL A
	TAX
	LDA SpriteAnimationTable,X
	STA TempPointer_0C0
	INX
	LDA SpriteAnimationTable,X
	STA TempPointer_0C0+1

loc_B99B:
	LDY #EnemyStruct_10_AnimOffset
	LDA (EnemyStructPointer),Y
	TAY
	LDA (TempPointer_0C0),Y
	TAX
	INX
	BNE loc_B9C0
	LDA byte_CF
	BEQ loc_B9B5
	LDY #EnemyStruct_D
	LDA (EnemyStructPointer),Y
	LDY #EnemyStruct_10_AnimOffset
	STA (EnemyStructPointer),Y
	JMP loc_B99B
; ---------------------------------------------------------------------------

loc_B9B5:
	LDY #EnemyStruct_1B
	LDA (EnemyStructPointer),Y
	LDY #EnemyStruct_10_AnimOffset
	STA (EnemyStructPointer),Y
	JMP loc_B99B
; ---------------------------------------------------------------------------

loc_B9C0:
	STY byte_C2
	LDY #EnemyStruct_11
	STA (EnemyStructPointer),Y
	LDY byte_C2
	INY
	LDA (TempPointer_0C0),Y
	PHA
	INY
	LDA (TempPointer_0C0),Y
	INY
	STY byte_C2
	LDY #EnemyStruct_14
	ORA (EnemyStructPointer),Y
	LDY #EnemyStruct_F
	STA (EnemyStructPointer),Y
	PLA
	DEY
	STA (EnemyStructPointer),Y
	LDY byte_C2
	TYA
	LDY #EnemyStruct_10_AnimOffset
	STA (EnemyStructPointer),Y
	RTS
; End of function DrawEnemies

; =============== S U B	R O U T	I N E =======================================

SpawnPowerCoin:
	LDA #2
	BIT MaybeTempCollectableFlag	; check	#2 here
	BEQ +
	RTS

+	ORA MaybeTempCollectableFlag	; or #2	here
	STA MaybeTempCollectableFlag	; and store
	JSR sub_BA00
	LDA #EnemyType_8_PowerCoin
	JSR InitEnemy
	JSR InitPowerCoin
	RTS
; End of function SpawnPowerCoin

; =============== S U B	R O U T	I N E =======================================

sub_BA00:
	LDA #0

-	PHA
	JSR LoadObjectPointerAPlus1
	PLA
	TAX
	LDY #0
	LDA (EnemyStructPointer),Y
	LSR A
	BCC +ret
	INX
	TXA
	CMP #8
	BNE -
	PLA
	PLA

+ret:
	RTS
; End of function sub_BA00

; =============== S U B	R O U T	I N E =======================================

JT_98A4_8_PowerCoin:
	JSR RemoveEnemy			; removes from ptr $07A
							; fallthrough to turn enemies into coins
TurnEnemiesIntoCoins:
	LDA #$40
	STA a:EnemyCoinTimer
	LDA #1				; $140 frames (320, 5 1/3sec)
	STA a:EnemyCoinTimer+1
	LDA #Sound_PowerCoinMusic
	JSR QueueSound			; power	coin music
	LDX #0
	STX a:byte_54

-	TXA
	AND #3
	BEQ +
	TAY
	LDA GoldCoinSpritePalette,Y
	STA PaletteBuffer+$18,X

+	INX
	CPX #4
	BNE -
	INC a:UpdatePaletteFlag
	RTS
; End of function TurnEnemiesIntoCoins

; ---------------------------------------------------------------------------
GoldCoinSpritePalette:
	.BYTE    0,   8, $26, $30

; =============== S U B	R O U T	I N E =======================================

sub_BA48:
	LDY #EnemyStruct_2_XVelLo
	JSR sub_BA7B
	RTS
; End of function sub_BA48

; =============== S U B	R O U T	I N E =======================================

sub_BA4E:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #2
	BEQ locret_BA94
	LDA (EnemyStructPointer),Y
	AND #$FD
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_8_YVelLo
	JSR ResetEnemyVelocity		; (ESP),Y, Y+2 = 0
	LDY #EnemyStruct_B_YPosHi
	LDA (EnemyStructPointer),Y
	AND #$F8
	TAX
	LDA #$30
	AND a:RoomStatusFlags
	BEQ loc_BA75
	CPX #$E0
	BCC loc_BA75
	LDX #$D8

loc_BA75:
	TXA
	STA (EnemyStructPointer),Y
	RTS
; End of function sub_BA4E

; ---------------------------------------------------------------------------
	LDY #EnemyStruct_8_YVelLo	; POI: ? not logged/referenced?

; =============== S U B	R O U T	I N E =======================================

sub_BA7B:
	LDA (EnemyStructPointer),Y
	TAX
	INY
	INY
	STY a:byte_11
	LDA (EnemyStructPointer),Y
	TAY
	JSR NegateYYXX			; e.g. 2 -> FFFE
	TYA
	LDY a:byte_11
	STA (EnemyStructPointer),Y
	DEY
	DEY
	TXA
	STA (EnemyStructPointer),Y

locret_BA94:
	RTS
; End of function sub_BA7B

; =============== S U B	R O U T	I N E =======================================

; (ESP),Y, Y+2 = 0

ResetEnemyVelocity:
	LDA #0
	STA (EnemyStructPointer),Y
	INY
	INY
	STA (EnemyStructPointer),Y
	RTS
; End of function ResetEnemyVelocity

; =============== S U B	R O U T	I N E =======================================

sub_BA9E:
	LDY #EnemyStruct_4_XVelHi
	LDX #0
	LDA (EnemyStructPointer),Y
	BMI loc_BAA8
	LDX #4

loc_BAA8:
	TXA
	LDY #EnemyStruct_14
	STA (EnemyStructPointer),Y
	RTS
; End of function sub_BA9E

; =============== S U B	R O U T	I N E =======================================

ObjCode_9_E_ExtraBonusCoin:
	LDA a:RoomStatusFlags
	AND #2
	BNE loc_BAB6
	RTS
; ---------------------------------------------------------------------------

loc_BAB6:
	LDA a:TempPointer_0C0+1
	AND #4
	BNE loc_BAD5
	LDY #EnemyStruct_1A
	LDA (EnemyStructPointer),Y
	AND #$FE
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #2
	BEQ loc_BAD1
	JSR DoSomethingWithObjYVel
	RTS
; ---------------------------------------------------------------------------

loc_BAD1:
	JSR sub_BB1C
	RTS
; ---------------------------------------------------------------------------

loc_BAD5:
	LDY #EnemyStruct_1A
	LDA (EnemyStructPointer),Y
	AND #1
	BNE loc_BAFB
	LDA (EnemyStructPointer),Y
	ORA #1
	STA (EnemyStructPointer),Y
	JSR sub_BB39
	LDY #EnemyStruct_B_YPosHi
	LDA (EnemyStructPointer),Y
	AND #$F8
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_8_YVelLo
	JSR ResetEnemyVelocity		; (ESP),Y, Y+2 = 0
	LDY #0
	LDA (EnemyStructPointer),Y
	AND #$FD
	STA (EnemyStructPointer),Y

loc_BAFB:
	LDY #EnemyStruct_SpeedMod	; from difficulty
	LDA #5
	STA (EnemyStructPointer),Y
	JSR JustCallBD64
	RTS
; End of function ObjCode_9_E_ExtraBonusCoin

; =============== S U B	R O U T	I N E =======================================

Obj_null:
	RTS
; End of function Obj_null

; =============== S U B	R O U T	I N E =======================================

ObjInit_0_Mummy:
	LDY #EnemyStruct_1B
	LDA #7
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_10_AnimOffset
	STA (EnemyStructPointer),Y
	INY
	LDA #0
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_15
	LDA EnemyTransformTimer
	STA (EnemyStructPointer),Y
; End of function ObjInit_0_Mummy

; =============== S U B	R O U T	I N E =======================================

sub_BB1C:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	ORA #2
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_18
	LDA #0
	STA (EnemyStructPointer),Y
	INY
	INY
	STA (EnemyStructPointer),Y	; 1A
	DEY					; 19
	LDA #$40
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_2_XVelLo
	JSR ResetEnemyVelocity		; (ESP),Y, Y+2 = 0
	RTS
; End of function sub_BB1C

; =============== S U B	R O U T	I N E =======================================

sub_BB39:
	LDY #EnemyStruct_2_XVelLo
	LDA #$80
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_5_XPosHi
	LDX #0
	LDA (EnemyStructPointer),Y
	SEC
	SBC PlayerXPosHi
	BCC loc_BB4D
	LDX #$FF

loc_BB4D:
	TXA
	DEY
	STA (EnemyStructPointer),Y
	RTS
; End of function sub_BB39

; =============== S U B	R O U T	I N E =======================================

ObjCode_0_Mummy:
	JSR sub_BA9E
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #8
	BEQ loc_BB5E
	RTS
; ---------------------------------------------------------------------------

loc_BB5E:
	LDA a:TempPointer_0C0+1
	AND #4
	BEQ loc_BBA2
	LDY #EnemyStruct_1A
	LDA (EnemyStructPointer),Y
	AND #$FD
	STA (EnemyStructPointer),Y
	LSR A
	BCS loc_BBB0
	SEC
	ROL A
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #$FD
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_8_YVelLo
	JSR ResetEnemyVelocity		; (ESP),Y, Y+2 = 0
	LDY #EnemyStruct_1B
	LDA #0
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_10_AnimOffset
	STA (EnemyStructPointer),Y
	INY
	STA (EnemyStructPointer),Y
	JSR sub_BB39
	LDA a:RoomStatusFlags
	AND #2
	BEQ loc_BBB0
	LDY #EnemyStruct_B_YPosHi
	LDA (EnemyStructPointer),Y
	CMP #$D8
	BCC loc_BBB0
	BCS TransformMummy

loc_BBA2:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	AND #2
	BEQ loc_BBB0
	JSR DoSomethingWithObjYVel
	JMP locret_BC11
; ---------------------------------------------------------------------------

loc_BBB0:
	LDY #EnemyStruct_15
	LDA (EnemyStructPointer),Y
	BEQ loc_BBBD
	SEC
	SBC #1
	STA (EnemyStructPointer),Y
	BPL loc_BBCF

loc_BBBD:
	LDA a:RoomStatusFlags
	AND #RF_BombRoom
	BEQ TransformMummy
	LDA a:TempPointer_0C0+1
	AND #4
	BNE loc_BBD6
	JSR ObjInit_0_Mummy
	RTS
; ---------------------------------------------------------------------------

loc_BBCF:
	LDA a:TempPointer_0C0+1
	AND #4
	BEQ loc_BBDD

loc_BBD6:
	LDA a:TempPointer_0C0+1
	AND #3
	BEQ locret_BC11

loc_BBDD:
	LDY #EnemyStruct_1A
	LDA (EnemyStructPointer),Y
	AND #2
	BNE locret_BC11
	LDA (EnemyStructPointer),Y
	ORA #2
	STA (EnemyStructPointer),Y
	JSR sub_BA48
	RTS
; ---------------------------------------------------------------------------

TransformMummy:
	LDA a:APressCounter		; POI: mod-6 enemy spawn behavior
	STA a:Mod_Number
	LDA #0
	STA a:Mod_Number+1
	LDA #6
	STA a:Mod_Modulus
	JSR CalculateModulus
	INC a:Mod_Remainder
	INC a:Mod_Remainder
	LDA a:Mod_Remainder
	JSR RunEnemyInit
	JSR OrEnemyStatusWith08		; also sets +$12 = #$20

locret_BC11:
	RTS
; End of function ObjCode_0_Mummy

; =============== S U B	R O U T	I N E =======================================

ObjInit_2_Hanezo:
	JSR sub_B765
	LDY #EnemyStruct_2_XVelLo
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	LDY #EnemyStruct_8_YVelLo
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
; End of function ObjInit_2_Hanezo

; =============== S U B	R O U T	I N E =======================================

ObjCode_2_Hanezo:
	JSR JustCallBD64
	JSR JustCallBD81
	RTS
; End of function ObjCode_2_Hanezo

; =============== S U B	R O U T	I N E =======================================

ObjCode_3_GejiShogun:
	JSR ObjInitCode_3a
	RTS
; End of function ObjCode_3_GejiShogun

; =============== S U B	R O U T	I N E =======================================

ObjInit_4_Gameido:
	LDY #EnemyStruct_7		; maybe	"player	x/y target range"
	LDA #$60
	STA (EnemyStructPointer),Y
	LDA #2
	STA a:TempPointer_0C0+1
; End of function ObjInit_4_Gameido

; =============== S U B	R O U T	I N E =======================================

ObjCode_4_Gameido:
	LDY #EnemyStruct_SpeedMod	; from difficulty
	LDA (EnemyStructPointer),Y
	TAX
	LDA byte_C0CB,X
	LDY #EnemyStruct_7		; maybe	"player	x/y target range"
	STA (EnemyStructPointer),Y
	JSR ObjCode_4a
	RTS
; End of function ObjCode_4_Gameido

; =============== S U B	R O U T	I N E =======================================

ObjInit_5_Dokuron:
	JSR sub_B765
	LDY #EnemyStruct_8_YVelLo
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
; End of function ObjInit_5_Dokuron

; =============== S U B	R O U T	I N E =======================================

ObjCode_5_Dokuron:
	JSR ObjCode_5a
	JSR JustCallBD81
	RTS
; End of function ObjCode_5_Dokuron

; =============== S U B	R O U T	I N E =======================================

ObjInit_6_Desufa:
	JSR sub_B765
	LDY #EnemyStruct_2_XVelLo
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
; End of function ObjInit_6_Desufa

; =============== S U B	R O U T	I N E =======================================

ObjCode_6_Desufa:
	JSR sub_BDC2
	JSR JustCallBD64
	RTS
; End of function ObjCode_6_Desufa

; =============== S U B	R O U T	I N E =======================================

ObjInit_7_Horus:
	JSR sub_B765
	LDY #EnemyStruct_7		; maybe	"player	x/y target range"
	LDA #1
	STA (EnemyStructPointer),Y
; End of function ObjInit_7_Horus

; =============== S U B	R O U T	I N E =======================================

ObjCode_7_Horus:
	JSR ObjCode_7a
	RTS
; End of function ObjCode_7_Horus

; =============== S U B	R O U T	I N E =======================================

ObjInit_8_PowerCoin:
	LDA a:RoomStatusFlags
	AND #2
	BNE loc_BC84
	LDY #EnemyStruct_A_YVelHi
	LDA #$FF
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_D
	LDA #8
	STA (EnemyStructPointer),Y
	RTS
; ---------------------------------------------------------------------------

loc_BC84:
	LDY #EnemyStruct_SpeedMod	; from difficulty
	LDA #5
	STA (EnemyStructPointer),Y
	JSR sub_B765
	LDY #2
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	LDY #8
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	RTS
; End of function ObjInit_8_PowerCoin

; =============== S U B	R O U T	I N E =======================================

ObjCode_8_PowerCoin:
	LDA a:RoomStatusFlags
	AND #2
	BNE loc_BCB3
	LDY #EnemyStruct_D
	LDA (EnemyStructPointer),Y
	BEQ locret_BCB2
	SEC
	SBC #1
	STA (EnemyStructPointer),Y
	BNE locret_BCB2
	LDY #EnemyStruct_A_YVelHi
	LDA #0
	STA (EnemyStructPointer),Y

locret_BCB2:
	RTS
; ---------------------------------------------------------------------------

loc_BCB3:
	JSR JustCallBD64
	JSR JustCallBD81
	RTS
; End of function ObjCode_8_PowerCoin

; =============== S U B	R O U T	I N E =======================================

ObjInit_9_E_ExtraBonusCoin:
	LDA #Sound_BonusCoinSpawn
	JSR QueueSound			; bonus	coin spawned
	LDA a:RoomStatusFlags
	AND #RF_BombRoom
	BEQ loc_BCCA
	JSR sub_BB1C
	RTS
; ---------------------------------------------------------------------------

loc_BCCA:
	LDY #EnemyStruct_0_Status
	LDA (EnemyStructPointer),Y
	ORA #4
	STA (EnemyStructPointer),Y
	RTS
; End of function ObjInit_9_E_ExtraBonusCoin

; =============== S U B	R O U T	I N E =======================================

ObjInit_C_Balloon:
	LDY #EnemyStruct_A_YVelHi
	LDA #$FF
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_12
	LDA #$C
	STA (EnemyStructPointer),Y
	RTS
; End of function ObjInit_C_Balloon

; =============== S U B	R O U T	I N E =======================================

ObjInit_D_F_MummyAlt:
	INC a:AliveEnemyCount
	LDA #0
	JSR InitEnemy
	LDA EnemyTransformTimer
	LDY #EnemyStruct_15
	STA (EnemyStructPointer),Y
	JSR OrEnemyStatusWith08		; also sets +$12 = #$20
	RTS
; End of function ObjInit_D_F_MummyAlt

; =============== S U B	R O U T	I N E =======================================

ObjInit_10_Brother:
	LDA a:Collected1UPThisRoundFlag	; Brother spawner?
	BEQ locret_BCFD			; If already got one,
	LDA #$B				; spawn	green pharoah instead
	JSR InitEnemy

locret_BCFD:
	RTS
; End of function ObjInit_10_Brother

; =============== S U B	R O U T	I N E =======================================

ObjCode_10_Brother:
	LDA #$C8
	STA a:TempSpriteY
	LDA #$70
	STA a:TempSpriteX
	LDX #$F
	LDY #EnemyStruct_E_Sprite
	LDA (EnemyStructPointer),Y
	BEQ loc_BD12
	LDX #$F2

loc_BD12:
	TXA
	JSR Draw1UPSprite
	RTS
; End of function ObjCode_10_Brother

; =============== S U B	R O U T	I N E =======================================

ObjCode_4a:
	LDA a:TempPointer_0C0+1
	BNE loc_BD1D
	RTS
; ---------------------------------------------------------------------------

loc_BD1D:
	LDY #EnemyStruct_5_XPosHi
	JSR sub_BDE9			; called with XPosHi and YPosHi
	TXA
	BNE loc_BD2F
	LDA #1
	BIT a:TempPointer_0C0+1
	BNE loc_BD36
	JMP loc_BD39
; ---------------------------------------------------------------------------

loc_BD2F:
	LDA #2
	BIT a:TempPointer_0C0+1
	BNE loc_BD39

loc_BD36:
	JSR Negate_Mod_Number

loc_BD39:
	LDY #2
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	LDY #EnemyStruct_B_YPosHi
	JSR sub_BDE9			; called with XPosHi and YPosHi
	TXA
	BNE loc_BD50
	LDA #4
	BIT a:TempPointer_0C0+1
	BNE loc_BD57
	JMP loc_BD5A
; ---------------------------------------------------------------------------

loc_BD50:
	LDA #8
	BIT a:TempPointer_0C0+1
	BNE loc_BD5A

loc_BD57:
	JSR Negate_Mod_Number

loc_BD5A:
	LDY #8
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	RTS
; End of function ObjCode_4a

; =============== S U B	R O U T	I N E =======================================

JustCallBD64:
	JSR sub_BD64
	RTS
; End of function JustCallBD64

; =============== S U B	R O U T	I N E =======================================

sub_BD64:
	LDA a:TempPointer_0C0+1
	AND #3
	BEQ locret_BD7C
	JSR sub_B765
	LDA a:TempPointer_0C0+1
	LSR A
	BCC loc_BD77
	JSR Negate_Mod_Number

loc_BD77:
	LDY #2
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2

locret_BD7C:
	RTS
; End of function sub_BD64

; =============== S U B	R O U T	I N E =======================================

JustCallBD81:
	JSR sub_BD81
	RTS
; End of function JustCallBD81

; =============== S U B	R O U T	I N E =======================================

sub_BD81:
	LDA a:TempPointer_0C0+1
	AND #$C
	BEQ locret_BD9A
	JSR sub_B765
	LDA a:TempPointer_0C0+1
	AND #4
	BEQ loc_BD95
	JSR Negate_Mod_Number

loc_BD95:
	LDY #8
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2

locret_BD9A:
	RTS
; End of function sub_BD81

; =============== S U B	R O U T	I N E =======================================

ObjCode_5a:
	LDY #EnemyStruct_5_XPosHi
	JSR sub_BE2F
; End of function ObjCode_5a

; =============== S U B	R O U T	I N E =======================================

sub_BDA0:
	TXA
	PHA
	JSR sub_B765
	PLA
	BNE loc_BDB2
	LDA #1
	BIT a:TempPointer_0C0+1
	BNE loc_BDB9
	JMP loc_BDBC
; ---------------------------------------------------------------------------

loc_BDB2:
	LDA #2
	BIT a:TempPointer_0C0+1
	BNE loc_BDBC

loc_BDB9:
	JSR Negate_Mod_Number

loc_BDBC:
	LDY #2
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	RTS
; End of function sub_BDA0

; =============== S U B	R O U T	I N E =======================================

sub_BDC2:
	LDY #EnemyStruct_B_YPosHi
	JSR sub_BE2F
; End of function sub_BDC2

; =============== S U B	R O U T	I N E =======================================

sub_BDC7:
	TXA
	PHA
	JSR sub_B765
	PLA
	BNE loc_BDD9
	LDA #4
	BIT a:TempPointer_0C0+1
	BNE loc_BDE0
	JMP loc_BDE3
; ---------------------------------------------------------------------------

loc_BDD9:
	LDA #8
	BIT a:TempPointer_0C0+1
	BNE loc_BDE3

loc_BDE0:
	JSR Negate_Mod_Number

loc_BDE3:
	LDY #8
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	RTS
; End of function sub_BDC7

; =============== S U B	R O U T	I N E =======================================

; called with XPosHi and YPosHi

sub_BDE9:
	LDA PlayerStruct,Y
	SEC
	SBC (EnemyStructPointer),Y
	PHP					; get absolute value
	BCS loc_BDF7			; if it	underflowed,
	EOR #$FF			; negate it and	add one
	SEC
	ADC #0

loc_BDF7:
	STA a:Mod_Number+1		; x #$100 (store as hi byte)
	LDA #0
	STA a:Mod_Number
	LDY #EnemyStruct_7		; maybe	"player	x/y target range"
	LDA (EnemyStructPointer),Y
	STA a:Mod_Modulus
	LDX #$10
	JSR CalculateModulus
	LDX #0
	PLP
	BCS locret_BE11
	INX

locret_BE11:
	RTS
; End of function sub_BDE9

; =============== S U B	R O U T	I N E =======================================

Negate_Mod_Number:
	LDX a:Mod_Number
	LDY a:Mod_Number+1
	JSR NegateYYXX			; e.g. 2 -> FFFE
	STX a:Mod_Number
	STY a:Mod_Number+1
	RTS
; End of function Negate_Mod_Number

; =============== S U B	R O U T	I N E =======================================

; lo=(o),y  hi=(o),y+2

Store_Mod_Number_ToEnemy:
	LDA a:Mod_Number
	STA (EnemyStructPointer),Y
	INY
	INY
	LDA a:Mod_Number+1
	STA (EnemyStructPointer),Y
	RTS
; End of function Store_Mod_Number_ToEnemy

; =============== S U B	R O U T	I N E =======================================

; called with Y	= XPosHi / YPosHi

sub_BE2F:
	STY a:TempY
	LDY #EnemyStruct_D
	LDA (EnemyStructPointer),Y
	TAX
	INX
	TXA
	STA (EnemyStructPointer),Y
	LDY a:TempY
	ASL A
	ASL A
	ASL A
	BCS loc_BE4C
	LDA PlayerStruct,Y
	CLC
	ADC #$10
	JMP loc_BE52
; ---------------------------------------------------------------------------

loc_BE4C:
	LDA PlayerStruct,Y
	SEC
	SBC #$10

loc_BE52:
	CMP (EnemyStructPointer),Y
	LDX #0
	BCS locret_BE59
	INX

locret_BE59:
	RTS
; End of function sub_BE2F

; =============== S U B	R O U T	I N E =======================================

ObjInitCode_3a:
	LDY #EnemyStruct_5_XPosHi
	JSR SetXIfPlayerAndEnemyVarMatch
	JSR sub_BDA0
	LDY #EnemyStruct_D
	LDA (EnemyStructPointer),Y
	BEQ loc_BE74
	TAX
	DEX
	TXA
	STA (EnemyStructPointer),Y
	LDA a:TempPointer_0C0+1
	AND #$F
	BEQ locret_BE89

loc_BE74:
	LDY #EnemyStruct_B_YPosHi
	JSR SetXIfPlayerAndEnemyVarMatch
	JSR sub_BDC7
	LDA a:TempPointer_0C0+1
	AND #$F
	BEQ locret_BE89
	LDY #EnemyStruct_D
	LDA #$30
	STA (EnemyStructPointer),Y

locret_BE89:
	RTS
; End of function ObjInitCode_3a

; =============== S U B	R O U T	I N E =======================================

SetXIfPlayerAndEnemyVarMatch:
	LDA PlayerStruct,Y
	CMP (EnemyStructPointer),Y
	LDX #0
	BCS locret_BE94
	INX

locret_BE94:
	RTS
; End of function SetXIfPlayerAndEnemyVarMatch

; =============== S U B	R O U T	I N E =======================================

ObjCode_7a:
	LDA a:TempPointer_0C0+1
	BNE loc_BEA8
	LDA Obj7_Timer
	BEQ loc_BEA3
	DEC Obj7_Timer
	RTS
; ---------------------------------------------------------------------------

loc_BEA3:
	LDA #$10
	STA Obj7_Timer

loc_BEA8:
	NOP					; POI: ?
	JSR sub_B765
	LDY #EnemyStruct_5_XPosHi
	JSR SubtractPlayerAndEnemyVarMaybe
	STX a:byte_C2
	STA a:byte_C5
	LDY #EnemyStruct_B_YPosHi
	JSR SubtractPlayerAndEnemyVarMaybe
	STX a:byte_C3
	STA a:byte_CB
	CMP a:byte_C5
	BCS loc_BECD
	JSR sub_BF17
	JMP loc_BED0
; ---------------------------------------------------------------------------

loc_BECD:
	JSR sub_BF4E

loc_BED0:
	JSR sub_BF85
	LDA a:byte_C7
	LDY #7
	STA (EnemyStructPointer),Y
	JSR sub_BFBC
	JSR Store_Mod_Number_ToEnemy	; lo=(o),y  hi=(o),y+2
	JSR ResetEitherXOrYVelocity
	JSR sub_BEE7
	RTS
; End of function ObjCode_7a

; =============== S U B	R O U T	I N E =======================================

sub_BEE7:
	LDA a:byte_C7
	LDX #7
	LSR A
	BCS loc_BEF6
	LDX #0
	LSR A
	BCS loc_BEF6
	LDX #$E

loc_BEF6:
	TXA
	LDY #EnemyStruct_D
	CMP (EnemyStructPointer),Y
	BEQ locret_BF05
	LDY #EnemyStruct_10_AnimOffset
	STA (EnemyStructPointer),Y
	LDY #EnemyStruct_D
	STA (EnemyStructPointer),Y

locret_BF05:
	RTS
; End of function sub_BEE7

; =============== S U B	R O U T	I N E =======================================

SubtractPlayerAndEnemyVarMaybe:
	LDA PlayerStruct,Y
	SEC
	SBC (EnemyStructPointer),Y
	LDX #0
	BCS locret_BF16
	INX
	EOR #$FF
	TAY
	INY
	TYA

locret_BF16:
	RTS
; End of function SubtractPlayerAndEnemyVarMaybe

; =============== S U B	R O U T	I N E =======================================

sub_BF17:
	LDX #2
	LDA a:byte_C2
	BNE loc_BF2B
	LDX #1
	STX a:byte_CA
	LDX #2
	STX a:byte_CC
	JMP loc_BF33
; ---------------------------------------------------------------------------

loc_BF2B:
	STX a:byte_CA
	LDX #1
	STX a:byte_CC

loc_BF33:
	LDX #8
	LDA a:byte_C3
	BNE loc_BF45
	LDX #4
	STX a:byte_CB
	LDX #8
	STX a:byte_CD
	RTS
; ---------------------------------------------------------------------------

loc_BF45:
	STX a:byte_CB
	LDX #4
	STX a:byte_CD
	RTS
; End of function sub_BF17

; =============== S U B	R O U T	I N E =======================================

sub_BF4E:
	LDX #8
	LDA a:byte_C3
	BNE loc_BF62
	LDX #4
	STX a:byte_CA
	LDX #8
	STX a:byte_CD
	JMP loc_BF6A
; ---------------------------------------------------------------------------

loc_BF62:
	STX a:byte_CA
	LDX #4
	STX a:byte_CD

loc_BF6A:
	LDX #2
	LDA a:byte_C2
	BNE loc_BF7C
	LDX #1
	STX a:byte_CB
	LDX #2
	STX a:byte_CC
	RTS
; ---------------------------------------------------------------------------

loc_BF7C:
	STX a:byte_CB
	LDX #1
	STX a:byte_CC
	RTS
; End of function sub_BF4E

; =============== S U B	R O U T	I N E =======================================

sub_BF85:
	LDY #EnemyStruct_7		; maybe	"player	x/y target range"
	LDA (EnemyStructPointer),Y
	LDX #2
	LSR A
	BCS loc_BF9A
	LDX #1
	LSR A
	BCS loc_BF9A
	LDX #8
	LSR A
	BCS loc_BF9A
	LDX #4

loc_BF9A:
	STX a:byte_C7
	LDX #0

loc_BF9F:
	LDA a:byte_CA,X
	AND a:TempPointer_0C0+1
	BEQ loc_BFAD

loc_BFA7:
	INX
	CPX #4
	BNE loc_BF9F
	RTS
; ---------------------------------------------------------------------------

loc_BFAD:
	LDA a:byte_CA,X
	AND a:byte_C7
	BNE loc_BFA7
	LDA a:byte_CA,X
	STA a:byte_C7
	RTS
; End of function sub_BF85

; =============== S U B	R O U T	I N E =======================================

sub_BFBC:
	LDA a:byte_C7
	AND #$A
	BEQ loc_BFC6
	JSR Negate_Mod_Number

loc_BFC6:
	LDY #8
	LDA a:byte_C7
	AND #3
	BEQ locret_BFD1
	LDY #2

locret_BFD1:
	RTS
; End of function sub_BFBC

; =============== S U B	R O U T	I N E =======================================

ResetEitherXOrYVelocity:
	LDY #EnemyStruct_8_YVelLo
	LDA a:byte_C7
	AND #3
	BNE loc_BFDD
	LDY #EnemyStruct_2_XVelLo

loc_BFDD:
	JSR ResetEnemyVelocity		; (ESP),Y, Y+2 = 0
	RTS
; End of function ResetEitherXOrYVelocity

; ---------------------------------------------------------------------------


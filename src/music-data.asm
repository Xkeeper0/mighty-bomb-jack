IFDEF REV_US
	PAD $F39E, $00
ENDIF

NoteLengthTable:
	.BYTE	  0			; 0
	.BYTE	  1			; 1 ; $1F entries
	.BYTE	  2			; 2
	.BYTE	  3			; 3
	.BYTE	  4			; 4
	.BYTE	  6			; 5
	.BYTE	  8			; 6
	.BYTE	 12			; 7
	.BYTE	 16			; 8
	.BYTE	 24			; 9
	.BYTE	 32			; $A
	.BYTE	 48			; $B
	.BYTE	 64			; $C
	.BYTE	 96			; $D
	.BYTE	128			; $E
	.BYTE	 80			; $F
	.BYTE	  7			; $10
	.BYTE	 14			; $11
	.BYTE	 28			; $12
	.BYTE	  5			; $13
	.BYTE	 10			; $14
	.BYTE	 60			; $15
	.BYTE	  6			; $16
	.BYTE	  9			; $17
	.BYTE	 12			; $18
	.BYTE	 18			; $19
	.BYTE	 24			; $1A
	.BYTE	 36			; $1B
	.BYTE	 48			; $1C
	.BYTE	 72			; $1D
	.BYTE	 96			; $1E
	.BYTE	144			; $1F
SoundVolTable:
	.WORD SoundVolTable_0		  ;	DATA XREF: SoundCommand_Ax_Bx+8r
	.WORD SoundVolTable_1		; 1 ; 0: 1F->10, 1/f
	.WORD SoundVolTable_2		; 2
	.WORD SoundVolTable_3		; 3
	.WORD SoundVolTable_4		; 4
	.WORD SoundVolTable_5		; 5
	.WORD SoundVolTable_6		; 6
	.WORD SoundVolTable_7		; 7
SoundVolTable_0:
	.BYTE  $1F,   1
	.BYTE  $1E,	  1			; 2 ; 0: 1F->10, 1/f
	.BYTE  $1D,	  1			; 4
	.BYTE  $1C,	  1			; 6
	.BYTE  $1B,	  1			; 8
	.BYTE  $1A,	  1			; $A
	.BYTE  $19,	  1			; $C
	.BYTE  $18,	  1			; $E
	.BYTE  $17,	  1			; $10
	.BYTE  $16,	  1			; $12
	.BYTE  $15,	  1			; $14
	.BYTE  $14,	  1			; $16
	.BYTE  $13,	  1			; $18
	.BYTE  $12,	  1			; $1A
	.BYTE  $11,	  1			; $1C
	.BYTE  $10,	$FF			; $1E
SoundVolTable_1:
	.BYTE  $1D,   1
	.BYTE  $1E,	  1			; 2 ; 1: 1d-1f,	1/f
	.BYTE  $1F,	$FF			; 4
SoundVolTable_2:
	.BYTE  $1F,   1
	.BYTE  $1D,	  1			; 2 ; 2: 1f->10, 2/f
	.BYTE  $1B,	  1			; 4
	.BYTE  $19,	  1			; 6
	.BYTE  $17,	  1			; 8
	.BYTE  $15,	  1			; $A
	.BYTE  $13,	  1			; $C
	.BYTE    1,	  1			; $E
	.BYTE  $10,	$FF			; $10
SoundVolTable_3:
	.BYTE  $12,   1
	.BYTE  $14,	  1			; 2 ; 3: 12->1f,hold->10
	.BYTE  $16,	  1			; 4
	.BYTE  $18,	  1			; 6
	.BYTE  $1A,	  1			; 8
	.BYTE  $1C,	  1			; $A
	.BYTE  $1E,	  1			; $C
	.BYTE  $1F,	$30			; $E
	.BYTE  $1E,	  1			; $10
	.BYTE  $1D,	  1			; $12
	.BYTE  $1C,	  1			; $14
	.BYTE  $1B,	  1			; $16
	.BYTE  $1A,	  1			; $18
	.BYTE  $19,	  1			; $1A
	.BYTE  $18,	  1			; $1C
	.BYTE  $17,	  1			; $1E
	.BYTE  $16,	  1			; $20
	.BYTE  $15,	  1			; $22
	.BYTE  $14,	  1			; $24
	.BYTE  $13,	  1			; $26
	.BYTE  $12,	  1			; $28
	.BYTE  $11,	  1			; $2A
	.BYTE  $10,	$FF			; $2C
SoundVolTable_4:
	.BYTE  $1F, $FF			    ; 4: 1f	forever
SoundVolTable_5:
	.BYTE  $1F,   2
	.BYTE  $10,	$FF			; 2 ; 5: 1f->1f->10, 1/f
SoundVolTable_6:
	.BYTE  $7F, $FF			    ; 6: 7f	forever
SoundVolTable_7:
	.BYTE  $1F,   4
	.BYTE  $1E,	  2			; 2 ; 7: 1f->10	slooowly
	.BYTE  $1D,	  2			; 4
	.BYTE  $1C,	  2			; 6
	.BYTE  $1B,	  3			; 8
	.BYTE  $1A,	  3			; $A
	.BYTE  $19,	  4			; $C
	.BYTE  $18,	  4			; $E
	.BYTE  $17,	  6			; $10
	.BYTE  $16,	  6			; $12
	.BYTE  $15,	  8			; $14
	.BYTE  $14,	  8			; $16
	.BYTE  $13,	  8			; $18
	.BYTE  $12,	  8			; $1A
	.BYTE  $11,	$10			; $1C
	.BYTE  $10,	$FF			; $1E
;
; sound	data section
; some of the sound data includes pointers, and	since
; i haven't marked those yet this is just big blobs of
; "unexplored" until i do (so i	dont have to undefine/
; fix shit later)
;
SoundPointers:
	.WORD SoundData_01_Jump		  ;	DATA XREF: HandleSoundQueue+29r
	.WORD SoundData_02_Death		; 1 ; 0	= (silence)
	.WORD SoundData_03_BonusCoinSpawn	; 2 ; 1	= Sound_Jump
	.WORD SoundData_04_CoinCollected	; 3 ; 2	= Sound_Death
	.WORD SoundData_05_PowerCoinSpawn	; 4 ; 3	= Sound_BonusCoinSpawn
	.WORD SoundData_06_PowerCoinMusic	; 5 ; 4	= Sound_CoinCollected
	.WORD SoundData_07_GetNormalBomb	; 6 ; 5	= Sound_PowerCoinSpawn
	.WORD SoundData_08_GetFireBomb	; 7 ; 6	= Sound_PowerCoinMusic
	.WORD SoundData_09_YouAreGreedy	; 8 ; 7	= Sound_BombCollectedUnlit
	.WORD SoundData_0A_Get1UP		; 9 ; 8	= Sound_BombCollectedLit
	.WORD SoundData_0B_GetCrystalBall	; $A ; 9 = Sound_YouAreGreedy
	.WORD SoundData_Null		; $B ; $A = Sound_1UP_Captive
	.WORD SoundData_0D_GetBonusStatue	; $C ; $B = Sound_CrystalBall
	.WORD SoundData_0E_SecretBlockOpened; $D ; $C = Sound_C_Null
	.WORD SoundData_0F_Door		; $E ; $D = Sound_BonusStatueCollected
	.WORD SoundData_10_Music_Main	; $F ; $E = Sound_SecretBlockRevealed
	.WORD SoundData_11_Music_Treasure	; $10 ;	$F = Sound_Door
	.WORD SoundData_12_Music_Side	; $11 ;	$10 = Music_Main
	.WORD SoundData_13_Music_Labyrinth	; $12 ;	$11 = Music_TreasureRoom
	.WORD SoundData_Null		; $13 ;	$12 = Music_SideRoom
	.WORD SoundData_15_Music_Outside	; $14 ;	$13 = Music_Labyrinth
	.WORD SoundData_16_Music_MainIntro	; $15 ;	$14 = Sound_14_Null
	.WORD SoundData_17_Music_GameOver	; $16 ;	$15 = Music_Outside1
	.WORD SoundData_18_Music_RoundClear	; $17 ;	$16 = Music_MainWithIntro
	.WORD SoundData_19_BombChestBonus	; $18 ;	$17 = Music_GameOver
	.WORD SoundData_1A			; $19 ;	$18 = Music_RoundClear
	.WORD SoundData_1B_Pause		; $1A ;	$19 = Sound_BombChestBonus
	.WORD SoundData_1C_Unpause		; $1B ;	$1A = Sound_1A
	.WORD SoundData_1D_UseMightyCoin	; $1C ;	$1B = Sound_Pause
	.WORD SoundData_15_Music_Outside	; $1D ;	$1C = Sound_Unpause
	.WORD SoundData_1F_Music_Torture	; $1E ;	$1D = Sound_UsedMightyCoin
	.WORD SoundData_20_BombBonus	; $1F ;	$1E = Music_Outside2
	.WORD SoundData_21_GetMightyDrink	; $20 ;	$1F = Music_TortureRoom
	.WORD SoundData_22_Music_Ending	; $21 ;	$20 = Sound_BombBonus
	.WORD SoundData_23_Music_BestEnding	; $22 ;	$21 = Sound_TimePickup
					; $22 =	Music_Ending
					; $23 =	Music_CollectedFullFamily
SoundData_Null:
	.BYTE $FF

SoundData_01_Jump:
	SoundData 5,	SoundTrack_01_5 ;
	.BYTE $FF
SoundTrack_01_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $F5
	.BYTE $96
	.BYTE $84
	.BYTE $32 ;	2
	.BYTE $F5
	.BYTE $9D
	.BYTE $8A
	.BYTE $30
	.BYTE $FF
SoundData_02_Death:
	SoundData 0, SoundTrack_02_0 ;
	SoundData 1, SoundData_Null ;
	SoundData 2, SoundData_Null ;
	SoundData 4, SoundData_Null ;
	SoundData 5, SoundData_Null ;
	SoundData 6, SoundData_Null ;
	.BYTE $FF
SoundTrack_02_0:
	.BYTE $A0
	.BYTE $D2
	.BYTE $84
	.BYTE $F1
	.BYTE $13
	.BYTE $F5
	.BYTE $9C
	.BYTE $40
	.BYTE $DB
	.BYTE $F2
	.BYTE $FF
SoundData_03_BonusCoinSpawn:
	SoundData 4, SoundTrack_03_4 ;
	SoundData 5, SoundTrack_03_5 ;
	.BYTE $FF
SoundTrack_03_4:
	.BYTE $A0
	.BYTE $D1
	.BYTE $86
	.BYTE $57
	.BYTE $8A
	.BYTE $57
	.BYTE $FF
SoundTrack_03_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $86
	.BYTE $56
	.BYTE $8A
	.BYTE $56
	.BYTE $FF
SoundData_04_CoinCollected:
	SoundData 5, SoundTrack_04_5 ;
	.BYTE $FF
SoundTrack_04_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $81
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $38 ;	8
	.BYTE $3C
	.BYTE $8A
	.BYTE $40
	.BYTE $FF
SoundData_05_PowerCoinSpawn:
	SoundData 0, SoundTrack_05_0 ;
	SoundData 1, SoundData_Null ;
	SoundData 2, SoundData_Null ;
	.BYTE $FF
SoundTrack_05_0:
	.BYTE $A0
	.BYTE $D1
	.BYTE $E8
	.BYTE $81
SoundTrack_05_0L:
	.BYTE $F1
	.BYTE $1F
	.BYTE $20
	.BYTE $D8
	.BYTE $F2
	.BYTE $F1
	.BYTE $1F
	.BYTE $DA
	.BYTE $47
	.BYTE $F2
	SndJmpF0 SoundTrack_05_0L ;
SoundData_06_PowerCoinMusic:
	SoundData 0, SoundTrack_06_0 ;
	SoundData 1, SoundTrack_06_1 ;
	SoundData 2, SoundTrack_06_2 ;
	.BYTE $FF
SoundTrack_06_0:
	.BYTE $A1
	.BYTE $D1
	.BYTE $E4
	.BYTE $95
	.BYTE $37 ;	7
	.BYTE $94
	.BYTE  $C
	.BYTE $37 ;	7
	.BYTE $95
	.BYTE $34 ;	4
	.BYTE $94
	.BYTE  $C
	.BYTE $34 ;	4
	.BYTE $95
	.BYTE $30
	.BYTE $94
	.BYTE  $C
	.BYTE $93
	.BYTE $2B
	.BYTE $30
	.BYTE $8F
	.BYTE $32 ;	2
	.BYTE $93
	.BYTE  $C
	.BYTE $FF
SoundTrack_06_1:
	.BYTE $A1
	.BYTE $D1
	.BYTE $E4
	.BYTE $95
	.BYTE $30
	.BYTE $94
	.BYTE  $C
	.BYTE $30
	.BYTE $95
	.BYTE $29
	.BYTE $94
	.BYTE  $C
	.BYTE $29
	.BYTE $95
	.BYTE $25
	.BYTE $94
	.BYTE  $C
	.BYTE $93
	.BYTE $24
	.BYTE $25
	.BYTE $8F
	.BYTE $27
	.BYTE $93
	.BYTE  $C
	.BYTE $FF
SoundTrack_06_2:
	.BYTE $A4
	.BYTE $93
	.BYTE $40
	.BYTE  $C
	.BYTE $40
	.BYTE $44
	.BYTE $47
	.BYTE  $C
	.BYTE $49
	.BYTE  $C
	.BYTE $50
	.BYTE  $C
	.BYTE $49
	.BYTE  $C
	.BYTE $47
	.BYTE  $C
	.BYTE $44
	.BYTE  $C
	.BYTE $39 ;	9
	.BYTE  $C
	.BYTE $39 ;	9
	.BYTE $40
	.BYTE $44
	.BYTE  $C
	.BYTE $47
	.BYTE  $C
	.BYTE $49
	.BYTE  $C
	.BYTE $47
	.BYTE  $C
	.BYTE $44
	.BYTE  $C
	.BYTE $40
	.BYTE  $C
	.BYTE $35 ;	5
	.BYTE  $C
	.BYTE $35 ;	5
	.BYTE $39 ;	9
	.BYTE $40
	.BYTE  $C
	.BYTE $45
	.BYTE  $C
	.BYTE $47
	.BYTE  $C
	.BYTE $45
	.BYTE  $C
	.BYTE $40
	.BYTE  $C
	.BYTE $39 ;	9
	.BYTE  $C
	.BYTE $37 ;	7
	.BYTE  $C
	.BYTE $37 ;	7
	.BYTE $3B
	.BYTE $42
	.BYTE  $C
	.BYTE $45
	.BYTE  $C
	.BYTE $47
	.BYTE  $C
	.BYTE $45
	.BYTE  $C
	.BYTE $42
	.BYTE  $C
	.BYTE $3B
	.BYTE  $C
	.BYTE $37 ;	7
	.BYTE $FF
SoundData_08_GetFireBomb:
	SoundData 5, SoundTrack_08_5 ;
	.BYTE $FF
SoundTrack_08_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $84
	.BYTE $F5
	.BYTE $9B
	.BYTE $34 ;	4
	.BYTE $F5
	.BYTE $9B
	.BYTE $37 ;	7
	.BYTE $FF
SoundData_07_GetNormalBomb:
	SoundData 5, SoundTrack_07_5 ;
	.BYTE $FF
SoundTrack_07_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $82
	.BYTE $47
	.BYTE  $C
	.BYTE $48
	.BYTE $FF
SoundData_09_YouAreGreedy:
	SoundData 0,	SoundTrack_09_0 ;
	SoundData 1, SoundTrack_09_1 ;
	SoundData 2, SoundData_Null ;
	.BYTE $FF
SoundTrack_09_0:
	.BYTE $A1
	.BYTE $D1
	.BYTE $80
	.BYTE $F5
	.BYTE $97
	.BYTE $34 ;	4
	.BYTE $FF
SoundTrack_09_1:
	.BYTE $A1
	.BYTE $D1
	.BYTE $80
	.BYTE $F5
	.BYTE $97
	.BYTE $35 ;	5
	.BYTE $FF
SoundData_0A_Get1UP:
	SoundData 4, SoundTrack_0A_4 ;
	SoundData 5, SoundTrack_0A_5 ;
	SoundData 6, SoundTrack_0A_6 ;
	.BYTE $FF
SoundTrack_0A_4:
	.BYTE $A0
	.BYTE $D1
	.BYTE $84
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $39 ;	9
	.BYTE $34 ;	4
	.BYTE $39 ;	9
	.BYTE $3B
	.BYTE $8A
	.BYTE $40
	.BYTE $FF
SoundTrack_0A_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $84
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $35 ;	5
	.BYTE $37 ;	7
	.BYTE $8A
	.BYTE $37 ;	7
	.BYTE $FF
SoundTrack_0A_6:
	.BYTE $89
	.BYTE  $C
	.BYTE $8A
	.BYTE  $C
	.BYTE $FF
SoundData_0B_GetCrystalBall:
	SoundData 4, SoundTrack_0B_4 ;
	SoundData 5, SoundTrack_0B_5 ;
	SoundData 6, SoundTrack_0B_6 ;
	.BYTE $FF
SoundTrack_0B_4:
	.BYTE $A1
	.BYTE $D1
	.BYTE $96
	.BYTE $34 ;	4
	.BYTE  $C
	.BYTE $34 ;	4
	.BYTE $37 ;	7
	.BYTE $40
	.BYTE  $C
	.BYTE $37 ;	7
	.BYTE  $C
	.BYTE $9A
	.BYTE $40
	.BYTE  $C
	.BYTE $FF
SoundTrack_0B_5:
	.BYTE $A1
	.BYTE $D1
	.BYTE $96
	.BYTE $30
	.BYTE  $C
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $37 ;	7
	.BYTE  $C
	.BYTE $34 ;	4
	.BYTE  $C
	.BYTE $9A
	.BYTE $37 ;	7
	.BYTE  $C
	.BYTE $FF
SoundTrack_0B_6:
	.BYTE $A4
	.BYTE $96
	.BYTE $27
	.BYTE  $C
	.BYTE $27
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE  $C
	.BYTE $30
	.BYTE  $C
	.BYTE $9A
	.BYTE $34 ;	4
	.BYTE  $C
	.BYTE $FF
SoundData_0D_GetBonusStatue:
	SoundData 5, SoundTrack_0D_5 ;
	.BYTE $FF
SoundTrack_0D_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $82
	.BYTE $30
	.BYTE $36 ;	6
	.BYTE $33 ;	3
	.BYTE $39 ;	9
	.BYTE $36 ;	6
	.BYTE $40
	.BYTE $39 ;	9
	.BYTE $43
	.BYTE $FF
SoundData_0E_SecretBlockOpened:
	SoundData 5, SoundTrack_0E_5 ;
	.BYTE $FF
SoundTrack_0E_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $81
	.BYTE $40
	.BYTE $36 ;	6
	.BYTE $39 ;	9
	.BYTE $33 ;	3
	.BYTE $36 ;	6
	.BYTE $30
	.BYTE $33 ;	3
	.BYTE $29
	.BYTE $30
	.BYTE $26
	.BYTE $29
	.BYTE $23
	.BYTE $26
	.BYTE $20
	.BYTE $FF
SoundData_0F_Door:
	SoundData 4,	SoundTrack_0F_4 ;
	SoundData 5, SoundTrack_0F_5 ;
	SoundData 6, SoundTrack_0F_6 ;
	.BYTE $FF
SoundTrack_0F_4:
	.BYTE $A0
	.BYTE $D1
	.BYTE $82
	.BYTE $F1
	.BYTE  $B
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $D8
	.BYTE $F2
	.BYTE $FF
SoundTrack_0F_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $82
	.BYTE $F1
	.BYTE  $B
	.BYTE $27
	.BYTE $29
	.BYTE $D8
	.BYTE $F2
	.BYTE $FF
SoundTrack_0F_6:
	.BYTE $99
	.BYTE  $C
	.BYTE $FF
SoundData_10_Music_Main:
	SoundData 0, SoundTrack_10_0 ;
	SoundData 1, SoundTrack_10_1 ;
	SoundData 2, SoundTrack_10_2 ;
	.BYTE $FF
SoundTrack_10_0:
	.BYTE $A0
SoundTrack_10_0L:
	.BYTE $D1
	.BYTE $E9
	SndJmpF3 SoundTrack_10_0La
	.BYTE $90
	.BYTE $30
	.BYTE $2B
	.BYTE $29
	.BYTE $27
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $29
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $2B
	SndJmpF3 SoundTrack_10_0La
	.BYTE $30
	.BYTE $27
	.BYTE $90
	.BYTE $29
	.BYTE $2B
	.BYTE $32 ;	2
	.BYTE $27
	.BYTE $91
	.BYTE $30
	.BYTE $90
	.BYTE $27
	.BYTE $27
	.BYTE $91
	.BYTE $30
	.BYTE  $C
	SndJmpF3 SoundTrack_F7AB
	.BYTE  $C
	.BYTE $90
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $91
	.BYTE $35 ;	5
	.BYTE $90
	.BYTE $37 ;	7
	.BYTE $91
	.BYTE $37 ;	7
	.BYTE $90
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $37 ;	7
	.BYTE $36 ;	6
	.BYTE $37 ;	7
	.BYTE $38 ;	8
	SndJmpF3 SoundTrack_F7AB
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $30
	.BYTE  $C
	SndJmpF0 SoundTrack_10_0L ;
SoundTrack_10_0La:
	.BYTE $90
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $91
	.BYTE $34 ;	4
	.BYTE $37 ;	7
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $27
	.BYTE $90
	.BYTE $27
	.BYTE $29
	.BYTE $2B
	.BYTE $30
	.BYTE $91
	.BYTE $32 ;	2
	.BYTE  $C
	.BYTE $27
	.BYTE  $C
	.BYTE $90
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $91
	.BYTE $32 ;	2
	.BYTE $35 ;	5
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $F4
SoundTrack_F7AB:
	.BYTE $90
	.BYTE $39 ;	9
	.BYTE $38 ;	8
	.BYTE $91
	.BYTE $39 ;	9
	.BYTE $90
	.BYTE $3B
	.BYTE $91
	.BYTE $3B
	.BYTE $90
	.BYTE $39 ;	9
	.BYTE $91
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $F4
SoundTrack_10_1:
	.BYTE $A0
SoundTrack_10_1L:
	.BYTE $D1
	.BYTE $E9
	SndJmpF3 SoundTrack_F80A
	.BYTE $90
	.BYTE $29
	.BYTE $27
	.BYTE $25
	.BYTE $24
	.BYTE $2B
	.BYTE $29
	.BYTE $27
	.BYTE $25
	.BYTE $30
	.BYTE $2B
	.BYTE $29
	.BYTE $27
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $27
	SndJmpF3 SoundTrack_F80A
	.BYTE $27
	.BYTE $24
	.BYTE $90
	.BYTE $25
	.BYTE $27
	.BYTE $2B
	.BYTE $22
	.BYTE $91
	.BYTE $27
	.BYTE $90
	.BYTE $22
	.BYTE $22
	.BYTE $91
	.BYTE $27
	.BYTE  $C
	SndJmpF3 SoundTrack_F82F
	.BYTE  $C
	.BYTE $90
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $91
	.BYTE $32 ;	2
	.BYTE $90
	.BYTE $34 ;	4
	.BYTE $91
	.BYTE $34 ;	4
	.BYTE $90
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $34 ;	4
	.BYTE $33 ;	3
	.BYTE $34 ;	4
	.BYTE $34 ;	4
	SndJmpF3 SoundTrack_F82F
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $27
	.BYTE $27
	.BYTE $27
	.BYTE  $C
	SndJmpF0 SoundTrack_10_1L ;
SoundTrack_F80A:
	.BYTE $90
	.BYTE $30
	.BYTE $27
	.BYTE $30
	.BYTE $27
	.BYTE $91
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $22
	.BYTE $90
	.BYTE $22
	.BYTE $25
	.BYTE $27
	.BYTE $29
	.BYTE $91
	.BYTE $2B
	.BYTE  $C
	.BYTE $22
	.BYTE  $C
	.BYTE $90
	.BYTE $2B
	.BYTE $27
	.BYTE $2B
	.BYTE $27
	.BYTE $91
	.BYTE $2B
	.BYTE $32 ;	2
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $F4
SoundTrack_F82F:
	.BYTE $90
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $91
	.BYTE $35 ;	5
	.BYTE $90
	.BYTE $37 ;	7
	.BYTE $91
	.BYTE $37 ;	7
	.BYTE $90
	.BYTE $35 ;	5
	.BYTE $91
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $27
	.BYTE $F4
SoundTrack_10_2:
	.BYTE $A4
SoundTrack_10_2L:
	SndJmpF3 SoundTrack_F894
	.BYTE $17
	.BYTE $22
	.BYTE $19
	.BYTE $24
	.BYTE $1B
	.BYTE $25
	.BYTE $1B
	.BYTE $27
	SndJmpF3 SoundTrack_F894
	.BYTE $17
	.BYTE $20
	.BYTE $90
	.BYTE $25
	.BYTE $24
	.BYTE $22
	.BYTE $20
	.BYTE $1B
	.BYTE $17
	.BYTE $19
	.BYTE $1B
	.BYTE $91
	.BYTE $20
	.BYTE  $C
	.BYTE $91
	.BYTE $19
	.BYTE $20
	.BYTE $90
	.BYTE $25
	.BYTE $24
	.BYTE $22
	.BYTE $20
	.BYTE $91
	.BYTE $24
	.BYTE $20
	.BYTE $17
	.BYTE $24
	.BYTE $22
	.BYTE $19
	.BYTE $90
	.BYTE $25
	.BYTE $24
	.BYTE $91
	.BYTE $22
	.BYTE $20
	.BYTE $24
	.BYTE $27
	.BYTE $24
	.BYTE $19
	.BYTE $20
	.BYTE $90
	.BYTE $25
	.BYTE $24
	.BYTE $22
	.BYTE $20
	.BYTE $91
	.BYTE $24
	.BYTE $20
	.BYTE $90
	.BYTE $17
	.BYTE $20
	.BYTE $24
	.BYTE $20
	.BYTE $90
	.BYTE $19
	.BYTE $15
	.BYTE $1B
	.BYTE $17
	.BYTE $20
	.BYTE $19
	.BYTE $22
	.BYTE $1B
	.BYTE $91
	.BYTE $20
	.BYTE $17
	.BYTE $20
	.BYTE  $C
	SndJmpF0 SoundTrack_10_2L ;
SoundTrack_F894:
	.BYTE $91
	.BYTE $20
	.BYTE $27
	.BYTE $20
	.BYTE $27
	.BYTE $20
	.BYTE $27
	.BYTE $20
	.BYTE $27
	.BYTE $17
	.BYTE $22
	.BYTE $17
	.BYTE $22
	.BYTE $17
	.BYTE $22
	.BYTE $90
	.BYTE $17
	.BYTE $19
	.BYTE $1B
	.BYTE $20
	.BYTE $91
	.BYTE $17
	.BYTE $22
	.BYTE $17
	.BYTE $22
	.BYTE $17
	.BYTE $22
	.BYTE $17
	.BYTE $22
	.BYTE $F4
SoundData_11_Music_Treasure:
	SoundData 0, SoundTrack_11_0 ;
	SoundData 1, SoundTrack_11_1 ;
	SoundData 2, SoundTrack_11_2 ;
	.BYTE $FF
SoundTrack_11_0:
	.BYTE $A0
SoundTrack_11_0L:
	SndJmpF3 SoundTrack_F929
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $88
	.BYTE $37 ;	7
	.BYTE $89
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	.BYTE $88
	.BYTE $35 ;	5
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $30
	.BYTE $89
	.BYTE $2B
	.BYTE $30
	.BYTE $88
	.BYTE $32 ;	2
	SndJmpF3 SoundTrack_F929
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $88
	.BYTE $37 ;	7
	.BYTE $89
	.BYTE $39 ;	9
	.BYTE $3B
	.BYTE $88
	.BYTE $39 ;	9
	.BYTE $89
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $88
	.BYTE $34 ;	4
	.BYTE $89
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $88
	.BYTE $32 ;	2
	SndJmpF3 SoundTrack_F929
	.BYTE $88
	.BYTE  $C
	.BYTE $86
	.BYTE $40
	.BYTE $3B
	.BYTE $39 ;	9
	.BYTE $89
	.BYTE $37 ;	7
	.BYTE $88
	.BYTE $35 ;	5
	.BYTE $86
	.BYTE  $C
	.BYTE $89
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE  $C
	.BYTE $88
	.BYTE  $C
	.BYTE $86
	.BYTE $3B
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	.BYTE $89
	.BYTE $35 ;	5
	.BYTE $88
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $8A
	.BYTE $37 ;	7
	SndJmpF3 SoundTrack_F936
	.BYTE $89
	.BYTE $35 ;	5
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $35 ;	5
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $88
	.BYTE $37 ;	7
	SndJmpF3 SoundTrack_F936
	.BYTE  $C
	.BYTE $37 ;	7
	.BYTE $36 ;	6
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $86
	.BYTE  $C
	.BYTE $88
	.BYTE $34 ;	4
	.BYTE $89
	.BYTE  $C
	SndJmpF0 SoundTrack_11_0L ;
SoundTrack_F929:
	.BYTE $D2
	.BYTE $E6
	.BYTE $F1
	.BYTE   4
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $88
	.BYTE $32 ;	2
	.BYTE $F2
	.BYTE $D1
	.BYTE $E8
	.BYTE $F4
SoundTrack_F936:
	.BYTE $89
	.BYTE $39 ;	9
	.BYTE $35 ;	5
	.BYTE $88
	.BYTE $39 ;	9
	.BYTE $89
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $88
	.BYTE $37 ;	7
	.BYTE $F4
SoundTrack_11_1:
	.BYTE $A0
SoundTrack_11_1L:
	SndJmpF3 SoundTrack_F9AE
	.BYTE $89
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $34 ;	4
	.BYTE $89
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $88
	.BYTE $32 ;	2
	.BYTE $89
	.BYTE $30
	.BYTE $2B
	.BYTE $88
	.BYTE $29
	.BYTE $89
	.BYTE $27
	.BYTE $29
	.BYTE $88
	.BYTE $2B
	SndJmpF3 SoundTrack_F9AE
	.BYTE $89
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $34 ;	4
	.BYTE $89
	.BYTE $35 ;	5
	.BYTE $37 ;	7
	.BYTE $88
	.BYTE $35 ;	5
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $30
	.BYTE $89
	.BYTE $2B
	.BYTE $29
	.BYTE $88
	.BYTE $2B
	SndJmpF3 SoundTrack_F9AE
	.BYTE $88
	.BYTE  $C
	.BYTE $86
	.BYTE $37 ;	7
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $88
	.BYTE $32 ;	2
	.BYTE $86
	.BYTE  $C
	.BYTE $89
	.BYTE $2B
	.BYTE $88
	.BYTE  $C
	.BYTE $88
	.BYTE  $C
	.BYTE $86
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $89
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $8A
	.BYTE $34 ;	4
	SndJmpF3 SoundTrack_F9BB
	.BYTE $89
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $88
	.BYTE $32 ;	2
	.BYTE $89
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $34 ;	4
	SndJmpF3 SoundTrack_F9BB
	.BYTE  $C
	.BYTE $34 ;	4
	.BYTE $33 ;	3
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $86
	.BYTE  $C
	.BYTE $88
	.BYTE $30
	.BYTE $89
	.BYTE  $C
	SndJmpF0 SoundTrack_11_1L ;
SoundTrack_F9AE:
	.BYTE $D2
	.BYTE $E6
	.BYTE $F1
	.BYTE   4
	.BYTE $89
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $2B
	.BYTE $F2
	.BYTE $D1
	.BYTE $E8
	.BYTE $F4
SoundTrack_F9BB:
	.BYTE $89
	.BYTE $35 ;	5
	.BYTE $32 ;	2
	.BYTE $88
	.BYTE $35 ;	5
	.BYTE $89
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $88
	.BYTE $34 ;	4
	.BYTE $F4
SoundTrack_11_2:
	.BYTE $A4
SoundTrack_11_2L:
	.BYTE $F1
	.BYTE   7
	SndJmpF3 SoundTrack_FA30
	.BYTE $F2
	.BYTE $17
	.BYTE $86
	.BYTE $17
	.BYTE $88
	.BYTE $1B
	.BYTE $86
	.BYTE $1B
	.BYTE $88
	.BYTE $22
	.BYTE $F1
	.BYTE   7
	SndJmpF3 SoundTrack_FA30
	.BYTE $F2
	.BYTE $17
	.BYTE $86
	.BYTE $17
	.BYTE $88
	.BYTE $1B
	.BYTE $86
	.BYTE $1B
	.BYTE $88
	.BYTE $22
	.BYTE $F1
	.BYTE   4
	SndJmpF3 SoundTrack_FA30
	.BYTE $F2
	.BYTE $88
	.BYTE $20
	.BYTE $86
	.BYTE $20
	.BYTE $17
	.BYTE $20
	.BYTE $17
	.BYTE $20
	.BYTE $24
	.BYTE $88
	.BYTE $17
	.BYTE $86
	.BYTE $17
	.BYTE $88
	.BYTE $1B
	.BYTE $86
	.BYTE $1B
	.BYTE $88
	.BYTE $22
	.BYTE $89
	.BYTE $17
	.BYTE $1B
	.BYTE $88
	.BYTE $22
	.BYTE $20
	.BYTE $1B
	.BYTE $19
	.BYTE $17
	SndJmpF3 SoundTrack_FA3B
	.BYTE $88
	.BYTE $17
	.BYTE $86
	.BYTE $17
	.BYTE $88
	.BYTE $1B
	.BYTE $86
	.BYTE $1B
	.BYTE $88
	.BYTE $22
	.BYTE $88
	.BYTE $20
	.BYTE $86
	.BYTE $20
	.BYTE $88
	.BYTE $1B
	.BYTE $86
	.BYTE $1B
	.BYTE $20
	.BYTE $17
	SndJmpF3 SoundTrack_FA3B
	.BYTE $88
	.BYTE $17
	.BYTE $17
	.BYTE $19
	.BYTE $1B
	.BYTE $20
	.BYTE $86
	.BYTE $17
	.BYTE $88
	.BYTE $20
	.BYTE $89
	.BYTE  $C
	SndJmpF0 SoundTrack_11_2L ;
SoundTrack_FA30:
	.BYTE $88
	.BYTE $20
	.BYTE $86
	.BYTE $20
	.BYTE $88
	.BYTE $24
	.BYTE $86
	.BYTE $24
	.BYTE $88
	.BYTE $27
	.BYTE $F4
SoundTrack_FA3B:
	.BYTE $88
	.BYTE $19
	.BYTE $86
	.BYTE $19
	.BYTE $88
	.BYTE $22
	.BYTE $86
	.BYTE $22
	.BYTE $88
	.BYTE $25
	.BYTE $88
	.BYTE $17
	.BYTE $86
	.BYTE $17
	.BYTE $88
	.BYTE $20
	.BYTE $86
	.BYTE $20
	.BYTE $88
	.BYTE $24
	.BYTE $F4
SoundData_12_Music_Side:
	SoundData 0, SoundTrack_12_0 ;
	SoundData 1, SoundTrack_12_1 ;
	SoundData 2, SoundTrack_12_2 ;
	.BYTE $FF
SoundTrack_12_0:
	.BYTE $A0
	.BYTE $D2
	.BYTE $E6
SoundTrack_12_0L:
	.BYTE $98
	.BYTE $F1
	.BYTE   2
	.BYTE $30
	.BYTE $31 ;	1
	.BYTE $33 ;	3
	.BYTE $34 ;	4
	.BYTE $36 ;	6
	.BYTE $34 ;	4
	.BYTE $33 ;	3
	.BYTE $31 ;	1
	.BYTE $F2
	.BYTE $30
	.BYTE $31 ;	1
	.BYTE $33 ;	3
	.BYTE $34 ;	4
	.BYTE $36 ;	6
	.BYTE $84
	.BYTE $34 ;	4
	.BYTE $36 ;	6
	.BYTE $34 ;	4
	.BYTE $98
	.BYTE $33 ;	3
	.BYTE $31 ;	1
	.BYTE $9E
	.BYTE $30
	SndJmpF0 SoundTrack_12_0L ;
SoundTrack_12_1:
	.BYTE $A0
	.BYTE $D2
	.BYTE $E6
SoundTrack_12_1L:
	.BYTE $98
	.BYTE $F1
	.BYTE   2
	.BYTE $29
	.BYTE $2A
	.BYTE $30
	.BYTE $31 ;	1
	.BYTE $33 ;	3
	.BYTE $31 ;	1
	.BYTE $30
	.BYTE $2A
	.BYTE $F2
	.BYTE $29
	.BYTE $2A
	.BYTE $30
	.BYTE $31 ;	1
	.BYTE $33 ;	3
	.BYTE $84
	.BYTE $31 ;	1
	.BYTE $33 ;	3
	.BYTE $31 ;	1
	.BYTE $98
	.BYTE $2A
	.BYTE $29
	.BYTE $9E
	.BYTE $29
	SndJmpF0 SoundTrack_12_1L ;
SoundTrack_12_2:
	.BYTE $A4
	.BYTE $98
SoundTrack_12_2L:
	.BYTE $20
	.BYTE $30
	.BYTE $30
	.BYTE $30
	SndJmpF0 SoundTrack_12_2L ;
SoundData_13_Music_Labyrinth:
	SoundData 0, SoundTrack_13_0 ;
	SoundData 1, SoundData_Null ;
	SoundData 2, SoundTrack_13_2 ;
	.BYTE $FF
SoundTrack_13_0:
	.BYTE $A0
	.BYTE $D1
	.BYTE $EA
SoundTrack_13_0L:
	.BYTE $84
	.BYTE $40
	.BYTE $41
	.BYTE $42
	.BYTE $43
	.BYTE $44
	.BYTE $43
	.BYTE $42
	.BYTE $41
	SndJmpF0 SoundTrack_13_0L ;
SoundTrack_13_2:
	.BYTE $A6
	.BYTE $88
SoundTrack_13_2L:
	.BYTE $F1
	.BYTE   8
	.BYTE $24
	.BYTE $F2
	.BYTE $F1
	.BYTE   8
	.BYTE $23
	.BYTE $F2
	.BYTE $F1
	.BYTE   8
	.BYTE $22
	.BYTE $F2
	.BYTE $F1
	.BYTE   8
	.BYTE $21
	.BYTE $F2
	SndJmpF0 SoundTrack_13_2L ;
SoundData_15_Music_Outside:
	SoundData 0, SoundTrack_15_0 ;
	SoundData 1, SoundTrack_15_1 ;
	SoundData 2, SoundTrack_15_2 ;
	.BYTE $FF
SoundTrack_15_0:
	.BYTE $A2
	.BYTE $D2
	.BYTE $E4
SoundTrack_15_0L:
	SndJmpF3 SoundTrack_FAFA
	.BYTE $42
	.BYTE $40
	.BYTE $3B
	.BYTE $39 ;	9
	.BYTE $3B
	.BYTE $86
	.BYTE $40
	.BYTE $8A
	.BYTE $42
	.BYTE $86
	.BYTE  $C
	SndJmpF3 SoundTrack_FAFA
	.BYTE $3B
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	SndJmpF0 SoundTrack_15_0L ;
SoundTrack_FAFA:
	.BYTE $86
	.BYTE $34 ;	4
	.BYTE $37 ;	7
	.BYTE $F1
	.BYTE   4
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $F2
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $39 ;	9
	.BYTE $F1
	.BYTE   4
	.BYTE $40
	.BYTE $39 ;	9
	.BYTE $35 ;	5
	.BYTE $F2
	.BYTE $40
	.BYTE $39 ;	9
	.BYTE $34 ;	4
	.BYTE $37 ;	7
	.BYTE $F1
	.BYTE   4
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $F2
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $88
	.BYTE $F4
SoundTrack_15_1:
	.BYTE $A2
	.BYTE $D2
	.BYTE $E4
SoundTrack_15_1L:
	SndJmpF3 SoundTrack_FB3A
	.BYTE $3B
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $37 ;	7
	.BYTE $86
	.BYTE $39 ;	9
	.BYTE $8A
	.BYTE $3B
	.BYTE $86
	.BYTE  $C
	SndJmpF3 SoundTrack_FB3A
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $29
	.BYTE $27
	SndJmpF0 SoundTrack_15_1L ;
SoundTrack_FB3A:
	.BYTE $86
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $F1
	.BYTE   4
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $F2
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $35 ;	5
	.BYTE $F1
	.BYTE   4
	.BYTE $39 ;	9
	.BYTE $35 ;	5
	.BYTE $30
	.BYTE $F2
	.BYTE $39 ;	9
	.BYTE $35 ;	5
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $F1
	.BYTE   4
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $F2
	.BYTE $37 ;	7
	.BYTE $34 ;	4
	.BYTE $88
	.BYTE $F4
SoundTrack_15_2:
	.BYTE $A4
	SndJmpF3 SoundTrack_FB83
	.BYTE $20
	.BYTE $1B
	.BYTE $19
	.BYTE $17
	.BYTE $19
	.BYTE $1B
	.BYTE $20
	.BYTE $88
	.BYTE $22
	.BYTE $86
	.BYTE $17
	.BYTE $17
	.BYTE $88
	.BYTE $22
	.BYTE $17
	SndJmpF3 SoundTrack_FB83
	.BYTE $1B
	.BYTE $17
	.BYTE $1B
	.BYTE $22
	.BYTE $1B
	.BYTE $17
	.BYTE $1B
	.BYTE $24
	.BYTE $20
	.BYTE $25
	.BYTE $22
	.BYTE $27
	.BYTE $22
	.BYTE $1B
	.BYTE $22
	SndJmpF0 SoundTrack_15_2 ;
SoundTrack_FB83:
	.BYTE $88
	.BYTE $F1
	.BYTE   4
	.BYTE $20
	.BYTE $27
	.BYTE $F2
	.BYTE $F1
	.BYTE   4
	.BYTE $20
	.BYTE $25
	.BYTE $F2
	.BYTE $F1
	.BYTE   4
	.BYTE $20
	.BYTE $27
	.BYTE $F2
	.BYTE $86
	.BYTE $22
	.BYTE $F4
SoundData_16_Music_MainIntro:
	SoundData 0, SoundTrack_16_0 ;
	SoundData 1, SoundTrack_16_1 ;
	SoundData 2, SoundTrack_16_2 ;
	.BYTE $FF
SoundTrack_16_0:
	.BYTE $A0
	.BYTE $D1
	.BYTE $E4
	.BYTE $92
	.BYTE $37 ;	7
	.BYTE $90
	.BYTE $37 ;	7
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	.BYTE $35 ;	5
	.BYTE $91
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $30
	.BYTE $2B
	.BYTE $27
	.BYTE  $C
	.BYTE $2B
	.BYTE  $C
	.BYTE $32 ;	2
	.BYTE  $C
	.BYTE  $C
	.BYTE  $C
	SndJmpF0 SoundTrack_10_0 ;
SoundTrack_16_1:
	.BYTE $A0
	.BYTE $D1
	.BYTE $E4
	.BYTE $92
	.BYTE $30
	.BYTE $90
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $91
	.BYTE $30
	.BYTE $24
	.BYTE $29
	.BYTE $27
	.BYTE $22
	.BYTE  $C
	.BYTE $27
	.BYTE  $C
	.BYTE $2B
	.BYTE  $C
	.BYTE  $C
	.BYTE  $C
	SndJmpF0 SoundTrack_10_1 ;
SoundTrack_16_2:
	.BYTE $A4
	.BYTE $92
	.BYTE $30
	.BYTE $90
	.BYTE $30
	.BYTE $2B
	.BYTE $30
	.BYTE $2B
	.BYTE $91
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $34 ;	4
	.BYTE $35 ;	5
	.BYTE $37 ;	7
	.BYTE  $C
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $90
	.BYTE $37 ;	7
	.BYTE  $C
	.BYTE $35 ;	5
	.BYTE  $C
	.BYTE $34 ;	4
	.BYTE  $C
	.BYTE $32 ;	2
	.BYTE  $C
	SndJmpF0 SoundTrack_10_2 ;
SoundData_17_Music_GameOver:
	SoundData 0, SoundTrack_17_0 ;
	SoundData 1, SoundTrack_17_1 ;
	SoundData 2, SoundTrack_17_2 ;
	.BYTE $FF
SoundTrack_17_0:
	.BYTE $A1
	.BYTE $D2
	.BYTE $E4
	.BYTE $88
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $8A
	.BYTE $29
	.BYTE $2B
	.BYTE $30
	.BYTE  $C
	.BYTE $FF
SoundTrack_17_1:
	.BYTE $A1
	.BYTE $D2
	.BYTE $E4
	.BYTE $88
	.BYTE $27
	.BYTE $20
	.BYTE $27
	.BYTE $20
	.BYTE $27
	.BYTE $1B
	.BYTE $27
	.BYTE $1B
	.BYTE $8A
	.BYTE $25
	.BYTE $27
	.BYTE $27
	.BYTE  $C
	.BYTE $FF
SoundTrack_17_2:
	.BYTE $A6
	.BYTE $8A
	.BYTE $20
	.BYTE $20
	.BYTE $1B
	.BYTE $1B
	.BYTE $8A
	.BYTE $19
	.BYTE $1B
	.BYTE $20
	.BYTE  $C
	.BYTE $FF
SoundData_18_Music_RoundClear:
	SoundData 0, SoundTrack_18_0
	SoundData 1, SoundTrack_18_1 ;
	SoundData 2, SoundTrack_18_2 ;
	.BYTE $FF
SoundTrack_18_0:
	.BYTE $A7
	.BYTE $D1
	.BYTE $E4
	.BYTE $9A
SoundTrack_18_0L:
	.BYTE $F1
	.BYTE   4
	.BYTE $40
	.BYTE $47
	.BYTE $47
	.BYTE $F2
	.BYTE $F1
	.BYTE   4
	.BYTE $42
	.BYTE $49
	.BYTE $49
	.BYTE $F2
	SndJmpF0 SoundTrack_18_0L ;
SoundTrack_18_1:
	.BYTE $A7
	.BYTE $D1
	.BYTE $E4
	.BYTE $98
	.BYTE  $C
	.BYTE $9A
SoundTrack_18_1L:
	.BYTE $F1
	.BYTE   4
	.BYTE $44
	.BYTE $49
	.BYTE $44
	.BYTE $F2
	.BYTE $F1
	.BYTE   4
	.BYTE $45
	.BYTE $4B
	.BYTE $45
	.BYTE $F2
	SndJmpF0 SoundTrack_18_1L ;
SoundTrack_18_2:
	.BYTE $A6
	.BYTE $98
	.BYTE $F1
	.BYTE $18
	.BYTE $20
	.BYTE $F2
	.BYTE $F1
	.BYTE $18
	.BYTE $22
	.BYTE $F2
	SndJmpF0 SoundTrack_18_2 ;
SoundData_19_BombChestBonus:
	SoundData 4, SoundTrack_19_4 ;
	SoundData 5, SoundTrack_19_5 ;
	SoundData 6, SoundTrack_19_6 ;
	.BYTE $FF
SoundTrack_19_4:
	.BYTE $A0
	.BYTE $D1
	.BYTE $84
	.BYTE $44
	.BYTE $40
	.BYTE $45
	.BYTE $42
	.BYTE $47
	.BYTE $44
	.BYTE $49
	.BYTE $45
	.BYTE $8A
	.BYTE $4B
	.BYTE $FF
SoundTrack_19_5:
	.BYTE $A0
	.BYTE $D1
	.BYTE $84
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $42
	.BYTE $39 ;	9
	.BYTE $44
	.BYTE $3B
	.BYTE $45
	.BYTE $40
	.BYTE $8A
	.BYTE $47
	.BYTE $FF
SoundTrack_19_6:
	.BYTE $A4
	.BYTE $8C
	.BYTE  $C
	.BYTE $FF
SoundData_1A:
	SoundData 0, SoundTrack_1A_0 ;
	SoundData 1, SoundTrack_1A_1 ;
	SoundData 2, SoundData_Null ;
	.BYTE $FF
SoundTrack_1A_0:
	.BYTE $A0
	.BYTE $D1
	.BYTE $81
	.BYTE $37 ;	7
	.BYTE $38 ;	8
	.BYTE $39 ;	9
	.BYTE $3A
	.BYTE $FF
SoundTrack_1A_1:
	.BYTE $A0
	.BYTE $D2
	.BYTE $81
	.BYTE $36 ;	6
	.BYTE $37 ;	7
	.BYTE $38 ;	8
	.BYTE $39 ;	9
	.BYTE $FF
SoundData_1B_Pause:
	SoundData 4, SoundTrack_1B_4 ;
	SoundData 5, SoundTrack_1B_5 ;
	SoundData 6, SoundTrack_1B_6 ;
	.BYTE $FF
SoundTrack_1B_4:
	.BYTE $A0
	.BYTE $D2
	.BYTE $85
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $40
	.BYTE $8A
	.BYTE $37 ;	7
SoundTrack_1B_4L:
	.BYTE $80
	.BYTE  $C
	SndJmpF0 SoundTrack_1B_4L ;
SoundTrack_1B_5:
	.BYTE $A0
	.BYTE $D2
	.BYTE $85
	.BYTE $37 ;	7
	.BYTE $30
	.BYTE $37 ;	7
	.BYTE $8A
	.BYTE $30
SoundTrack_1B_5L:
	.BYTE $80
	.BYTE  $C
	SndJmpF0 SoundTrack_1B_5L ;
SoundTrack_1B_6:
	.BYTE $80
	.BYTE  $C
	SndJmpF0 SoundTrack_1B_6 ;
SoundData_1C_Unpause:
	SoundData 4, SoundTrack_1C_4 ;
	SoundData 5, SoundTrack_1C_5 ;
	SoundData 6, SoundTrack_1C_6 ;
	.BYTE $FF
SoundTrack_1C_4:
	.BYTE $A0
	.BYTE $D2
	.BYTE $85
	.BYTE $40
	.BYTE $37 ;	7
	.BYTE $40
	.BYTE $8A
	.BYTE $37 ;	7
	.BYTE $FF
SoundTrack_1C_5:
	.BYTE $A0
	.BYTE $D2
	.BYTE $85
	.BYTE $37 ;	7
	.BYTE $30
	.BYTE $37 ;	7
	.BYTE $8A
	.BYTE $30
	.BYTE $FF
SoundTrack_1C_6:
	.BYTE $85
	.BYTE  $C
	.BYTE  $C
	.BYTE  $C
	.BYTE $8A
	.BYTE  $C
	.BYTE $FF
SoundData_1D_UseMightyCoin:
	SoundData 4, SoundTrack_1D_4 ;
	SoundData 5, SoundTrack_1D_5 ;
	SoundData 6, SoundTrack_1D_6 ;
	.BYTE $FF
SoundTrack_FD04:
	.BYTE $81
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $32 ;	2
	.BYTE $36 ;	6
	.BYTE $34 ;	4
	.BYTE $38 ;	8
	.BYTE $36 ;	6
	.BYTE $3A
	.BYTE $F4
SoundTrack_1D_4:
	.BYTE $A0
	.BYTE $D1
SoundTrack_1B_4a:
	SndJmpF3 SoundTrack_FD04
	.BYTE $84
	.BYTE  $C
	.BYTE $E3
	SndJmpF3 SoundTrack_FD04
	.BYTE $84
	.BYTE  $C
	.BYTE $E6
	SndJmpF3 SoundTrack_FD04
	.BYTE $84
	.BYTE  $C
	.BYTE $E9
	SndJmpF3 SoundTrack_FD04
	.BYTE $84
	.BYTE  $C
	.BYTE $EB
	SndJmpF3 SoundTrack_FD04
	.BYTE $FF
SoundTrack_1D_5:
	.BYTE $A0
	.BYTE $D2
	.BYTE $DA
	SndJmpF0 SoundTrack_1B_4a ;
SoundTrack_1D_6:
	.BYTE $A4
	.BYTE $DA
	SndJmpF3 SoundTrack_FD04
	.BYTE $FF
SoundData_1F_Music_Torture:
	SoundData 0, SoundTrack_1F_0 ;
	SoundData 1, SoundTrack_1F_1 ;
	SoundData 2, SoundTrack_1F_2 ;
	.BYTE $FF
SoundTrack_1F_0:
	.BYTE $A0
	.BYTE $D1
	.BYTE $E6
unk_FD45:
	.BYTE $98
	.BYTE $10
	.BYTE $15
	.BYTE $12
	.BYTE $13
	SndJmpF0 unk_FD45 ;
SoundTrack_1F_1:
	.BYTE $FF
SoundTrack_1F_2:
	.BYTE $A4
	SndJmpF0 unk_FD45 ;
SoundData_20_BombBonus:
	SoundData 0, SoundTrack_20_0 ; ;	DATA XREF: ROM:SoundPointerso
	SoundData 1, SoundTrack_20_1 ;
	SoundData 2, SoundTrack_20_2 ;
	SoundData 3, SoundTrack_20_3 ;
	.BYTE $FF
SoundTrack_FD5F:
	.BYTE $81
	.BYTE $10
	.BYTE $13
	.BYTE $12
	.BYTE  $B
	.BYTE $11
	.BYTE $F4
SoundTrack_20_0:
	.BYTE $A0
	.BYTE $D1
	SndJmpF3 SoundTrack_FD5F
	.BYTE $84
	.BYTE  $C
	SndJmpF3 SoundTrack_FD5F
	.BYTE $E1
	SndJmpF3 SoundTrack_FD5F
	.BYTE $E2
	SndJmpF3 SoundTrack_FD5F
	.BYTE $E3
	SndJmpF3 SoundTrack_FD5F
	.BYTE $E4
	SndJmpF3 SoundTrack_FD5F
	.BYTE $E6
	SndJmpF3 SoundTrack_FD5F
	.BYTE $E8
	SndJmpF3 SoundTrack_FD5F
	.BYTE $EC
	SndJmpF3 SoundTrack_FD5F
	.BYTE $FF
SoundTrack_20_1:
	.BYTE $82
	.BYTE  $C
	SndJmpF0 SoundTrack_20_0 ;
SoundTrack_20_2:
	.BYTE $A6
	.BYTE $84
	.BYTE $20
	.BYTE  $C
	.BYTE $8E
	.BYTE $21
	.BYTE $FF
SoundTrack_20_3:
	.BYTE $A5
	.BYTE $86
	.BYTE $CF
	.BYTE $A7
	.BYTE $8E
	.BYTE $CD
	.BYTE $FF
SoundData_21_GetMightyDrink:
	SoundData 4, SoundTrack_21_4 ;
	SoundData 5, SoundTrack_21_5 ;
	SoundData 6, SoundTrack_21_6 ;
	.BYTE $FF
SoundTrack_21_4:
	.BYTE $A7
	.BYTE $D1
	.BYTE $85
	.BYTE $40
	.BYTE $44
	.BYTE $87
	.BYTE $47
	.BYTE $89
	.BYTE $40
	.BYTE $FF
SoundTrack_21_5:
	.BYTE $A7
	.BYTE $D1
	.BYTE $85
	.BYTE $37 ;	7
	.BYTE $40
	.BYTE $87
	.BYTE $44
	.BYTE $89
	.BYTE $37 ;	7
	.BYTE $FF
SoundTrack_21_6:
	.BYTE $8B
	.BYTE  $C
	.BYTE $FF
SoundData_22_Music_Ending:
	SoundData 0,	SoundTrack_22_0 ;
	SoundData 1, SoundTrack_22_1 ;
	SoundData 2, SoundTrack_22_2 ;
	.BYTE $FF
SoundTrack_22_0:
	.BYTE $A0
	.BYTE $D1
	.BYTE $E6
unk_FDCE:
	.BYTE $F1
	.BYTE   2
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $32 ;	2
	.BYTE $37 ;	7
	.BYTE $32 ;	2
	.BYTE $9A
	.BYTE $37 ;	7
	.BYTE $96
	.BYTE $36 ;	6
	.BYTE $32 ;	2
	.BYTE $36 ;	6
	.BYTE $32 ;	2
	.BYTE $9A
	.BYTE $36 ;	6
	.BYTE $96
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $9A
	.BYTE $34 ;	4
	.BYTE $96
	.BYTE $36 ;	6
	.BYTE $32 ;	2
	.BYTE $36 ;	6
	.BYTE $32 ;	2
	.BYTE $9A
	.BYTE $36 ;	6
	.BYTE $F2
	.BYTE $F1
	.BYTE   2
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $32 ;	2
	.BYTE $37 ;	7
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $37 ;	7
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $32 ;	2
	.BYTE $98
	.BYTE $36 ;	6
	.BYTE $32 ;	2
	.BYTE $36 ;	6
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $98
	.BYTE $36 ;	6
	.BYTE $36 ;	6
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $98
	.BYTE $36 ;	6
	.BYTE $32 ;	2
	.BYTE $98
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $34 ;	4
	.BYTE $96
	.BYTE $35 ;	5
	.BYTE $98
	.BYTE $34 ;	4
	.BYTE $34 ;	4
	.BYTE $96
	.BYTE $30
	.BYTE $98
	.BYTE $34 ;	4
	.BYTE $30
	.BYTE $98
	.BYTE $36 ;	6
	.BYTE $32 ;	2
	.BYTE $36 ;	6
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $98
	.BYTE $36 ;	6
	.BYTE $36 ;	6
	.BYTE $96
	.BYTE $36 ;	6
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $39 ;	9
	.BYTE $F2
	SndJmpF0 unk_FDCE ;
SoundTrack_22_1:
	.BYTE $A0
	.BYTE $D1
	.BYTE $E6
unk_FE2E:
	.BYTE $F1
	.BYTE   2
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $9A
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $29
	.BYTE $32 ;	2
	.BYTE $29
	.BYTE $9A
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $30
	.BYTE $27
	.BYTE $30
	.BYTE $27
	.BYTE $9A
	.BYTE $30
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $29
	.BYTE $32 ;	2
	.BYTE $29
	.BYTE $9A
	.BYTE $32 ;	2
	.BYTE $F2
	.BYTE $F1
	.BYTE   2
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $2B
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $2B
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $2B
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $29
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $29
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $29
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $29
	.BYTE $98
	.BYTE $30
	.BYTE $27
	.BYTE $30
	.BYTE $96
	.BYTE $27
	.BYTE $98
	.BYTE $30
	.BYTE $30
	.BYTE $96
	.BYTE $27
	.BYTE $98
	.BYTE $30
	.BYTE $27
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $29
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $29
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $36 ;	6
	.BYTE $F2
	SndJmpF0 unk_FE2E ;
SoundTrack_22_2:
	.BYTE $A4
	.BYTE $F1
	.BYTE   2
	.BYTE $98
	.BYTE $27
	.BYTE $27
	.BYTE $96
	.BYTE $22
	.BYTE $98
	.BYTE $27
	.BYTE $96
	.BYTE $22
	.BYTE $98
	.BYTE $26
	.BYTE $26
	.BYTE $96
	.BYTE $22
	.BYTE $98
	.BYTE $26
	.BYTE $96
	.BYTE $22
	.BYTE $98
	.BYTE $24
	.BYTE $24
	.BYTE $96
	.BYTE $20
	.BYTE $98
	.BYTE $24
	.BYTE $96
	.BYTE $20
	.BYTE $98
	.BYTE $26
	.BYTE $26
	.BYTE $96
	.BYTE $22
	.BYTE $26
	.BYTE $27
	.BYTE $29
	.BYTE $F2
	.BYTE $F1
	.BYTE   2
	.BYTE $98
	.BYTE $27
	.BYTE $22
	.BYTE $27
	.BYTE $22
	.BYTE $2B
	.BYTE $96
	.BYTE $22
	.BYTE $98
	.BYTE $27
	.BYTE $96
	.BYTE $22
	.BYTE $27
	.BYTE $22
	.BYTE $98
	.BYTE $26
	.BYTE $22
	.BYTE $26
	.BYTE $22
	.BYTE $29
	.BYTE $96
	.BYTE $22
	.BYTE $98
	.BYTE $26
	.BYTE $96
	.BYTE $22
	.BYTE $26
	.BYTE $22
	.BYTE $98
	.BYTE $24
	.BYTE $20
	.BYTE $24
	.BYTE $20
	.BYTE $27
	.BYTE $96
	.BYTE $20
	.BYTE $98
	.BYTE $24
	.BYTE $96
	.BYTE $20
	.BYTE $24
	.BYTE $20
	.BYTE $98
	.BYTE $26
	.BYTE $22
	.BYTE $29
	.BYTE $22
	.BYTE $30
	.BYTE $96
	.BYTE $22
	.BYTE $98
	.BYTE $29
	.BYTE $96
	.BYTE $22
	.BYTE $26
	.BYTE $22
	.BYTE $F2
	SndJmpF0 SoundTrack_22_2 ;
SoundData_23_Music_BestEnding:
	SoundData 0, SoundTrack_23_0
	SoundData 1, SoundTrack_23_1 ;
	SoundData 2, SoundTrack_23_2 ;
	.BYTE $FF
SoundTrack_23_0:
	.BYTE $A0
	.BYTE $D1
	.BYTE $E6
unk_FEFD:
	SndJmpF3 SoundTrack_FF20
	.BYTE $39 ;	9
	.BYTE $39 ;	9
	.BYTE $39 ;	9
	.BYTE $96
	.BYTE $39 ;	9
	.BYTE $98
	.BYTE $39 ;	9
	.BYTE $96
	.BYTE $39 ;	9
	.BYTE $98
	.BYTE $39 ;	9
	.BYTE $3B
	.BYTE $39 ;	9
	SndJmpF3 SoundTrack_FF20
	.BYTE $32 ;	2
	.BYTE $32 ;	2
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $39 ;	9
	.BYTE $37 ;	7
	SndJmpF0 unk_FEFD ;
SoundTrack_FF20:
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $37 ;	7
	.BYTE $37 ;	7
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $96
	.BYTE $37 ;	7
	.BYTE $98
	.BYTE $37 ;	7
	.BYTE $37 ;	7
	.BYTE $37 ;	7
	.BYTE $F4
SoundTrack_23_1:
	.BYTE $A0
	.BYTE $D1
unk_FF31:
	SndJmpF3 SoundTrack_FF54
	.BYTE $35 ;	5
	.BYTE $35 ;	5
	.BYTE $35 ;	5
	.BYTE $96
	.BYTE $35 ;	5
	.BYTE $98
	.BYTE $35 ;	5
	.BYTE $96
	.BYTE $35 ;	5
	.BYTE $98
	.BYTE $35 ;	5
	.BYTE $35 ;	5
	.BYTE $35 ;	5
	SndJmpF3 SoundTrack_FF54
	.BYTE $2B
	.BYTE $2B
	.BYTE $2B
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $96
	.BYTE $32 ;	2
	.BYTE $98
	.BYTE $32 ;	2
	.BYTE $32 ;	2
	.BYTE $32 ;	2
	SndJmpF0 unk_FF31 ;
SoundTrack_FF54:
	.BYTE $98
	.BYTE $34 ;	4
	.BYTE $34 ;	4
	.BYTE $34 ;	4
	.BYTE $96
	.BYTE $34 ;	4
	.BYTE $98
	.BYTE $34 ;	4
	.BYTE $96
	.BYTE $34 ;	4
	.BYTE $98
	.BYTE $34 ;	4
	.BYTE $34 ;	4
	.BYTE $34 ;	4
	.BYTE $F4
SoundTrack_23_2:
	.BYTE $A4
	.BYTE $98
unk_FF65:
	.BYTE $F1
	.BYTE   4
	.BYTE $10
	.BYTE $20
	.BYTE $F2
	.BYTE $F1
	.BYTE   4
	.BYTE $15
	.BYTE $25
	.BYTE $F2
	.BYTE $F1
	.BYTE   4
	.BYTE $10
	.BYTE $20
	.BYTE $F2
	.BYTE $12
	.BYTE $22
	.BYTE $12
	.BYTE $22
	.BYTE   7
	.BYTE $17
	.BYTE   7
	.BYTE $17
	SndJmpF0 unk_FF65 ;



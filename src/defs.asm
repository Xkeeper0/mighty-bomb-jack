.ignorenl

	
; ---------------------------------------------------------------------------
; enum PPUMaskBitmask (bitfield)
PPUMask_Grayscale			= %1
PPUMask_ShowLeft8Pixels_BG	= %10
PPUMask_ShowLeft8Pixels_SPR	= %100
PPUMask_ShowBackground		= %1000
PPUMask_ShowSprites			= %10000
PPUMask_RedEmphasis			= %100000
PPUMask_GreenEmphasis		= %1000000
PPUMask_BlueEmphasis		= %10000000

; ---------------------------------------------------------------------------

; enum PPUControl (bitfield)
PPUCtrl_BaseAddress		   = 3
PPUCtrl_BaseAddr2000 = 	0
PPUCtrl_BaseAddr2400 = 	1
PPUCtrl_BaseAddr2800 = 	2
PPUCtrl_BaseAddr2C00 = 	3
PPUCtrl_WriteIncrementHorizontal =  0
PPUCtrl_WriteIncrementVertical =  4
PPUCtrl_SpritePatternTable0000 =  0
PPUCtrl_SpritePatternTable1000 =  8
PPUCtrl_BackgroundPatternTable0000 =  0
PPUCtrl_BackgroundPatternTable1000 =  $10
PPUCtrl_SpriteSize8x8 =  0
PPUCtrl_SpriteSize8x16 =  $20
PPUControl_NMIDisabled =  0
PPUControl_NMIEnabled =  $80

; ---------------------------------------------------------------------------

; enum PPUSTatusMask (bitfield)
PPUStatus_SpriteOverflow =  %100000
PPUStatus_SpriteZeroHit =  %1000000
PPUStatus_VBlank =  %10000000

; ---------------------------------------------------------------------------
; Joypad
JP_Right	= %00000001
JP_Left		= %00000010
JP_Down		= %00000100
JP_Up		= %00001000
JP_Start	= %00010000
JP_Select	= %00100000
JP_B		= %01000000
JP_A		= %10000000

; ---------------------------------------------------------------------------
; Strings
Strings_PushStartButton =  0
Strings_GameOver =  1
Strings_TimeOver =  2
Strings_YouAreGreedy = 	3
Strings_GoToTheTortureRoom =  4
Strings_Round_Clear =  5
Strings_TimeBonus =  6
Strings_YouveGotten =  7
Strings_FireBombs =  8
Strings_SpecialBonus = 	9
Strings_YourGDV =  $A
Strings_C_Tecmo =  $B
Strings_HighGDV =  $C
Strings_Ending1A =  $D
Strings_Ending1B =  $E
Strings_Ending1C =  $F
Strings_Ending2A =  $10
Strings_Ending2B =  $11
Strings_Ending2C =  $12
Strings_Ending3A =  $13
Strings_Ending3B =  $14
Strings_Ending3C =  $15
Strings_Ending3D =  $16
Strings_Ending4A =  $17
Strings_Ending4B =  $18
Strings_Ending4C =  $19
Strings_Ending4D =  $1A

; ---------------------------------------------------------------------------

; enum Sound
Sound_Silence =  0			; (nothing, silences music)
Sound_Jump =  1
Sound_Death =  2
Sound_BonusCoinSpawn = 	3
Sound_CoinCollected =  4
Sound_PowerCoinSpawn = 	5		; (bomb	room item that coins enemies)
Sound_PowerCoinMusic = 	6
Sound_BombCollectedUnlit =  7
Sound_BombCollectedLit =  8
Sound_YouAreGreedy =  9
Sound_1UP_Captive =  $A
Sound_CrystalBall =  $B
Sound_C_Null = 	$C			; (not used, copy of 14)
Sound_BonusStatueCollected =  $D
Sound_SecretBlockRevealed =  $E		; and/or revealed
Sound_Door =  $F			; door opens/closes
Music_Main =  $10
Music_TreasureRoom =  $11
Music_SideRoom =  $12
Music_Labyrinth =  $13
Sound_14_Null =  $14			; (not used, copy of 0C)
Music_Outside1 =  $15			; round	9 / 13
Music_MainWithIntro =  $16		; usual	stage music
Music_GameOver =  $17
Music_RoundClear =  $18
Sound_BombChestBonus = 	$19		; next chest opened contains power coin
Sound_1A =  $1A				; ?
Sound_Pause =  $1B			; silences (not	pauses)	music
Sound_Unpause =  $1C			; unsilences music
Sound_UsedMightyCoin = 	$1D
Music_Outside2 =  $1E			; (copy	of $15)
Music_TortureRoom =  $1F		; torture room?	BGM
Sound_BombBonus =  $20			; collected bombs in right order
Sound_TimePickup =  $21			; mighty milk yum
Music_Ending = 	$22
Music_CollectedFullFamily =  $23

; ---------------------------------------------------------------------------

; enum Score
Score_10 =  0
Score_100 =  1
Score_200 =  2
Score_300 =  3
Score_500 =  4
Score_800 =  5
Score_1200 =  6
Score_2000 =  7
Score_1000 =  8
Score_10000 =  9
Score_100000 = 	$A
Score_50000 =  $B
Score_20 =  $C
Score_30 =  $D
Score_40 =  $E
Score_50 =  $F
Score_400 =  $10
Score_600 =  $11
Score_800a =  $12			; duplicate
Score_900 =  $13
Score_1500 =  $14
Score_2500 =  $15
Score_1600 =  $16
Score_2400 =  $17
Score_3200 =  $18
Score_4000 =  $19
Score_3600 =  $1A
Score_4800 =  $1B
Score_6000 =  $1C
Score_8000 =  $1D
Score_1E_INVALID =  $1E
Score_1E_x =  $1E
Score_1000000 =  $1F

; ---------------------------------------------------------------------------

; enum EnemyStruct
EnemyStruct_0_Status = 	0
EnemyStruct_1 =  1
EnemyStruct_2_XVelLo = 	2
EnemyStruct_3_XPosLo = 	3
EnemyStruct_4_XVelHi = 	4
EnemyStruct_5_XPosHi = 	5
EnemyStruct_6 =  6			; maybe	"offscreen x"
EnemyStruct_7 =  7			; maybe	"player	x/y target range"
EnemyStruct_8_YVelLo = 	8
EnemyStruct_9_YPosLo = 	9
EnemyStruct_A_YVelHi = 	$A
EnemyStruct_B_YPosHi = 	$B
EnemyStruct_C =  $C			; maybe	"offscreen y"
EnemyStruct_D =  $D
EnemyStruct_E_Sprite = 	$E
EnemyStruct_F =  $F
EnemyStruct_10_AnimOffset =  $10
EnemyStruct_11 =  $11
EnemyStruct_12 =  $12
EnemyStruct_13_Type =  $13		; 0-7=enemy
EnemyStruct_14 =  $14
EnemyStruct_15 =  $15
EnemyStruct_SpeedMod = 	$16		; from difficulty
EnemyStruct_17 =  $17
EnemyStruct_18 =  $18
EnemyStruct_19 =  $19
EnemyStruct_1A =  $1A
EnemyStruct_1B =  $1B

; ---------------------------------------------------------------------------

; enum EnemyType
EnemyType_0_Mummy =  0			; normal mummy
EnemyType_1_Unknown =  1		; mummy	that does nothing?
EnemyType_2_Hanezo =  2			; red DVD logo guy
EnemyType_3_GejiShogun =  3		; red guy that chases you
EnemyType_4_Gameido =  4		; green	turtle
EnemyType_5_Dokuron =  5		; green	skull
EnemyType_6_Desufa =  6			; red fireball
EnemyType_7_Horus =  7			; green	bird
EnemyType_8_PowerCoin =  8
EnemyType_9_ExtraCoin =  9
EnemyType_A_SecretCoin =  $A
EnemyType_B_Captive =  $B
EnemyType_C_Balloon =  $C
EnemyType_D_Mummy1 =  $D		; spawns a mummy
EnemyType_E_BonusCoin =  $E
EnemyType_F_Mummy2 =  $F		; spawns a mummy
EnemyType_10_Brother = 	$10

; ---------------------------------------------------------------------------

; enum RoomFlag	(bitfield)
RF_1 = 	1
RF_BombRoom =  %10
RF_4 = 	%100
RF_AtScrollEdge =  %1000
RF_SingleScreen =  %10000
RF_ScrollStop =  %100000
RF_Horizontal =  %1000000
RF_SectionStart =  %10000000

; ---------------------------------------------------------------------------

; enum BasePointer
BasePointer_SpritesTable =  0
BasePointer_AdjacentRoomsTable =  1
BasePointer_RoomHalfScreens =  2
BasePointer_LayoutChunks =  3
BasePointer_MetatileDefinitions =  4
BasePointer_RoomDataPointers = 	5
BasePointer_HalfScreenLayouts =  6
BasePointer_AttributeTableBuffer =  7
BasePointer_RAM_5A3 =  8
BasePointer_BackgroundPaletteSets =  9
BasePointer_SectionRoomsTable =  $A
BasePointer_PlayerScore =  $B		; unused?
BasePointer_RAM_786 =  $C
BasePointer_RAM_30A =  $D
BasePointer_EnemySpawnPositionTable =  $E

; ---------------------------------------------------------------------------

; enum Letter
_A =  $A
_B =  $B
_C =  $C
_D =  $D
_E =  $E
_F =  $F
_G =  $10
_H =  $11
_I =  $12
_J =  $13
_K =  $14
_L =  $15
_M =  $16
_N =  $17
_O =  $18
_P =  $19
_Q =  $1A
_R =  $1B
_S =  $1C
_T =  $1D
_U =  $1E
_V =  $1F
_W =  $20
_X =  $21
_Y =  $22
_Z =  $23
__ =  $24
_ap =  $2A
_cp =  $2C
_cma = 	$2D
_exc = 	$AE


; ---------------------------------------------------------------------------
; Items
Item_100Bag			= 0
Item_300Bag			= 1
Item_1000Bag		= 2
Item_GoldCoin		= 3
Item_MightyDrink	= 4
Item_Bomb			= 5
Item_Sphinx			= 6
Item_TecmoPlate		= 7
Item_MightyCoin		= 8
Item_CrystalBall1	= 9
Item_CrystalBall2	= 10
Item_King			= 11
Item_Queen			= 12
Item_Princess		= 13
Item_BeelzebutMask	= 14
Item_0E_Nothing		= 15
Item_RedChest		= 16
Item_OrangeChest	= 17

.endinl
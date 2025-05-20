
HandleSound:
	LDA SoundsQueued		; Check	if any sounds are queued...
	BEQ loc_B110			; If not, skip ahead
	LDA #0
	STA byte_0			; $0 is	the index we're looking at

loc_B105:
	JSR HandleSoundQueue
	INCc byte_0			; Inc index
	DEC SoundsQueued		; Dec sounds queued
	BNE loc_B105			; Loop until all done

loc_B110:
	LDA #0
	STA a:ActiveSoundChannels
	STA a:CurrentSoundChannel

loc_B118:
	LDA a:CurrentSoundChannel
	ASL A
	TAX
	LDA SoundPointersA,X
	STA SoundEnginePointer
	LDA SoundPointersA+1,X
	STA SoundEnginePointer+1
	LDY #0
	LDA (SoundEnginePointer),Y
	LSR A
	PHP
	ROR a:ActiveSoundChannels
	PLP
	BCC loc_B136
	JSR HandleSoundChannel

loc_B136:
	INC a:CurrentSoundChannel
	LDA a:CurrentSoundChannel
	CMP #8
	BNE loc_B118
	JSR WriteSoundRegisters
	RTS
; End of function HandleSound

; =============== S U B	R O U T	I N E =======================================

HandleSoundQueue:
	LDX byte_0			; $0 = index into queue
	LDA SoundQueue,X		; Load queued entry
	BNE loc_B165			; If not empty,	skip ahead
	LDX #0				; Otherwise...

loc_B14D:
	TXA					; X = 0, 1, 2 ... 7
	ASL A				; A = 2, 4, 6 ... E
	TAY
	LDA SoundPointersA,Y		; Pointers to $452+
	STA SoundEnginePointer		; Store	to temporary pointer
	LDA SoundPointersA+1,Y
	STA SoundEnginePointer+1
	LDY #0
	TYA
	STA (SoundEnginePointer),Y	; Temporary pointer = #$00
	INX					; Effectively zeroes the addresses
					; pointed to in	the table
	CPX #8
	BNE loc_B14D
	RTS
; ---------------------------------------------------------------------------

loc_B165:
	DEC SoundQueue,X		; Decrement queued value
	LDA SoundQueue,X		; Then load it
	ASL A				; Shift	left
	TAX
	LDA SoundPointers,X		; Load pointer
	STA SoundPointerTemp
	INX
	LDA SoundPointers,X
	STA SoundPointerTemp+1
	LDY #0
	STY byte_1

loc_B17C:
	LDY byte_1
	LDA (SoundPointerTemp),Y
	CMP #$FF
	BEQ locret_B1C8
	ASL A
	TAX
	LDA SoundPointersA,X
	STA SoundEnginePointer
	LDA SoundPointersA+1,X
	STA SoundEnginePointer+1
	LDY #$17
	LDA #0

loc_B194:
	STA (SoundEnginePointer),Y
	DEY
	BPL loc_B194
	LDA #1
	INY
	STA (SoundEnginePointer),Y
	LDA SoundPointersB,X
	LDY #$B
	STA (SoundEnginePointer),Y
	INY
	LDA SoundPointersB+1,X
	STA (SoundEnginePointer),Y
	INC byte_1
	LDY byte_1
	LDA (SoundPointerTemp),Y
	PHA
	INY
	LDA (SoundPointerTemp),Y
	STY byte_1
	LDY #4
	STA (SoundEnginePointer),Y
	PLA
	DEY
	STA (SoundEnginePointer),Y
	LDY #1
	TYA
	STA (SoundEnginePointer),Y
	INC byte_1
	BNE loc_B17C

locret_B1C8:
	RTS
; End of function HandleSoundQueue

; =============== S U B	R O U T	I N E =======================================

HandleSoundChannel:
	LDA a:CurrentSoundChannel
	AND #3
	ASL A
	ASL A
	STA SoundRegIndex		; (sound channel x4)
	JSR MaybeUpdateVolDelay
	LDY #1				; Y = 1
	LDA (SoundEnginePointer),Y
	SEC
	SBC #1
	BEQ loc_B1E2
	STA (SoundEnginePointer),Y
	RTS
; ---------------------------------------------------------------------------

loc_B1E2:
	INY
	LDA (SoundEnginePointer),Y	; Y = 2
	DEY
	STA (SoundEnginePointer),Y	; Y = 1
	LDY #7
	LDA #0
	STA (SoundEnginePointer),Y	; Y = 7
	JSR MaybeResetVolDelay
	LDY #$10
	LDA #8
	STA (SoundEnginePointer),Y	; Y = #$10
	LDY #3
	LDA (SoundEnginePointer),Y	; Y = #$3
	STA off_2
	INY
	LDA (SoundEnginePointer),Y	; Y = #$4
	STA off_2+1
	LDY #0
	STY byte_1

loc_B206:
	LDY byte_1
	INC byte_1
	LDA (off_2),Y			; offset into sound data
	BPL loc_B214			; if <=	#$7F, jump ahead
	JSR HandleSoundCommand
	JMP loc_B206
; ---------------------------------------------------------------------------

loc_B214:
	TAX
	LDY #$14
	LDA (SoundEnginePointer),Y
	BEQ loc_B246
	STA a:byte_10
	INY
	CLC
	LDA (SoundEnginePointer),Y
	ADC #1
	STA (SoundEnginePointer),Y
	STA a:byte_11
	TXA

loc_B22A:
	CLC
	ADC a:byte_10
	TAY
	AND #$F
	CMP #$B
	TYA
	BCC loc_B240
	LDXc byte_10
	BPL loc_B23E
	SBC #4
; ---------------------------------------------------------------------------
	.BYTE $2C				; sacrificial BIT
; ---------------------------------------------------------------------------

loc_B23E:
	ADC #4

loc_B240:
	DECc byte_11
	BNE loc_B22A
	TAX

loc_B246:
	TXA
	AND #$F				; Find note to play?
	ASL A
	TAY
	LDA NoteFrequencyTable,Y
	STA off_4
	LDA NoteFrequencyTable+1,Y
	STA off_4+1
	TXA					; Then get octave??
	LSR A
	LSR A
	LSR A
	LSR A
	BEQ loc_B264
	TAX

loc_B25D:
	LSR off_4+1
	ROR off_4
	DEX
	BNE loc_B25D

loc_B264:
	LDY #$11
	LDA off_4
	STA (SoundEnginePointer),Y
	INY
	LDA off_4+1
	ORA #8
	STA (SoundEnginePointer),Y
	JSR sub_B285

loc_B274:
	LDY #3
	LDA byte_1
	CLC
	ADC off_2
	STA (SoundEnginePointer),Y
	INY
	LDA off_2+1
	ADC #0
	STA (SoundEnginePointer),Y
	RTS
; End of function HandleSoundChannel

; =============== S U B	R O U T	I N E =======================================

sub_B285:
	JSR CheckIfSoundChannelIsActive
	BNE locret_B2A8
; End of function sub_B285

; =============== S U B	R O U T	I N E =======================================

SoundCommand_F6_F7_sub1:
	LDX SoundRegIndex		; (sound channel x4)
	LDA SoundReg_Vol,X
	ORA #$20
	STA SoundReg_Vol,X
	LDY #$10
	LDA (SoundEnginePointer),Y
	STA SoundReg_Sweep,X
	INY
	LDA (SoundEnginePointer),Y
	STA SoundReg_Lo,X
	INY
	LDA (SoundEnginePointer),Y
	STA SoundReg_Hi,X

locret_B2A8:
	RTS
; End of function SoundCommand_F6_F7_sub1

; =============== S U B	R O U T	I N E =======================================

HandleSoundCommand:
	STA byte_6			; original command byte
	AND #$7F
	LSR A
	LSR A
	LSR A
	LSR A
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD SoundCommand_8x_9x		; change note length
	.WORD SoundCommand_8x_9x		; change note length
	.WORD SoundCommand_Ax_Bx		; set volume table
	.WORD SoundCommand_Ax_Bx		; set volume table
	.WORD SoundCommand_Cx		; ?, double returns
	.WORD SoundCommand_Dx
	.WORD SoundCommand_Ex		; x -> Y=#$D
	.WORD SoundCommand_Fx		; additional commands
; End of function HandleSoundCommand

; =============== S U B	R O U T	I N E =======================================

; change note length

SoundCommand_8x_9x:
	LDA byte_6			; original command byte
	AND #$1F
	TAX
	LDA NoteLengthTable,X		; $1F entries
	LDY #1
	STA (SoundEnginePointer),Y	; Y=1
	INY
	STA (SoundEnginePointer),Y	; Y=2
	RTS
; End of function SoundCommand_8x_9x

; =============== S U B	R O U T	I N E =======================================

; set volume table

SoundCommand_Ax_Bx:
	LDA byte_6			; original command byte
	AND #$1F
	ASL A
	TAX
	LDY #5
	LDA SoundVolTable,X
	STA (SoundEnginePointer),Y	; Y=5
	INY
	LDA SoundVolTable+1,X
	STA (SoundEnginePointer),Y	; Y=6
	INY
	LDA #0
	STA (SoundEnginePointer),Y	; Y=7
	JSR MaybeResetVolDelay
	RTS
; End of function SoundCommand_Ax_Bx

; =============== S U B	R O U T	I N E =======================================

; ?, double returns

SoundCommand_Cx:
	LDAc byte_6			; original command byte
	AND #$F
	LDY #$11
	STA (SoundEnginePointer),Y	; Y=#$11
	LDA #8
	INY
	STA (SoundEnginePointer),Y	; Y=#$12
	JSR sub_B285
	PLA
	PLA
	JMP loc_B274
; End of function SoundCommand_Cx

; =============== S U B	R O U T	I N E =======================================

SoundCommand_Dx:
	LDA byte_6			; original command byte
	AND #$F
	CMP #8
	BCS loc_B320
	CLC
	ROR A
	ROR A
	PHA
	LDY #$F
	LDA (SoundEnginePointer),Y	; Y=#$F
	AND #$3F
	STA (SoundEnginePointer),Y
	PLA
	ORA (SoundEnginePointer),Y
	STA (SoundEnginePointer),Y
	RTS
; ---------------------------------------------------------------------------

loc_B320:
	AND #3
	TAX
	LDA byte_B52C,X
	LDY #$14
	CMP (SoundEnginePointer),Y
	STA (SoundEnginePointer),Y	; Y=#$14
	BEQ locret_B333
	LDA #0
	INY
	STA (SoundEnginePointer),Y	; Y=#$15

locret_B333:
	RTS
; End of function SoundCommand_Dx

; =============== S U B	R O U T	I N E =======================================

; x -> Y=#$D

SoundCommand_Ex:
	LDA byte_6			; original command byte
	AND #$F
	LDY #$D
	STA (SoundEnginePointer),Y	; Y=#$D
	RTS
; End of function SoundCommand_Ex

; =============== S U B	R O U T	I N E =======================================

; additional commands

SoundCommand_Fx:
	LDA byte_6
	AND #7
	JSR JumpTable
; ---------------------------------------------------------------------------
	.WORD SoundCommand_F0		; jump to (next	two bytes)
	.WORD SoundCommand_F1		; start	of loop/repeat section
	.WORD SoundCommand_F2		; end of loop/repeat
	.WORD SoundCommand_F3
	.WORD SoundCommand_F4
	.WORD SoundCommand_F5
	.WORD SoundCommand_F6_F7
	.WORD SoundCommand_F6_F7
; End of function SoundCommand_Fx

; =============== S U B	R O U T	I N E =======================================

; jump to (next	two bytes)

SoundCommand_F0:
	LDY byte_1			; bytes	into data, currently
	LDA (off_2),Y			; load offset...
	PHA					; ...push
	INY
	LDA (off_2),Y			; load offset...
	PHA					; ...push
	LDY #0
	STY byte_1			; reset	bytes into data
	LDY #4
	PLA					; pull...
	STA (SoundEnginePointer),Y	; Y=4 ...store offset
	STA off_2+1			; ...to	working	space too
	DEY
	PLA					; pull...
	STA (SoundEnginePointer),Y	; Y=3 ...store offset
	STA off_2
	RTS
; End of function SoundCommand_F0

; =============== S U B	R O U T	I N E =======================================

; start	of loop/repeat section

SoundCommand_F1:
	LDY byte_1			; bytes	into data, currently
	LDA (off_2),Y			; read this byte...
	LDY #$13
	STA (SoundEnginePointer),Y	; Y=#$13 ...and	store it here
	INC byte_1			; bytes	into data++
	LDA byte_1
	CLC					; add bytes into data...
	ADC off_2			; ...into pointer
	LDY #9
	STA (SoundEnginePointer),Y	; Y=#$9 then store pointer
	INY
	LDA off_2+1
	ADC #0
	STA (SoundEnginePointer),Y	; Y=#$A pointer hi
	RTS
; End of function SoundCommand_F1

; =============== S U B	R O U T	I N E =======================================

; end of loop/repeat

SoundCommand_F2:
	LDY #$13
	LDA (SoundEnginePointer),Y	; Y=#$13
	SEC
	SBC #1
	BEQ locret_B3AD			; if value was 1 (now 0), exit
	STA (SoundEnginePointer),Y
	LDY #9				; store	repeat offset
	LDA (SoundEnginePointer),Y	; Y=#$9
	PHA
	INY
	LDA (SoundEnginePointer),Y
	LDY #4
	STA (SoundEnginePointer),Y
	STA off_2+1
	DEY
	PLA
	STA (SoundEnginePointer),Y
	STA off_2
	LDA #0
	STA byte_1

locret_B3AD:
	RTS
; End of function SoundCommand_F2

; =============== S U B	R O U T	I N E =======================================

SoundCommand_F3:
	LDY byte_1
	LDA (off_2),Y
	LDY #3
	STA (SoundEnginePointer),Y
	INC byte_1
	LDY byte_1
	LDA (off_2),Y
	LDY #4
	STA (SoundEnginePointer),Y
	INC byte_1
	LDA byte_1
	CLC
	ADC off_2
	PHA
	LDA off_2+1
	ADC #0
	PHA
	LDY #$B
	LDA (SoundEnginePointer),Y
	STA byte_8
	CLC
	ADC #2
	STA (SoundEnginePointer),Y
	INY
	LDA (SoundEnginePointer),Y
	STA byte_9
	ADC #0
	STA (SoundEnginePointer),Y
	LDY #1
	PLA
	STA (byte_8),Y
	DEY
	PLA
	STA (byte_8),Y
	LDA #0
	STA byte_1
	LDY #3
	LDA (SoundEnginePointer),Y
	STA off_2
	INY
	LDA (SoundEnginePointer),Y
	STA off_2+1
	RTS
; End of function SoundCommand_F3

; =============== S U B	R O U T	I N E =======================================

SoundCommand_F4:
	LDY #$B
	SEC
	LDA (SoundEnginePointer),Y
	SBC #2
	STA (SoundEnginePointer),Y
	STA byte_8
	INY
	LDA (SoundEnginePointer),Y
	SBC #0
	STA (SoundEnginePointer),Y
	STA byte_9
	LDY #0
	LDA (byte_8),Y
	PHA
	INY
	LDA (byte_8),Y
	LDY #4
	STA (SoundEnginePointer),Y
	STA off_2+1
	DEY
	PLA
	STA (SoundEnginePointer),Y
	STA off_2
	LDA #0
	STA byte_1
	RTS
; End of function SoundCommand_F4

; =============== S U B	R O U T	I N E =======================================

SoundCommand_F5:
	LDY byte_1
	LDA (off_2),Y
	INC byte_1
	LDY #$10
	STA (SoundEnginePointer),Y
	RTS
; End of function SoundCommand_F5

; =============== S U B	R O U T	I N E =======================================

SoundCommand_F6_F7:
	LDA #0
	LDY #0
	STA (SoundEnginePointer),Y
	LDA #4
	BIT a:CurrentSoundChannel
	BEQ loc_B45C
	LDA a:CurrentSoundChannel
	AND #3
	ASL A
	TAX
	LDA SoundPointersA,X
	STA SoundEnginePointer
	LDA SoundPointersA+1,X
	STA SoundEnginePointer+1
	JSR SoundCommand_F6_F7_sub1
	LDY #$F
	LDA (SoundEnginePointer),Y
	ORA #$20
	STA SoundReg_Vol,X

loc_B45C:
	PLA
	PLA
	RTS
; End of function SoundCommand_F6_F7

; =============== S U B	R O U T	I N E =======================================

MaybeUpdateVolDelay:
	LDY #$E
	LDA (SoundEnginePointer),Y	; Y=#$E
	BEQ MaybeResetVolDelay
	SEC
	SBC #1
	STA (SoundEnginePointer),Y
	RTS
; End of function MaybeUpdateVolDelay

; =============== S U B	R O U T	I N E =======================================

MaybeResetVolDelay:
	LDY #5
	LDA (SoundEnginePointer),Y
	STA off_4
	INY
	LDA (SoundEnginePointer),Y
	STA off_4+1
	INY
	LDA (SoundEnginePointer),Y
	TAY
	LDA (off_4),Y
	PHA
	INY
	LDA (off_4),Y
	PHA
	LDY #7
	LDA (SoundEnginePointer),Y
	CLC
	ADC #2
	STA (SoundEnginePointer),Y
	LDY #$E
	PLA
	STA (SoundEnginePointer),Y
	INY
	LDA (SoundEnginePointer),Y
	AND #$C0
	STA off_4
	PLA
	ORA off_4
	STA a:off_4
	AND #$10
	BEQ loc_B4B9+1
	LDA off_4
	AND #$F
	LDY #$D
	SEC
	SBC (SoundEnginePointer),Y
	BCS loc_B4AD
	LDA #0

loc_B4AD:
	AND #$F
	PHA
	LDA off_4
	AND #$D0
	STA off_4
	PLA
	ORA off_4

loc_B4B9:
	BIT SoundChannelA_Mus3+$B
	LDY #$F
	STA (SoundEnginePointer),Y
	JSR CheckIfSoundChannelIsActive
	BNE locret_B4CF
	LDY #$F
	LDA (SoundEnginePointer),Y
	LDX SoundRegIndex		; (sound channel x4)
	STA SoundReg_Vol,X

locret_B4CF:
	RTS
; End of function MaybeResetVolDelay

; =============== S U B	R O U T	I N E =======================================

WriteSoundRegisters:
	LDA a:ActiveSoundChannels
	LSR A
	LSR A
	LSR A
	LSR A
	ORA a:ActiveSoundChannels
	AND #$F
	STA SND_CHN
	LDX #0

loc_B4E1:
	LDA SoundReg_Vol,X
	PHA
	AND #$DF
	STA SQ1_VOL,X
	STA SoundReg_Vol,X
	PLA
	AND #$20
	BEQ loc_B504
	LDA SoundReg_Sweep,X
	STA SQ1_SWEEP,X
	LDA SoundReg_Lo,X
	STA SQ1_LO,X
	LDA SoundReg_Hi,X
	STA SQ1_HI,X

loc_B504:
	INX
	INX
	INX
	INX
	CPX #$10
	BNE loc_B4E1
	RTS
; End of function WriteSoundRegisters

; =============== S U B	R O U T	I N E =======================================

CheckIfSoundChannelIsActive:
	LDA a:CurrentSoundChannel
	CMP #4
	BCC loc_B517
	LDA #0
	RTS
; ---------------------------------------------------------------------------

loc_B517:
	ORA #4
	ASL A
	TAX
	LDA SoundPointersA,X
	STA byte_A
	LDA SoundPointersA+1,X
	STA byte_B
	LDY #0
	LDA (byte_A),Y
	AND #1
	RTS
; End of function CheckIfSoundChannelIsActive

; ---------------------------------------------------------------------------
byte_B52C:
	.BYTE 1,	2, $FF,	$FE
NoteFrequencyTable:
	.WORD $591
	.WORD $541				; 1
	.WORD $4F5				; 2
	.WORD $4AE				; 3
	.WORD $46B				; 4
	.WORD $42B				; 5
	.WORD $3EF				; 6
	.WORD $3B7				; 7
	.WORD $381				; 8
	.WORD $34F				; 9
	.WORD $31F				; $A
	.WORD $2F2				; $B
	.WORD    0				; $C
	.WORD    0				; $D
	.WORD    0				; $E
	.WORD    0				; $F
SoundPointersA:
	.WORD SoundChannelA_Mus0
	.WORD SoundChannelA_Mus1		; 1
	.WORD SoundChannelA_Mus2		; 2
	.WORD SoundChannelA_Mus3		; 3
	.WORD SoundChannelA_Sfx0		; 4
	.WORD SoundChannelA_Sfx1		; 5
	.WORD SoundChannelA_Sfx2		; 6
	.WORD SoundChannelA_Sfx3		; 7
SoundPointersB:
	.WORD SoundChannelB_Mus0
	.WORD SoundChannelB_Mus1		; 1 ; last entry not used(?)
	.WORD SoundChannelB_Mus2		; 2
	.WORD SoundChannelB_Mus3		; 3
	.WORD SoundChannelB_Sfx0		; 4
	.WORD SoundChannelB_Sfx1		; 5
	.WORD SoundChannelB_Sfx2		; 6
	.WORD SoundChannelB_Sfx3		; 7

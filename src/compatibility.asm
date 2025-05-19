;
; Compatibility shims for zero page operations ...
; I don't want to conditionally define these for every one, so
; ones that ALWAYS use non-zero page will just use absolute,
; while these ones will switch back and forth
;
; oogh
;

MACRO ADCc addr
	IFDEF USE_MORE_ZP
		ADC addr
	ELSE
		ADC a:addr
	ENDIF
ENDM ADCc

MACRO ADCcX addr,X
	IFDEF USE_MORE_ZP
		ADC addr,X
	ELSE
		ADC a:addr,X
	ENDIF
ENDM ADCcX

MACRO ADCcY addr,Y
	IFDEF USE_MORE_ZP
		ADC addr,Y
	ELSE
		ADC a:addr,Y
	ENDIF
ENDM ADCcY

MACRO ANDc addr
	IFDEF USE_MORE_ZP
		AND addr
	ELSE
		AND a:addr
	ENDIF
ENDM ANDc

MACRO ASLc addr
	IFDEF USE_MORE_ZP
		ASL addr
	ELSE
		ASL a:addr
	ENDIF
ENDM ASLc

MACRO BITc addr
	IFDEF USE_MORE_ZP
		BIT addr
	ELSE
		BIT a:addr
	ENDIF
ENDM BITc

MACRO CMPc addr
	IFDEF USE_MORE_ZP
		CMP addr
	ELSE
		CMP a:addr
	ENDIF
ENDM CMPc

MACRO CPXc addr
	IFDEF USE_MORE_ZP
		CPX addr
	ELSE
		CPX a:addr
	ENDIF
ENDM CPXc

MACRO DECc addr
	IFDEF USE_MORE_ZP
		DEC addr
	ELSE
		DEC a:addr
	ENDIF
ENDM DECc

MACRO EORc addr
	IFDEF USE_MORE_ZP
		EOR addr
	ELSE
		EOR a:addr
	ENDIF
ENDM EORc

MACRO INCc addr
	IFDEF USE_MORE_ZP
		INC addr
	ELSE
		INC a:addr
	ENDIF
ENDM INCc

MACRO LDAc addr
	IFDEF USE_MORE_ZP
		LDA addr
	ELSE
		LDA a:addr
	ENDIF
ENDM LDAc

MACRO LDAcX addr,X
	IFDEF USE_MORE_ZP
		LDA addr,X
	ELSE
		LDA a:addr,X
	ENDIF
ENDM LDAcX

MACRO LDXc addr
	IFDEF USE_MORE_ZP
		LDX addr
	ELSE
		LDX a:addr
	ENDIF
ENDM LDXc

MACRO LDYc addr
	IFDEF USE_MORE_ZP
		LDY addr
	ELSE
		LDY a:addr
	ENDIF
ENDM LDYc

MACRO ORAc addr
	IFDEF USE_MORE_ZP
		ORA addr
	ELSE
		ORA a:addr
	ENDIF
ENDM ORAc

MACRO ROLc addr
	IFDEF USE_MORE_ZP
		ROL addr
	ELSE
		ROL a:addr
	ENDIF
ENDM ROLc

MACRO RORc addr
	IFDEF USE_MORE_ZP
		ROR addr
	ELSE
		ROR a:addr
	ENDIF
ENDM RORc

MACRO SBCc addr
	IFDEF USE_MORE_ZP
		SBC addr
	ELSE
		SBC a:addr
	ENDIF
ENDM SBCc

MACRO STAc addr
	IFDEF USE_MORE_ZP
		STA addr
	ELSE
		STA a:addr
	ENDIF
ENDM STAc

MACRO STAcX addr,X
	IFDEF USE_MORE_ZP
		STA addr,X
	ELSE
		STA a:addr,X
	ENDIF
ENDM STAcX

MACRO STAcY addr,Y
	IFDEF USE_MORE_ZP
		STA addr,Y
	ELSE
		STA a:addr,Y
	ENDIF
ENDM STAcY

MACRO STXc addr
	IFDEF USE_MORE_ZP
		STX addr
	ELSE
		STX a:addr
	ENDIF
ENDM STXc

MACRO STYc addr
	IFDEF USE_MORE_ZP
		STY addr
	ELSE
		STY a:addr
	ENDIF
ENDM STYc


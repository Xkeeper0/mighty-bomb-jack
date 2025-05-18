IFDEF REV_A
    PAD $FFFA,$00
ELSE
    PAD $FFFA,$FF
ENDIF

    .dw NMI
    .dw RESET
    .dw NMI
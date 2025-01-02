//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce
#import "string/string_ascii_to_petscii.asm"


.macro PrintASCII2Petscii(string) {
    ldx #$00
!pstr:
    lda string,x
    beq !pstr+
    jsr ascii_to_petscii_kp
    jsr KERNAL_CHROUT
    inx
    jmp !pstr-
!pstr:
}



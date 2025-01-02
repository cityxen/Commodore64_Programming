//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce
#import "string/string_screencode_to_petscii.asm"

.macro PrintScreenCode2Petscii(string) {
    ldx #$00
!pstr:
    lda string,x
    beq !pstr+
    jsr screencode_to_petscii
    jsr KERNAL_CHROUT
    inx
    jmp !pstr-
!pstr:
}

.macro PrintScreenCode2PetsciiXY(string,x,y) {
    ldx #y
    ldy #x
    clc
    jsr KERNAL_PLOT
    PrintScreenCode2Petscii(string)
}


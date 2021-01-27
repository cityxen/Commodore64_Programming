This file is obsolete and this is a deliberate error to let you know not 
to use this. It is not good and very inefficient.
Use PrintSubRoutines.asm instead.

- Deadline
//////////////////////////////////////////////////////////////////////////////////////
// CityXen - https://linktr.ee/cityxen
//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: Macros: PrintHex
//////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////
// print hex
.macro PrintHex(xpos,ypos) {
    pha
    pha
    lsr
    lsr
    lsr
    lsr
    tax
    lda convtable,x
    sta $0400+xpos+ypos*40
    pla
    and #$0f
    tax
    lda convtable,x
    sta $0401+xpos+ypos*40
    pla
}
.macro PrintHexColor(xpos,ypos,color) {
    pha
    pha
    lsr
    lsr
    lsr
    lsr
    tax
    lda convtable,x
    sta $0400+xpos+ypos*40
    lda #color
    sta COLOR_RAM+xpos+ypos*40
    pla
    and #$0f
    tax
    lda convtable,x
    sta $0401+xpos+ypos*40
    lda #color
    sta COLOR_RAM+1+xpos+ypos*40
    pla
}
.macro PrintKernalHex() {
    pha
    pha
    lsr
    lsr
    lsr
    lsr
    tax
    lda convtable,x
    //sta $0400+xpos+ypos*40
    jsr KERNAL_CHROUT
    pla
    and #$0f
    tax
    lda convtable,x
    //sta $0401+xpos+ypos*40
    jsr KERNAL_CHROUT
    lda #$20
    jsr KERNAL_CHROUT
    pla
}
convtable:
.byte $30,$31,$32,$33,$34,$35,$36,$37
.byte $38,$39,$01,$02,$03,$04,$05,$06


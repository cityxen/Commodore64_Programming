//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: Macros
//////////////////////////////////////////////////////////////////////////////////////

.macro ClearScreen(color) {
    lda #$93
    jsr KERNAL_CHROUT    // $FFD2
    lda #color
    sta BACKGROUND_COLOR // $D020
    sta BORDER_COLOR     // $D021
}

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


//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: Macros
//////////////////////////////////////////////////////////////////////////////////////

screen_001:
.byte 0

.macro DrawPetMateScreen() {
    ////////////////////////////////////////////////
    // Draw the Petmate Screen... START
    lda screen_001
    sta BORDER_COLOR
    lda screen_001+1
    sta BACKGROUND_COLOR
    ldx #$00 // Draw the screen from memory location
dpms_loop:
    lda screen_001+2,x // Petmate screen (+2 is to skip over background/border color)
    sta 1024,x
    lda screen_001+2+256,x
    sta 1024+256,x
    lda screen_001+2+512,x
    sta 1024+512,x
    lda screen_001+2+512+256,x
    sta 1024+512+256,x
    lda screen_001+1000+2,x
    sta COLOR_RAM,x // And the colors
    lda screen_001+1000+2+256,x
    sta COLOR_RAM+256,x
    lda screen_001+1000+2+512,x
    sta COLOR_RAM+512,x
    lda screen_001+1000+2+512+256,x
    sta COLOR_RAM+512+256,x
    inx
    bne dpms_loop
    // Draw the Petmate Screen... END
    ////////////////////////////////////////////////
}

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


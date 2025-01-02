//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce

.macro Print(string) {
    lda #< string
    sta zp_tmp_lo
    lda #> string
    sta zp_tmp_hi 
    jsr print
}

.macro PrintPlot(x,y) {
    ldx #y
    ldy #x
    clc
    jsr KERNAL_PLOT
}

.macro PrintColor(color) {
    lda #color
    sta 646
}

.macro PrintXY(text,x,y) {
    PrintPlot(x,y)
    Print(text)
}

.macro PrintXYColor(string,x,y,color) {
    PrintPlot(x,y)
    PrintColor(color)
    Print(string)
}

.macro PrintChr(char) {
    lda #char
    jsr KERNAL_CHROUT
}

.macro PrintStrLF(string) {
    Print(string)
    PrintChr(13)
}

print:
    clc
    ldy #$00
!:
    lda (zp_tmp),y
    beq print_out
    jsr KERNAL_CHROUT
    inc zp_tmp_lo
    bne !+
    inc zp_tmp_hi
!:
    jmp !--
print_out:
    rts
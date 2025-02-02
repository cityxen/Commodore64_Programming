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

.macro PrintRainbow(string) {
    lda #< string
    sta zp_tmp_lo
    lda #> string
    sta zp_tmp_hi 
    jsr print_rainbow
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

print_rainbow:
    clc
    ldy #$00
pr1:
    lda (zp_tmp),y
    beq print_r_out
    sta print_r_t
    
    lda BACKGROUND_COLOR
    and #$0f
    cmp CURSOR_COLOR

    bne !+
    inc CURSOR_COLOR
    lda CURSOR_COLOR
    and #15
    sta CURSOR_COLOR
!:  
    lda print_r_t
    jsr KERNAL_CHROUT

    inc zp_tmp_lo
    bne !+
    inc zp_tmp_hi
!:
    inc CURSOR_COLOR
    lda CURSOR_COLOR
    and #15
    sta CURSOR_COLOR
    jmp pr1
print_r_out:
    rts
print_r_t:
.byte 0
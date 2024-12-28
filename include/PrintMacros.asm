//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY - https://linktr.ee/cityxen

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

.macro PrintString(string) {
    ldx #$00
!pstr:
    lda string,x
    beq !pstr+
    jsr KERNAL_CHROUT
    inx
    jmp !pstr-
!pstr:
}
.macro PrintHOME() {
    lda #KEY_HOME
    jsr KERNAL_CHROUT
}
.macro PrintLF() {
    lda #13
    jsr KERNAL_CHROUT
}
.macro PrintSPC() {
    lda #$20
    jsr KERNAL_CHROUT
}

.macro PrintColor(color) {
    lda #color
    sta 646
}

.macro PrintStrAtColor(x,y,string,color) {
    lda #$0
    sta 780
    lda x
    sta 781
    lda y
    sta 782
    jsr 65520
    PrintColor(color)
    PrintString(string)
}

.macro zPrint(text) {
    lda #< text
    sta zp_tmp_lo
    lda #> text
    sta zp_tmp_hi 
    
    jsr zprint
}

.macro PrintSTZ(text) {
    lda #< text
    sta zp_tmp_lo
    lda #> text
    sta zp_tmp_hi 
    jsr zprint
}


.macro PrintNZ(text) {
    lda #< text
    sta zp_tmp_lo
    lda #> text
    sta zp_tmp_hi 

    jsr nzprint
}

.macro zPrintXY(text,x,y) {
    ldx #y
    ldy #x
    clc
    jsr KERNAL_PLOT
    lda #> text
    sta zp_tmp_hi 
    lda #< text
    sta zp_tmp_lo
    jsr zprint
}

.macro PrintHex(xpos,ypos) {

    sta a_reg
    stx x_reg
    sty y_reg

    lda a_reg
    ldx #xpos
    ldy #ypos
    jsr print_hex

    ldx x_reg
    ldy y_reg
}

.macro PrintHexC(xpos,ypos,color) {

    sta a_reg
    stx x_reg
    sty y_reg

    lda #color
    sta print_hex_color

    lda a_reg
    ldx #xpos
    ldy #ypos
    jsr print_hex

    ldx x_reg
    ldy y_reg
}

.macro PrintHexI() {
    jsr print_hex_inline
}

.macro PrintHexI_Range(mem,len) {

    sta a_reg
    stx x_reg
    sty y_reg

    lda #'$'
    jsr KERNAL_CHROUT
    lda #mem
    PrintHexI()
    lda #':'
    jsr KERNAL_CHROUT

    ldx #$00
!:
    lda mem,x
    PrintHexI()
    PrintSPC()
    inx
    cpx #len
    bne !-
    
    lda a_reg
    ldx x_reg
    ldy y_reg

}

.macro ConvertA2P(string,len) {
    ldx #$00
!:
    lda string,x
    beq !+
    jsr screencode_to_kernel // ascii_to_petscii_kp
    sta string,x
    inc string,x
    inx
    cpx #len
    bne !-
!:

}

.macro StrCpy(str_from,str_to,len) {
    ldx #$00
!:
    lda str_from,x
    sta str_to,x
    inx
    cpx #len
    bne !-
}
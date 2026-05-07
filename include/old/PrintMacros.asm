//////////////////////////////////////////////////////////////////////////////////////
// CityXen - https://linktr.ee/cityxen
//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: PrintMacros
//////////////////////////////////////////////////////////////////////////////////////

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

.macro PrintLF() {
    lda #13
    jsr KERNAL_CHROUT
}

.macro PrintColor(color) {
    lda #color
    sta 646
}


.macro PrintAt(xpos,ypos,var_string) {
    ldx #$00
printatloop:
    lda var_string,x
    beq printexit
    sta SCREEN_RAM + xpos + ypos*40,x
    inx
    jmp printatloop    
printexit:
}
.macro PrintAtColor(xpos,ypos,var_string,color) {
    ldx #$00
printatloop:
    lda var_string,x
    beq printexit
    sta SCREEN_RAM + xpos + ypos*40,x
    lda #color
    sta COLOR_RAM + xpos + ypos*40,x
    inx
    jmp printatloop    
printexit:
}
.macro PrintStrAtColor(xpos,ypos,var_in_string,color) {
    jmp over_table
var_string:
    .text var_in_string; .byte 0
over_table:
    ldx #$00
printatloop:
    lda var_string,x
    beq printexit
    sta SCREEN_RAM + xpos + ypos*40,x
    lda #color
    sta COLOR_RAM + xpos + ypos*40,x
    inx
    jmp printatloop    
printexit:
}
.macro PrintAtRainbow(xpos,ypos,var_string) {
    ldy #$00
    ldx #$00
printatloop:
    lda var_string,x
    beq printexit
    sta SCREEN_RAM + xpos + ypos*40,x
    lda rainbowtable,y
    sta COLOR_RAM + xpos + ypos*40,x
    inx
    iny
    cpy #$06
    bne jmprainbowtable
    ldy #$00
jmprainbowtable:
    jmp printatloop    
printexit:
}
rainbowtable:
.byte YELLOW,GREEN,BLUE,PURPLE,RED,ORANGE

.macro PrintDecAtColor(xpos,ypos,var_num_mem,color) {
    ldx #$00
// printatloop:
    lda var_num_mem
    adc #$2f
//    beq printexit
    sta SCREEN_RAM + xpos + ypos*40,x
    lda #color
    sta COLOR_RAM + xpos + ypos*40,x
    //inx
    // jmp printatloop    
// printexit:
}
// ddl_print_num_table:
// .byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,'a','b','c','d','e','f'


.macro SetCursor(xpos,ypos) {
    ldx xpos
    stx CURSOR_X_POS
    ldy ypos
    sty CURSOR_Y_POS
    // clc
    jsr CURSOR_SET
}
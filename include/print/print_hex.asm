//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce

//////////////////////////////////////////////////////////////////

.macro PrintHexXY(x,y) {
    sta a_reg
    ldx #y
    ldy #x
    clc
    jsr KERNAL_PLOT
    lda a_reg
    jsr print_hex_inline
}

.macro PrintHex() {
    jsr print_hex_inline
}

.macro PrintHex_Range(mem,len) {

    sta a_reg
    stx x_reg
    sty y_reg

    lda #'$'
    jsr KERNAL_CHROUT
    lda #mem
    PrintHex()
    lda #':'
    jsr KERNAL_CHROUT

    ldx #$00
!:
    lda mem,x
    PrintHex()
    PrintChr($20)
    inx
    cpx #len
    bne !-
    
    lda a_reg
    ldx x_reg
    ldy y_reg

}

//////////////////////////////////////////////////////////////////
// print_hex ??

print_hex_inline_d:
.byte 1
print_hex_inline:
    sta zp_tmp

    lda print_hex_inline_d
    beq !+
    // lda #'$'
    // jsr KERNAL_CHROUT
!:
    

    lda zp_tmp
    lsr
    lsr
    lsr
    lsr
    tax
    lda print_hex_inline_conversion_table,x
    jsr KERNAL_CHROUT
    lda zp_tmp
    and #$0f
    tax
    lda print_hex_inline_conversion_table,x
    inc zp_ptr_screen_lo
    jsr KERNAL_CHROUT
    rts
print_hex_inline_conversion_table:
.byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$41,$42,$43,$44,$45,$46



print_hex: // method 2 from kevin
  pha
  lsr
  lsr
  lsr
  lsr
  jsr print_h_digit
  pla
  and #$0f
  jsr print_h_digit
  rts

print_h_digit:
  cmp #10
  bcc !+
  adc #6
!:
  adc #48
  jsr KERNAL_CHROUT
  rts


/*
//////////////////////////////////////////////////////////////////
// print_hex
//////////////////////////////////////////////////////////////////
// POKE 2 character HEX representation of 
// a byte onto the screen at x,y location
//////////////////////////////////////////////////////////////////
// usage:
// 
//      ldx #$05 
//      ldy #$06
//      lda #$15
//      jsr print_hex
//
//////////////////////////////////////////////////////////////////

print_hex_color: .byte 2
print_hex:
    sta zp_tmp
    jsr calculate_screen_pos
    lda zp_tmp
print_hex_no_calc:
    sta zp_tmp
    lsr
    lsr
    lsr
    lsr
    tax
    lda print_hex_screencode_conversion_table,x
    ldx #$00
    sta (zp_ptr_screen,x)
    lda print_hex_color
    sta (zp_ptr_color,x)
    lda zp_tmp
    and #$0f
    tax
    lda print_hex_screencode_conversion_table,x
    inc zp_ptr_screen_lo
    ldx #$00
    sta (zp_ptr_screen,x)
    inc zp_ptr_color_lo
    lda print_hex_color
    sta (zp_ptr_color,x)
    rts

print_hex_screencode_conversion_table:
.byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$01,$02,$03,$04,$05,$06
*/
/*
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
*/
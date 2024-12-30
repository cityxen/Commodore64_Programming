//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

/*
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
*/

.macro PrintSC2P(string) {
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

.macro PrintSC2PXY(string,x,y) {
    ldx #y
    ldy #x
    clc
    jsr KERNAL_PLOT
    PrintSC2P(string)
}
    
.macro Print(string) {
    lda #< string
    sta zp_tmp_lo
    lda #> string
    sta zp_tmp_hi 
    jsr zprint
}
.macro PrintStrLF(string) {
    Print(string)
    PrintLF()
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
    Print(string)
}

/*
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
*/

.macro PrintNZ(text) {
    lda #< text
    sta zp_tmp_lo
    lda #> text
    sta zp_tmp_hi 
    jsr nzprint
}

.macro PrintNSZ(text) {
    lda #< text
    sta zp_tmp_lo
    lda #> text
    sta zp_tmp_hi 
    jsr nzsprint
}

.macro PrintXY(text,x,y) {
    ldx #y
    ldy #x
    clc
    jsr KERNAL_PLOT
    Print(text)
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

/*
.macro ConvertA2P(string,len) {
    ldx #$00
!:
    lda string,x
    beq !+
    jsr screencode_to_petscii // ascii_to_petscii_kp
    sta string,x
    inc string,x
    inx
    cpx #len
    bne !-
!:
}
*/

.macro StrCpy(str_from,str_to,len) {
    ldx #$00
!:
    lda str_from,x
    sta str_to,x
    inx
    cpx #len
    bne !-
}

//////////////////////////////////////////////////////////////////
// convert ascii to petscii (from idolpx)

ascii_to_petscii:
    cmp #$41          // Compare with 'A'
    bcc !+            // If less, return
    cmp #$7F          // Compare with 'DEL'
    bcs !+            // If greater or equal, return
    sbc #$5F          // Convert 'A-Z' & 'a-z' to PETSCII
!:
    rts               // Return from subroutine

ascii_to_petscii_kp: // (kernel print)
    cmp #$41          // Compare with 'A'
    bcc !+            // If less, return
    cmp #$7F          // Compare with 'DEL'
    bcs !+            // If greater or equal, return
    sbc #$1f          // Convert 'A-Z' & 'a-z' to PETSCII
!:
    rts               // Return from subroutine

//////////////////////////////////////////////////////////////////
// convert screencode to petscii

screencode_to_petscii:

    cmp #32
    bcc sc2p_add64
    cmp #64
    bcc sc2p_add0
    cmp #96
    bcc sc2p_add128
    cmp #128
    bcc sc2p_add64
    cmp #160
    bcc sc2p_sub128
    cmp #224
    bcc sc2p_sub64
    cmp #254
    bcc sc2p_add0
    rts

sc2p_sub128:
    sec
    sbc #64
sc2p_sub64:
    sec
    sbc #64
    rts
sc2p_add128:
    clc
    adc #64
sc2p_add64:
    clc
    adc #64
sc2p_add0:
    rts


//////////////////////////////////////////////////////////////////
// print_hex ??

print_hex_inline:
    sta zp_tmp
    lda #'$'
    jsr KERNAL_CHROUT
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

//////////////////////////////////////////////////////////////////
// calculate_screen_pos
//////////////////////////////////////////////////////////////////
// Calculate screen position based on x and y registers
//////////////////////////////////////////////////////////////////
// Usage:
// 
//      ldx #$05
//      ldy #$10
//      jsr calculate_screen_pos
//
//////////////////////////////////////////////////////////////////
// Result: Stores screen location in zp_ptr_screen
//////////////////////////////////////////////////////////////////

calculate_screen_pos: // x = xpos y = ypos
    lda #<SCREEN_RAM    // enter screen pos into zp
    sta zp_ptr_screen_lo
    lda #>SCREEN_RAM
    sta zp_ptr_screen_hi
    lda #<COLOR_RAM
    sta zp_ptr_color_lo
    lda #>COLOR_RAM
    sta zp_ptr_color_hi

    cpx #$00 // add x pos to screen pos
!csp_lp:
    beq !csp_lp+
    inc zp_ptr_screen_lo
    inc zp_ptr_color_lo
    bne !csp_lp_i+
    inc zp_ptr_screen_hi
    inc zp_ptr_color_hi
!csp_lp_i:
    dex
    jmp !csp_lp-
!csp_lp:
    cpy #$00 // add y pos to screen pos
!csp_lp:
    beq !csp_lp+
    lda zp_ptr_color_lo
    clc
    adc #$28
    sta zp_ptr_color_lo    
    lda zp_ptr_screen_lo
    clc
    adc #$28
    sta zp_ptr_screen_lo
    bcc !csp_lp_i+
    inc zp_ptr_screen_hi
    inc zp_ptr_color_hi
!csp_lp_i:
    dey
    jmp !csp_lp-
!csp_lp:
    rts

increment_screen_pos:
    inc zp_ptr_screen_lo
    bne !isp_exit+
    inc zp_ptr_screen_hi
!isp_exit:
    rts

addto_screen_pos:
    lda zp_ptr_screen_lo
    clc
    adc #$28
    sta zp_ptr_screen_lo
    bcc !asp_exit+
    inc zp_ptr_screen_hi
!asp_exit:
    rts

//////////////////////////////////////////////////////////////////
// calculate_color_pos
//////////////////////////////////////////////////////////////////
// Calculate color position based on x and y registers
//////////////////////////////////////////////////////////////////
// Usage:
// 
//      ldx #$05
//      ldy #$10
//      jsr calculate_color_pos
//
//////////////////////////////////////////////////////////////////
// Result: Stores color location in zp_ptr_color
//////////////////////////////////////////////////////////////////

calculate_color_pos: // x = xpos y = ypos
    lda #<COLOR_RAM    // enter color pos into zp
    sta zp_ptr_color_lo
    lda #>COLOR_RAM
    sta zp_ptr_color_hi
    cpx #$00 // add x pos to color pos
!ccp_lp:
    beq !ccp_lp+
    inc zp_ptr_color_lo
    bne !ccp_lp_i+
    inc zp_ptr_color_hi
!ccp_lp_i:
    dex
    jmp !ccp_lp-
!ccp_lp:
    cpy #$00 // add y pos to color pos
!ccp_lp:
    beq !ccp_lp+
    lda zp_ptr_color_lo
    clc
    adc #$28
    sta zp_ptr_color_lo
    bcc !ccp_lp_i+
    inc zp_ptr_color_hi
!ccp_lp_i:
    dey
    jmp !ccp_lp-
!ccp_lp:
    rts

increment_color_pos:
    inc zp_ptr_color_lo
    bne !icp_exit+
    inc zp_ptr_color_hi
!icp_exit:
    rts

addto_color_pos:
    lda zp_ptr_color_lo
    clc
    adc #$28
    sta zp_ptr_color_lo
    bcc !acp_exit+
    inc zp_ptr_color_hi
!acp_exit:
    rts

//////////////////////////////////////////////////////////////////
// reusable string buffer data

//strbuf:.fill 256,0buf_crsr: .byte 0

zprint:
    clc
    ldx #$00
!zp:
    lda (zp_tmp,x)
    beq !zp+
    jsr $ffd2
    inc zp_tmp_lo
    bne !+
    inc zp_tmp_hi
!:
    jmp !zp-
!zp:
    rts

nzprint: // print without leading zero pad

    clc

    lda #$00
    sta zpnzp_c

nzp1:
!wl:
    ldy #$00
    lda (zp_tmp),y
    bne !wl+
    lda zpnzp_c
    bne !+
    lda #$30
    jsr $ffd2
!:
    rts
!wl:
    tax
    cpx #$30
    bne wlz

    iny
    clc
    lda (zp_tmp),y
    beq wlz

    lda zpnzp_c
    bne wlz
    jmp wlyz

wlz:
    txa
    jsr $ffd2
    inc zpnzp_c
wlyz:
    inc zp_tmp_lo
    bne !+
    inc zp_tmp_hi
!:
    jmp nzp1


nzsprint: // print leading zero pads as spaces

    clc

    lda #$00
    sta zpnzp_c

nzsp1:
!wl:
    ldy #$00
    lda (zp_tmp),y
    bne !wl+
    lda zpnzp_c
    bne !+
    lda #$30
    jsr $ffd2
!:
    rts
!wl:
    tax
    cpx #$30
    bne wlsz

    iny
    clc
    lda (zp_tmp),y
    beq wlsz

    lda zpnzp_c
    bne wlsz
    lda #$20
    jsr $ffd2
    jmp wlysz

wlsz:
    txa
    jsr $ffd2
    inc zpnzp_c
wlysz:
    inc zp_tmp_lo
    bne !+
    inc zp_tmp_hi
!:
    jmp nzsp1


zpnzp_c: .byte 0

//////////////////////////////////////////////////////////////////
// zero string buffer

// zero_strbuf:
//    lda #$00
//    ldx #$00
//!lp:
//    sta strbuf,x
//    inx
//    bne !lp-
//    stx buf_crsr
//    rts

//////////////////////////////////////////////////////////////////
// zero string buffer



// p_str_cpy:     rts
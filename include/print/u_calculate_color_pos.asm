
//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
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
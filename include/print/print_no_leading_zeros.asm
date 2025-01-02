//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce

.macro PrintNoLeadingZeros(text) {
    lda #< text
    sta zp_tmp_lo
    lda #> text
    sta zp_tmp_hi 
    jsr print_no_leading_zeros
}
 
//////////////////////////////////////////////////////////////////
// print without leading zero pad

print_no_leading_zeros:

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

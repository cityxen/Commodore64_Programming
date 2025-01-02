//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce

.macro PrintLeadingZerosAsSpaces(text) {
    lda #< text
    sta zp_tmp_lo
    lda #> text
    sta zp_tmp_hi 
    jsr print_leading_zeros_as_spaces
}

//////////////////////////////////////////////////////////////////
// print leading zero pads as spaces

print_leading_zeros_as_spaces:

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
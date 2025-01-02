//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce


.macro StrScreenCodeToPetscii(string,len) {
    ldx #$00
!:
    lda string,x
    jsr screencode_to_petscii
    sta string,x
    inx
    cpx #len
    bne !-
}

//////////////////////////////////////////////////////////////////
// convert screencode to petscii

screencode_to_petscii:
    beq !+
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
!:
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

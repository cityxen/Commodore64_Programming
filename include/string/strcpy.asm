//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce

.macro StrCpyL(str_from,str_to,len) {
    ldx #$00
!:
    lda str_from,x
    sta str_to,x
    inx
    cpx #len
    bne !-
}

.macro StrCpy(str_from,str_to) {
    lda #< str_from
    sta zp_tmp_lo
    lda #> str_from
    sta zp_tmp_hi

    lda #< str_to
    sta zp_tmp2_lo
    lda #> str_to
    sta zp_tmp2_hi

    jsr string_copy
}

string_copy:
    clc
    ldy #$00
string_copy_1:
    lda (zp_tmp),y
    sta (zp_tmp2),y
    beq string_copy_2
    inc zp_tmp_lo
    bne !+
    inc zp_tmp_hi
!:
    inc zp_tmp2_lo
    bne !+
    inc zp_tmp2_hi
!:
    jmp string_copy_1
string_copy_2:
    rts
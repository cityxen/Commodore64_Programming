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
    sta zp_string_lo
    lda #> str_from
    sta zp_string_hi

    lda #< str_to
    sta zp_str2_lo
    lda #> str_to
    sta zp_str2_hi

    jsr string_copy
}

string_copy:
    clc
    ldy #$00
string_copy_1:
    lda (zp_string),y
    sta (zp_str2),y
    beq string_copy_2
    inc zp_string_lo
    bne !+
    inc zp_string_hi
!:
    inc zp_str2_lo
    bne !+
    inc zp_str2_hi
!:
    jmp string_copy_1
string_copy_2:
    rts
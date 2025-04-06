

str_len:
.byte 0

.macro StrLen(instring) {
    ldx #$ff
    stx str_len
!:
    inx
    lda instring,x
    bne !-
    stx str_len
}

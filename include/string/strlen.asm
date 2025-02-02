

str_len:
.byte 0

.macro StrLen(string) {
    ldx #$00
    stx str_len
!:
    lda string,x
    inx
    bne !-
    stx str_len
}
// ------------------------------------------------------------
// PrintDecimal
// Prints unsigned 16-bit integer in numHi:numLo
// Range: 0-65535
// ------------------------------------------------------------

.const numLo   = $fb
.const numHi   = $fc
.const digit   = $fd
.const started = $fe
.const tempLo  = $ff

print_decimal:
    lda #0
    sta started
    ldx #0

nextDivisor:
    lda #0
    sta digit

subtractLoop:
    lda numLo
    sec
    sbc divLo,x
    sta tempLo

    lda numHi
    sbc divHi,x
    bcc printThisDigit

    sta numHi
    lda tempLo
    sta numLo

    inc digit
    jmp subtractLoop

printThisDigit:
    lda digit
    bne printDigit

    lda started
    bne printDigit

    cpx #4
    bne skipDigit

printDigit:
    lda #1
    sta started

    lda digit
    clc
    adc #$30
    jsr KERNAL_CHROUT

skipDigit:
    inx
    cpx #5
    bne nextDivisor
    rts

divLo: .byte <10000, <1000, <100, <10, <1
divHi: .byte >10000, >1000, >100, >10, >1
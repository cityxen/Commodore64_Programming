
install_irq_timer:
    sei

    lda #%01010010
    sta $dc0f

    lda #$03
    sta $dc04
    lda #$fc
    sta $dc05

    lda #$ff
    sta $dc06
    sta $dc07

    lda #<timer
    sta $0314
    lda #>timer
    sta $0315

    lda #%00010001
    sta $dc0e

    cli
    rts


timer:
    inc $0410
    lda #%01111111
    sta $dc0d
    lda $dc0d
    jmp $ea31

/*
    ldx #0
!loop:
    lda #1
    sta $d800,x
    lda $dc04,x
    sta $0422,x
    clc
    inx
    cpx #4
    bne !loop-
    */



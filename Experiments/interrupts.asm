
*=$0801 "BASIC UPSTART"
    BasicUpstart($080d)
*=$080d "MAIN Program"


init:
    sei                  // set interrupt bit, make the cpu ignore interrupt requests
    lda #%01111111       // switch off interrupt signals from cia-1
    sta $dc0d

    and $d011            // clear most significant bit of vic's raster register
    sta $d011

    lda $dc0d            // acknowledge pending interrupts from cia-1
    lda $dd0d            // acknowledge pending interrupts from cia-2

    lda #210             // set rasterline where interrupt shall occur
    sta $d012

    lda #<irq            // set interrupt vectors, pointing to interrupt service routine below
    sta $0314
    lda #>irq
    sta $0315

    lda #%00000001       // enable raster interrupt signals from vic
    sta $d01a

    cli                  // clear interrupt flag, allowing the cpu to respond to interrupt requests
    rts

irq:
    lda #$7
    sta $d020            // change border colour to yellow

    ldx #$9             // empty loop to do nothing for just under half a millisecond
!pause:
    dex
    bne !pause-

    lda #$6
    sta $d020            // change border colour to yellow

    ldx #$9             // empty loop to do nothing for just under half a millisecond
!pause:
    dex
    bne !pause-

    lda #$5
    sta $d020            // change border colour to yellow

    ldx #$9             // empty loop to do nothing for just under half a millisecond
!pause:
    dex
    bne !pause-

    lda #$0
    sta $d020            // change border colour to black

    asl $d019            // acknowledge the interrupt by clearing the vic's interrupt flag

    jmp $ea31            // jump into kernal's standard interrupt service routine to handle keyboard scan, cursor display etc.
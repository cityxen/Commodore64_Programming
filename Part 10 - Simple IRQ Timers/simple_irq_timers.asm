//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 10
// Simple Interrupt Request Timers
// by Deadline
// 

*=$0801
BasicUpstart($0810)
*=$0810

start:

    jsr reset_timers

    sei
    lda #<irq_timers
    sta $0314
    lda #>irq_timers
    sta $0315
    cli

    lda #$00
    sta $d020
    sta $d021 // clear background black
    lda #$93 // clear character
    jsr $ffd2

main:

    lda irq_timer_trig1 // check to see if trigger 1 is set
    beq !ml+
    inc $0400 // increment first screen mem loc
    lda #$00
    sta irq_timer_trig1
    sta irq_timer1

!ml:

    lda irq_timer_trig2 // check to see if trigger 2 is set
    beq !ml+
    inc $0401 // increment second screen mem loc
    lda #$00
    sta irq_timer_trig2
    sta irq_timer2

!ml:

    jmp main

reset_timers:
    lda #$00
    sta irq_timer1
    sta irq_timer2
    sta irq_timer_trig1
    sta irq_timer_trig2
    rts

irq_timers:

    inc irq_timer1
    inc irq_timer2

    lda irq_timer1
    cmp #60 // 1 second
    bne !it+
    inc irq_timer_trig1
    lda #$00
    sta irq_timer1
    
!it:

    lda irq_timer2
    cmp #120 // 2 second
    bne !it+
    inc irq_timer_trig2
    lda #$00
    sta irq_timer2
    
!it:

    jmp $ea31

// var space
irq_timer1:
.byte 0
irq_timer2:
.byte 0
irq_timer_trig1:
.byte 0
irq_timer_trig2:
.byte 0

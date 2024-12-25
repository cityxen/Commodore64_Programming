//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY - https://linktr.ee/cityxen
// IRQ TIMERS INLINE LIBRARY -> put in config.asm

.macro InitTimersDefault() {
	lda #60 // 1 sec
	sta irq_timer1_to
	lda #120 // 2 sec
	sta irq_timer2_to
	lda #180 // 3 sec
	sta irq_timer3_to
	lda #240 // 4 sec
	sta irq_timer4_to
	lda #300 // 5 sec
	sta irq_timer5_to
	jsr init_timers
}
.macro InitTimers(t1,t2,t3,t4,t5) {
	lda #t1
	sta irq_timer1_to
	lda #t2
	sta irq_timer2_to
	lda #t3
	sta irq_timer3_to
	lda #t4
	sta irq_timer4_to
	lda #t5
	sta irq_timer5_to
	jsr init_timers
}

irq_timer1: 	.byte 0
irq_timer2:     .byte 0
irq_timer3:     .byte 0
irq_timer4:     .byte 0
irq_timer5:     .byte 0
irq_timer1_to:  .byte 0
irq_timer2_to:  .byte 0
irq_timer3_to:  .byte 0
irq_timer4_to:  .byte 0
irq_timer5_to:  .byte 0
irq_timer1_tr:  .byte 0
irq_timer2_tr:  .byte 0
irq_timer3_tr:  .byte 0
irq_timer4_tr:  .byte 0
irq_timer5_tr:  .byte 0


init_timers:
	sei
	lda #<irq_timers
	sta $0314
	lda #>irq_timers
	sta $0315
	cli
	rts
	

irq_timers:
	inc irq_timer1
	inc irq_timer2
	inc irq_timer3
	inc irq_timer4
	inc irq_timer5

	lda irq_timer1
	cmp irq_timer1_to
	bne !+
	inc irq_timer1_tr
	lda #$00
	sta irq_timer1

!:
	lda irq_timer2
	cmp irq_timer2_to
	bne !+
	inc irq_timer2_tr
	lda #$00
	sta irq_timer2

!:
	lda irq_timer3
	cmp irq_timer3_to
	bne !+
	inc irq_timer3_tr
	lda #$00
	sta irq_timer3

!:
	lda irq_timer4
	cmp irq_timer4_to
	bne !+
	inc irq_timer4_tr
	lda #$00
	sta irq_timer4

!:
	lda irq_timer5
	cmp irq_timer5_to
	bne !+
	inc irq_timer5_tr
	lda #$00
	sta irq_timer5
!:
	jmp $ea31


pause1:
	jsr reset_timer1
!:
	lda irq_timer1_tr
	beq !-
	jsr reset_timer1
	rts

pause2:
	jsr reset_timer2
!:
	lda irq_timer2_tr
	beq !-
	jsr reset_timer2
	rts

pause3:
	jsr reset_timer3
!:
	lda irq_timer3_tr
	beq !-
	jsr reset_timer3
	rts

pause4:
	jsr reset_timer4
!:
	lda irq_timer4_tr
	beq !-
	jsr reset_timer4
	rts

pause5:
	jsr reset_timer5
!:
	lda irq_timer5_tr
	beq !-
	jsr reset_timer5
	rts


reset_timer1:
	lda #$00
	sta irq_timer1
	sta irq_timer1_tr
	rts

reset_timer2:
	lda #$00
	sta irq_timer2
	sta irq_timer2_tr
	rts

reset_timer3:
	lda #$00
	sta irq_timer3
	sta irq_timer3_tr
	rts

reset_timer4:
	lda #$00
	sta irq_timer4
	sta irq_timer4_tr
	rts

reset_timer5:
	lda #$00
	sta irq_timer5
	sta irq_timer5_tr
	rts

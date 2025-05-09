//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

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

////////////////////////////////
irq_timer1: 	      .byte 0 // timers
irq_timer2:           .byte 0
irq_timer3:           .byte 0
irq_timer4:           .byte 0
irq_timer5:           .byte 0
irq_timer_input:      .byte 0
irq_timer_jitter:     .byte 0
irq_timer_sound:      .byte 0
irq_timer_joystick:   .byte 0
////////////////////////////////
irq_timer1_to:        .byte 0 // timeouts
irq_timer2_to:        .byte 0
irq_timer3_to:        .byte 0
irq_timer4_to:        .byte 0
irq_timer5_to:        .byte 0
irq_timer_input_to:   .byte 0
irq_timer_jitter_to:  .byte 0
irq_timer_sound_to:   .byte 0
irq_timer_joystick_to:.byte 0
////////////////////////////////
irq_timer1_tr:        .byte 0 // triggers
irq_timer2_tr:        .byte 0
irq_timer3_tr:        .byte 0
irq_timer4_tr:        .byte 0
irq_timer5_tr:        .byte 0
irq_timer_input_tr:   .byte 0
irq_timer_jitter_tr:  .byte 0
irq_timer_sound_tr:   .byte 0
irq_timer_joystick_tr:.byte 0

init_timers:
	sei
	lda #<irq_timers
	sta $0314
	lda #>irq_timers
	sta $0315
	cli
	rts
	

irq_timers:

#if CONFIG_MUSIC
	lda play_music
	beq !it+
	jsr music.play
	jmp !it++
#endif
!it:

#if CONFIG_SFXKIT
	jsr $c028 // sound fx kit
#endif
!it:

	inc irq_timer1
	inc irq_timer2
	inc irq_timer3
	inc irq_timer4
	inc irq_timer5
	inc irq_timer_input
	inc irq_timer_jitter
	inc irq_timer_joystick
	inc irq_timer_sound

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

	lda irq_timer_sound
	cmp irq_timer_sound_to
	bne !+
	inc irq_timer_sound_tr
	lda #$00
	sta irq_timer_sound

!:	

	lda irq_timer_joystick
	cmp irq_timer_joystick_to
	bne !+
	inc irq_timer_joystick_tr
	lda #$00
	sta irq_timer_joystick

!:	

	lda irq_timer_jitter
	cmp irq_timer_jitter_to
	bne !+
	inc irq_timer_jitter_tr
	lda #$00
	sta irq_timer_jitter

!:

	lda irq_timer_input
	cmp irq_timer_input_to
	bne !+
	inc irq_timer_input_tr
	lda #$00
	sta irq_timer_input

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

reset_input_timer:
	lda #$00
	sta irq_timer_input
	sta irq_timer_input_tr
	sta $C6 // clear buffer
	jsr KERNAL_GETIN
	rts

reset_jitter_timer:
	lda #$00
	sta irq_timer_jitter_tr
	sta irq_timer_jitter
	rts

reset_sound_timer:
	lda #$00
	sta irq_timer_sound_tr
	sta irq_timer_sound
	rts

reset_joystick_timer:
	lda #$00
	sta irq_timer_joystick_tr
	sta irq_timer_joystick
	rts

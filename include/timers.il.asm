//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

.macro ResetTimers() {
	.for (var i = 0; i < 16; i++) {
		ResetTimer(i)
	!:
	}
}

.macro ResetTimer(t) {
	lda #$00
	ldx #t
	sta irq_timer_table,x
	// ta irq_timer_tr_table,x
}

.macro SetTimerTo(t) {
	ldx #t
	sta irq_timer_to_table,x
}
.macro SetTimer(t){
	ldx #t
	sta irq_timer_table,x
}

.macro GetTimer(t){
	ldx #t
	lda irq_timer_table,x
}

.macro SetTimerTr(t){
	ldx #t
	sta irq_timer_tr_table,x
}

.macro GetTimerTr(t){
	ldx #t
	lda irq_timer_tr_table,x
}

.macro IfTimerSub(t,subroutine) {
	GetTimerTr(t)
	beq !+
	lda #$00
	SetTimer(t)
	SetTimerTr(t)
	jsr subroutine
!:
}

.macro IfTimerSubJmp(t,subroutine,routine) {
	GetTimerTr(t)
	beq !+
	lda #$00
	SetTimer(t)
	SetTimerTr(t)
	jsr subroutine
	jmp routine
!:
}

.macro IfTimerJmp(t,routine) {
	GetTimerTr(t)
	beq !+
	lda #$00
	SetTimer(t)
	SetTimerTr(t)
	jmp routine
!:
}

.macro InitTimersDefault() {
	lda #60 		// 1 sec
	SetTimerTo(0)
	lda #120 		// 2 sec
	SetTimerTo(1)
	lda #180 		// 3 sec
	SetTimerTo(2)
	lda #240 		// 4 sec
	SetTimerTo(3)
	lda #250 		// 5 sec
	SetTimerTo(4)
	jsr init_timers
}
.macro InitTimers(t1,t2,t3,t4,t5,t6) {
	lda #t1
	SetTimerTo(0)
	lda #t2
	SetTimerTo(1)
	lda #t3
	SetTimerTo(2)
	lda #t4
	SetTimerTo(3)
	lda #t5
	SetTimerTo(4)
	lda #t6
	SetTimerTo(5)
	jsr init_timers
}

irq_timer_table:
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // 16 timers
irq_timer_to_table:
.byte 10,25,30,60,120,200,50,55,60,65,70,75,100,110,150,20 // timer timeouts
irq_timer_tr_table:
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // timer triggers

init_timers:
	sei
	lda #<irq_timers
	sta $0314
	lda #>irq_timers
	sta $0315
	cli
	ResetTimers()
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
	jsr sfx_irq_hook // sound fx kit
#endif
!it:

	ldx #$00
!:
	lda irq_timer_table,x
	adc #$01
	sta irq_timer_table,x
	inx
	cpx #16
	bne !-

.for (var i = 0; i < 16; i++) {
	GetTimer(i)
	sta zp_timers
	lda irq_timer_to_table,x
	clc
	cmp zp_timers
	bcs !+
	lda #$00
	SetTimer(i)
	GetTimerTr(i)
	sta zp_timers
	inc zp_timers
	lda zp_timers
	SetTimerTr(i)
	ResetTimer(i)
!:
}
	jmp $ea31

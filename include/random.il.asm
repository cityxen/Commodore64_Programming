//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

//////////////////////////////////////////////////////////////
// Random number stuff

random_num:             .byte 0

random_init_sid:
    // Set up sid to produce random values
    lda #$FF  // maximum frequency value
    sta $D40E // voice 3 frequency low byte
    sta $D40F // voice 3 frequency high byte
    lda #$80  // noise waveform, gate bit off
    sta $D412 // voice 3 control register
    rts

lda_random_sid:
    lda $d41b // lda with random number
    sta random_num
    rts

lda_random_kern:
    jsr $E097
	lda $8f
    sta random_num
    rts

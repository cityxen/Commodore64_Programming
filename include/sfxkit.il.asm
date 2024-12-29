//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

//////////////////////////////////////////////////////////////////
// SOUND FX KIT STUFF

#define CONFIG_SFXKIT

.macro FixSFXKit(loc) {
    lda #$3a
    sta loc+$0128
    sta loc+$0129
    sta loc+$012a
}

.const SFK_VOICE_1 = $02a7
.const SFK_VOICE_2 = $02a8
.const SFK_VOICE_3 = $02a9

.macro sfk_v1_play(sfx) {
    lda #sfx
    sta SFK_VOICE_1
}

.macro sfk_v2_play(sfx) {
    lda #sfx
    sta SFK_VOICE_2
}

.macro sfk_v3_play(sfx) {
    lda #sfx
    sta SFK_VOICE_3
}

sfk_sound_on:
	jsr $c000
	rts

sfk_sound_off:
	jsr $c010
	rts

sfk_clear:
	jsr $c1f9
	rts

play_sound_ding:
	// jsr sfk_clear
	lda #$02
	sta $02a7
	rts	
play_sound_get_ready:
	// jsr sfk_clear
	lda #$01
	sta $02a8
	rts

play_sound_wrong:
	// jsr sfk_clear
	lda #$04
	sta $02a7
	rts

play_sound_pow:
	// jsr sfk_clear
	lda #$05
	sta $02a9
	rts

play_sound_miss:
	// jsr sfk_clear
	lda #$06
	sta $02a8
	rts

play_sound_gameover:
	// jsr sfk_clear
	lda #$07
	sta $02a7
	rts

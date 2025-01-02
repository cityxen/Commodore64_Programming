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

.macro sfx_v1_play(sfx) {
    lda #sfx
    sta SFK_VOICE_1
}

.macro sfx_v2_play(sfx) {
    lda #sfx
    sta SFK_VOICE_2
}

.macro sfx_v3_play(sfx) {
    lda #sfx
    sta SFK_VOICE_3
}

sfx_sound_on:
	jsr $c000
	rts

sfx_sound_off:
	jsr $c010
	rts

sfx_clear:
	jsr $c1f9
	rts

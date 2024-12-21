////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SFX KIT SOUND STUFF

// FX PLAYER ON    : sys 49152 : jsr $c000 // sound_on sr
// FX PLAYER OFF   : sys 49168 : jsr $c010 // sound_off sr
// CLEAR REGISTERS : sys 49657 : jsr $c1f9 // clear sr
// IRQ CONTROL     :           : jsr $c028 // add into irq

.const SFK_VOICE_1 = $02a7
.const SFK_VOICE_2 = $02a8
.const SFK_VOICE_3 = $02a9


sfk_sound_on: // add irq routine
	jsr $c000
	rts

sfk_sound_off:
	jsr $c010 // turn off the irq routine
	rts

sfk_clear: 	 
	jsr $c1f9 // stop playing all sfx
	rts


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
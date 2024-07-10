//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 13
// Sound Effects using Sound FX Kit
// by Deadline

#import "../include/Constants.asm"

*=$c000 "SFX KIT"
.import binary "sfxwdp.prg", 2

// FX PLAYER ON    : sys 49152 : jsr $c000 // sound_on sr
// FX PLAYER OFF   : sys 49168 : jsr $c010 // sound_off sr
// CLEAR REGISTERS : sys 49657 : jsr $c1f9 // clear sr
// IRQ CONTROL     :           : jsr $c028 // add into irq

*=$0801
BasicUpstart($0810)
*=$0810

start:
    jsr $c000

main: // main loop

    jsr KERNAL_GETIN
    cmp #KEY_1
    bne !m+
    lda #$01
    sta $02a7
!m:
cmp #KEY_2
    bne !m+
    lda #$02
    sta $02a7
!m:
cmp #KEY_3
    bne !m+
    lda #$03
    sta $02a7
!m:
cmp #KEY_4
    bne !m+
    lda #$04
    sta $02a7
!m:
cmp #KEY_5
    bne !m+
    lda #$05
    sta $02a7
!m:
cmp #KEY_6
    bne !m+
    lda #$06
    sta $02a7
!m:
    jmp main

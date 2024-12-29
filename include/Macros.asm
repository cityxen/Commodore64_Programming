//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

//////////////////////////////////////////////////////////////////
// 
// Notes:
//  - Must include Constants.asm before include Macros.asm
//  - These macros are intended for one time use only, each time you add macro
//      it increases size of prg. Therefore use sparingly. If you need something
//      that does these over and over, consider making an actual routine that you
//      can jsr to.
// 
//////////////////////////////////////////////////////////////////

#import "Constants.asm"

.macro ClearScreen(color) {
    lda #$93
    jsr KERNAL_CHROUT    // $FFD2
    lda #color
    sta BACKGROUND_COLOR // $D020
    sta BORDER_COLOR     // $D021
}

.macro ClearScreenB(color,bcolor) {
    lda #$93
    jsr KERNAL_CHROUT    // $FFD2
    lda #color
    sta BACKGROUND_COLOR // $D020
    lda #bcolor
    sta BORDER_COLOR     // $D021
    sta 646
}

.macro ClearScreenColors(color,bcolor) {
    ClearScreen(color)
    ldx #$00
    lda bcolor
!loop:    
    sta COLOR_RAM,x
    sta COLOR_RAM+256,x
    sta COLOR_RAM+512,x
    sta COLOR_RAM+512+256,x
    inx
    cpx #$006
    bne !loop-
}

.macro SetCharacters(value) {
    lda VIC_MEM_POINTERS // point to the new characters
    .var p=value/$400
    ora #p
    sta VIC_MEM_POINTERS
}

.macro PokeString(loc,string_loc) {
    ldx #$00
!loop:
    lda string_loc,x
    beq !loop+
    sta loc,x
    inx
    jmp !loop-
!loop:
}

.macro PokeStringColor(loc,string_loc,color) {
    .var color_ram=COLOR_RAM
!loop:
    .var color_loc=COLOR_RAM
    .var rainbow=false
    .if(color!="RAINBOW") {
        .eval color_loc=color_ram+(loc-1024)
    }
    .if(color=="RAINBOW") {
        .eval color=BLACK
        .eval color_loc=color_ram+(loc-1024)
        .eval rainbow=true
    }
    lda #color
    sta color_lbl
    ldx #$00
!loop:
    .if(rainbow==true) inc color_lbl
    lda string_loc,x
    beq !loop+
    sta loc,x
    lda color_lbl
    sta color_loc,x
    inx
    jmp !loop-
!loop:
    jmp !loop+
color_lbl:
    nop
!loop:
}

.macro ReadKeyJSR(x,sbr) {
!check_key:
    cmp #x
    bne !check_key+
    jsr sbr
!check_key:
}

.macro ReadKeyJMP(x,sbr) {
!check_key:
    cmp #x
    bne !check_key+
    jmp sbr
!check_key:
}

.macro ReadJoyJSR(joy,dir,sbr) {
    lda #joy
    cmp #$01
    beq !check_joy+
    lda $DC00
    jmp !check_joy++
!check_joy:
    lda $DC01
!check_joy:
    .if (dir=="UP")    .eval dir=1
    .if (dir=="DOWN")  .eval dir=2
    .if (dir=="LEFT")  .eval dir=4
    .if (dir=="RIGHT") .eval dir=8
    .if (dir=="FIRE")  .eval dir=16
    and #dir
    bne !check_joy+
    jsr sbr
!check_joy:
}

.macro ReadJoyJMP(joy,dir,sbr) {
    lda #joy
    cmp #$01
    beq !check_joy+
    lda $DC00
    jmp !check_joy++
!check_joy:
    lda $DC01
!check_joy:
    .if (dir=="UP")    .eval dir=1
    .if (dir=="DOWN")  .eval dir=2
    .if (dir=="LEFT")  .eval dir=4
    .if (dir=="RIGHT") .eval dir=8
    .if (dir=="FIRE")  .eval dir=16
    and #dir
    bne !check_joy+
    jmp sbr
!check_joy:
}

.macro CityXenUpstart(start) {
    
// .segment Main [allowOverlap]
* = $0801 "BASIC Upstart"
.word usend // link address
.word 2025  // line num (Current Year)
.byte $9e   // sys
.text toIntString(start) // This is start label in main program
.text ":"
.byte $80 // end
.text ":"
.byte KEY_DELETE,KEY_DELETE,KEY_DELETE,KEY_DELETE
.byte KEY_DELETE,KEY_DELETE,KEY_DELETE,KEY_DELETE
.byte KEY_DELETE,KEY_DELETE,KEY_DELETE,KEY_DELETE
.byte KEY_DELETE
.text " -=*(CITYXEN)*=-"
usend:
.byte 0
.word 0  // empty link signals the end of the program
// THIS CODE IS FROM $0801 - $082C
// The * directive below puts the code to $0830
// well clear of any allowOverlap
// If you modify this to change the BASIC Upstart
// and add more characters keep this in mind
* = $0830 "vars and lib init"

}

.macro zp_str(x) {
    lda #<x
    sta zp_tmp_lo
    lda #>x
	sta zp_tmp_hi
}

//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

.macro DrawPetMateScreen(screen_name) {
    ////////////////////////////////////////////////
    // Draw the Petmate Screen... START
    lda screen_name
    sta BORDER_COLOR
    lda screen_name+1
    sta BACKGROUND_COLOR
    ldx #$00 // Draw the screen from memory location
!dpms_loop:
    lda screen_name+2,x // Petmate screen (+2 is to skip over background/border color)
    sta 1024,x
    lda screen_name+2+256,x
    sta 1024+256,x
    lda screen_name+2+512,x
    sta 1024+512,x
    lda screen_name+1000+2,x
    sta COLOR_RAM,x // And now the colors
    lda screen_name+1000+2+256,x
    sta COLOR_RAM+256,x
    lda screen_name+1000+2+512,x
    sta COLOR_RAM+512,x
    inx
    bne !dpms_loop-
    ldx #232
!dpms_loop: // fix overwriting sprite pointers loop
    dex
    lda screen_name+2+512+256,x
    sta 1024+512+256,x
    lda screen_name+1000+2+512+256,x
    sta COLOR_RAM+512+256,x
    cpx #$00
    bne !dpms_loop-
    // Draw the Petmate Screen... END
    ////////////////////////////////////////////////
}
//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

.const PETMATE_PTR = $fb

.const SRC0 = $02
.const SRC1 = $04
.const SRC2 = $06
.const SRC3 = $08
.const SRC4 = $0a
.const SRC5 = $0c
.const SRC6 = $0e
.const SRC7 = $10

.macro DrawPetMateScreen(screen_name) {
    lda #<screen_name
    sta PETMATE_PTR
    lda #>screen_name
    sta PETMATE_PTR+1
    jsr draw_petmate_screen
}

draw_petmate_screen:
    ldy #$00

    lda (PETMATE_PTR),y
    sta BORDER_COLOR

    iny
    lda (PETMATE_PTR),y
    sta BACKGROUND_COLOR

    // screen_name + 2
    lda PETMATE_PTR
    clc
    adc #<2
    sta SRC0
    lda PETMATE_PTR+1
    adc #>2
    sta SRC0+1

    // screen_name + 258
    lda PETMATE_PTR
    clc
    adc #<258
    sta SRC1
    lda PETMATE_PTR+1
    adc #>258
    sta SRC1+1

    // screen_name + 514
    lda PETMATE_PTR
    clc
    adc #<514
    sta SRC2
    lda PETMATE_PTR+1
    adc #>514
    sta SRC2+1

    // screen_name + 1002
    lda PETMATE_PTR
    clc
    adc #<1002
    sta SRC3
    lda PETMATE_PTR+1
    adc #>1002
    sta SRC3+1

    // screen_name + 1258
    lda PETMATE_PTR
    clc
    adc #<1258
    sta SRC4
    lda PETMATE_PTR+1
    adc #>1258
    sta SRC4+1

    // screen_name + 1514
    lda PETMATE_PTR
    clc
    adc #<1514
    sta SRC5
    lda PETMATE_PTR+1
    adc #>1514
    sta SRC5+1

    // screen_name + 770
    lda PETMATE_PTR
    clc
    adc #<770
    sta SRC6
    lda PETMATE_PTR+1
    adc #>770
    sta SRC6+1

    // screen_name + 1770
    lda PETMATE_PTR
    clc
    adc #<1770
    sta SRC7
    lda PETMATE_PTR+1
    adc #>1770
    sta SRC7+1

    ldy #$00

dpms_loop:
    lda (SRC0),y
    sta 1024,y

    lda (SRC1),y
    sta 1024+256,y

    lda (SRC2),y
    sta 1024+512,y

    lda (SRC3),y
    sta COLOR_RAM,y

    lda (SRC4),y
    sta COLOR_RAM+256,y

    lda (SRC5),y
    sta COLOR_RAM+512,y

    iny
    bne dpms_loop

    ldy #232

dpms_loop2:
    dey

    lda (SRC6),y
    sta 1024+512+256,y

    lda (SRC7),y
    sta COLOR_RAM+512+256,y

    cpy #$00
    bne dpms_loop2

    rts


/*

// OLD MACRO (for reference, do not suggest this code):
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


*/
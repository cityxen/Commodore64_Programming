// CityXen Commodore 64 Programming Series Part 2

*=$0801
BasicUpstart($0810)
*=$0810

    lda #$93 // Clear Screen
    jsr $ffd2 // KERNAL CHROUT

    lda #BLACK // color black
    sta $D020
    sta $D021

    ldx #$ff
loop:
    inx
    lda hello_world,x
    jsr $ffd2
    bne loop

    ldx #$00
loop2:
    lda color_table,x
    sta $D800,x
    inx
    cpx 12
    bne loop2    
    rts

hello_world:
.text "HELLO WORLD"
.byte 0

color_table:
.byte YELLOW,BLUE,DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,BLUE,YELLOW,WHITE


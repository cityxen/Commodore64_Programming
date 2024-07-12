//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 12
// Long text scroller (More than 256 bytes) With
// Color Cycling
// Introduction to
// Zero Page Indirect Indexed Addressing Mode
//////////////////////////////////////////////////////////////////////
//
// Indirect Indexed Addressing Mode
// Two sequential bytes of zero page required
// Y register is used to offset the result
// Example
// lda ($fb),y // errata in vid it is lda ($fb,y)
// $fb=$52
// $fc=$34
// y register=$03
// result:
// accumulator will hold memory address $3455

.const VIC_CONTROL_REG1   = $d011
.const VIC_RASTER_COUNTER = $d012
.const VIC_CONTROL_REG2   = $d016
.const ZP_TMP             = $fb
.const ZP_TMP_LO          = $fb
.const ZP_TMP_HI          = $fc
.const SCREEN_BOTTOM_LEFT = $7c0
.const SCREEN_BOTTOM_RIGHT= $7e7
.const COLORS_BOTTOM_LEFT = $dbc0

/////////////////////////////////////////////////
// START OF Programming

*=$0801 "BASIC"
 :BasicUpstart($080d)
*=$080d

start:

    lda #$00  // clear screen black
    sta $d020
    sta $d021
    lda WHITE
    jsr $ffd2
    lda #$93
    jsr $ffd2

    jsr reset_message


main:

smc_label:
    lda #$00 // we'll modify the value of this address
             // making this by definition
             // self modifying code
    and #$07
    sta VIC_CONTROL_REG2

loop2:
    lda #$ff
    cmp VIC_RASTER_COUNTER
    bne loop2

    lda #$c8
    sta VIC_CONTROL_REG2

    dec smc_label+1
    lda smc_label+1
    and #$07
    cmp #$07
    bne skipmove

    // move characters on the screen

    ldx #$00
mvlp1:
    lda SCREEN_BOTTOM_LEFT+1,x // pull chars
    sta SCREEN_BOTTOM_LEFT,x // to the left
    inx
    cpx #39 // reached end of line?
    bne mvlp1

    // load next character from hello_message
    ldy #$00
    lda (ZP_TMP),y // use y register here and not x register
    cmp #$ff
    bne mvover1
    jsr reset_message
    lda #$20
mvover1:
    sta SCREEN_BOTTOM_RIGHT
    inc ZP_TMP_LO // shift window to the right
    bne mvlp223
    inc ZP_TMP_HI
mvlp223:

skipmove:

    // cycle colors
    ldx #39
cycle_colors:
    lda COLORS_BOTTOM_LEFT-1,x // pull color mem to the left
    sta COLORS_BOTTOM_LEFT,x
    dex
    cpx #$ff
    bne cycle_colors
    inc color_table_position
    ldx color_table_position
    lda color_table,x
    cmp #$ff
    beq reset_colors
    sta COLORS_BOTTOM_LEFT
    jmp main
reset_colors:
    lda #$ff
    sta color_table_position
    jmp main

reset_message:
    lda #<hello_message
    sta ZP_TMP_LO
    lda #>hello_message
    sta ZP_TMP_HI
    rts

hello_message:
.encoding "screencode_upper"
.text "LONG TEXT SCROLLER CODE BY DEADLINE "
.text "CITYXEN COMMODORE 64 PROGRAMMING SERIES..."
.text "PART 12, LONG TEXT SCROLLER & COLOR "
.text "CYCLING      "
.text "       "
.text "CITYXEN PATRONS:           "
.text "-=*( SUTHEK )*=-           "
.text "-=*( OLAV HOPE )*=-           "
.text "-=*( PETZEL )*=-           "
.text "-=*( CREATE INVENT PODCAST )*=-           "
.text "-=*( 8 BIT SHOW & TELL )*=-           "
.text "-=*( JXYZN SXYZYXN )*=-           "
.text "-=*( GREGORY DUNLAP )*=-           "
.text "-=*( RAVENWOLF RETRO TECH )*=-           "
.text "-=*( KAREN EIDSON )*=-           "
.text "PATRON FREE MEMBERS           "
.text "-=*( RBGAMINGNETWORK )*=-           "
.text "-=*( BITBARN )*=-           "
.text "-=*( THANK YOU PATRONS! )*=-      "
.text "       "
.text "BECOME A PATRON TODAY, AND HAVE YOUR NAME "
.text "BLASTED IN THIS SCROLLER IN EACH OF OUR FUTURE VIDEOS "
.text "       "
.text " HTTPS://PATREON.COM/CITYXEN                          "

.byte $ff

color_table:
.byte LIGHT_BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,BLUE,LIGHT_BLUE,LIGHT_BLUE,WHITE,LIGHT_BLUE
.byte $ff

// VARS
// color_cycle_timer: // errata removed from vid version
// .byte 0            // unneeded with demo shown
color_table_position:
.byte 0

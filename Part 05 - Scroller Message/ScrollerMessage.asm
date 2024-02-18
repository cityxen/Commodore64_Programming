//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 5
// Horizontal Scroller Message with Color Cycle, Multicolor Characters, Raster line changes
// by Deadline

#import "../include/Constants.asm"
#import "../include/Macros.asm"

*=$3000 "customfont"
#import "characters-charset.asm"

.const SCREEN_BOTTOM_LEFT  = $7C0
.const SCREEN_BOTTOM_RIGHT = $7E7

.const COLORS_BOTTOM_LEFT  = $DBC0
.const COLOR_VAR           = $C000
.const COLOR_TIMER         = $C001

*=$0801 "BASIC"
    BasicUpstart($0810)
*=$0810

    ClearScreen(BLACK) // ClearScreen macro from Macros.asm

    lda #LIGHT_GRAY // Set up multicolor character colors
    sta BACKGROUND_COLOR_1
    lda #DARK_GRAY
    sta BACKGROUND_COLOR_2

    ldx #$00
fillwhite:
    lda #WHITE
    sta COLOR_RAM,x
    lda #9   // 00001001
    sta COLOR_RAM+154,x
    inx
    cpx #$fe
    bne fillwhite

    ldx #$00
txtloop:
    lda initial_text,x
    beq dotxtloop2
    sta SCREEN_RAM,x
    inx
    jmp txtloop

dotxtloop2:
    ldx #64
txtloop2:
    txa
    sta 1215,x
    inx
    cpx #76
    bne txtloop2

    ldx #96
txtloop3:
    txa
    sta 1223,x
    inx
    cpx #108
    bne txtloop3

    jmp start

initial_text:
.text "  cityxen scroller message by deadline"
.byte 0

start:

    ldx #39 // initial color fill of screen for the scroller message color
    lda #DARK_GRAY
fillcolorloop:
    sta COLORS_BOTTOM_LEFT-1,x
    dex
    cpx #$ff
    bne fillcolorloop

    sei // disable interrupts

    lda VIC_MEM_POINTERS // point to the new characters
    ora #$0c
    sta VIC_MEM_POINTERS

loop1:

    lda #$5f        // Wait for raster line $5f
    cmp VIC_RASTER_COUNTER
    bne loop1b      // if not at $5f, goto loop1b

    lda VIC_CONTROL_REG_2 // Turn on multicolor mode
    ora #16
    sta VIC_CONTROL_REG_2

    lda #WHITE  // Change border to white
    sta BORDER_COLOR

loop1b:
    lda #$f2        // Wait for raster line $f2
    cmp VIC_RASTER_COUNTER
    bne loop1       // if not at $f2, goto loop1

    lda VIC_CONTROL_REG_2 // Turn off multicolor character mode
    and #239
    sta VIC_CONTROL_REG_2

    lda #BLACK // change border to black
    sta BORDER_COLOR

varlabel:
    lda #$00 // go into 38 column mode and set scroll bits
    and #$07 // varlabel+1 will be changed with self modifying code
    sta VIC_CONTROL_REG_2

loop2:
    lda #$ff // wait for raster line $ff
    cmp VIC_RASTER_COUNTER
    bne loop2

    lda #$c8 // reset the borders to 40 column mode
    sta VIC_CONTROL_REG_2

    dec varlabel+1
    lda varlabel+1
    and #$07
    cmp #$07
    bne skipmove

    // Move scroller characters
    ldx #$00
mvlp1:
    lda SCREEN_BOTTOM_LEFT+1,x
    sta SCREEN_BOTTOM_LEFT,x
    inx
    cpx #39
    bne mvlp1

mvlp2: // put character from scroller message onto bottom right
    ldx #$00
    lda hello_message,x
    sta SCREEN_BOTTOM_RIGHT
    inx
    lda hello_message,x
    cmp #$ff
    bne mvover1
    ldx #$00
mvover1:
    stx mvlp2+1

skipmove:
    // color cycling

    inc COLOR_TIMER
    lda COLOR_TIMER
    cmp #$05
    beq more_color
    jmp loop1

more_color:
    lda #$00  // reset color timer
    sta COLOR_TIMER

    // move colors
    ldx #39
cycle_colors:
    lda COLORS_BOTTOM_LEFT-1,x
    sta COLORS_BOTTOM_LEFT,x
    dex
    cpx #$ff
    bne cycle_colors

    inc COLOR_VAR
    ldx COLOR_VAR
    lda color_table,x
    cmp #$ff
    beq reset_colors
    sta COLORS_BOTTOM_LEFT
    jmp loop1

reset_colors:
    lda #$ff
    sta COLOR_VAR

    jmp loop1

hello_message:
.encoding "screencode_upper"
.text "  HELLO, THIS IS A HORIZONTAL SCROLLER MESSAGE BY DEADLINE OF CITYXEN. THIS IS "
.text "A MODIFIED VERSION OF THE EXAMPLE PROVIDED WITH KICKASSEMBLER. IT IS "
.text "PART 5 OF THE COMMODORE 64 PROGRAMMING SERIES VIDEOS ON OUR YOUTUBE CHANNEL..."
.byte $ff

color_table:
.byte DARK_GRAY, GRAY, LIGHT_GRAY, WHITE, LIGHT_GRAY, GRAY, DARK_GRAY
.byte $ff

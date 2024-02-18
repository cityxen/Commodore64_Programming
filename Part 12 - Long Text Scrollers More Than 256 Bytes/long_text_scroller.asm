//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 11
// Long text scroller. (More than 256 bytes)
// by Deadline
//

.segment Code []
.file [name="prg_files/longscroll.prg",segments="Code"]
.disk [filename="prg_files/longscroll.d64", name="LONG SCROLL TEXT", id="CXN24" ] {
    [name="longscroll", type="prg",  segments="Code"]
}

*=$2ff0 "constants"
#import "../../Commodore64_Programming/include/Constants.asm"
// #import "../../Commodore64_Programming/include/Macros.asm"
#import "../../Commodore64_Programming/include/DrawPetMateScreen.asm"

.const SCREEN_BOTTOM_LEFT  = $7C0
.const SCREEN_BOTTOM_RIGHT = $7E7
.const COLORS_BOTTOM_LEFT  = $DBC0

//////////////////////////////////////////////////////////
// START OF PROGRAM

//.segment Main [allowOverlap]
//*=$0801 "BASIC"
// :BasicUpstart($0815)
//*=$080a "cITYxEN wORDS"
//.byte $3a,99,67,73,84,89,88,69,78,99
//*=$0815 "MAIN PROGRAM"

*=$0801 "BASIC"
    BasicUpstart2($0810)
*=$0810 "Program"

start:

    lda #<hello_message
    sta zp_tmp_lo
    lda #>hello_message
    sta zp_tmp_hi

    lda #$00
    sta count_var_high
    sta count_var_low
    sta timer_var
    sta $d020
    sta $d021
    ldx #0
    ldy #0
    lda #00
    
    sei
    lda #<irq1
    sta $0314
    lda #>irq1
    sta $0315
    asl $d019
    lda #$7b
    sta $dc0d
    lda #$81
    sta $d01a
    lda #$1b
    sta $d011
    lda #$80
    sta $d012
    cli
    
    lda WHITE
    jsr $ffd2
    lda #$93
    jsr $ffd2

    ldx #$00
color_cycle_fill_loop:
    lda #WHITE
    sta COLORS_BOTTOM_LEFT-1,x
    sta COLORS_BOTTOM_LEFT,x
    sta COLORS_BOTTOM_LEFT+10,x
    sta COLORS_BOTTOM_LEFT+20,x
    sta COLORS_BOTTOM_LEFT+30,x
    inx
    cpx #$0a
    bne color_cycle_fill_loop

loop256:
      
loop1d:
    lda #$f2         // Wait for raster line $f2
    cmp VIC_RASTER_COUNTER
    bne loop256      // if not at $f2, goto loop1
    
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

mvlp22:

    ldx #$00
    lda (zp_tmp,x)
    cmp #$ff
    bne mvover1

    lda #<hello_message
    sta zp_tmp_lo
    lda #>hello_message
    sta zp_tmp_hi

    lda #$20

mvover1:
    sta SCREEN_BOTTOM_RIGHT
    inc zp_tmp_lo
    bne mvlp223
    inc zp_tmp_hi

mvlp223:

skipmove:

    // color cycling

    //inc vars
    //lda vars
    //cmp #$05
    //beq more_color
    //jmp nomore_color

//more_color:
    //lda #$00  // reset color timer
    //sta vars
    
//nomore_color:

    // move colors
    //ldx #39
//cycle_colors:
    //lda COLORS_BOTTOM_LEFT-1,x
    //sta COLORS_BOTTOM_LEFT,x
    //dex
    //cpx #$ff
    //bne cycle_colors

    //inc vars+1
    //ldx vars+1
    //lda color_table,x
    //cmp #$ff
    //beq reset_colors
    //sta COLORS_BOTTOM_LEFT
    //jmp loop256

//reset_colors:
    //lda #$ff
    //sta vars+1
    
    jmp loop256

vars:
.byte 0

hello_message:
.encoding "screencode_upper"
.text "LONG TEXT SCROLLER CODE BY DEADLINE... "
.text "CITYXEN COMMODORE 64 PROGRAMMING SERIES...       "
.text "PATRONS:                        "
.text "-=*(SUTHEK)*=-                  "
.text "-=*(OLAV HOPE)*=-               "
.text "-=*(PETZEL)*=-                  "
.text "-=*(CREATE INVENT PODCAST)*=-   "
.text "-=*(8 BIT SHOW & TELL)*=-       "
.text "-=*(JXYZN SXYZYXN!)*=-          "
.text "-=*(THANK YOU PATRONS!)*=-      "
.text "                                "
.text "WE'VE PUT THIS CODE ON OUR GITHUB SO YOU CAN"
.text "DOWNLOAD IT.       GFX/CODE BY DEADLINE     "
.text "THIS SCROLLER HAS MORE THAN 256 BYTES IN IT. IN FACT, "
.text "IT IS CODED IN SUCH A WAY THAT IT WILL KEEP SCROLLING "
.text "THROUGH MEMORY UNTIL IT ENCOUNTERS $FF, WHICH IS WHAT "
.text "I CODED IT TO LOOK FOR TO END THE SCROLL.             "
.text "THIS WILL BE IN THE THANK YOU SECTION OF OUR GITHUB. "
.text "MORE COMMODORE PROGRAMMING AND OTHER GOODNESS COMING IN 2024, SO STAY TUNED! "
.text "                                            "
.text "-=*(DEADLINE/CXN)*=- "
.text "                                            "
.byte $ff

color_table:
// .byte WHITE, BLUE, LIGHT_BLUE, WHITE, WHITE, WHITE, WHITE, LIGHT_BLUE, BLUE, WHITE
.byte WHITE, WHITE
.byte $ff

tmps:
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0

irq1:
    asl $d019
    // jsr music.play
    pla
    tay
    pla
    tax
    pla
    rti

*=$2740
count_var_low:
.byte 0
count_var_high:
.byte 0
timer_var:
.byte 0

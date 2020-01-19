//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 2
// Hello World (with color printing)
// by Deadline

*=$0801
BasicUpstart($0810)
*=$0810

    lda #$93    // Clear Screen
    jsr $ffd2   // KERNAL CHROUT

    lda #BLACK  // color black
    sta $D020   // Border color
    sta $D021   // Background color

    ldx #$ff    // load x with 255
loop:
    inx         // increment x register
    lda hello_world,x // load accumulator with hello_world, (offset by x)
    jsr $ffd2   // KERNAL CHROUT
    bne loop    // branch if not equal to loop

    ldx #$00    // load x with 0
loop2:
    lda color_table,x // load accumulator with color_table, (offset by x)
    sta $D800,x // store at screen color ram, (offset by x)
    inx         // increment x register
    cpx #12     // bug fix from video comment (thanks Asaf Saar)
    bne loop2   // branch if not equal to loop2
    rts         // return from subroutine (end of program)

hello_world:    // character table label for the words hello world
.text "HELLO WORLD"
.byte 0

color_table:    // color table label
.byte YELLOW,BLUE,DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,BLUE,YELLOW,WHITE


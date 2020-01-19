//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 4
// Custom Characters And Smooth Scroll & Introducing Kick Assembler Macros
// by Deadline

#import "../include/Constants.asm" // import constants.asm which contains helpful words instead of hex numbers
#import "../include/Macros.asm"    // import macros.asm which has macros to use

*=$3000 "customfont" // specify that characters load in at $3000
#import "characters-charset.asm"   // import character data

*=$0801 "BASIC"
    BasicUpstart($0810)
*=$0810

.const T_SCROLL_REG = $C000
.const T_TIMER_1 = $C001
.const T_TIMER_2 = $C002

    sei

    ClearScreen(BLACK) // from Macros.asm

	lda VIC_MEM_POINTERS // point to the new characters
    ora #$0c
    sta VIC_MEM_POINTERS

    lda VIC_CONTROL_REG_1
    and #$F7
    sta VIC_CONTROL_REG_1

    ldx #$18
loop_crs_down:    
    lda #$11
    jsr KERNAL_CHROUT
    dex 
    cpx #$00
    bne loop_crs_down

loop_char_scroll:
    lda VIC_CONTROL_REG_1
    and #$F8
    ora #$07
    sta VIC_CONTROL_REG_1

    lda #$0D // CR
    jsr KERNAL_CHROUT

loop_print_hello_start:
    ldx #$FF
loop_print_hello:
    inx
    lda hello_message,x
    jsr $ffd2
    bne loop_print_hello

    lda #$06
    sta T_SCROLL_REG

loop_scroll_reg:
    
    clc
    lda VIC_RASTER_COUNTER
    cmp #$02
    bne loop_scroll_reg

    lda VIC_CONTROL_REG_1
    and #$F8
    ora T_SCROLL_REG
    sta VIC_CONTROL_REG_1

    lda #$00
    sta T_TIMER_1
    sta T_TIMER_2

loop_timer_1:
    inc T_TIMER_1

loop_timer_2:
    inc T_TIMER_2
    lda T_TIMER_2
    cmp #$FF
    bne loop_timer_2
        
    lda T_TIMER_1
    cmp #$05
    bne loop_timer_1


    dec T_SCROLL_REG
    lda T_SCROLL_REG
    cmp #$FF
    bne loop_scroll_reg

    jmp loop_char_scroll

hello_message:
.text "   HELLO"
.byte 0

    rts

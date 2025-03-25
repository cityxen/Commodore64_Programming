//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 6
// Petmate screens and Reading Keyboard Input
// by Deadline

#import "../include/Constants.asm"
#import "../include/Macros.asm"
#import "../include/DrawPetMateScreen.asm"

*=$09a3 "SCREENS"
#import "screen1.asm"
#import "screen2.asm"
#import "screen3.asm"

*=$0801 "BASIC"
    BasicUpstart($0810)
*=$0810

    ClearScreen(BLACK) // from Macros.asm
    jsr write_instructions

mainloop:
    jsr KERNAL_GETIN
check_1_hit:
    cmp #$31
    bne check_2_hit
    DrawPetMateScreen(screen_001)
    jsr write_instructions
    jmp mainloop
check_2_hit:
    cmp #$32
    bne check_3_hit
    DrawPetMateScreen(screen_002)
    jsr write_instructions
    jmp mainloop
check_3_hit:
    cmp #$33
    bne check_4_hit
    DrawPetMateScreen(disk_menu)
    jsr write_instructions
    jmp mainloop
check_4_hit:
    cmp #$34
    bne check_next_key
    DrawPetMateScreen(last_screen)
    jsr write_instructions
    jmp mainloop

check_next_key:
    jmp mainloop

write_instructions:
    ldx #$00
w_i_loop:
    lda instructions,x
    beq w_i_exit
    sta 1988,x
    lda #WHITE
    sta $dbc4,x
    inx
    jmp w_i_loop
w_i_exit:
    rts

instructions:
.text " press 1 to 4 to change screens "
.byte 0


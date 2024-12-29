#import "Constants.asm"
#import "Macros.asm"
#import "PrintMacros.asm"
#import "input.il.asm"
#import "print.il.asm"
#import "sys.il.asm"

CityXenUpstart(start)

start:

    lda #LIGHT_BLUE
    sta print_hex_color
    lda #$93
    jsr $ffd2
    ldx #$00

    InputText2(user_name,15,10,10,1)

    lda #$93
    jsr $ffd2

    PrintSC2P(user_name)

    rts

user_name:
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0



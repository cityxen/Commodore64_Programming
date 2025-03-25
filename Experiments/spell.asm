//////////////////////////////////////////////////////////////////////
// SPELL!
// by Deadline

#import "../include/Constants.asm"
#import "../include/Macros.asm"
#import "../include/DrawPetMateScreen.asm"

*=$2000 "SCREENS"
#import "screen-spell.asm"

*=$0801 "BASIC"
    BasicUpstart($0810)
*=$0810
    ClearScreen(BLACK) // from Macros.asm
mainloop:
    DrawPetMateScreen(screen_001)
    jmp mainloop

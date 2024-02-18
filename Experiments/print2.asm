#import "../include/CityXenLib.asm"

.file [name="print2.prg", segments="Main"]
CityXenUpstart() // super duper CityXen code thingy
#import "../include/CityXenLibCode.asm"
#import "screen.asm"
#import "print2_vars.asm"

*=$1200 "Code"

start:

    DrawPetMateScreen(screen)
    zPrint(textit)

    PrintLF()
    PrintHOME()
    lda #$03
    PrintHexI()
    PrintLF()

    zPrint(printvar2)

    rts

textit:
.byte 13
.text "TEST TEXT IT"

.byte 0

#import "../include/CityXenLib.asm"
.file [name="print2.prg", segments="Main"]
CityXenUpstart() // super duper CityXen code thingy
#import "../include/CityXenLibCode.asm"
start:
    zPrint(textit)

    PrintLF()
    PrintHOME()
    lda #$32
    PrintHexI()
    PrintLF()

    rts

textit:
.byte $93,13
.text "TEST TEXT IT"

.byte 0

#import "Constants.asm"
#import "Macros.asm"
#import "PrintMacros.asm"

CityXenUpstart(start)

start:

    lda #$93
    jsr $ffd2

    jsr score_reset

    PrintLF()
    PrintNZ(score_str)

    lda #$50 // set score val to 1
    sta score_math_o

    PrintLF()
    lda score_math_o
    PrintHexI()

    jsr score_add // add 1
    jsr score_add // add 1
    jsr score_add // add 1
    jsr score_add // add 1
    jsr score_add // add 1
    jsr score_add // add 1


    PrintLF()
    PrintNZ(score_str)

    PrintLF()

    lda #$5 // // set score val to 11
    sta score_math_o

    lda score_math_o
    PrintHexI()

    jsr score_sub // subtract 11

    PrintLF()
    PrintNZ(score_str)

    jsr score_reset

    PrintLF()
    PrintNZ(score_str)

    rts

#import "print.il.asm"
#import "sys.il.asm"
#import "score.il.asm"

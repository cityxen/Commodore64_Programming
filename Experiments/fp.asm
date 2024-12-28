#import "Constants.asm"
#import "Macros.asm"
#import "PrintMacros.asm"
#import "print.il.asm"
#import "sys.il.asm"

CityXenUpstart(start)

start:

    lda #LIGHT_BLUE
    sta print_hex_color
    lda #$93
    jsr $ffd2
    ldx #$00

    FPTest(numba1)
    FPTest(numba2)
    FPTest(numba3)
    FPTest(numba4)
    FPTest(numba5)
    
    rts

ftw:
    PrintHexI_Range($61,8)
    rts

.macro FPTest(num) {
    lda #<num
    sta $7a
    lda #>num
    sta $7b
    clc
    lda num
    jsr FIN
    jsr FOUT

    PrintLF()
    zPrint(FSTR)
    PrintSPC()

    lda #<num
    sta $7a
    lda #>num
    sta $7b
    clc
    lda num
    jsr FIN

    PrintHexI_Range($61,8)
    PrintLF()

    // Add it to itself
    lda #<num
    sta $7a
    lda #>num
    sta $7b
    clc
    lda num
    jsr FIN
    jsr MOVFA
    lda $61
    jsr FADDT
    jsr FOUT
    zPrint(FSTR)
    PrintSPC()
    
    lda #<$0100
    sta $7a
    lda #>$0100
    sta $7b
    clc
    lda num
    jsr FIN
    PrintHexI_Range($61,8)
    PrintLF()



}

numba1:
.text "1"
.byte 0

numba2:
.text "2"
.byte 0

numba3:
.text "3"
.byte 0

numba4:
.text "4"
.byte 0

numba5:
.text "5"
.byte 0

numba6:
.text "6"
.byte 0

numba7:
.text "7"
.byte 0

numba8:
.text "8"
.byte 0




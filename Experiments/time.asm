
#import "../include/Constants.asm"

*=$0801 "BASIC UPSTART"
    BasicUpstart($080d)
*=$080d "MAIN Program"

main:
    jsr KERNAL_RDTIM
    sta $0400
    stx $0401
    sty $0402
    jmp main
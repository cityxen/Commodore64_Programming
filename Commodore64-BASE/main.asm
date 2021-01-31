//////////////////////////////////////////////////////////////////////////
// Commodore 64 BASE main file
//
// Machine: Commodore 64
// Version: 1
// Author: 
//
// Assembly files are for use with KickAssembler
// http://theweb.dk/KickAssembler
//
// Notes: If you're going to attempt to compile this, you'll
// need the Macros and Constants from this repo:
// https://github.com/cityxen/Commodore64_Programming
//
// How To setup KickAssembler in Windows 10:
// https://www.youtube.com/watch?v=R9VE2U_p060
//
//////////////////////////////////////////////////////////////////////////
.var basic = $0801
.var main  = $080d
.var music = 0
irq1:

.file [name="program.prg",segments="Main"]
.disk [filename="program.d64", name="program", id="id" ]  {
        [name="program", type="prg",  segments="Main"]
}

.segment Main []
//////////////////////////////////////////////////////////
// START OF MAIN
*=basic "basic"
    BasicUpstart(main)
*=main  "main"
jmp start
#import "RetroDevLib-C64.asm"
start:

    ClearScreen(BLACK)
    PrintStrAtColor(0,0,"hello",WHITE)
    PrintStrAtRainbow(0,1,"hello rainbow")
    PrintDecAtColor(0,2,3,BLUE)

loop:
    jmp loop
    rts

// END OF MAIN
///////////////////////////////////////////////////

words:
.text "program"
.byte 0



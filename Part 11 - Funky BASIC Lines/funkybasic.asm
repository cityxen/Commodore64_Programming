//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 11
// Funky BASIC Lines
// by Deadline
//

#import "../include/Constants.asm"

.file [name="funkybasic.prg", segments="Main"]

.segment Main [allowOverlap]
* = $0801 "BASIC Upstart"
.word usend // link address
.word 2024  // line number
.byte $9e   // BASIC Token for SYS
.text toIntString(start) // start label to SYS to
.text ":"
.byte $80   // BASIC Token for END
.text ":"
.byte KEY_DELETE,KEY_DELETE,KEY_DELETE
.byte KEY_DELETE,KEY_DELETE,KEY_DELETE
.byte KEY_DELETE,KEY_DELETE,KEY_DELETE
.byte KEY_DELETE,KEY_DELETE,KEY_DELETE
.byte KEY_DELETE
.text " -=*(CITYXEN)*=-"
usend:
.byte 0
.word 0  // empty link signals the end of the program
// THIS CODE IS FROM $0801 - $082c
// The * directive below puts the code to $0830
// well clear of any overlap
// If you modify this code to change BASIC Upstart
// and add more characters keep this in mind
* = $0830 "init other things / vars / data"

var_color1:
.byte 0

start:
    lda #$00
    sta $d020
    sta $d021
    lda #$00
    sta var_color1
lp:
    lda var_color1
    sta $d020
    inc var_color1
    jmp lp



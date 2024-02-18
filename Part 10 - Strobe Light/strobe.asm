//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 10
// Strobe Light
// by Deadline (From a magazine in the 80's)
//
// BASIC:
// 10 PRINT"CLEAR":POKE53280,0:POKE53281,0
// 20 FORI=0TO100:NEXT
// 30 POKE53280,1:POKE53281,1
// 40 GOTO 10
//

*=$0801
BasicUpstart($0810)
*=$0810

main:
lda #00
sta 53280
sta 53281
lda #$93
jsr $FFD2

jsr delay_dark

lda #01
sta 53280
sta 53281

wait_vbl:
lda 53266
bne wait_vbl
wait_vbl2:
lda 53266
bne wait_vbl2

jmp main

delay_dark:
delay:
inc $c000
beq delay2
jmp delay
delay2:
inc $c001
lda $c001
cmp #$f4
beq delay3
jmp delay2
delay3:

rts





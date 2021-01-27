////////////////////////////////////////////////////////////////
// Print stuff experiments
//////////////////////////////////////////////////////////////////////////////////////
// Initial defines and imports
// From https://github.com/cityxen/Commodore64_Programming
// git clone https://github.com/cityxen/Commodore64_Programming
#import "../include/Constants.asm"

//////////////////////////////////////////////////////////////////////////////////////
// File stuff
.file [name="print.prg", segments="Main"]

//////////////////////////////////////////////////////////////////////////////////////
// BASIC Upstart stuff
.segment Main [allowOverlap]
*=$0801 "BASIC"
 :BasicUpstart($0815)
*=$080a "cITYxEN wORDS"
.byte $3a,99,67,73,84,89,88,69,78,99
*=$0815 "MAIN PROGRAM"

//////////////////////////////////////////////////////////////////////////////////////
// Program start
program:
    lda #$00 // INITIALIZE STUFF
    sta BACKGROUND_COLOR
    sta BORDER_COLOR
    lda #$93
    jsr KERNAL_CHROUT
    lda #23
    sta $d018 // put to lower case mode
    
    lda #> no_rs232
    sta zp_tmp_hi 
    lda #< no_rs232
    sta zp_tmp_lo
    jsr zprint
    rts

no_rs232:
.encoding "petscii_mixed"
.text "Can not find RS-232 userport device"
.byte 0

//////////////////////////////////////////////////////////////////////////////////////
// string buffer data
strbuf:
.fill 256,0
buf_crsr:
.byte 

zprint:
    // uses zero page pointer to string which you have to set up prior to calling
    // ie;
    // lda #> up9600_write_string
    // sta zp_tmp_hi 
    // lda #< up9600_write_string
    // sta zp_tmp_lo
    // jsr up9600_write_2
    ldx #$00
!wl:
    lda (zp_tmp,x)
    beq !wl+
    jsr $ffd2
    inc zp_tmp_lo
    jmp !wl-
!wl:
    rts

//////////////////////////////////////////////////////////////////////////////////////
// UP9600 write data
up9600_ident:
.encoding "ascii" // "screencode_mixed" "petscii_mixed" "screencode_lower" "petscii_lower"
.text "IDENTIFY:C64"

//////////////////////////////////////////////////////////////////////////////////////
// zero string buffer
zero_strbuf:
    lda #$00
    ldx #$00
!lp:
    sta strbuf,x
    inx
    bne !lp-
    stx buf_crsr
    rts


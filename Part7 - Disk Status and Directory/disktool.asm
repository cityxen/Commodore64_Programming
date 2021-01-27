//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 7
// Disk Status and Directory
// by Deadline
// 
// Based on code converted to KickAssembler from:
// https://codebase64.org/doku.php?id=base:reading_the_directory
//

#import "../include/Constants.asm"
#import "../include/Macros.asm"
#import "../include/DrawPetMateScreen.asm"

*=$1000
#import "disktool-program-screen.asm"

.var drive_number = $fb

*=$0801 "BASIC UPSTART"
    BasicUpstart($080d)
*=$080d "MAIN Program"

init:
    // Store 8 into drive number variable
    lda #$08
    sta drive_number

    // change to white print
    lda #$05
    jsr KERNAL_CHROUT

start:
    // Draw Screen
    DrawPetMateScreen(screen_disk_tool)
    jsr draw_drive_number
    jmp mainloop

draw_drive_number:
    // Show Drive Number on Screen
    lda drive_number
    clc // clear carry flag so we don't rotate carry into a
    rol // rotate left (multiply by 2)
    sec // sec carry flag for subtract operation
    sbc #$10 // subtract 16
    tax
    lda drive_number_text,x // get text indexed by x
    sta $0737 // put to screen
    lda drive_number_text+1,x
    sta $0738
    rts
drive_number_text:
.text "08091011"

mainloop:
    jsr KERNAL_GETIN // Check keyboard for key hits

// D (Directory)
!check_key:
    cmp #KEY_D
    bne !check_key+
    inc $d020
    jsr show_directory
    jmp start

// C (Change Drive)
!check_key:
    cmp #KEY_C
    bne !check_key+
    inc drive_number
    lda drive_number
    cmp #$0c
    bne !cki+
    lda #$08
    sta drive_number
!cki:
    jsr draw_drive_number
    jmp mainloop

// T (Status)
!check_key:
    cmp #KEY_T
    bne !check_key+
    lda #$13 // print home
    jsr KERNAL_CHROUT
    ldx #$16 // print down 22 times
!cki:
    lda #$11 // down
    jsr KERNAL_CHROUT
    dex
    bne !cki-
    ldx #$10 // print right 16 times
!cki:
    lda #$1d // right char
    jsr KERNAL_CHROUT
    dex
    bne !cki-
    jsr show_drive_status
    jmp mainloop

!check_key:
    jmp mainloop

show_directory:
    ClearScreen(BLACK)
    lda #dirname_end-dirname // set length of dirname
    ldx #<dirname // lo byte of dirname
    ldy #>dirname // hi byte of dirname
    jsr KERNAL_SETNAM
    lda #$02 // filenumber
    ldx drive_number // default to device number 8
    ldy #$00 // secondary address
    jsr KERNAL_SETLFS
    jsr KERNAL_OPEN
    bcs error
    ldx #$02 // set filenumber
    jsr KERNAL_CHKIN
    ldy #$04 // skip 4 bytes on first dir line
    bne skip2
next:
    ldy #$02 // skip 2 bytes on all other lines
skip2:
    jsr getbyte
    dey
    bne skip2
    jsr getbyte // get low byte of basic line number
    tay
    jsr getbyte // get high byte of basic line number
    pha
    tya
    tax
    pla
    jsr $bdcd // print basic line number
    lda #$20 // print space
char:
    jsr KERNAL_CHROUT
    jsr getbyte
    bne char
    lda #$0d // carriage return character
    jsr KERNAL_CHROUT
    jsr KERNAL_STOP // run/stop pressed?
    bne next
error:
    // check for error here
exit:
    lda #$02 // filenumber 2
    jsr KERNAL_CLOSE
    jsr KERNAL_CLRCHN
    lda #$0d
    jsr KERNAL_CHROUT
    jsr show_drive_status
    ldx #$00
anykey_text:
    lda dir_presskey_text,x
    beq !anykey+
    jsr KERNAL_CHROUT
    inx
    jmp anykey_text
!anykey:
    jsr KERNAL_WAIT_KEY
    beq !anykey-
    rts

getbyte:
    jsr KERNAL_READST
    bne end
    jmp KERNAL_CHRIN
end:
    pla
    pla
    jmp exit

dirname:
.text "$"
dirname_end:
dir_presskey_text:
.encoding "screencode_mixed"
.byte $0d
.text "PRESS ANY KEY"
.byte 0

show_drive_status:
    lda #$00
    sta $90 // clear status flags
    lda drive_number // device number
    jsr KERNAL_LISTEN
    lda #$6f // secondary address
    jsr KERNAL_SECLSN
    jsr KERNAL_UNLSTN
    lda $90
    bne sds_devnp // device not present
    lda drive_number
    jsr KERNAL_TALK
    lda #$6f // secondary address
    jsr KERNAL_SECTLK
sds_loop:
    lda $90 // get status flags
    bne sds_eof
    jsr KERNAL_IECIN
    jsr KERNAL_CHROUT
    jmp sds_loop
sds_eof:
    jsr KERNAL_UNTALK
    rts
sds_devnp:
    // handle device not present error handling
    rts

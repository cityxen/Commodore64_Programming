//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 8
// Disk Load and Save
// by Deadline
// 
// Based on code converted to KickAssembler from:
// https://codebase64.org/doku.php?id=base:reading_the_directory
//

#import "../include/Constants.asm"
#import "../include/Macros.asm"
#import "../include/DrawPetMateScreen.asm"

*=$1000 "Screen"
#import "disktool-program-screen.asm"

*=$17d2 "Vars"
drive_number:
.byte 0
filename:
.encoding "screencode_mixed"
.text "DISKTOOLDATA"
.byte 0,0,0,0,0,0,0,0
filename_length:
.byte 12

.const data_start           = $6000 // 256 bytes of data storage area
.const data_end             = $6100

.const zp_pointer_lo        = $fb
.const zp_pointer_hi        = $fc

*=$17e8 "DiskData"
#import "diskdata.asm"

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

    // Copy disk data data to working memory area $6000
    jsr copydiskdata

    // Set up sid to produce random values
    lda #$FF  // maximum frequency value
    sta $D40E // voice 3 frequency low byte
    sta $D40F // voice 3 frequency high byte
    lda #$80  // noise waveform, gate bit off
    sta $D412 // voice 3 control register

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

/////////////////////////////////////////////
// Part 8 key code start

// L (Load Data)
!check_key:
    cmp #KEY_L
    bne !check_key+
    inc $d020
    jsr load_data
    jmp start

// S (Save Data)
!check_key:
    cmp #KEY_S
    bne !check_key+
    inc $d020
    jsr save_data
    jmp start

// V (View Data)
!check_key:
    cmp #KEY_V
    bne !check_key+
    inc $d020
    jsr viewdiskdata
    jmp start

// R (Randomize Data)
!check_key:
    cmp #KEY_R
    bne !check_key+
    inc $d020
    jsr randomizediskdata
    jsr viewdiskdata
    jmp start

// E (Restore Original Data)
!check_key:
    cmp #KEY_E
    bne !check_key+
    inc $d020
    jsr copydiskdata
    jmp start

// Part 8 key code end
/////////////////////////////////////////////

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

/////////////////////////////////////////////
// Part 8 disk code start

load_data:
    ClearScreen(BLACK)
    ldx #$00
!ld:
    lda load_loading,x
    beq !ld+
    sta SCREEN_RAM,x
    inx
    jmp !ld-
!ld:
    ldx #$00
!ld:
    lda filename,x
    beq !ld+
    cmp #27
    bcc cfn_dont_add_l
    sbc #$40
cfn_dont_add_l:
    sta SCREEN_RAM+8,x
    inx
    cpx #$10
    bne !ld-
!ld:
    lda #$0f
    ldx drive_number
    ldy #$ff
    jsr KERNAL_SETLFS
    lda filename_length
    ldx #<filename
    ldy #>filename
    jsr KERNAL_SETNAM
    ldx #00 // Set Load Address
    ldy #00 // 
    lda #00
    jsr KERNAL_LOAD
    lda #13
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr show_drive_status
    ldx #$00
!ld:
    lda dir_presskey_text,x
    beq !ld+
    jsr KERNAL_CHROUT
    inx
    jmp !ld-
!ld:
    jsr KERNAL_WAIT_KEY
    beq !ld-
    jsr viewdiskdata
    rts

load_loading:
.encoding "screencode_mixed"
.text "loading "
.byte 0

save_data:
    ClearScreen(BLACK)
    ldx #$00
!sv:
    lda save_saving,x
    beq !sv+
    sta SCREEN_RAM,x
    inx
    jmp !sv-
!sv:
    ldx #$00
!sv:
    lda filename,x
    beq !sv+
    cmp #27 // convert petscii to screen code
    bcc cfn_dont_add_s
    sbc #$40
cfn_dont_add_s:
    sta SCREEN_RAM+7,x
    inx
    cpx #$10
    bne !sv-
!sv:
    jsr displaydiskdata
    lda #$0f
    ldx drive_number
    ldy #$ff
    jsr KERNAL_SETLFS
    lda filename_length
    ldx #<filename
    ldy #>filename
    jsr KERNAL_SETNAM
    lda #<data_start // Set Start Address
    sta zp_pointer_lo
    lda #>data_start
    sta zp_pointer_hi
    ldx #<data_end // Set End Address
    ldy #>data_end
    lda #<zp_pointer_lo
    jsr KERNAL_SAVE
    lda #13
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr show_drive_status
    ldx #$00
!sv:
    lda dir_presskey_text,x
    beq !sv+
    jsr KERNAL_CHROUT
    inx
    jmp !sv-
!sv:
    jsr KERNAL_WAIT_KEY
    beq !sv-
    rts

save_saving:
.encoding "screencode_mixed"
.text "saving "
.byte 0

// Part 8 disk code end
/////////////////////////////////////////////
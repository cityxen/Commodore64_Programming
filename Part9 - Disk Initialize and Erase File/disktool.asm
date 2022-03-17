//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 9
// Disk Format and Erase File plus Save Self Program
// by Deadline
// 
// Based on code converted to KickAssembler from:
// https://codebase64.org/doku.php?id=base:reading_the_directory
//

#import "../include/Constants.asm"
#import "../include/Macros.asm"
#import "../include/DrawPetMateScreen.asm"
#import "../include/PrintMacros.asm"

*=$1800 "Screen"
#import "disktool-program-screen.asm"

*=$1fd2 "Vars"
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

prg_filename:
.encoding "screencode_mixed"
.text "DISKTOOLCOPY.PRG"
.byte 0
prg_filename_length:
.byte 16

.const prg_start            = $0801
.const prg_end              = $2150

*=$2000 "DiskData"
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
    sta $04eb // put to screen
    lda drive_number_text+1,x
    sta $04ec
    rts

drive_number_text:
.text "08091011"

//////////////////////////////////////////////
// Main Loop
mainloop:

//////////////////////////////////////////////
// Check Keyboard
    jsr KERNAL_GETIN // Check keyboard for key hits
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

// D (Directory)
!check_key:
    cmp #KEY_D
    bne !check_key+
    inc $d020
    jsr show_directory
    jmp start

// I (Initialize Disk (FORMAT))
!check_key:
    cmp #KEY_I
    bne !check_key+
    inc $d020
    jsr formatdisk
    jmp start

// A (Erase File)
!check_key:
    cmp #KEY_A
    bne !check_key+
    inc $d020
    jsr erasefile
    jmp start

// W (Write program to disk)
!check_key:
    cmp #KEY_W
    bne !check_key+
    inc $d020
    jsr writeprogram
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
    PrintColor(WHITE)
    lda #KEY_HOME
    jsr KERNAL_CHROUT
    lda #KEY_CURSOR_DOWN
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    lda #KEY_CURSOR_RIGHT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr show_drive_status
    jmp mainloop

!check_key:
    jmp mainloop

/////////////////////////////////////////////
// Show Directory

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

/////////////////////////////////////////////
// Show Drive Status

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
// Load Data

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

/////////////////////////////////////////////
// Save Data

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

/////////////////////////////////////////////
// Format Disk

formatdisk:
formatdisk_confirm:
    jsr draw_confirm_question
fd_loop2:
    jsr KERNAL_GETIN
    cmp #$00
    beq fd_loop2
fd_check_y_hit: // Y (Yes Format the Disk)
    cmp #KEY_Y
    beq format_disk
    rts
 format_disk:
    ClearScreenB(BLUE,LIGHT_BLUE)
    PrintString(fd_text)
    PrintLF()
    PrintLF()
    ldx #$00
    lda #15
    ldx #<fd_cmd
    ldy #>fd_cmd
    jsr KERNAL_SETNAM // call SETNAM

    lda #$0f          // file number 15
    ldx drive_number  // default to device 8
    ldy #$0f          // secondary address 15
    jsr KERNAL_SETLFS // call SETLFS
    jsr KERNAL_OPEN   // call OPEN

    jsr show_drive_status

    lda #$0F          // filenumber 15
    jsr KERNAL_CLOSE  // call CLOSE
    jsr KERNAL_CLRCHN // call CLRCHN

fd_out:
    jsr presskey
    rts

fd_text:
.encoding "petscii_upper"
.text "FORMATTING DISK"
.byte 0
fd_text_end:
fd_cmd:
.text "N0:CLEANDISK,01" // command string
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
fd_cmd_end:

/////////////////////////////////////////////
// Erase File

erasefile:
erase_file_confirm:
    jsr draw_confirm_question
efc_loop2:
    jsr KERNAL_GETIN
    cmp #$00
    beq efc_loop2
efc_check_y_hit: // Y (Yes Erase File)
    cmp #KEY_Y
    beq erase_file
    rts
    // Yes hit, erase the file
erase_file:
    ClearScreenB(BLUE,LIGHT_BLUE)
    ldx #$00
ef_cpfn:
    lda filename,x
    sta ef_cmd+3,x
    inx
    cpx filename_length
    bne ef_cpfn
    inx
    inx
    inx
    stx zp_temp
    ldx #$00
efw_print1:
    lda ef_text,x
    jsr KERNAL_CHROUT
    inx
    cpx #$08
    bne efw_print1
    ldx #$00
efw_print2:
    lda ef_cmd,x
    jsr KERNAL_CHROUT
    inx
    stx zp_temp2
    lda zp_temp
    cmp zp_temp2
    bne efw_print2
    PrintLF()
    PrintLF()
    lda zp_temp
    ldx #<ef_cmd
    ldy #>ef_cmd
    jsr KERNAL_SETNAM   // call SETNAM (Set command)
    lda #$0F            // file number 15
    ldx drive_number    // default to drive 8
    ldy #$0F            // secondary address 15
    jsr KERNAL_SETLFS   // call SETLFS
    jsr KERNAL_OPEN     // call OPEN

    jsr show_drive_status
    bcc ef2_noerror

ef2_noerror:
    lda #$0f    // filenumber 15
    jsr KERNAL_CLOSE
    jsr KERNAL_CLRCHN

ef_out:
    jsr presskey
    rts

ef_text:
.encoding "screencode_mixed"
.text "ERASING"
ef_text_end:
ef_cmd:
.text "S0:" // command string
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ef_cmd_end:

/////////////////////////////////////////////
// Write Program

writeprogram:
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
    lda prg_filename,x
    beq !sv+
    cmp #27 // convert to petscii to screen code
    bcc cfn_dont_add_w
    sbc #$40
cfn_dont_add_w:
    sta SCREEN_RAM+7,x
    inx
    cpx #$10
    bne !sv-
!sv:
    lda #$0f
    ldx drive_number
    ldy #$ff
    jsr KERNAL_SETLFS
    lda prg_filename_length
    ldx #<prg_filename
    ldy #>prg_filename
    jsr KERNAL_SETNAM
    lda #<prg_start // Set start address
    sta zp_pointer_lo
    lda #>prg_start //
    sta zp_pointer_hi
    ldx #<prg_end // Set end address
    ldy #>prg_end
    lda #<zp_pointer_lo
    jsr KERNAL_SAVE
    PrintLF()
    PrintLF()
    jsr show_drive_status
    jsr presskey
    rts

////////////////////////////////////////////////////
// Draw Confirm Question

draw_confirm_question:
    ldy #$02
    ldx #$00
ndc_loop:
    lda confirm_text,x
    sta SCREEN_RAM+12+11*40,x
    tya
    sta COLOR_RAM+12+11*40,x
    lda confirm_text+15,x
    sta SCREEN_RAM+12+12*40,x
    tya
    sta COLOR_RAM+12+12*40,x
    lda confirm_text+30,x
    sta SCREEN_RAM+12+13*40,x
    tya
    sta COLOR_RAM+12+13*40,x
    inx
    cpx #15
    bne ndc_loop
    rts

confirm_text:
.byte 079,119,119,119,119,119,119,119,119,119,119,119,119,119,080
.byte 101,001,018,005,032,025,015,021,032,019,021,018,005,063,103
.byte 076,111,111,111,111,111,111,111,111,111,111,111,111,111,122

////////////////////////////////////////////////////
// Press Any Key

presskey:
    PrintString(dir_presskey_text)
!pk:
    jsr KERNAL_WAIT_KEY
    beq !pk-
    rts

dir_presskey_text:
.encoding "petscii_upper"
.byte $0d
.text "PRESS ANY KEY"
.byte 0







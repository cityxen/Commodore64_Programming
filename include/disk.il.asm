//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

#importonce

.const zp_pointer_lo        = $fb
.const zp_pointer_hi        = $fc

device_not_present_text:
.byte 28
.text "rERROR"
.byte 146
.text "e:"
.byte 28
.text "DEVICE e"
.byte 0
device_not_present_text2:
.byte 28
.text " NOT PRESENT"
.byte $0d
.byte 0
drive_number_text:
.text "0809101112131415161718192021222324252627282930"
drive_number:
.byte 8
filename_length:
.byte 255
filename:
filename_buffer: // reserve space for filename buffer
.encoding "screencode_upper"
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
use_file_loc:
.byte 0
sec_command: 
    // 0 = load to file address
    // 1 = load to specified address
.byte 1
file_loc:
file_loc_lo:
.byte 0
file_loc_hi:
.byte 0
file_loc_end:
file_loc_end_lo:
.byte 0
file_loc_end_hi:
.byte 0
file_size:
file_size_hi:
.byte 0
file_size_lo:
.byte 0
load_loading:
.encoding "screencode_mixed"
.text "saving "
save_saving:
.encoding "screencode_mixed"
.text "saving "
.byte 0
save_record_over_string:
.text "@0:"
.byte 0

load_address_end:
load_address_end_lo:
.byte 0
load_address_end_hi:
.byte 0

//.const LOAD_ADDRESS_END_HI = $ae
//.const LOAD_ADDRESS_END_LO = $af
.const LOAD_ADDRESS_HI     = $c2
.const LOAD_ADDRESS_LO     = $c1

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Zeroize filename buffer

zeroize_filename_buffer:
    ldx #$00
!zfb:
    lda #$00
    sta filename_buffer,x
    inx
    bne !zfb-
    rts

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Print Drive Number to screen

draw_drive_number:

    lda drive_number // Show Drive Number on Screen
    clc // clear carry flag so we don't rotate carry into a
    rol // rotate left (multiply by 2)
    sec // sec carry flag for subtract operation
    sbc #$10 // subtract 16
    tax
    lda drive_number_text,x // get text indexed by x
    jsr KERNAL_CHROUT
    lda drive_number_text+1,x
    jsr KERNAL_CHROUT

    rts

//////////////////////////////////////////////////////////////////

load_file_file_loc:

load_file:
    // Load the file
    lda filename_length
    ldx #<filename_buffer
    ldy #>filename_buffer
    jsr KERNAL_SETNAM 
    lda #$01
    ldx drive_number
    // 0 = load to file address
    // 1 = load to specified address
    ldy sec_command
    jsr KERNAL_SETLFS
    lda #01
    ldx #<file_loc // 00 // Set Load Address
    ldy #>file_loc // 00 // 
    jsr KERNAL_LOAD
    txa
    sta load_address_end_lo
    tya
    sta load_address_end_hi

    clc
    lda load_address_end_lo
    sbc file_loc_lo
    sta file_size_lo
    lda load_address_end_hi
    sbc file_loc_hi
    sta file_size_hi

    rts


//////////////////////////////////////////////////////////////////

save_file:
    
    // Save a range of memory to a file
    
    lda filename_length
    ldx #<filename
    ldy #>filename
    jsr KERNAL_SETNAM

    lda #$01
    ldx drive_number
    ldy sec_command
    jsr KERNAL_SETLFS

    lda #<file_loc // Set Start Address
    sta zp_tmp_lo
    lda #>file_loc
    sta zp_tmp_hi
    ldx #<file_loc_end // Set End Address
    ldy #>file_loc_end
    lda zp_tmp_lo

    jsr KERNAL_SAVE

    lda #$01
    jsr KERNAL_CLOSE

    rts


save_data:
    
    lda filename_length
    ldx #<filename
    ldy #>filename
    jsr KERNAL_SETNAM

    lda #$0f
    ldx drive_number
    ldy #$ff
    jsr KERNAL_SETLFS

    lda #<file_loc // Set Start Address
    sta zp_pointer_lo
    lda #>file_loc
    sta zp_pointer_hi
    ldx #<file_loc_end // Set End Address
    ldy #>file_loc_end
    lda #<zp_pointer_lo
    
    jsr KERNAL_SAVE

    lda #$0f
    jsr KERNAL_CLOSE

    rts

//////////////////////////////////////////////////////////////////

open_file_get_one_byte:
    // Load the file
    lda filename_length
    ldx #<filename_buffer
    ldy #>filename_buffer
    jsr KERNAL_SETNAM 
    lda #$0f
    ldx drive_number
    ldy #$02
    jsr KERNAL_SETLFS
    jsr KERNAL_OPEN

    ldx #$0f      //; filenumber 15
    jsr $ffc6     //; call chkin (file 15 now used as input)
    jsr $ffb7     //; call readst (read status byte)
    jsr $ffcf     //; call chrin (get a byte from file)

    lda #$0f      //; filenumber 15
    jsr KERNAL_CLOSE
    jsr $ffcc

    rts

//////////////////////////////////////////////////////////////////

show_drive_status2:
    lda #$00
    sta $90 // clear status flags
    lda drive_number // device number
    jsr KERNAL_LISTEN
    lda #15 // 6f // secondary address
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
    Print(device_not_present_text2)
    rts

//////////////////////////////////////////////////////////////////

show_drive_status:

    lda #$00
    sta SPRITE_ENABLE

        lda #$00      //; no filename
        ldx #$00
        ldy #$00
        jsr $ffbd     //; call setnam

        lda #$0f      //; file number 15
        ldx $ba       //; last used device number
        bne sdsskip
        ldx #$08      //; default to device 8
sdsskip:
        ldy #$0f      //; secondary address 15 (error channel)
        jsr $ffba     //; call setlfs

        jsr $ffc0     //; call open
        bcs sdserror     //; if carry set, the file could not be opened

        ldx #$0f      //; filenumber 15
        jsr $ffc6     //; call chkin (file 15 now used as input)

sdsloop:
        jsr $ffb7     //; call readst (read status byte)
        bne sdseof      //; either eof or read error
        jsr $ffcf     //; call chrin (get a byte from file)
        jsr $ffd2     //; call chrout (print byte to screen)
        jmp sdsloop     //; next byte

sdseof:
sdsclose:
        lda #$0f      //; filenumber 15
        jsr $ffc3     //; call close

        jsr $ffcc     //; call clrchn

        rts
sdserror:
        //; akkumulator contains basic error code

        //; most likely error:
        //; a = $05 (device not present)

        //... error handling for open errors ...
        jmp sdsclose    //; even if open failed, the file has to be closed

//////////////////////////////////////////////////////////////////
// Show Directory show_directory
// if you want it to pause, A=0 no pause, A=1 pause

show_directory:
    sta dirpause
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

    lda dirpause
    beq !+

    ldx #$00
anykey_text:
    lda STR_PRESSKEY,x
    beq !anykey+
    jsr KERNAL_CHROUT
    inx
    jmp anykey_text

!anykey:
    jsr KERNAL_WAIT_KEY
    beq !anykey-
!:
    rts

getbyte:
    jsr KERNAL_READST    
    bne end
    jmp KERNAL_CHRIN
end:
    pla
    pla
    jmp exit

dirname: .text "$"
dirname_end:
dirpause: .byte 0


//////////////////////////////////////////////////////////////////

.macro ClearFileLocation() {
    lda #$00
    sta sec_command
    lda #$ff
    sta file_loc_lo
    lda #$ff
    sta file_loc_hi
}

.macro SetFileLocation(file_loc) {
    lda #$01
    sta sec_command
    lda #<file_loc
    sta file_loc_lo
    lda #>file_loc
    sta file_loc_hi
}

.macro SetFileLocationEnd(file_loc_end) {
    lda #<file_loc_end
    sta file_loc_end_lo
    lda #>file_loc_end
    sta file_loc_end_hi
}


.macro SetFileName(infilename) {
    jsr zeroize_filename_buffer
    ldx #$00
!sfb:
    lda infilename,x
    beq !sfb+
    jsr screencode_to_petscii
    sta filename_buffer,x
    inx
    jmp !sfb-
!sfb:
    stx filename_length
    lda #$00
    sta filename_buffer,x
    inx
    sta filename_buffer,x
}

.macro KeyFileLoad(key,file,loc) {
    cmp #key
    bne !kfs+
    SetFileName(file)
    lda #<loc
    sta file_loc_lo
    lda #>loc
    sta file_loc_hi

    lda SPRITE_ENABLE
    sta zp_tmp

    lda #$00
    sta SPRITE_ENABLE

    jsr load_file

    lda zp_tmp
    sta SPRITE_ENABLE

    jmp main_loop
!kfs:
}



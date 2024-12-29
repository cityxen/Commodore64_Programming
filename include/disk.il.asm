//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

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
file_loc_lo:
.byte 0
file_loc_hi:
.byte 0


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

    Print(drive_text)
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
    PrintLF()
    rts

//////////////////////////////////////////////////////////////////

load_file:
    // Load the file
    lda filename_length
    ldx #<filename_buffer
    ldy #>filename_buffer
    jsr KERNAL_SETNAM 
    lda #$01
    ldx drive_number
    ldy #$02
    jsr KERNAL_SETLFS
    lda #00
    ldx #file_loc_lo // 00 // Set Load Address
    ldy #file_loc_hi // 00 // 
    jsr KERNAL_LOAD
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
    lda #255
    sta SPRITE_ENABLE

        rts
sdserror:
        //; akkumulator contains basic error code

        //; most likely error:
        //; a = $05 (device not present)

        //... error handling for open errors ...
        jmp sdsclose    //; even if open failed, the file has to be closed

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

    jsr load_data

    lda zp_tmp
    sta SPRITE_ENABLE

    jmp main_loop
!kfs:
}



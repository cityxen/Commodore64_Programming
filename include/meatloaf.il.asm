///////////////////////////////////////////////////////////////
// Meatloaf Functions
// By Deadline / CityXen
ml_drive_number: .byte 8
ml_detect_cmd:
.encoding "petscii_mixed"
.text "i0:"     // command string
ml_detect_cmd_end:
ml_detect_byte:  .byte 0
ml_detect_check: .byte 0
ml_detected:     .byte 0
ml_enabled:      .byte 0
ml_detected_text: .text "meatloaf found:"
.byte 0
ml_enabled_text:  .text "meatloaf enabled:"
.byte 0
ml_detect_meatloaf:
        lda #$00
        sta ml_detect_byte
        sta ml_detected
        sta ml_detect_check
        lda #ml_detect_cmd_end-ml_detect_cmd
        ldx #<ml_detect_cmd
        ldy #>ml_detect_cmd
        jsr $ffbd     // call setnam
        lda #$0f      // file number 15
        ldx ml_drive_number
ml_i_skip:
        ldy #$0f      // secondary address 15
        jsr $ffba     // call setlfs
        jsr $ffc0     // call open
ml_i_close:
        lda #$0f      // filenumber 15
        jsr $ffc3     // call close
        jsr $ffcc     // call clrchn
ml_show_drive_status:
        lda #$00      // no filename
        ldx #$00
        ldy #$00
        jsr $ffbd
        lda #$0f
        ldx ml_drive_number
ml_sdsskip:
        ldy #$0f      // secondary address 15 (error channel)
        jsr $ffba     // call setlfs
        jsr $ffc0     // call open
        bcs ml_sdserror  // if carry set, the file could not be opened
        ldx #$0f      // filenumber 15
        jsr $ffc6     // call chkin (file 15 now used as input)
ml_sdsloop:
        jsr $ffb7     // call readst (read status byte)
        bne ml_sdseof    // either eof or read error
        jsr $ffcf     // call chrin (get a byte from file)
        sta ml_detect_check
        inc ml_detect_byte
        lda ml_detect_byte
        cmp #$04
        bne !+
        lda ml_detect_check
        cmp #'m'
        bne !+
        lda #$01
        sta ml_detected
!:
        jmp ml_sdsloop   // next byte
ml_sdseof:
ml_sdsclose:
        lda #$0f      // filenumber 15
        jsr $ffc3     // call close
        jsr $ffcc     // call clrchn
        rts
ml_sdserror:
        // accumulator contains basic error code, most likely error: a = $05 (device not present)
        jmp sdsclose

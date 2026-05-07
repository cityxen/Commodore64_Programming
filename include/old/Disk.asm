.macro Disk_Load_StringName(filename,hibyte,lobyte) {
    jmp overfilename
    in_filename:
    .text filename; .byte 0
overfilename:
	lda #$01
	ldx #<in_filename
	ldy #>in_filename
	jsr KERNAL_SETNAM // SETNAM. Set file name parameters. Input: A = File name length; X/Y = Pointer to file name.
	lda #$00
    ldx #<hibyte
	ldy #>lobyte
	jsr KERNAL_LOAD // A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
}
.macro Disk_Load_MemName(in_filename,hibyte,lobyte) {
	lda #$01
	ldx #<in_filename
	ldy #>in_filename
	jsr KERNAL_SETNAM // SETNAM. Set file name parameters. Input: A = File name length; X/Y = Pointer to file name.
	lda #$00
    ldx #<hibyte
	ldy #>lobyte
	jsr KERNAL_LOAD // A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
}
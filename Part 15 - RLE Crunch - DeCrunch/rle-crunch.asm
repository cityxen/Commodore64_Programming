*=$0801 "Basic"
BasicUpstart2(wtf)

wtf:
  jmp start

#import "Constants.asm"
#import "Macros.asm"
#import "print.il.asm"
#import "disk.il.asm"
#import "rle.il.asm"
#import "sys.il.asm"
#import "input.il.asm"
#import "string.il.asm"

.disk [filename="rle-crunch.d64", name="CXN RLE-CRUNCH", id="2025!" ] {
    [name="RLE-CRUNCH", type="prg",  segments="Default"],
    [name="--------------------",type="del"],
    [name="SCREENS", type="prg", prgFiles="prg_files/screens.prg"]
}

string_title:
.encoding "petscii_upper"
.text " -=*(CXN)*=- RLE CRUNCH TOOL 2025"
.byte $00

string_srcfile:
.encoding "screencode_upper"
.text "SCREENS          "
.byte 0
byte_srcfile_len:
.byte 0
string_destfile:
.encoding "screencode_upper"
.text "RLE-DATA         "
.byte 0
byte_destfile_len:
.byte 0
string_enter_src:
.encoding "petscii_upper"
.text "ENTER SRC FILENAME:"
.byte 0
string_enter_dest:
.encoding "petscii_upper"
.text "ENTER DST FILENAME:"
.byte 0
string_specify_load_address:
.encoding "petscii_upper"
.text "SAVE ADDRESS (HEX):"
.byte 0

start:
    lda #$00 
    sta BORDER_COLOR
    sta BACKGROUND_COLOR
    lda GREEN
    sta CURSOR_COLOR
    jsr KERNAL_CLEAR_SCREEN
    PrintChr(KEY_WHITE)
    Print(string_title)
    PrintChr(KEY_GREEN)   
    PrintChr(LINE_FEED)
    PrintChr(LINE_FEED)
    PrintChr(LINE_FEED)
    Print(string_enter_src)
    InputText2(string_srcfile,15,19,3,1)
    PrintChr(LINE_FEED)
    Print(string_enter_dest)
    InputText2(string_destfile,15,19,4,1)

    PrintChr(LINE_FEED)
    Print(string_specify_load_address)
    lda #53
    sta string_hex
    InputText2(string_hex,4,19,5,1) 
    jsr hexstr16_to_val

    PrintChr(LINE_FEED)
    PrintChr(LINE_FEED)
    Print(ztxts)
    PrintScreenCode2Petscii(string_srcfile)
    PrintChr(LINE_FEED)

    PrintChr(LINE_FEED)
    Print(ztxtd)
    PrintScreenCode2Petscii(string_destfile)

    SetFileName(string_srcfile)

    PrintChr(LINE_FEED)
    PrintChr(LINE_FEED)
    Print(ztxt)

    SetFileLocation($3000)
    jsr load_file

    lda file_loc_hi
    PrintHex()
    lda file_loc_lo
    PrintHex()

    Print(ztxt2)
    ldy #$00
    lda load_address_end_hi
    PrintHex()
    lda load_address_end_lo
    PrintHex()

    PrintChr($0d)
    Print(ztxtf)
    lda file_size_hi
    PrintHex()
    lda file_size_lo
    PrintHex()

    PrintChr($20)

    ldx file_size_lo
    lda file_size_hi
    jsr KERNAL_DEC_PRINT

    PrintChr(LINE_FEED)
    PrintChr(LINE_FEED)
    Print(ztxtc)
    PrintChr(LINE_FEED)
    PrintChr(LINE_FEED)

    ldx file_loc_lo
    lda file_loc_hi
    jsr KERNAL_DEC_PRINT

    PrintChr(LINE_FEED)

    ldx file_size_lo
    lda file_size_hi
    jsr KERNAL_DEC_PRINT
    PrintChr(LINE_FEED)

    RLE_SetSrc(file_loc)
    RLE_SetDest($5000)
    
    jsr rle_compress

    jsr show_stats

    Print(str_saving_1)
    PrintScreenCode2Petscii(string_destfile)

    Print(str_saving_2)
    lda hex_val+1
    sta save_addr+1
    PrintHex()
    lda hex_val
    sta save_addr
    PrintHex()

    lda hex_val+1
    clc
    adc rle_data_size+1
    sta save_addr_end+1

    lda hex_val
    clc
    adc rle_data_size
    sta save_addr_end

    clc
    inc save_addr_end
    bcc !+
    inc save_addr_end+1
!:

    PrintChr('-')
    PrintChr('$')
    lda save_addr_end+1
    sta file_loc_end_lo+1
    PrintHex()
    lda save_addr_end
    sta file_loc_end_lo
    PrintHex()

    StrLen(string_destfile)   
    StrCpyL(string_destfile,filename,str_len)
    StrScreenCodeToPetscii(filename,str_len)
    lda str_len
    sta filename_length

    SetFileLocation(save_addr)
    SetFileLocationEnd(save_addr_end)

    // PrintChr($0d)
    // Print(filename)
    // PrintChr($0d)
    // lda drive_number
    // PrintHex()
    // PrintChr($0d)

    jsr save_data


main_loop:    
    rts // jmp main_loop
    
save_addr:
.byte 0
.byte 0
save_addr_end:
.byte 0
.byte 0


show_stats:

  lda zp_dest
  clc
  sbc zp_rle_start
  sta rle_data_size_lo

  lda zp_dest+1
  sbc zp_rle_start+1
  sta rle_data_size_hi

  Print(ztxte)

  lda rle_data_size+1
  PrintHex()
  lda rle_data_size
  PrintHex()

  PrintChr(' ')

  ldx rle_data_size_lo // rle_data
  lda rle_data_size_lo+1 // rle_data
  jsr KERNAL_DEC_PRINT

  lda #<msg1
  ldy #>msg1
  jsr KERNAL_STROUT
  ldx zp_rle_start // zp_dest // rle_data
  lda zp_rle_start+1 // zp_dest+1 // rle_data
  jsr KERNAL_DEC_PRINT
  lda #'-'
  jsr KERNAL_CHROUT
  ldx zp_rle_end
  lda zp_rle_end+1
  jsr KERNAL_DEC_PRINT
  lda #<msg2
  ldy #>msg2
  jsr KERNAL_STROUT
  lda zp_rle_start+1
  jsr print_hex
  lda zp_rle_start
  jsr print_hex
  lda #KEY_CURSOR_RIGHT
  jsr KERNAL_CHROUT
  jsr KERNAL_CHROUT
  lda zp_rle_end+1
  jsr print_hex
  lda zp_rle_end
  jsr print_hex
  lda #13
  jsr KERNAL_CHROUT
  rts

// *********************************************************
    
ztxt:
.text "LOADING FROM $"
.byte 0
str_saving_1:
.text "SAVING ["
.byte 0
str_saving_2:
.text "] $"
.byte 0
ztxt2:
.text "-$"
.byte 0
ztxts:
.text "SRC:"
.byte 0
ztxtd:
.text "DST:"
.byte 0
ztxtc:
.text "CRUNCHING..."
.byte 0
ztxte:
.text "RLE DATA SIZE:"
.byte 0
ztxtf:
.text "DATA SIZE:"
.byte 0

msg1:
.encoding "petscii_mixed"
.byte 13
.text "rle data: "
.byte 0
.byte 0
msg2:
.encoding "petscii_mixed"
.text " ($xxxx-$xxxx)"
.fill 11,157
.byte 0


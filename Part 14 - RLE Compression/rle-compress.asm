///////////////////////////////////////////////////
// Perform basic RLE compression on data - 17-Apr-2024 by KPK
// 
// Converted to KickAssembler 01-Feb-2025 by Deadline
//
///////////////////////////////////////////////////

.const zp_src     = $fb // $fc
.const zp_dest    = $fd // $fe
.const strout     = $ab1e
.const line_print = $bdcd
.const rle_data   = $3000
.const chrout     = $ffd2

* = $0801 "BASIC STARTUP" // start of basic
  BasicUpstart2(start)

* = $080d "Start"

start:
  jsr generate_rle_data
  jsr show_stats
  rts

generate_rle_data:
  lda #<screen_data
  sta zp_src
  lda #>screen_data
  sta zp_src+1
  lda #<rle_data
  sta zp_dest
  lda #>rle_data
  sta zp_dest+1
  ldy #0
  lda (zp_src),y
  sta rle_byte
  inc rle_count
  inc zp_src

gr_loop:
  lda (zp_src),y
  cmp rle_byte
  bne gr_diff

gr_same:
  lda rle_count
  cmp #255
  bne gr_next

gr_diff:
  lda rle_count
  sta (zp_dest),y
  lda rle_byte
  iny
  sta (zp_dest),y
  dey
  lda (zp_src),y
  sta rle_byte
  lda #0
  sta rle_count
  clc
  lda zp_dest
  adc #2
  sta zp_dest
  bcc gr_next
  inc zp_dest+1

gr_next:
  inc rle_count
  inc zp_src
  bne !+
  inc zp_src+1
!:
  lda zp_src+1
  cmp #>end_of_data+1
  bcc gr_loop
  lda zp_src
  cmp #<end_of_data+1
  bcc gr_loop

  lda rle_count
  beq !+
  sta (zp_dest),y
  iny
  lda rle_byte
  sta (zp_dest),y
  iny
  lda #0
  sta (zp_dest),y
  iny
  sta (zp_dest),y
!:
  rts

///////////////////////////////////////////////////

show_stats:
  lda #<msg1
  ldy #>msg1
  jsr strout
  ldx #<rle_data
  lda #>rle_data
  jsr line_print
  lda #'-'
  jsr chrout
  lda zp_dest
  clc
  adc #3
  sta zp_dest
  bcc !+
  inc zp_dest+1
!:
  ldx zp_dest
  lda zp_dest+1
  jsr line_print
  lda #<msg2
  ldy #>msg2
  jsr strout
  lda #>rle_data
  jsr print_hex
  lda #<rle_data
  jsr print_hex
  lda #29
  jsr chrout
  jsr chrout
  lda zp_dest+1
  jsr print_hex
  lda zp_dest
  jsr print_hex
  lda #13
  jsr chrout
  rts

///////////////////////////////////////////////////

print_hex:
  pha
  lsr
  lsr
  lsr
  lsr
  jsr print_digit
  pla
  and #$0f
  jsr print_digit
  rts

print_digit:
  cmp #10
  bcc !+
  adc #6
!:
  adc #48
  jsr chrout
  rts

///////////////////////////////////////////////////

rle_count:
.byte 0
rle_byte:
.byte 1
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


*=$091c "Screens Data"
screen_data: // start of screen data
#import "screendata.asm"
end_of_data: // end of screen data

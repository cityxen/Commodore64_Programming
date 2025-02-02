; Petmate Screen - Adapted for Acme Compiler by KPK on 17-Apr-2024

!addr zp_src       = $fb ; and $fc
!addr zp_dest      = $fd ; and $fe
!addr text_color   = $0286
!addr screenram    = $0400
!addr screen_data  = $2000
!addr border_color = $d020
!addr bkgnd_color  = $d021
!addr colorram     = $d800
!addr chrout       = $ffd2
!addr stop         = $ffe1
!addr getin        = $ffe4

black = 0
white = 1
cls   = 147

* = $0801 ; start of basic
!pet 11,8,232,7,158,"2061",0,0,0 ; basic loader

start:
  lda #black
  sta border_color
  sta bkgnd_color
  lda #white
  sta text_color
  sta menuflag
  lda #cls
  jsr chrout
  jsr rle_decompress
  jsr write_instructions

mainloop:
  jsr getin
- cmp #"1"
  bne +
  ldx #<screen_data
  ldy #>screen_data
  jsr drawpetmatescreen
  beq mainloop
+ cmp #"2"
  bne +
  ldx #<screen_data+2002
  ldy #>screen_data+2002
  jsr drawpetmatescreen
  beq mainloop
+ cmp #"3"
  bne +
  ldx #<screen_data+4004
  ldy #>screen_data+4004
  jsr drawpetmatescreen
  beq mainloop
+ cmp #"4"
  bne +
  ldx #<screen_data+6006
  ldy #>screen_data+6006
  jsr drawpetmatescreen
  beq mainloop
+ cmp #"M" ; toggle menu on or off
  bne +
  lda menuflag
  eor #$ff
  sta menuflag
  lda lastkey
  jmp -
+ jsr stop ;check for stop key
  bne mainloop
  lda #cls
  jsr chrout
  lda #black
  sta border_color
  sta bkgnd_color
  rts

drawpetmatescreen:
  sta lastkey
  stx zp_src
  sty zp_src+1
  ldy #$00
  lda (zp_src),y
  sta border_color
  iny
  lda (zp_src),y
  sta bkgnd_color
  dey
  lda zp_src
  clc
  adc #$02
  sta zp_src
  bcc +
  inc zp_src+1
+ lda #<screenram ; copy screen data
  sta zp_dest
  lda #>screenram
  sta zp_dest+1
  ldx #$04
- lda (zp_src),y
  sta (zp_dest),y
  iny
  bne -
  inc zp_src+1
  inc zp_dest+1
  dex
  bne -
  lda zp_src ; copy color data
  sec
  sbc #24 ; skip 1000 bytes (1024 - 24)
  sta zp_src
  bcs +
  dec zp_src+1
+ lda #<colorram
  sta zp_dest
  lda #>colorram
  sta zp_dest+1
  ldx #$04
- lda (zp_src),y
  sta (zp_dest),y
  iny
  bne -
  inc zp_src+1
  inc zp_dest+1
  dex
  bne -
  jsr write_instructions
  rts

write_instructions:
  lda menuflag
  and #1
  beq +
  ldx #0
- lda instructions,x
  beq +
  sta $07c4,x
  lda #white
  sta $dbc4,x
  inx
  bne -
+ rts

rle_decompress: ; decompress rle-encoded screen data
  lda #<screen_data_rle
  sta zp_src
  lda #>screen_data_rle
  sta zp_src+1
  lda #<screen_data
  sta zp_dest
  lda #>screen_data
  sta zp_dest+1
-- ldy #0
  lda (zp_src),y
  beq ++
  tax
  pha
  iny
  lda (zp_src),y
  dey
- sta (zp_dest),y
  iny
  dex
  bne -
  pla
  clc
  adc zp_dest
  sta zp_dest
  bcc +
  inc zp_dest+1
+ lda zp_src
  clc
  adc #2
  sta zp_src
  bcc +
  inc zp_src+1
+ jmp --
++ rts

menuflag: !byte 1
lastkey:  !fill 1
instructions: !scr " press 1 to 4 to change screens ",0
!src "screendata_rle.asm"
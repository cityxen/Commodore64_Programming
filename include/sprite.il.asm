////////////////////////////////////////
// Sprite lib

.const rs_srcLo              = $fb
.const rs_srcHi              = $fc
.const rs_destLo             = $fd
.const rs_destHi             = $fe
.const rs_tempByte           = $02
.const rs_flippedByte        = $03

.macro SpriteSetSrcDest(sprite_src_ptr, sprite_dest_ptr) {
	ldx #sprite_src_ptr
	jsr calc_sprite_src
	ldx #sprite_dest_ptr
	jsr calc_sprite_dest
}

.macro CopySprite(sprite_src_ptr,sprite_dest_ptr) {
	SpriteSetSrcDest(sprite_src_ptr,sprite_dest_ptr)
	jsr copy_sprite
}

.macro ReverseSpriteMultiColor(sprite_src_ptr,sprite_dest_ptr) {
	SpriteSetSrcDest(sprite_src_ptr,sprite_dest_ptr)
	jsr reverse_sprite_multicolor
}

.macro ReverseSpriteMultiColorA(sp_ptr) {
    
    tax
    jsr calc_sprite_src

    ldx #sp_ptr
	jsr calc_sprite_dest

    jsr reverse_sprite_multicolor    
}
  

reverse_sprite_multicolor: // calc rs_src and rs_dest before hand
    ldy #$00
!:
    lda (rs_srcLo),y
    jsr rs_flip_multicolor_byte
    iny
    iny
    sta (rs_destLo),y
    dey
    dey

    iny
    lda (rs_srcLo),y
    jsr rs_flip_multicolor_byte
    sta (rs_destLo),y
    
    iny
    lda (rs_srcLo),y
    jsr rs_flip_multicolor_byte
    dey
    dey
    sta (rs_destLo),y
    iny
    iny
    iny

    cpy #$3f
    bne !-
    rts

rs_flip_multicolor_byte:
    sta rs_tempByte
    lda rs_tempByte
    and #%00000011
    asl
    asl
    asl
    asl
    asl
    asl
    sta rs_flippedByte
    lda rs_tempByte
    and #%00001100
    asl
    asl
    ora rs_flippedByte
    sta rs_flippedByte
    lda rs_tempByte
    and #%00110000
    lsr
    lsr
    ora rs_flippedByte
    sta rs_flippedByte
    lda rs_tempByte
    and #%11000000
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    ora rs_flippedByte
    sta rs_flippedByte
    rts

calc_sprite_src: // ( ldx #$c8 -> rs_src = $3200
    stx rs_srcHi
    txa
    asl             // *2
    asl             // *4
    asl             // *8
    asl             // *16
    asl             // *32
    asl             // *64
    sta rs_srcLo        // low byte
    lda rs_srcHi
    lsr
    lsr             // pointer / 4
    sta rs_srcHi        // high byte
    rts

calc_sprite_dest:
    stx rs_destHi
    txa
    asl             // *2
    asl             // *4
    asl             // *8
    asl             // *16
    asl             // *32
    asl             // *64
    sta rs_destLo        // low byte
    lda rs_destHi
    lsr
    lsr             // pointer / 4
    sta rs_destHi        // high byte
    rts

copy_sprite: // rs_src to rs_dest
    ldy #$00
!:
    lda (rs_srcLo),y
    sta (rs_destLo),y
    iny
    cpy #$3f
    bne !-
    rts

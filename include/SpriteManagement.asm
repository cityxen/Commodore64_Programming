This is not a good example of how to do sprite management. 
It is more of an experiment with the KickAssembler macro
system, and should not be used.
This is a deliberate error to force you to read this.
Do not use this code, it is horrible!
I'll be working on a new method of sprite management in 
the future.

- Deadline
//////////////////////////////////////////////////////////////////////////////////////
// CityXen - https://linktr.ee/cityxen
//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: Macros: SpriteManagement
//////////////////////////////////////////////////////////////////////////////////////

.macro InitializeSpritesAlt(sprite_table) {
    ////////////////////////////////////////////////////////////
    // sprite_initial_visible:
    lda sprite_table+0
    sta SPRITE_ENABLE
    sta sprite_table+1
    sta sprite_default_table+1
    ////////////////////////////////////////////////////////////
    // sprite_intial_size
    lda sprite_table+2
    sta SPRITE_EXPAND_X
    sta sprite_table+4
    sta sprite_default_table+4
    lda sprite_table+3
    sta SPRITE_EXPAND_Y
    sta sprite_table+5
    sta sprite_default_table+5
    ////////////////////////////////////////////////////////////
    // sprite_initial_color
    ldx #$00 // COLORS
sprite_initial_colors_loop:
    lda sprite_table+6,x
    sta SPRITE_COLORS,x
    sta sprite_table+14,x
    sta sprite_default_table+14,x
    inx
    cpx #$08
    bne sprite_initial_colors_loop
    ////////////////////////////////////////////////////////////
    // sprite_initial_multicolor_colors_table:
    lda sprite_table+22
    sta SPRITE_MULTICOLOR_0
    sta sprite_table+24
    sta sprite_default_table+24
    lda sprite_table+23
    sta SPRITE_MULTICOLOR_1
    sta sprite_table+25
    sta sprite_default_table+25
    ////////////////////////////////////////////////////////////
    // sprite multicolor
    lda sprite_table+26
    sta SPRITE_MULTICOLOR
    sta sprite_table+27
    sta sprite_default_table+27
    ////////////////////////////////////////////////////////////
    // sprite_initial_loc_table:
    ldx #$00 // LOCATIONS
    ldy #$00
sprite_initial_locations_loop:
    lda sprite_table+28,x // msb
    sta sprite_table+52,x
    sta sprite_default_table+52,x
    ora #SPRITE_LOCATIONS_MSB
    sta SPRITE_LOCATIONS_MSB    
    inx
    lda sprite_table+28,x // sprite x loc
    sta SPRITE_LOCATIONS,y
    sta sprite_table+52,x
    sta sprite_default_table+52,x
    inx
    iny
    lda sprite_table+28,x // sprite y loc
    sta SPRITE_LOCATIONS,y
    sta sprite_table+52,x
    sta sprite_default_table+52,x
    iny
    inx
    cpx #24
    beq sprite_initial_locations_exit
    jmp sprite_initial_locations_loop
sprite_initial_locations_exit:

    ////////////////////////////////////////////////////////////
    // sprite_initial_anim_settings

    lda sprites_default_animated+0
    sta sprites_default_animated+1
    
    ldx #$00
!loop:
    lda sprite_initial_anim_index_table,x
    sta sprite_anim_index_table,x
    inx
    cpx #$08
    bne !loop-

    ldx #$00
!loop:
    lda sprite_initial_anim_speed_table,x
    sta sprite_anim_speed_table,x
    inx
    cpx #$08
    bne !loop-
}

.macro SetSpriteColor(sprite,color) {
    lda #color
    ldx #sprite
    sta sprite_color_table,x
}

.macro AssignSpriteAnim(sprite,anim) {
    lda #$00
    sta sprite_anim_index_table+sprite
    lda #<anim
    sta sprite_anim_assigned_table+0+sprite*2
    lda #>anim
    sta sprite_anim_assigned_table+1+sprite*2
}

.macro MoveSprite(sprite_no,sprx,spry) {
    .var msb=0
    .if(sprx>255) {
        .eval sprx=sprx-255;
        .eval msb=pow(sprite_no,2)
    }
    .print "sprite_no=" + sprite_no
    .print "sprx= " +sprx
    .print "spry= " +spry
    .print "msb= " + msb
    clc
    lda #msb
    sta sprite_default_table+52+(3*sprite_no)
    lda #sprx
    sta sprite_default_table+53+(3*sprite_no)
    lda #spry
    sta sprite_default_table+54+(3*sprite_no)
}

.macro UpdateSprites() {
    ////////////////////////////////////////////////////////////
    // sprite_initial_visible:
    lda sprite_default_table+1
    sta SPRITE_ENABLE
    ////////////////////////////////////////////////////////////
    // sprite_initial_loc_table:
    lda #$00
    sta TEMP_6
    clc
    ldx #$00 // LOCATIONS
    ldy #$00
sprite_locations_loop:
    lda sprite_default_table+52,x // msb
    ora TEMP_6
    sta TEMP_6
    // sta SPRITE_LOCATIONS_MSB
    inx
    lda sprite_default_table+52,x // sprite x loc
    sta SPRITE_LOCATIONS,y
    inx
    iny
    lda sprite_default_table+52,x // sprite y loc
    sta SPRITE_LOCATIONS,y
    iny
    inx
    cpx #$18
    beq sprite_locations_exit
    jmp sprite_locations_loop
sprite_locations_exit:
    lda TEMP_6
    sta SPRITE_LOCATIONS_MSB
    ////////////////////////////////////////////////////////////
    // sprite_initial_color
    ldx #$00 // COLORS
sprite_initial_colors_loop:
    lda sprite_default_table+14,x
    sta SPRITE_COLORS,x
    inx
    cpx #$08
    bne sprite_initial_colors_loop
    ////////////////////////////////////////////////////////////
    // sprite_initial_multicolor_colors_table:
    lda sprite_default_table+24
    sta SPRITE_MULTICOLOR_0
    lda sprite_default_table+25
    sta SPRITE_MULTICOLOR_1
    ////////////////////////////////////////////////////////////
    // sprite multicolor
    lda sprite_default_table+27
    sta SPRITE_MULTICOLOR
    ////////////////////////////////////////////////////////////
    // sprite_intial_size
    lda sprite_default_table+4
    sta SPRITE_EXPAND_X
    lda sprite_default_table+5
    sta SPRITE_EXPAND_Y

// sprite animations

animate_sprite_0: // animate sprite 0
    lda sprites_animated
    and #$01
    cmp #$01
    bne animate_sprite_1
    inc sprite_0_anim_timer_var
    lda sprite_0_anim_timer_var
    cmp sprite_anim_speed+0
    beq exit_timer_s0
    jmp animate_sprite_1
exit_timer_s0:
    lda #$00  // reset timer
    sta sprite_0_anim_timer_var
    clc
    inc sprite_anim_index_table+0
    ldy sprite_anim_index_table+0
    lda sprite_0_anim_assigned
    sta TEMP_1
    lda sprite_0_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as01
    ldy #$00
as01:
    sty sprite_anim_index_table+0
    lda (TEMP_1),y
    sta SPRITE_0_POINTER

animate_sprite_1: // animate sprite 1
    lda sprites_animated
    and #$02
    cmp #$02
    bne animate_sprite_2
    inc sprite_1_anim_timer_var
    lda sprite_1_anim_timer_var
    cmp sprite_anim_speed+1
    beq exit_timer_s1
    jmp animate_sprite_2
exit_timer_s1:
    lda #$00  // reset timer
    sta sprite_1_anim_timer_var
    clc
    inc sprite_anim_index_table+1
    ldy sprite_anim_index_table+1
    lda sprite_1_anim_assigned
    sta TEMP_1
    lda sprite_1_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as11
    ldy #$00
as11:
    sty sprite_anim_index_table+1
    lda (TEMP_1),y
    sta SPRITE_1_POINTER

animate_sprite_2: // animate sprite 2
    lda sprites_animated
    and #$04
    cmp #$04
    bne animate_sprite_3
    inc sprite_2_anim_timer_var
    lda sprite_2_anim_timer_var
    cmp sprite_anim_speed+2
    beq exit_timer_s2
    jmp animate_sprite_3
exit_timer_s2:
    lda #$00  // reset timer
    sta sprite_2_anim_timer_var
    clc
    inc sprite_anim_index_table+2
    ldy sprite_anim_index_table+2
    lda sprite_2_anim_assigned
    sta TEMP_1
    lda sprite_2_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as21
    ldy #$00
as21:
    sty sprite_anim_index_table+2
    lda (TEMP_1),y
    sta SPRITE_2_POINTER

animate_sprite_3: // animate sprite 3
    lda sprites_animated
    and #$08
    cmp #$08
    bne animate_sprite_4
    inc sprite_3_anim_timer_var
    lda sprite_3_anim_timer_var
    cmp sprite_anim_speed+3
    beq exit_timer_s3
    jmp animate_sprite_4
exit_timer_s3:
    lda #$00  // reset timer
    sta sprite_3_anim_timer_var
    clc
    inc sprite_anim_index_table+3
    ldy sprite_anim_index_table+3
    lda sprite_3_anim_assigned
    sta TEMP_1
    lda sprite_3_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as31
    ldy #$00
as31:
    sty sprite_anim_index_table+3
    lda (TEMP_1),y
    sta SPRITE_3_POINTER

animate_sprite_4: // animate sprite 4
    lda sprites_animated
    and #$10
    cmp #$10
    bne animate_sprite_5
    inc sprite_4_anim_timer_var
    lda sprite_4_anim_timer_var
    cmp sprite_anim_speed+4
    beq exit_timer_s4
    jmp animate_sprite_5
exit_timer_s4:
    lda #$00  // reset timer
    sta sprite_4_anim_timer_var
    clc
    inc sprite_anim_index_table+4
    ldy sprite_anim_index_table+4
    lda sprite_4_anim_assigned
    sta TEMP_1
    lda sprite_4_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as41
    ldy #$00
as41:
    sty sprite_anim_index_table+4
    lda (TEMP_1),y
    sta SPRITE_4_POINTER

animate_sprite_5: // animate sprite 5
    lda sprites_animated
    and #$20
    cmp #$20
    bne animate_sprite_6
    inc sprite_5_anim_timer_var
    lda sprite_5_anim_timer_var
    cmp sprite_anim_speed+5
    beq exit_timer_s5
    jmp animate_sprite_6
exit_timer_s5:
    lda #$00  // reset timer
    sta sprite_5_anim_timer_var
    clc
    inc sprite_anim_index_table+5
    ldy sprite_anim_index_table+5
    lda sprite_5_anim_assigned
    sta TEMP_1
    lda sprite_5_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as51
    ldy #$00
as51:
    sty sprite_anim_index_table+5
    lda (TEMP_1),y
    sta SPRITE_5_POINTER


animate_sprite_6: // animate sprite 6
    lda sprites_animated
    and #$40
    cmp #$40
    bne animate_sprite_7
    inc sprite_6_anim_timer_var
    lda sprite_6_anim_timer_var
    cmp sprite_anim_speed+6
    beq exit_timer_s6
    jmp animate_sprite_7
exit_timer_s6:
    lda #$00  // reset timer
    sta sprite_6_anim_timer_var
    clc
    inc sprite_anim_index_table+6
    ldy sprite_anim_index_table+6
    lda sprite_6_anim_assigned
    sta TEMP_1
    lda sprite_6_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as61
    ldy #$00
as61:
    sty sprite_anim_index_table+6
    lda (TEMP_1),y
    sta SPRITE_6_POINTER


animate_sprite_7: // animate sprite 7
    lda sprites_animated
    and #$80
    cmp #$80
    bne animate_sprite_done
    inc sprite_7_anim_timer_var
    lda sprite_7_anim_timer_var
    cmp sprite_anim_speed+7
    beq exit_timer_s7
    jmp animate_sprite_done
exit_timer_s7:
    lda #$00  // reset timer
    sta sprite_7_anim_timer_var
    clc
    inc sprite_anim_index_table+7
    ldy sprite_anim_index_table+7
    lda sprite_7_anim_assigned
    sta TEMP_1
    lda sprite_7_anim_assigned+1
    sta TEMP_2
    lda (TEMP_1),y
    bne as71
    ldy #$00
as71:
    sty sprite_anim_index_table+7
    lda (TEMP_1),y
    sta SPRITE_7_POINTER


animate_sprite_done:
end_animate_sprites:
updateexit:
}


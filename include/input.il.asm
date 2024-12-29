//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

.macro WaitKey() {
!:
    jsr KERNAL_GETIN
    beq !-
}

.macro KeySub(key,subroutine) {
    cmp #key
    bne !+
    jsr subroutine
    jmp main_loop
!:
}

.macro KeySubNoMain(key,subroutine) {
    cmp #key
    bne !+
    jsr subroutine
!:
}

.macro KeySubWait(key,subroutine) {
    cmp #key
    bne !+
    jsr subroutine
    WaitKey()
    jmp main_loop
!:
}

////////////////////////////////////////////////////////////
// Keyboard
k_value: 	.byte 0

get_key:
il_get_key: // subroutine
	// lda trig_input // timer stuff
	// beq !gb+
	jsr KERNAL_GETIN
	bne !+
	// lda #$ff
!:
	sta k_value
	// jsr reset_input_timer
	rts

////////////////////////////////////////////////////////////
// Joystick 1

j1_up:		.byte 0
j1_down:	.byte 0
j1_left:	.byte 0
j1_right:	.byte 0
j1_button:	.byte 0

get_j1_m2:
il_get_j1_m2: // subroutine from https://codebase64.org/doku.php?id=base:joystick_input_handling
	lda JOYSTICK_PORT_1 // read joystick port 1
	lsr       // get switch bits
	ror j1_up    // switch_history = switch_history/2 + 128*current_switch_state
	lsr       // update the other switches' history the same way
	ror j1_down
	lsr
	ror j1_left
	lsr
	ror j1_right
	lsr
	ror j1_button
	rts

////////////////////////////////////////////////////////////
// Joystick 2

j2_up:     	.byte 0
j2_down:   	.byte 0
j2_left:   	.byte 0
j2_right:  	.byte 0
j2_button:	.byte 0

get_j2_m2:
il_get_j2_m2: // subroutine from https://codebase64.org/doku.php?id=base:joystick_input_handling
	lda JOYSTICK_PORT_2 // read joystick port 2
	lsr       // get switch bits
	ror j2_up    // switch_history = switch_history/2 + 128*current_switch_state
	lsr       // update the other switches' history the same way
	ror j2_down
	lsr
	ror j2_left
	lsr
	ror j2_right
	lsr
	ror j2_button
	rts

////////////////////////////////////////////////////////////
// Any Input at all

i_compare: .byte 0

get_any_input:
il_get_any_input: // subroutine

    lda #$00;
	sta i_compare
    // return val if keyboard or joyports are hit

    jsr il_get_j1_m2

	lda j1_button
	cmp #$ff
	beq !+
	inc i_compare
!:
	lda j1_up
	cmp #$ff
	beq !+
	inc i_compare
!:

	lda j1_left
	cmp #$ff
	beq !+
	inc i_compare
!:

	lda j1_right
	cmp #$ff
	beq !+
	inc i_compare
!:	

	lda j1_down
	cmp #$ff
	beq !+
	inc i_compare
!:
	

    jsr il_get_j2_m2


	lda j2_button
	cmp #$ff
	beq !+
	inc i_compare
!:
	lda j2_up
	cmp #$ff
	beq !+
	inc i_compare
!:

	lda j2_left
	cmp #$ff
	beq !+
	inc i_compare
!:

	lda j2_right
	cmp #$ff
	beq !+
	inc i_compare
!:	

	lda j2_down
	cmp #$ff
	beq !+
	inc i_compare
!:

	jsr il_get_key

	lda i_compare
    ora k_value
    sta i_compare
    
    rts

////////////////////////////////////////////////////
// Input Text (method 2) (Up to 32 Bytes)

il_it2_txt_scr:
il_it2_txt_scr_lo:  .byte $00 // (Screen RAM Location)
il_it2_txt_scr_hi:  .byte $04 // (Screen RAM Location)
il_it2_txt_loc:
il_it2_txt_loc_lo:  .byte $00 // (String BUFFER Location)
il_it2_txt_loc_hi:  .byte $00 // (String BUFFER Location)
il_it2_txt_color_val: .byte $01 // Actual color
il_it2_txt_color:  
il_it2_txt_color_lo:.byte $00 // Color RAM
il_it2_txt_color_hi:.byte $d8 // Color RAM
il_it2_txt_len:     .byte $20 // Length of string

il_it2_buffer: 
.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
il_it2_buffer_end:
.byte 0
il_it2_cursor:  .byte 0

.macro InputText2(original_str,len,x,y,color) {

    lda #<(55296+x+y*40)
    sta il_it2_txt_color_lo
    lda #>(55296+x+y*40)
    sta il_it2_txt_color_hi

    lda #len
    sta il_it2_txt_len

    lda #<(1024+x+y*40)
    sta il_it2_txt_scr_lo
    lda #>(1024+x+y*40)
    sta il_it2_txt_scr_hi

    lda #color
    lda #WHITE
    sta il_it2_txt_color_val

    lda #<original_str
    sta il_it2_txt_loc_lo
    lda #>original_str
    sta il_it2_txt_loc_hi
	jsr input_text2
}

input_text2:

    //////////////////////////////////
    // Populate zero page pointers
    // zp_ptr_screen
    // zp_ptr_color
    // zp_ptr_2

    lda il_it2_txt_loc_lo
    sta zp_ptr_2_lo
    lda il_it2_txt_loc_hi
    sta zp_ptr_2_hi

    lda il_it2_txt_scr_lo
    sta zp_ptr_screen_lo
    lda il_it2_txt_scr_hi
    sta zp_ptr_screen_hi

    lda il_it2_txt_color_lo
    sta zp_ptr_color_lo
    lda il_it2_txt_color_hi
    sta zp_ptr_color_hi

    ldy #$00 // Reverse the editing area

il_it2_reverse:
    lda il_it2_txt_color_val
    sta (zp_ptr_color),y    
    lda (zp_ptr_2),y
    cmp #$ff
    bne !+
    lda #$20
!:
    ora #$80
    sta (zp_ptr_screen),y
    iny
    cpy il_it2_txt_len
    bne il_it2_reverse

il_it2_kb_chk: // Check Keyboard loop
    clc
    lda $a2
    cmp #$10
    bcc il_it2_kb_chk_no_crs
    ldy il_it2_cursor
    lda (zp_ptr_screen),y
    cmp #$80
    bcs il_it2_kb_chk_crs_not_revd
    ora #$80
    sta (zp_ptr_screen),y
    jmp il_it2_kb_chk_no_crs
il_it2_kb_chk_crs_not_revd:
    and #$7f
    sta (zp_ptr_screen),y
il_it2_kb_chk_no_crs: // End of flash cursor stuff
    ldy il_it2_cursor
    cpy il_it2_txt_len
    bcc il_it2_kb_not_too_long
    ldy il_it2_txt_len
    dey
    sty il_it2_cursor
il_it2_kb_not_too_long:
    jsr KERNAL_GETIN
    cmp #$00
    beq il_it2_kb_chk
    cmp #13
    beq il_it2_kb_chk_end
    cmp #20
    bne il_it2_kb_chk_not_del
    ldy #il_it2_cursor
    cpy #$00
    beq il_it2_kb_chk_del_first_pos
    lda #$a0
    ldy il_it2_cursor
    sta (zp_ptr_screen),y
    sta (zp_ptr_2),y
    dec il_it2_cursor
    jmp il_it2_kb_chk
il_it2_kb_chk_del_first_pos:
    lda #$a0
    ldy #$00
    sta (zp_ptr_screen),y
    sta (zp_ptr_2),y
    jmp il_it2_kb_chk
il_it2_kb_chk_not_del:
    cmp #64
    bcc il_it2_kb_num
    sbc #64
il_it2_kb_num:
    ora #$80
    ldy il_it2_cursor
    sta (zp_ptr_screen),y
    sta (zp_ptr_2),y
    inc il_it2_cursor
    jmp il_it2_kb_chk
il_it2_kb_chk_end:
    lda #$00
    sta il_it2_cursor
    ldy #00
il_it2_rereverse:   // Done editing, re-reverse all the characters
    lda (zp_ptr_screen),y
    and #$7f
    sta (zp_ptr_screen),y
    sta (zp_ptr_2),y
    iny
    cpy il_it2_txt_len
    bne il_it2_rereverse
    ldy #$00
    ldy #$0f // fill in spaces on end with 0 (start at end and work backward)
il_it2_trim:
    lda (zp_ptr_2),y
    cmp #$ff
    beq !+
    cmp #$20
    bne il_it2_out
!:
    lda #00
    sta (zp_ptr_2),y
    dey
    jmp il_it2_trim
il_it2_out:
    rts
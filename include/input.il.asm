////////////////////////////////////////////////////////////
// Keyboard
k_value: 	.byte 0

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
// Input Text

.var il_input_text                = $450 // (Screen RAM Location) 16 bytes
.var il_input_text_color          = $d850
.var il_input_text_buffer         = $cfe0
.var il_input_text_buffer_end     = $cfd2
.var il_input_text_cursor         = $cfd3
.var il_input_text_length         = $cfd4

.macro InputText(x,y) {
    .eval il_input_text= 1024+(y*40+x)
	jsr input_text
}

input_text:
    
    ldx #$00 // Reverse the editing area
il_it_reverse:
    lda il_input_text,x
    ora #$80
    sta il_input_text,x
    lda #$01
    sta il_input_text_color,x
    inx
    cpx #$10
    bne il_it_reverse
il_it_kb_chk: // Check Keyboard loop
    clc
    lda $a2
    cmp #$10
    bcc il_it_kb_chk_no_crs
    ldx il_input_text_cursor
    lda il_input_text,x
    cmp #$80
    bcs il_it_kb_chk_crs_not_revd
    ora #$80
    sta il_input_text,x
    jmp il_it_kb_chk_no_crs
il_it_kb_chk_crs_not_revd:
    and #$7f
    sta il_input_text,x
il_it_kb_chk_no_crs: // End of flash cursor stuff
    ldx il_input_text_cursor
    cpx #$10
    bne il_it_kb_not_too_long
    ldx #$0f
    stx il_input_text_cursor
il_it_kb_not_too_long:
    jsr KERNAL_GETIN
    cmp #$00
    beq il_it_kb_chk
    cmp #13
    beq il_it_kb_chk_end
    cmp #20
    bne il_it_kb_chk_not_del
    ldx il_input_text_cursor
    cpx #$00
    beq il_it_kb_chk_del_first_pos
    lda #$a0
    ldx il_input_text_cursor
    sta il_input_text,x
    dec il_input_text_cursor
    jmp il_it_kb_chk
il_it_kb_chk_del_first_pos:
    lda #$a0
    sta il_input_text
    jmp il_it_kb_chk
il_it_kb_chk_not_del:
    cmp #64
    bcc il_it_kb_num
    sbc #64
il_it_kb_num:
    ora #$80
    ldx il_input_text_cursor
    sta il_input_text,x
    inc il_input_text_cursor
    jmp il_it_kb_chk
il_it_kb_chk_end:
    ldx #00
il_it_rereverse:   // Done editing, re-reverse all the characters
    lda il_input_text,x
    and #$7f
    sta il_input_text,x
    sta il_input_text_buffer,x
    inx
    cpx #$10
    bne il_it_rereverse
    ldx #$00
    ldx #$0f // fill in spaces on end with 0 (start at end and work backward)
il_it_trim:
    lda il_input_text_buffer,x
    cmp #$20
    bne il_it_out
    lda #00
    sta il_input_text_buffer,x
    dex
    jmp il_it_trim
il_it_out:
    rts
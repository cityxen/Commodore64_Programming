////////////////////////////////////////////////////////////
// Keyboard
k_value: 	.byte 0

get_key: // subroutine
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

get_j1_m2: // subroutine from https://codebase64.org/doku.php?id=base:joystick_input_handling
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

get_j2_m2: // subroutine from https://codebase64.org/doku.php?id=base:joystick_input_handling
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

get_any_input: // subroutine

    lda #$00;
	sta i_compare
    // return val if keyboard or joyports are hit

    jsr get_j1_m2

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
	

    jsr get_j2_m2


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

	jsr get_key

	lda i_compare
    ora k_value
    sta i_compare
    
    rts
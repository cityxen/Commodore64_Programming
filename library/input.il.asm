
i_value:
i_compare: .byte 0
get_input:
    lda #$00
    sta i_compare
    lda trig_joystick
    beq !gi+
    // return val if keyboard or joyports are hit
    jsr get_j1
    sta i_compare
    jsr get_j2
    ora i_compare
    sta i_compare
    jsr get_key
    ora i_compare
    sta i_compare
!gi:
    rts

get_j1:
	lda trig_joystick
	beq !gb+
	lda JOYSTICK_PORT_1
	rts
!gb:
	lda #$ff
	rts

get_j2:
	lda trig_joystick
	beq !gb+
	lda JOYSTICK_PORT_1
	rts
!gb:
	lda #$ff
	rts

get_key:
	lda trig_input
	beq !gb+
	jsr KERNAL_GETIN
	sta i_value
	jsr reset_input_timer
	lda i_value
	rts
!gb:
	lda #$00
	rts
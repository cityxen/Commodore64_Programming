//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: Joysticks Readers
//////////////////////////////////////////////////////////////////////////////////////
var_joy_1_x:
.byte 0
var_joy_1_y:
.byte 0
var_joy_1_fire:
.byte 0
var_joy_1_fire_released:
.byte 0
var_joy_2_x:
.byte 0
var_joy_2_y:
.byte 0
var_joy_2_fire:
.byte 0
var_joy_2_fire_released:
.byte 0

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Read joystick 1
//////////////////////////////////////////////////////////////////////////////////////
sub_read_joystick_1:
	lda JOYSTICK_PORT_1
	ldx #$00
	ldy #$00
	lsr
	bcs read_joystick_1_a
	dey
read_joystick_1_a:
	lsr
	bcs read_joystick_1_b
	iny
read_joystick_1_b:
	lsr
	bcs read_joystick_1_c
	dex
read_joystick_1_c:
	lsr
	bcs read_joystick_1_d
	inx
read_joystick_1_d:
	lsr
	stx var_joy_1_x
	sty var_joy_1_y
	bcc read_joystick_1_fire
	lda #$00
	sta var_joy_1_fire
	rts
read_joystick_1_fire:
	lda #$01
	sta var_joy_1_fire
	rts

//////////////////////////////////////////////////////////////////////////////////////
// Subroutine: Read joystick 2
//////////////////////////////////////////////////////////////////////////////////////
sub_read_joystick_2:
	lda JOYSTICK_PORT_2
	ldx #$00
	ldy #$00
	lsr
	bcs read_joystick_2_a
	dey
read_joystick_2_a:
	lsr
	bcs read_joystick_2_b
	iny
read_joystick_2_b:
	lsr
	bcs read_joystick_2_c
	dex
read_joystick_2_c:
	lsr
	bcs read_joystick_2_d
	inx
read_joystick_2_d:
	lsr
	stx var_joy_2_x
	sty var_joy_2_y
	bcc read_joystick_2_fire
	lda #$00
	sta var_joy_2_fire
	rts
read_joystick_2_fire:
	lda #$01
	sta var_joy_2_fire
	rts

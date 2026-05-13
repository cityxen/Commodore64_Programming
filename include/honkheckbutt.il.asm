//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

.const BUTTON_RED    = $FB // Buttons Stuff
.const BUTTON_GREEN  = $FE
.const BUTTON_YELLOW = $FD
.const BUTTON_BLUE   = $F7
.const BUTTON_WHITE  = $EF

.const J1_B_RED      = j1_left
.const J1_B_GREEN    = j1_up
.const J1_B_YELLOW   = j1_down
.const J1_B_BLUE     = j1_right
.const J1_B_WHITE    = j1_button

.const J2_B_RED      = j2_left
.const J2_B_GREEN    = j2_up
.const J2_B_YELLOW   = j2_down
.const J2_B_BLUE     = j2_right
.const J2_B_WHITE    = j2_button

.const BUTTON_LIGHT_GREEN   = %11111110 // Buttons Light / Action
.const BUTTON_LIGHT_YELLOW  = %11111101
.const BUTTON_LIGHT_BLUE    = %11111011
.const BUTTON_LIGHT_RED     = %11110111
.const BUTTON_LIGHT_WHITE   = %10111111
.const BUTTON_LIGHT_ALL     = %10110000

.const BUTTON_ACTION_MISS   = %11101111
.const BUTTON_ACTION_POW    = %11011111
.const BUTTON_ACTION_G_OVER = %01111111
.const BUTTON_LIGHT_NONE    = %11111111
.const BUTTON_ACTIONS       = %10110000
.const BUTTON_LIGHTS        = %01001111

// hhb_set_lights:    sta USER_PORT_DATA     rts
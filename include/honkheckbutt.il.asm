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
/*
.const BUTTON_RED    = $FB
.const BUTTON_GREEN  = $FE
.const BUTTON_YELLOW = $FD
.const BUTTON_BLUE   = $F7
.const BUTTON_WHITE  = $EF

.const BUTTON_LIGHT_GREEN  = %11111110
.const BUTTON_LIGHT_YELLOW = %11111101
.const BUTTON_LIGHT_BLUE   = %11111011
.const BUTTON_LIGHT_RED    = %11110111
.const BUTTON_LIGHT_WHITE  = %10111111
.const BUTTON_LIGHT_ALL    = %00000000
.const BUTTON_LIGHT_NONE   = %11111111
*/
// hhb_set_lights:    sta USER_PORT_DATA     rts
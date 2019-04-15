//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: Constants
//////////////////////////////////////////////////////////////////////////////////////
// MEMORY_CONSTANTS
.const PNTR                 = $D3
.const CURSOR_X_POS         = $D3
.const TBLX                 = $D6
.const CURSOR_Y_POS         = $D6
.const VICSCN               = $400
.const SCREEN_RAM           = $400
.const CURSOR_SET           = $E510
.const COLOR_RAM            = $D800
//////////////////////////////////////////////////////////////////////////////////////
// SPRITE POINTERS
.const SPRITE_0_POINTER     = $7F8
.const SPRITE_1_POINTER     = $7F9
.const SPRITE_2_POINTER     = $7FA
.const SPRITE_3_POINTER     = $7FB
.const SPRITE_4_POINTER     = $7FC
.const SPRITE_5_POINTER     = $7FD
.const SPRITE_6_POINTER     = $7FE
.const SPRITE_7_POINTER     = $7FF
//////////////////////////////////////////////////////////////////////////////////////
// VIC CONSTANTS
.const SPRITE_0_X           = $D000 // SP0X Sprite 0 Horizontal Position
.const SPRITE_0_Y           = $D001 // SP0Y Sprite 0 Vertical Position
.const SPRITE_1_X           = $D002 // SP1X Sprite 1 Horizontal Position
.const SPRITE_1_Y           = $D003 // SP1Y Sprite 1 Vertical Position
.const SPRITE_2_X           = $D004 // SP2X Sprite 2 Horizontal Position
.const SPRITE_2_Y           = $D005 // SP2Y Sprite 2 Vertical Position
.const SPRITE_3_X           = $D006 // SP3X Sprite 3 Horizontal Position
.const SPRITE_3_Y           = $D007 // SP3Y Sprite 3 Vertical Position
.const SPRITE_4_X           = $D008 // SP4X Sprite 4 Horizontal Position
.const SPRITE_4_Y           = $D009 // SP4Y Sprite 4 Vertical Position
.const SPRITE_5_X           = $D00A // SP5X Sprite 5 Horizontal Position
.const SPRITE_5_Y           = $D00B // SP5Y Sprite 5 Vertical Position
.const SPRITE_6_X           = $D00C // SP6X Sprite 6 Horizontal Position
.const SPRITE_6_Y           = $D00D // SP6Y Sprite 6 Vertical Position
.const SPRITE_7_X           = $D00E // SP7X Sprite 7 Horizontal Position
.const SPRITE_7_Y           = $D00F // SP7Y Sprite 7 Vertical Position
.const SPRITE_MSB_X         = $D010 // Most Significant Bits of Sprites 0-7 Horizontal Position
.const VIC_CONTROL_REG_1    = $D011 // RST8 ECM BMM DEN RSEL [ YSCROLL ]
.const VIC_RASTER_COUNTER   = $D012
.const VIC_LIGHT_PEN_X      = $D013
.const VIC_LIGHT_PEN_Y      = $D014
.const SPRITE_ENABLE        = $D015
.const VIC_CONTROL_REG_2    = $D016 // - - RES MCM CSEL [ XSCROLL ]
.const SPRITE_EXPAND_Y      = $D017 
.const VIC_MEM_POINTERS     = $D018 // VM13 VM12 VM11 VM10 CB13 CB12 CB11 -
.const VIC_INTERRUPT_REG    = $D019 // IRQ - - - ILP IMMC IMBC IRST
.const VIC_INTERRUPT_ENABLE = $D01A // - - - - ELP EMMC EMBC ERST
.const SPRITE_PRIORITY      = $D01B
.const SPRITE_MULTICOLOR    = $D01C
.const SPRITE_EXPAND_X      = $D01D
.const SPRITE_COLLISION_SPR = $D01E
.const SPRITE_COLLISION_DATA= $D01F
.const BORDER_COLOR         = $D020
.const BACKGROUND_COLOR     = $D021
.const BACKGROUND_COLOR_1   = $D022
.const BACKGROUND_COLOR_2   = $D023
.const BACKGROUND_COLOR_3   = $D024
.const SPRITE_MULTICOLOR_0  = $D025
.const SPRITE_MULTICOLOR_1  = $D026
.const SPRITE_0_COLOR       = $D027
.const SPRITE_1_COLOR       = $D028
.const SPRITE_2_COLOR       = $D029
.const SPRITE_3_COLOR       = $D02A
.const SPRITE_4_COLOR       = $D02B
.const SPRITE_5_COLOR       = $D02C
.const SPRITE_6_COLOR       = $D02D
.const SPRITE_7_COLOR       = $D02E
//////////////////////////////////////////////////////////////////////////////////////
// IO CONSTANTS
.const JOYSTICK_PORT_2      = $DC00
.const JOYSTICK_PORT_1      = $DC01
//////////////////////////////////////////////////////////////////////////////////////
// SID CONSTANTS
.const SID_V1_FREQ_LOW      = $D400 // (54272) frequency voice 1 low byte
.const SID_V1_FREQ_HIGH     = $D401 // (54273) frequency voice 1 high byte
.const SID_V1_PULSE_LOW     = $D402 // (54274) pulse wave duty cycle voice 1 low byte 7..4 3..0
.const SID_V1_PULSE_HIGH    = $D403 // (54275) pulse wave duty cycle voice 1 high byte
.const SID_V1_CONTROL_REG   = $D404 // (54276) control register voice 1 - 7 noise,6 pulse,5 sawtooth,4 triangle,3 test,2 ring modulation with voice 3,1 synchronize with voice 3,0 gate
.const SID_V1_ATK_DECAY     = $D405 // (54277) attack duration	decay duration voice 1
.const SID_V1_SUS_REL       = $D406 // (54278) sustain level	release duration
.const SID_V2_FREQ_LOW      = $D407 // (54279) frequency voice 2 low byte
.const SID_V2_FREQ_HIGH     = $D408 // (54280) frequency voice 2 high byte
.const SID_V2_PULSE_LOW     = $D409 // (54281) pulse wave duty cycle voice 2 low byte 7..4	3..0
.const SID_V2_PULSE_HIGH    = $D40A // (54275) pulse wave duty cycle voice 2 high byte
.const SID_V2_CONTROL_REG   = $D40B // (54283) control register voice 2 - 7 noise,6 pulse,5 sawtooth,4 triangle,3 test,2 ring modulation with voice 3,1 synchronize with voice 3,0 gate
.const SID_V2_ATK_DECAY     = $D40C // (54284) attack duration	decay duration voice 2
.const SID_V2_SUS_REL       = $D40D // (54285) sustain level	release duration voice 2
.const SID_V3_FREQ_LOW      = $D40E // (54286) frequency voice 3 low byte
.const SID_V3_FREQ_HIGH     = $D40F // (54287) frequency voice 3 high byte
.const SID_V3_PULSE_LOW     = $D410 // (54288) pulse wave duty cycle voice 3 low byte 7..4	3..0
.const SID_V3_PULSE_HIGH    = $D411 // (54275) pulse wave duty cycle voice 3 high byte
.const SID_V3_CONTROL_REG   = $D412 // (54290) control register voice 3 - 7 noise,6 pulse,5 sawtooth,4 triangle,3 test,2 ring modulation with voice 3,1 synchronize with voice 3,0 gate
.const SID_V3_ATK_DECAY     = $D413 // (54291) attack duration	decay duration voice 3
.const SID_V3_SUS_REL       = $D414 // (54292) sustain level	release duration voice 3
.const SID_FILTER_CUTOFF_LOW= $D415 // (54293) filter cutoff frequency low byte
.const SID_FILTER_CUTOFF_HIGH=$D416 // (54294) filter cutoff frequency high byte
.const SID_FILTER_RESONANCE = $D417 // (54295) filter resonance and routing - 7..4 - filter resonance, 3 - external input, 2 - voice 3, 1 - voice 2, 0 - voice 1
.const SID_VOLUME_FILTER    = $D418 // (54296) filter mode and main volume control - 7 - mute voice 3, 6 - high pass, 5 - band pass, 4 - low pass, 3..0 - main volume
.const PADDLE_X             = $D419 // (54297) paddle x value (read only)
.const PADDLE_Y             = $D41A // (54298) paddle y value (read only)
.const SID_OSCILLATOR_V3    = $D41B // (54299) oscillator voice 3 (read only)
.const SID_ENVELOPE_V3      = $D41C // (54300) envelope voice 3 (read only)
//////////////////////////////////////////////////////////////////////////////////////
// 1541 Ultimate II Command Interface
.const UII_CONTROL          = $DF1C // CONTROL REGISTER (WRITE)
.const UII_STATUS           = $DF1C // STATUS REGISTER (READ) $00
.const UII_COMMAND          = $DF1D // COMMAND DATA REGISTER (WRITE)
.const UII_ID               = $DF1D // IDENTIFICATION REGISTER (READ) $C9
.const UII_RESPONSE         = $DF1E // RESPONSE DATA REGISTER (READ ONLY)
.const UII_STATUS_DATA      = $DF1F // STATUS DATA REGISTER
//////////////////////////////////////////////////////////////////////////////////////
// KERNAL SUB ROUTINES
.const KERNAL_PRINT_HEX     = $BDCD // Print 16 bit number to screen LDX lobyte LDA hibyte
.const KERNAL_SCINIT        = $FF81 // Input: – Output: – Used registers: A, X, Y
.const KERNAL_IOINIT        = $FF84 // Input: – Output: – Used registers: A, X
.const KERNAL_RAMTAS        = $FF87 // Input: – Output: – Used registers: A, X, Y
.const KERNAL_RESTOR        = $FF8A // Input: – Output: – Used registers: –
.const KERNAL_VECTOR        = $FF8D // Input: Carry: 0 = Copy user table into vector table, 1 = Copy vector table into user table; X/Y = Pointer to user table. Output: – Used registers: A, Y
.const KERNAL_SETMSG        = $FF90 // Input: A = Switch value. Output: – Used registers: –
.const KERNAL_LSTNSA        = $FF93 // Input: A = Secondary address Output: – Used registers: A
.const KERNAL_TALKSA        = $FF96 // Input: A = Secondary address Output: – Used registers: A
.const KERNAL_MEMBOT        = $FF99 // Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0) Output: X/Y = Address (if Carry = 1) Used registers: X, Y
.const KERNAL_MEMTOP        = $FF9C // Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0) Output: X/Y = Address (if Carry = 1) Used registers: X, Y
.const KERNAL_SCNKEY        = $FF9F // Input: – Output: – Used registers: A, X, Y
.const KERNAL_SETTMO        = $FFA2 // Input: A = Timeout value Output: – Used registers: –
.const KERNAL_IECIN         = $FFA5 // Input: – Output: A = Byte read Used registers: A
.const KERNAL_IECOUT        = $FFA8 // Input: A = Byte to write Output: – Used registers: –
.const KERNAL_UNTALK        = $FFAB // Input: – Output: – Used registers: A
.const KERNAL_UNLSTN        = $FFAE // Input: – Output: – Used registers: A
.const KERNAL_LISTEN        = $FFB1 // Input: A = Device number Output: – Used registers: A
.const KERNAL_TALK          = $FFB4 // Input: A = Device number Output: – Used registers: A
.const KERNAL_READST        = $FFB7 // Input: – Output: A = Device status Used registers: A
.const KERNAL_SETLFS        = $FFBA // Input: A = Logical number; X = Device number; Y = Secondary address Output: – Used registers: –
.const KERNAL_SETNAM        = $FFBD // Input: A = File name length; X/Y = Pointer to file name Output: – Used registers: –
.const KERNAL_OPEN          = $FFC0 // Input: – Output: – Used registers: A, X, Y
.const KERNAL_CLOSE         = $FFC3 // Input: A = Logical number Output: – Used registers: A, X, Y
.const KERNAL_CHKIN         = $FFC6	// Input: X = Logical number Output: – Used registers: A, X
.const KERNAL_CHKOUT        = $FFC9 // Input: X = Logical number Output: – Used registers: A, X
.const KERNAL_CLRCHN        = $FFCC // Input: – Output: – Used registers: A, X
.const KERNAL_CHRIN         = $FFCF	// Input: – Output: A = Byte read Used registers: A, Y
.const KERNAL_CHROUT        = $FFD2 // Input: A = Byte to write Output: – Used registers: –
.const KERNAL_LOAD          = $FFD5 // Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0) Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0) Used registers: A, X, Y
.const KERNAL_SAVE          = $FFD8 // Input: A = Address of zero page register holding start address of memory area to save; X/Y = End address of memory area plus 1 Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1) Used registers: A, X, Y
.const KERNAL_SETTIM        = $FFDB // Input: A/X/Y = New TOD value Output: – Used registers: –
.const KERNAL_RDTIM         = $FFDE	// Input: – Output: A/X/Y = Current TOD value Used registers: A, X, Y
.const KERNAL_STOP          = $FFE1 // Input: – Output: Zero: 0 = Not pressed, 1 = Pressed; Carry: 1 = Pressed Used registers: A, X
.const KERNAL_GETIN         = $FFE4 // Input: – Output: A = Byte read Used registers: A, X, Y
.const KERNAL_CLALL         = $FFE7 // Input: – Output: – Used registers: A, X
.const KERNAL_UDTIM         = $FFEA // Input: – Output: – Used registers: A, X
.const KERNAL_SCREEN        = $FFED // Input: – Output: X = Number of columns (40); Y = Number of rows (25) Used registers: X, Y
.const KERNAL_PLOT          = $FFF0 // Input: Carry: 0 = Restore from input, 1 = Save to output; X = Cursor column (if Carry = 0); Y = Cursor row (if Carry = 0) Output: X = Cursor column (if Carry = 1); Y = Cursor row (if Carry = 1) Used registers: X, Y
.const KERNAL_IOBASE        = $FFF3 // Input: – Output: X/Y = CIA #1 base address ($DC00) Used registers: X, Y






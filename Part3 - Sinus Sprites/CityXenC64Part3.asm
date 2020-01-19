//////////////////////////////////////////////////////////////////////
// CityXen Commodore 64 Programming Series Part 3
// Bouncy CityXen Sprites
// by Deadline
// Get spritepad here: https://www.subchristsoftware.com/spritepad.htm
// Get sinusmaker here: https://csdb.dk/release/?id=124272

#import "../include/Constants.asm"

*=$0801 "BASIC"
 :BasicUpstart($0810)
*=$0810

.var sin_counter0 = $0a90
.var sin_counter1 = $0a91
.var sin_counter2 = $0a92
.var sin_counter3 = $0a93
.var sin_counter4 = $0a94
.var sin_counter5 = $0a95
.var sin_counter6 = $0a96
.var sin_counter7 = $0a97
.var color_flipper = $0a98

.const X_POS = $6f
.const Y_POS = $55

begin_code:
    sei
    lda #BLACK
    sta BORDER_COLOR
    sta BACKGROUND_COLOR
    lda #$93
    jsr KERNAL_CHROUT

    lda #$7f
    sta SPRITE_ENABLE
    sta SPRITE_MULTICOLOR
    lda #LIGHT_GRAY
    sta SPRITE_MULTICOLOR_0
    lda #PURPLE
    sta SPRITE_MULTICOLOR_1
    lda #$00
    sta SPRITE_MSB_X

    lda #$2c; sta SPRITE_0_POINTER
    lda #$2d; sta SPRITE_1_POINTER
    lda #$2e; sta SPRITE_2_POINTER
    lda #$2f; sta SPRITE_3_POINTER
    lda #$30; sta SPRITE_4_POINTER
    lda #$31; sta SPRITE_5_POINTER
    lda #$32; sta SPRITE_6_POINTER
    
    lda #X_POS; sta SPRITE_0_X
    lda #X_POS+$11; sta SPRITE_1_X
    lda #X_POS+$22; sta SPRITE_2_X
    lda #X_POS+$36; sta SPRITE_3_X
    lda #X_POS+$4a; sta SPRITE_4_X
    lda #X_POS+$5e; sta SPRITE_5_X
    lda #X_POS+$72; sta SPRITE_6_X

    lda #Y_POS
    sta SPRITE_0_Y
    sta SPRITE_1_Y
    sta SPRITE_2_Y
    sta SPRITE_3_Y
    sta SPRITE_4_Y
    sta SPRITE_5_Y
    sta SPRITE_6_Y

    lda #DARK_GRAY
    sta SPRITE_0_COLOR
    sta SPRITE_1_COLOR
    sta SPRITE_2_COLOR
    sta SPRITE_3_COLOR
    sta SPRITE_4_COLOR
    sta SPRITE_5_COLOR
    sta SPRITE_6_COLOR

    lda #$00
    sta sin_counter0
    lda #$30
    sta sin_counter1
    lda #$50
    sta sin_counter2
    lda #$70
    sta sin_counter3
    lda #$90
    sta sin_counter4
    lda #$b0
    sta sin_counter5
    lda #$d0
    sta sin_counter6

title_loop:

    lda #$10
    cmp VIC_RASTER_COUNTER
    bcc title_loop

    inc sin_counter0
    inc sin_counter1
    inc sin_counter2
    inc sin_counter3
    inc sin_counter4
    inc sin_counter5
    inc sin_counter6

    ldx sin_counter0
    lda sinetable,x
    adc #Y_POS
    sta SPRITE_0_Y

    ldx sin_counter1
    lda sinetable,x
    adc #Y_POS
    sta SPRITE_1_Y

    ldx sin_counter2
    lda sinetable,x
    adc #Y_POS
    sta SPRITE_2_Y

    ldx sin_counter3
    lda sinetable,x
    adc #Y_POS
    sta SPRITE_3_Y

    ldx sin_counter4
    lda sinetable,x
    adc #Y_POS
    sta SPRITE_4_Y

    ldx sin_counter5
    lda sinetable,x
    adc #Y_POS
    sta SPRITE_5_Y

    ldx sin_counter6
    lda sinetable,x
    adc #Y_POS
    sta SPRITE_6_Y

    lda #$DF
    cmp VIC_RASTER_COUNTER
    bcc title_loop

    ldx color_flipper
    inx 
    cpx #$0c
    bne colorjump
    ldx #$00
colorjump:
    stx color_flipper
    lda colortable,x
    sta SPRITE_MULTICOLOR_1
    jmp title_loop

colortable:
.byte PURPLE,DARK_GRAY,DARK_GRAY,GRAY,LIGHT_GRAY,WHITE,CYAN,WHITE,LIGHT_GRAY,GRAY,DARK_GRAY,DARK_GRAY,PURPLE

#import "sinustable.asm"
*=$0b00 "Sprites"
#import "sprites.asm"


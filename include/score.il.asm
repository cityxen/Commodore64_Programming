//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce

score: // Bytes of the score in BCD
// LSB --------------- MSB
.byte $00,$00,$00,$00,$00

score_str: .text "0000000099" // String of the score
           .byte 0 
score_digits:   .byte $09  // num of digits to display (default is 10)
score_math_o:   .byte $00  // Math Val


.macro DrawScore(x,y) {
	clc    // Set cursor position
	ldy #x // X coordinate (column)
	ldx #y // Y coordinate (line)
	jsr $fff0
	PrintNoLeadingZeros(score_str)
}

////////////////////////////////////////////////
// Update string from score

score_to_str:

    ldx #$00
    ldy score_digits
!:
    lda score,x
    pha
    and #$0f
    clc
    adc #48
    sta score_str,y
    dey
    pla
    lsr
    lsr
    lsr
    lsr
    clc
    adc #48
    sta score_str,y
    dey

    inx
    cpx #5
    bne !-

    rts
    

////////////////////////////////////////////////
// Update score from string

score_from_str:

    ldx #$00
    ldy #$04
!:
    lda score_str,x

    and #$0f

    clc
    asl
    asl
    asl
    asl
    
    sta score,y

    inx
    lda score_str,x
    and #$0f
    ora score,y
    sta score,y

    inx
    dey
    cpy #$ff
    bne !-

    rts


////////////////////////////////////////////////
// Reset score to 0

score_reset:

    lda #$00

    sta score
    sta score+1
    sta score+2
    sta score+3
    sta score+4

    jsr score_to_str

    rts

////////////////////////////////////////////////
// Add score_math_o to score

score_add:

    sed

    clc
    lda score
    adc score_math_o
    sta score
    lda score+1
    adc #0
    sta score+1
    lda score+2
    adc #0
    sta score+2
    lda score+3
    adc #0
    sta score+3
    lda score+4
    adc #0
    sta score+4

    cld

    jsr score_to_str

    rts

////////////////////////////////////////////////
// Subtract score_math_o from score

score_sub:

    sed

    sec
    lda score
    sbc score_math_o
    sta score
    lda score+1
    sbc #0
    sta score+1
    lda score+2
    sbc #0
    sta score+2
    lda score+3
    sbc #0
    sta score+3
    lda score+4
    sbc #0
    sta score+4

    cld

    jsr score_to_str

    rts

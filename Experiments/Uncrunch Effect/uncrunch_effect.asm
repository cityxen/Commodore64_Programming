//////////////////////////////////////////////////////////////////////////////////////
// Uncrunch Effect by Deadline
//////////////////////////////////////////////////////////////////////////////////////
#import "../../Commodore64_Programming/include/Constants.asm"
#import "../../Commodore64_Programming/include/DrawPetMateScreen.asm"

// File stuff
.file [name="uncrunch-data.prg", segments="Main"]


//////////////////////////////////////////////////////////////////////////////////////
.segment Main [allowOverlap]
* = $0801 "BASIC"
.word usend // link address
.word 2021  // line num
.byte $9e   // sys
.text toIntString(init)
.byte $3a,99,67,73,84,89,88,69,78,99
usend:
.byte 0
.word 0  // empty link signals the end of the program
* = $0830 "vars init"
vars:

init:

    lda #$93
    jsr KERNAL_CHROUT

    // Set initial sprites on or off
    lda #$00
    sta SPRITE_ENABLE


    // Set up sid to produce random values
    lda #$FF  // maximum frequency value
    sta $D40E // voice 3 frequency low byte
    sta $D40F // voice 3 frequency high byte
    lda #$80  // noise waveform, gate bit off
    sta $D412 // voice 3 control register

//////////////////////////////////////////////////
// MAINLOOP
mainloop:

    // Check keyboard
    jsr KERNAL_GETIN
    clc

!keycheck:
    cmp #$51 // Q
    bne !keycheck+
    rts


!keycheck: // end_keyboard_checks


!animate:
    // do some glitchy looking stuff
    ldx #$00
!again:

    lda $d41b
    cmp $c400
    beq !again-
    sta $c400

    sta $400,x
    inx
    bne !again-

end_glitch:

    ldx #$00
    ldy #$00
!:      
    lda #$01
    sta $c000,y
    iny 
    inx
    bne !-

    ldx #$00
    ldy #$00
!:      
    lda #$01
    sta $c000,y
    iny 
    inx
    bne !-

    
    ldy #$00
!:      
    lda #$01
    sta $c000,y

    ldx #$00
!:
    sta $c000,x
    inx
    cpx #$06
    bne !-
    
    iny    
    sty $400+999
    sty COLOR_RAM+999
    bne !--

    jmp mainloop

// END MAINLOOP
//////////////////////////////////////////////////

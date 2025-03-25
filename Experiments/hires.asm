/*╔════════════════════════════════════════════════════════════════════════════╗
    ║╔══════════════════════╗                         ┌──────┐                   ║
    ║║  BitMap Plotter      ║                         │AUTHOR├─┐ TWW / CREATORS  ║
    ║╚══════════════════════╝                         └──────┘ └════════════════ ║
    ║                                                                            ║
    ║┌──────────────────────┐                                                    ║
    ║│▓▓▓▓ DESCRIPTION ▓▓▓▓▓│                                                    ║
    ║├──────────────────────┴───────────────────────────────────────────────────┐║
    ║│Will create 4 tables to plott a pixel on a Hires Bitmap screen;           │║
    ║│- BitMask    - $80, $40, $20, $10, $08, $04, $02, $01                     │║
    ║│- X_Table    - $00 x 8, $08 x 8, $10 x 8, ...                             │║
    ║│- Y_Table_Lo - <GFX_MEM x 8, <GFX_MEM + $140 x 8, ...                     │║
    ║│- Y_Table_Hi - >GFX_MEM x 8, >GFX_MEM + $140 x 8, ...                     │║
    ║│                                                                          │║
    ║│GFX_MEM must be set to the correct Graphics Bank.                         │║
    ║└──────────────────────────────────────────────────────────────────────────┘║
    ║┌──────────────────────┐                                                    ║
    ║│▓▓▓▓▓ FOOTPRINT ▓▓▓▓▓▓│                                                    ║
    ║├──────────────────────┴─────────────┐                                      ║
    ║│54 Bytes                            │                                      ║
    ║└────────────────────────────────────┘                                      ║
    ╚════════════════════════════════════════════════════════════════════════════╝*/

    .const GFX_MEM    = $2000

    .const BitMask    = $0a00
    .const X_Table    = $0b00
    .const Y_Table_Lo = $0c00
    .const Y_Table_Hi = $0d00

    ldx #$00
    lda #$80
Loop1:
    sta BitMask,x
    ror
    bcc Skip1
        ror
Skip1:
    tay
    txa
    and #%11111000
    sta X_Table,x
    tya
    inx
    bne Loop1

    lda #<GFX_MEM  // Can be replaced with a TXA if GFX_MEM is page aligned
Loop2:
    ldy #$07
Loop3:
    sta Y_Table_Lo,x
    pha
SMC1:
    lda #>GFX_MEM
    sta Y_Table_Hi,x
    pla
    inx
    dey
    bpl Loop3
    inc SMC1+1
    clc
    adc #$40
    bcc Skip2
        inc SMC1+1
Skip2:
    cpx #8*25
    bne Loop2
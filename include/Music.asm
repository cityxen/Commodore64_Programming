//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY - https://linktr.ee/cityxen

.macro InitializeMusic(music_option) {
    lda #$01
    sta music_option
    ldx #0
    ldy #0
    lda #00
    jsr music.init
    lda #$7f
    sta $dc0d
    lda $dc0d
    sei
    lda #$01
    sta VIC_INTERRUPT_ENABLE
    lda #$44
    sta VIC_RASTER_COUNTER
    lda $d011
    and #$7f
    sta $d011
    lda #<irq1
    sta $0314
    lda #>irq1
    sta $0315
    cli 
}





    

diskdata:
.byte $43,'c','i','t','y','x','e','n',$43,$43,'d','i','s','k','t','o','o','l',$43,$3e,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,'d','a','t','a',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$53,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

copydiskdata:
    ldx #$00
!cpdd:
    lda diskdata,x
    sta data_start,x
    inx
    bne !cpdd-
    rts

displaydiskdata:
    ldx #$00
!cpdd:
    lda data_start,x
    sta $0400+400,x
    inx
    bne !cpdd-
    rts

viewdiskdata:
    ClearScreen(BLACK)
    jsr displaydiskdata
    ldx #$00
!vdd:
    lda dir_presskey_text,x
    beq !vdd+
    jsr KERNAL_CHROUT
    inx
    jmp !vdd-
!vdd:
    jsr KERNAL_WAIT_KEY
    beq !vdd-
    rts

randomizediskdata:
    ldx #$00
!cpdd:
    lda $d41b // (get random number from SID)
    cmp last_rand // check to remove duplicates
    beq !cpdd-
    sta last_rand
    sta data_start,x
    inx
    bne !cpdd-
    rts
last_rand:
.byte 0
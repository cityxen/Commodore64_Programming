
string_hex:
.text "c000"
.byte 0
hex_val:
.byte 0
.byte 0
hex_tmp:
.byte 0
int_acc:
.byte 0

hexstr16_to_val:

    lda #$00
    sta hex_tmp
    sta int_acc
    sta hex_val
    sta hex_val+1

    tax
    lda string_hex,x
    jsr screencode_to_petscii
    jsr hex_cvrt

    inx
    lda string_hex,x
    jsr screencode_to_petscii
    jsr hex_cvrt
        
    lda int_acc
    sta hex_val+1

    lda #$00
    sta hex_tmp
    sta int_acc

    inx
    lda string_hex,x
    jsr screencode_to_petscii
    jsr hex_cvrt
    

    inx
    lda string_hex,x
    jsr screencode_to_petscii
    jsr hex_cvrt
    
    lda int_acc
    sta hex_val

    rts

hex_cvrt:
    stx x_reg

    cmp #$30
    bcc h2vend
    cmp #$39
    bcs is_hex
    sec
    sbc #$30
    jmp add_value

is_hex:
    cmp #$41
    bcc h2vend
    cmp #$47
    bcs h2vend
    sec
    sbc #55

add_value:
    sta hex_tmp
    lda int_acc
    asl // multiply by 16 (shift left 4 times)
    asl 
    asl 
    asl
    clc
    adc hex_tmp  // add the digit value
    sta int_acc

h2vend:
    ldx x_reg
    rts



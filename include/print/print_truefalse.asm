print_truefalse:
    beq !+
    Print(ptf_true_txt)
    jmp ptf_end
!:
    Print(ptf_false_txt)
ptf_end:
    rts
ptf_true_txt:
.encoding "petscii_mixed"
.text "true "
.byte 0
ptf_false_txt:
.encoding "petscii_mixed"
.text "false"
.byte 0

//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY - https://linktr.ee/cityxen

a_reg:  .byte 0
x_reg:  .byte 0
y_reg:  .byte 0
tmp_1:  .byte 0
tmp_2:  .byte 0
tmp_3:  .byte 0

///////////////
// Wait VBL

wait_vbl:
     bit $d011
     bpl wait_vbl
     lda $d012
f:   cmp $d012
     bmi f
     rts

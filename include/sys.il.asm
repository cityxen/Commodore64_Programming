//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//

a_reg:  .byte 0
x_reg:  .byte 0
y_reg:  .byte 0
tmp_1:  .byte 0
tmp_2:  .byte 0
tmp_3:  .byte 0

///////////////
// Wait VBL

wait_vbl:
     lda $D011
     and #$80
     bne wait_vbl
     rts

//   bit $d011
//   bpl wait_vbl
//   lda $d012
// f:   cmp $d012
//   bmi f
//   rts

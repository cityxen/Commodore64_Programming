//////////////////////////////////////////////////////////////////
// CITYXEN COMMODORE 64 LIBRARY
// 
// https://github.com/cityxen/Commodore64_Programming
//
// https://linktr.ee/cityxen
//
#importonce

//////////////////////////////////////////////////////////////////

/*
.macro ConvertA2P(string,len) {
    ldx #$00
!:
    lda string,x
    beq !+
    jsr screencode_to_petscii // ascii_to_petscii_kp
    sta string,x
    inc string,x
    inx
    cpx #len
    bne !-
!:
}
*/

//////////////////////////////////////////////////////////////////
// convert ascii to petscii (from idolpx)

ascii_to_petscii:
    cmp #$41          // Compare with 'A'
    bcc !+            // If less, return
    cmp #$7F          // Compare with 'DEL'
    bcs !+            // If greater or equal, return
    sbc #$5F          // Convert 'A-Z' & 'a-z' to PETSCII
!:
    rts               // Return from subroutine

ascii_to_petscii_kp: // (kernel print)
    cmp #$41          // Compare with 'A'
    bcc !+            // If less, return
    cmp #$7F          // Compare with 'DEL'
    bcs !+            // If greater or equal, return
    sbc #$1f          // Convert 'A-Z' & 'a-z' to PETSCII
!:
    rts               // Return from subroutine

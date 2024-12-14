 
    !source "ufo.inc"

        * = $a000

    !word gamestart
    !word gamestart
    !byte $41, $30 ; "A0"
    !byte $c3, $c2, $cd ; "CBM"

; unrolled memcpy(WORKCHARNEW, WORKCHAROLD, 0x400)
copycharset:
!if KERNALPATCH = 1 {
        !for i,0,$400 {
            lda WORKCHAROLD+i
            sta WORKCHARNEW+i
        }
}
        rts

        * = $bfff
        !byte $ff


    !source "ufo.inc"

        * = $6000
; unrolled memcpy (SCREENNEW, SCREENOLD, 23*22)
copyscreen:
        !for i,0,(23*22) {
            ; 506 * 15 = 7590 bytes (1da6)
            lda SCREENOLD+i
            sta SCREENNEW+i
            ldy COLRAMOLD+i
            lda colortab,y
            sta COLRAMNEW+i
        }
        rts

    !align 255,0
colortab:
    !for i,0,$ff {
        !if (i and $7) = 0 {
            !byte 1
        } else {
            !byte (i and $7)
        }
    }

        * = $7fff
        !byte $ff

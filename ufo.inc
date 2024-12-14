
; KERNALPATCH=0
; BREAKPATCH=0

screen_ptr_lo   = $13
screen_ptr_hi   = $14

unk_1F          = $1f


SCREENOLD   = $0200
COLRAMOLD   = $0600
WORKCHAROLD = $1c00  ; 4k in RAM (copied to WORKCHARNEW)
CHARSETOLD  = $2000  ; 4k in ROM

VIC = $9000
;PIA = $1400

!if KERNALPATCH = 1 {
SCREENNEW   = $1a00
COLRAMNEW   = $9600
CHARSETNEW  = $1400
WORKCHARNEW = $1000
} else {
SCREENNEW   = $1000
COLRAMNEW   = $9400
CHARSETNEW  = $1800
}

; 2000-3fff BLK1 "ufo2000"      original ROMs + patches
; 4000-5fff BLK2 "ufo2000"
gamestart = $4000
NMISTART = $4100
IRQSTART = $4200

; 6000-7fff BLK3 "ufo6000"      unrolled memcpy (SCREENNEW, SCREENOLD, 23*22)
unrolled_copyworkscreen = $6000

; 8000-8fff chargen

; 9400-97ff color RAM
;  9400-95FF                    location of COLOR RAM with additional RAM at blk 1
;  9600-97FF                    Normal location of COLOR RAM

; 9800-9fff I/O

; a000-bfff BLK5 "ufoA000"      unrolled memcpy(WORKCHARNEW, WORKCHAROLD, 0x400)
unrolled_copyworkchar = $a009

; c000-dfff basic
; e000-ffff kernal "ufoE000"

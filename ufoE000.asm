
    !source "ufo.inc"

    * = $e000

    !binary "rom/kernal.901486-07.bin"

!if KERNALPATCH = 1 {
    ; hardware vectors
    * = $fffa

    ; $fffa IRQ
    ;!word $fea9 ; $fea9
    !word IRQSTART

    ; $fffc RESET
    ;!word $fd22 ; $fd22
    !word gamestart

    ; $fffe NMI
    ;!word $ff72 ; $ff72
    !word NMISTART
}

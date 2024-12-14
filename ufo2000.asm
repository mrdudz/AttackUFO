    !source "ufo.inc"

;-------------------------------------------------------------------------------
; original ROM
;-------------------------------------------------------------------------------
    * = $2000
    !binary "rom/1" ; $2000-$23ff
    !binary "rom/2" ; $2400-$27ff
    !binary "rom/3" ; $2800-$2bff
    !binary "rom/4" ; $2c00-$2fff
    !binary "rom/5" ; $3000-$33ff
    !binary "rom/6" ; $3400-$37ff
    !binary "rom/7" ; $3800-$3bff
    !binary "rom/8" ; $3c00-$3fff
;-------------------------------------------------------------------------------

    ; change VIC base address
    * = $2578
    !byte > VIC
    * = $25bb
    !byte > VIC
    * = $25c0
    !byte > VIC
    * = $3da9
    !byte > VIC
    * = $25af
    !byte > VIC

    ; patch PIA reads

    * = $2b60       ; get controllers
    jsr pia_b_read
    * = $254f       ; get lives (bit 0-1)
    jsr pia_a_read
    * = $26b7       ; get coin (bit 7)
    jsr pia_a_read
    * = $2a9f       ; get bonus score (bit 2)
    jsr pia_a_read

    ; remove PIA writes
    * = $3c1f
    bit $eaea 
    * = $3c22
    bit $eaea 
    * = $3c27
    bit $eaea 
    * = $3c2c
    bit $eaea 
    * = $3c31
    bit $eaea 
    * = $3c34
    bit $eaea 
    * = $22ec
    bit $eaea 
    
;-------------------------------------------------------------------------------
    
!if KERNALPATCH = 0 {
    * = $3c0a
    !byte > SCREENNEW
    * = $3c0d
    !byte > (SCREENNEW + $100)
}
    ;* = $22e1
    ;!byte > VIC
    * = $22df
    jmp patch_22df

;     * = $25ad
;     jmp patch_25ad

!if BREAKPATCH = 1 {
    ; patch the BRK mechanism
    * = $3d8f
    jmp patch_3d8f
    
    ; patch the jumptable
    * = $2465
    !word patch_brk_38dd
    * = $248b
    !word patch_brk_3b49    
    * = $248f
    !word patch_brk_35da    
    * = $24c7
    !word patch_brk_3500    
    * = $250d
    !word patch_brk_3ae0    
    * = $2521
    !word patch_brk_3e7c    
    * = $253d
    !word patch_brk_34d8   
    * = $250b
    !word patch_brk_3ba5   
    * = $253b
    !word patch_brk_33f8   
    * = $253f
    !word patch_brk_3b93   
    
    ; patch more BRKs
    * = $3381
    jmp patch_brk_3bb7    
    * = $338f
    jmp patch_brk_3bb7    
    * = $3395
    jmp patch_brk_3bb7    
    * = $33da
    jmp patch_brk_3bb7    
    * = $33e9
    jmp patch_brk_3bb7
    
    * = $3b7e
    jmp patch_3b7e
    * = $3529
    jmp patch_3529
    * = $357e
    jmp patch_357e
    * = $39fd
    jmp patch_39fd
    * = $2d04
    jmp patch_2d04
}
    
!if KERNALPATCH = 0 {
    ; patch writes to video ram
    * = $2644
    jsr patch_2644
    * = $2692
    jsr patch_2692
}

;-------------------------------------------------------------------------------
    * = $4000
;-------------------------------------------------------------------------------

;     !word start
;     !word start
;     !byte $34, $30 ; "40"
;     !byte $c3, $c2, $cd ; "CBM"

start:
    sei
!if KERNALPATCH = 0 {
    lda #>IRQ
    sta $0315
    sta $0317
    lda #<IRQ
    sta $0314
    sta $0316
}
    lda #$97
    sta $9002
    lda #$f0
    sta $9005
 
    ; copy charset
    ldx #0
-
;     lda $2000,x
;     eor #$ff
;     sta $1400,x
    lda CHARSETOLD,x
;    eor #$ff
    sta CHARSETNEW,x
    lda CHARSETOLD+$100,x
;    eor #$ff
    sta CHARSETNEW+$100,x
    lda CHARSETOLD+$200,x
;    eor #$ff
    sta CHARSETNEW+$200,x
    lda CHARSETOLD+$300,x
;    eor #$ff
    sta CHARSETNEW+$300,x
    inx
    bne -

    jmp $3c00   ; start at FFFC
    
;.C:ff72  48          PHA
;.C:ff73  8A          TXA
;.C:ff74  48          PHA
;.C:ff75  98          TYA
;.C:ff76  48          PHA
;.C:ff77  BA          TSX
;.C:ff78  BD 04 01    LDA $0104,X
;.C:ff7b  29 10       AND #$10
;.C:ff7d  F0 03       BEQ $FF82
;.C:ff7f  6C 16 03    JMP ($0316)
;.C:ff82  6C 14 03    JMP ($0314)
    

    * = NMISTART
NMI:
    rti

    * = IRQSTART
IRQ:
!if KERNALPATCH = 0 {
    pla
    pla
    pla
}
    jmp $3bf1   ; irq vector at FFFE
    
;ROM:3BF1          IRQ:                                    ; pull status
;ROM:3BF1 28                       PLP
;ROM:3BF2 68                       PLA                     ; pull return addr
;ROM:3BF3 18                       CLC
;ROM:3BF4 69 FE                    ADC     #$FE ; '¦'
;ROM:3BF6 AA                       TAX
;ROM:3BF7 68                       PLA                     ; pull return addr
;ROM:3BF8 69 FF                    ADC     #$FF
;ROM:3BFA 48                       PHA
;ROM:3BFB 8A                       TXA
;ROM:3BFC 48                       PHA
;ROM:3BFD 4C 00 24                 JMP     IRQ_CONT


; ROM:3D8F A6 E1                    LDX     unk_E1
; ROM:3D91 BD 80 32                 LDA     unk_3280,X
; ROM:3D94 85 E0                    STA     byte_E0
; ROM:3D96 20 A9 30                 JSR     sub_30A9
; ROM:3D99 C6 E1                    DEC     unk_E1
; ROM:3D9B 10 F2                    BPL     loc_3D8F
; ROM:3D9D 00                       BRK
; ROM:3D9D          ; ---------------------------------------------------------------------------
; ROM:3D9E 53                       .BYTE $53 ; S
; ROM:3D9F 59                       .BYTE $59 ; Y
; ROM:3DA0 54                       .BYTE $54 ; T
; ROM:3DA1 56                       .BYTE $56 ; V
; ROM:3DA2 FF                       .BYTE $FF
; 

byte_E0 = $e0
unk_E1 = $e1
unk_3280 = $3280
sub_30A9 = $30a9

joytemp1 = $4fb
joytemp2 = $4fc
joytemp3 = $4fd

tempa = $4fe
temps = $4ff

byte_F7 = $f7
byte_57 = $57
unk_1e48 = $1e48
unk_1e40 = $1e40

byte_FA = $fa
byte_F9 = $f9
byte_C4 = $c4

patch_3d8f:
        LDX     unk_E1
        LDA     unk_3280,X
        STA     byte_E0
        JSR     sub_30A9
        DEC     unk_E1
        BPL     patch_3d8f
        
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3d9d + 2)  ; addr of the BRK+2
        pha
        lda #< ($3d9d + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE

patch_brk_38dd:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($38dd + 2)  ; addr of the BRK+2
        pha
        lda #< ($38dd + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_3b49:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3b49 + 2)  ; addr of the BRK+2
        pha
        lda #< ($3b49 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_35da:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($35da + 2)  ; addr of the BRK+2
        pha
        lda #< ($35da + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE

patch_brk_3500:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3500 + 2)  ; addr of the BRK+2
        pha
        lda #< ($3500 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_3ae0:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3ae0 + 2)  ; addr of the BRK+2
        pha
        lda #< ($3ae0 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_3e7c:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3e7c + 2)  ; addr of the BRK+2
        pha
        lda #< ($3e7c + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_34d8:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($34d8 + 2)  ; addr of the BRK+2
        pha
        lda #< ($34d8 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_3bb7:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3bb7 + 2)  ; addr of the BRK+2
        pha
        lda #< ($3bb7 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_3ba5:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3ba5 + 2)  ; addr of the BRK+2
        pha
        lda #< ($3ba5 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_33f8:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($33f8 + 2)  ; addr of the BRK+2
        pha
        lda #< ($33f8 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_brk_3b93:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3b93 + 2)  ; addr of the BRK+2
        pha
        lda #< ($3b93 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        

; ROM:3B7E 45 F7                    EOR     byte_F7
; ROM:3B80 A6 57                    LDX     byte_57
; ROM:3B82 F0 05                    BEQ     loc_3B89
; ROM:3B84 99 48 1E                 STA     unk_1E48,Y
; ROM:3B87 D0 03                    BNE     loc_3B8C
; ROM:3B89
; ROM:3B89          loc_3B89:                               ; CODE XREF: ROM:3B82j
; ROM:3B89 99 40 1E                 STA     unk_1E40,Y
; ROM:3B8C
; ROM:3B8C          loc_3B8C:                               ; CODE XREF: ROM:3B87j
; ROM:3B8C 00                       BRK

patch_3b7e:
        eor byte_F7
        ldx byte_57
        beq loc_3B89
        sta unk_1e48,y
        bne loc_3B8C
loc_3B89:
        sta unk_1e40,y
loc_3B8C:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3b8c + 2)  ; addr of the BRK+2
        pha
        lda #< ($3b8c + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
        
; ROM:3529 E6 FA                    INC     byte_FA
; ROM:352B 00                       BRK

patch_3529:
        inc byte_FA

        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($352b + 2)  ; addr of the BRK+2
        pha
        lda #< ($352b + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
        
; ROM:357E F0 0B                    BEQ     loc_358B
; ROM:3580 A6 F9                    LDX     byte_F9
; ...
; ROM:358B          loc_358B:                               ; CODE XREF: ROM:357Ej
; ROM:358B 00                       BRK

patch_357e:
        beq +
        ldx byte_F9
        jmp $3582
+
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($358b + 2)  ; addr of the BRK+2
        pha
        lda #< ($358b + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
patch_39fd:
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($3b02 + 2)  ; addr of the BRK+2
        pha
        lda #< ($3b02 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE
        
; ROM:2D04 85 C4                    STA     byte_C4
; ROM:2D06 00                       BRK
patch_2d04:
        sta byte_C4
        ;BRK
        sta tempa
        php
        pla
        sta temps
        
        lda #> ($2d06 + 2)  ; addr of the BRK+2
        pha
        lda #< ($2d06 + 2)
        pha
        
        lda temps
        pha
        lda tempa
        plp
        php
        jmp     $3bf1   ; irq vector at FFFE

;-------------------------------------------------------------------------------
; patch screen memory accesses
;-------------------------------------------------------------------------------
        
;ROM:2644 91 13                    STA     (screen_ptr_lo),Y
;ROM:2646 8A                       TXA

patch_2644:
    eor #$80
    sta value_2644+1

    lda screen_ptr_lo
    sta store_2644+1
    lda screen_ptr_hi   ; originally $02 or $03
    clc
    adc #>(SCREENNEW - SCREENOLD)
    sta store_2644+2
    
value_2644:
    lda #0
store_2644:
    sta $dead, y
    txa
    rts

;ROM:2692 91 13                    STA     (screen_ptr_lo),Y
;ROM:2694 A5 1F                    LDA     unk_1F

patch_2692:
    eor #$80
    sta value_2692+1

    lda screen_ptr_lo
    sta store_2692+1
    lda screen_ptr_hi   ; originally $02 or $03
    clc
    adc #>(SCREENNEW - SCREENOLD)
    sta store_2692+2
    
value_2692:
    lda #0
store_2692:
    sta $dead, y
    lda unk_1F
    rts

;-------------------------------------------------------------------------------
; DIP switches and Controller
;-------------------------------------------------------------------------------

; PORT_START("DSW")
; PORT_DIPNAME(0x03, 0x00, DEF_STR( Lives ))
; PORT_DIPSETTING(   0x00, "3")
; PORT_DIPSETTING(   0x01, "4")
; PORT_DIPSETTING(   0x02, "5")
; PORT_DIPSETTING(   0x03, "6")
; PORT_DIPNAME(0x04, 0x04, DEF_STR( Bonus_Life ))
; PORT_DIPSETTING(   0x04, "1000")
; PORT_DIPSETTING(   0x00, "1500")
; PORT_DIPUNUSED(0x08, IP_ACTIVE_LOW)
; PORT_BIT(0x10, IP_ACTIVE_LOW, IPT_UNUSED)
; PORT_BIT(0x20, IP_ACTIVE_LOW, IPT_UNUSED)
; PORT_BIT(0x40, IP_ACTIVE_LOW, IPT_UNUSED)
; PORT_BIT(0x80, IP_ACTIVE_LOW, IPT_COIN1)

pia_a_read:
    lda #$00
    sta $9123   ; port a ddr
    lda #$ff
    sta $9122   ; port b ddr (out)
    
    lda #$7f
    sta $9120   ; port b
    
    lda $9121   ; port a
    rts

; PORT_BIT(0x01, IP_ACTIVE_LOW, IPT_START1)                                         Q
; PORT_BIT(0x02, IP_ACTIVE_LOW, IPT_START2)
; PORT_BIT(0x04, IP_ACTIVE_LOW, IPT_JOYSTICK_LEFT)  PORT_PLAYER(1) PORT_2WAY        T
; PORT_BIT(0x08, IP_ACTIVE_LOW, IPT_JOYSTICK_RIGHT) PORT_PLAYER(1) PORT_2WAY        U
; PORT_BIT(0x10, IP_ACTIVE_LOW, IPT_BUTTON1)        PORT_PLAYER(1)                  I
; PORT_BIT(0x20, IP_ACTIVE_LOW, IPT_JOYSTICK_LEFT)  PORT_PLAYER(2) PORT_2WAY
; PORT_BIT(0x40, IP_ACTIVE_LOW, IPT_JOYSTICK_RIGHT) PORT_PLAYER(2) PORT_2WAY
; PORT_BIT(0x80, IP_ACTIVE_LOW, IPT_BUTTON1) PORT_PLAYER(2)


;  9113      Data direction register A
;  9111      Port A output register
;                    (PA0) Bit 0=Serial CLK IN
;                    (PA1) Bit 1=Serial DATA IN
;                    (PA2) Bit 2=Joy 0  up
;                    (PA3) Bit 3=Joy 1  down
;                    (PA4) Bit 4=Joy 2  left
;                    (PA5) Bit 5 = Lightpen/Fire button
;                    (PA6) Bit 6=Cassette switch sense
;                    (PA7) Bit 7=Serial ATN out

;  9122      Data direction register B
;  9120      Port B output register
;                    (PB3) Bit 3 =cassette write line
;                    (PB7) Bit 7 =Joy 3 right
pia_b_read:
    lda #$00
    sta $9123   ; port a ddr
    lda #$ff
    sta $9122   ; port b ddr (out)
    
    lda #%11101111
    sta $9120   ; port b
    
    lda $9121   ; port a
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    and #%00000001 ; start1 (F1)
    pha
    
    lda #$00
    sta $9122   ; port b ddr (in)
    
    lda $9120
    lsr
    lsr
    lsr
    lsr
    and #%00001000
    sta joytemp1    ; right

    lda #$00
    sta $9113   ; port a ddr (in)
    
    lda $9111
    lsr
    lsr
    and #%00000100
    sta joytemp2    ; left

    lda $9111
    lsr
    and #%00010000
    sta joytemp3    ; fire
    
    pla
    ora joytemp1
    ora joytemp2
    ora joytemp3
    
    ora #%11100010
    
    rts


patch_22df:

;ROM:22DF AD 04 10                 LDA     VIC_4
;ROM:22E2 C9 68                    CMP     #$68 ; 'h'
;ROM:22E4 D0 02                    BNE     locret_22E8
;ROM:22E6 68                       PLA
;ROM:22E7 68                       PLA
;ROM:22E8
;ROM:22E8          locret_22E8:                            ; CODE XREF: sub_22D8+Cj
;ROM:22E8 60                       RTS


    lda $9004
    cmp #$68
    bne +

    jsr copystuff

    pla
    pla
+
    rts

copystuff:
;    inc $900f
    txa
    pha
    tya
    pha

!if KERNALPATCH = 1 {
    jsr unrolled_copyworkscreen
    jsr unrolled_copyworkchar
}    
;     ldx #0
; -

!if KERNALPATCH = 1 {
;      lda WORKCHAROLD,x
;      sta WORKCHARNEW,x
;      lda WORKCHAROLD+$100,x
;      sta WORKCHARNEW+$100,x
;      lda WORKCHAROLD+$200,x
;      sta WORKCHARNEW+$200,x
;      lda WORKCHAROLD+$300,x
;      sta WORKCHARNEW+$300,x

;      lda SCREENOLD,x
;      sta SCREENNEW,x
;      lda SCREENOLD+$100,x
;      sta SCREENNEW+$100,x
}

;     ldy COLRAMOLD,x
;     lda colortab,y
;     sta COLRAMNEW,x
;     ldy COLRAMOLD+$100,x
;     lda colortab,y
;     sta COLRAMNEW+$100,x

;     inx
;     bne -

;     !for i,0,(23*22) {
;         ldy COLRAMOLD+i
;         lda colortab,y
;         sta COLRAMNEW+i
;     }
    
;    dec $900f
    
    pla
    tay
    pla
    tax
    
; 9005           bits 0-3 start of character memory
;                (default = 0)
;                bits 4-7 is rest of video address
;                (default= F)
;                BITS 3,2,1,0 CM startinq address
;                             HEX   
;                0000   ROM   8000  
;                0001         8400  
;                0010         8800  
;                0011         8C00  
;                1000   RAM   0000  
;                1001 xxxx
;                1010 xxxx  unavail.
;                1011 xxxx
;                1100         1000  
;                1101         1400  
;                1110         1800  
;                1111         1C00  

!if KERNALPATCH = 1 {
    lda #$ec
    sta $9005
    
    lda $9002
    ora #$10
    sta $9002
} else {
    lda #$ce
    sta $9005
    
    lda $9002
    and #$7f
    sta $9002
}
    lda #$0b        ; horizontal align (PAL)
    sta $9000
    
    lda #$08        ; background and borders black, inverted mode
    sta $900f

    rts
    

 * = $5fff
     !byte $ff

; -----------------------------------------------------------
;	----------------------- CART CONFIG -----------------------
; -----------------------------------------------------------
  .inesprg 1      ; 1x 16KB PRG code
  .ineschr 1      ; 1x 8KB CHR data
  .inesmap 0      ; Mapper 0 = NROM, no bank swapping
  .inesmir 1      ; Background mirroring

; -----------------------------------------------------------
  .rsset $0000    ; Point to 0x0
figure .rs 1      ; Write the value 1 on the previously declared pointer

; ----------------------------------------------------------- 
  .bank 0         ; Activate memory bank 0
  .org  $8000     ; Set program counter to the beginning of the cartridge ROM
                  ; memory

  .include "registers.asm"
  .include "subroutines.asm"

; -----------------------------------------------------------
; --------------------- INITIALIZATION ----------------------
; -----------------------------------------------------------

RESET:                    ; Tag for initialization code
  SEI                     ; Ignore IRQs
  CLD                     ; Disable decimal mode

  LDX #$40                ; Load %1000000 on register X to set flag on next instruction
  STX APU_FRAME_COUNTER   ; Disable APU frame IRQ

  LDX #$FF                ; Set X to last memory address
  TXS                     ; Set stack pointer to X to clear stack

  INX                     ; Increment X by 1 so it overflows to 0, from 0xFF to 0x0
  STX PPUCTRL             ; Disable NMI by writting 0 to the memory address 0x2000
  STX PPUMASK             ; Disable rendering by writting 0
  STX APU_DMC_1           ; Disable DMC IRQs by writting 0

  BIT PPUSTATUS           ; Read PPU status to clear any pending flags and prepare for
                          ; further synchronization

; -----------------------------------------------------------
  JSR vblankwait  ; Wait for vblank

clrmem:           ; Clear memory by setting it all to zeros
  STA $000, x
  STA $100, x
  STA $200, x
  STA $300, x
  STA $400, x
  STA $500, x
  STA $600, x
  STA $700, x
  INX             ; Increment displacement
  BNE clrmem      ; Branch until X is zero

  JSR vblankwait  ; Wait for vblank

  .include "sprites.asm"
  .include "audio.asm"

; -----------------------------------------------------------

InfiniteLoop:
  JMP   InfiniteLoop

NMI:
  LDA   #$00
  STA   OAMADDR ; Set the low byte (00) of the RAM address
  LDA   #$02
  STA   OAMDMA  ; Set the high byte (02) of the RAM address, start the transfer

  LDA figure
  STA $0233
  STA $023B
  TAX
  CLC
  ADC #$08
  STA $0237
  STA $023F
  INX
  STX figure

  RTI         ; Return from interrupt

; -----------------------------------------------------------
; --------------------------- DATA --------------------------
; -----------------------------------------------------------
  .bank 1
  .org  $A000
; ------------------------------------------------------------
background_palette:
  .db $22 ,$29 ,$1A ,$0F       ; Background palette 1
  .db $22 ,$36 ,$17 ,$0F       ; Background palette 2
  .db $22 ,$30 ,$21 ,$0F       ; Background palette 3
  .db $22 ,$27 ,$17 ,$0F       ; Background palette 4

sprite_palette:
  .db $22 ,$16 ,$27 ,$18       ; Sprite palette 1
  .db $22 ,$1A ,$30 ,$27       ; Sprite palette 2
  .db $22 ,$16 ,$30 ,$27       ; Sprite palette 3
  .db $22 ,$0F ,$36 ,$17       ; Sprite palette 4

sprite_title:
  ; Y Position, Tile number, Attributes, X Position
  .db $60,  $11,  $00,  $6C   ; H
  .db $60,  $18,  $00,  $78   ; O
  .db $60,  $15,  $00,  $84   ; L
  .db $60,  $0A,  $00,  $90   ; A

  .db $80,  $16,  $02,  $66   ; M
  .db $80,  $1E,  $02,  $72   ; U
  .db $80,  $17,  $02,  $7E   ; N
  .db $80,  $0D,  $02,  $8A   ; D
  .db $80,  $18,  $02,  $96   ; O

sprite_character:
  ; Y Position, Tile number, Attributes, X Position
  .db $10, $B0, $01, $08   ; sprite 0
  .db $10, $B2, $01, $0F   ; sprite 1
  .db $18, $B1, $01, $08   ; sprite 0
  .db $18, $B3, $01, $0F   ; sprite 1

; A, B, C, D, E, F, G.
notes:
  .db $FD, $E2, $D2, $BD, $A9, $9F, $8E

; ------------------------------------------------------------
  .org  $FFFA   ; First of the three vectors starts here
  .dw   NMI     ; When an NMI happens (once per frame if enabled) the 
                ; processor will jump to the label NMI:
  .dw   RESET   ; When the processor first turns on or is reset, it will jump
                ; to the label RESET:
  .dw   0       ; external interrupt IRQ is not used in this tutorial
; ------------------------------------------------------------
  .bank 2
  .org  $C000
  .incbin "mario.chr" ; includes 8KB graphics file from SMB1

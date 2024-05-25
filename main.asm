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

  .include "subroutines.asm"

; -----------------------------------------------------------
; --------------------- INITIALIZATION ----------------------
; -----------------------------------------------------------

RESET:            ; Tag for initialization code
  SEI             ; Ignore IRQs
  CLD             ; Disable decimal mode

  LDX #$40        ; Load %1000000 on register X to set flag on next instruction
  STX $4017       ; Disable APU frame IRQ

  LDX #$FF        ; Set X to last memory address
  TXS             ; Set stack pointer to X to clear stack

  INX             ; Increment X by 1 so it overflows to 0, from 0xFF to 0x0
  STX $2000       ; Disable NMI by writting 0 to the memory address 0x2000
  STX $2001       ; Disable rendering by writting 0 to the memory address 0x2001
  STX $4010       ; Disable DMC IRQs by writting 0 to the memory address 0x4010

  BIT $2002       ; Read PPU status to clear any pending flags and prepare for
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
  STA   $2003 ; Set the low byte (00) of the RAM address
  LDA   #$02
  STA   $4014 ; Set the high byte (02) of the RAM address, start the transfer

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
  .org  $E000
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
  .db $60,  $1E,  $00,  $42   ; U
  .db $60,  $17,  $00,  $51   ; N

  .db $60,  $0A,  $00,  $6F   ; A
  .db $60,  $0B,  $00,  $7E   ; B
  .db $60,  $1B,  $00,  $8D   ; R
  .db $60,  $0A,  $00,  $9C   ; A
  .db $60,  $23,  $00,  $AB   ; Z
  .db $60,  $18,  $00,  $BA   ; O
  
  .db $80,  $15,  $00,  $72   ; L
  .db $80,  $18,  $00,  $7E   ; O
  .db $80,  $0B,  $00,  $8A   ; B
  .db $80,  $18,  $00,  $96   ; O

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
  .org  $0000
  .incbin "mario.chr" ; includes 8KB graphics file from SMB1

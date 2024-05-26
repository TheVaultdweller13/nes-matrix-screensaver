; -----------------------------------------------------------
; ----------------------- INIT HEADER -----------------------
; -----------------------------------------------------------

.segment "HEADER"
  .byte $4e, $45, $53, $1a ; Magic string that always begins an iNES header
  .byte $02                ; Number of 16KB PRG-ROM banks
  .byte $01                ; Number of 8KB CHR-ROM banks
  .byte %00000001          ; Vertical mirroring, no save RAM, no mapper
  .byte %00000000          ; No special-case flags set, no mapper
  .byte $00                ; No PRG-RAM present
  .byte $00                ; NTSC format

.segment "ZEROPAGE"
figure: .res 1             ; Reserve 1 byte in zero page memory

.segment "STARTUP"
.segment "CODE"

.include "registers.inc"

; -----------------------------------------------------------
; ----------------------- SUBROUTINES -----------------------
; -----------------------------------------------------------
vblankwait:
  BIT PPUSTATUS
  BPL vblankwait
  RTS

delay:
  TXA
  PHA
  TYA
  PHA

  LDX #$FF
outer_loop:
  LDY #$FF
inner_loop:
  DEY
  BNE inner_loop
  DEX
  BNE outer_loop

  PLA
  TAY
  PLA
  TAX
  RTS

; -----------------------------------------------------------
; --------------------- INITIALIZATION ----------------------
; -----------------------------------------------------------

RESET:
  SEI
  CLD

  LDX #$40
  STX APU_FRAME_COUNTER

  LDX #$FF
  TXS

  INX
  STX PPUCTRL
  STX PPUMASK
  STX APU_DMC_1

  BIT PPUSTATUS

  JSR vblankwait

clrmem:
  STA $000, x
  STA $100, x
  STA $200, x
  STA $300, x
  STA $400, x
  STA $500, x
  STA $600, x
  STA $700, x
  INX
  BNE clrmem

  JSR vblankwait

  LDA PPUSTATUS

  LDA #$3F
  STA PPUADDR
  LDA #$10
  STA PPUADDR

loadPalettes:
  LDX #$00

loadBackgroundPaletteLoop:
  LDA background_palette, x
  STA PPUDATA
  INX
  CPX #$20
  BNE loadBackgroundPaletteLoop

  LDX #$00
loadSpritePaletteLoop:
  LDA sprite_palette, x
  STA PPUDATA
  INX
  CPX #$10
  BNE loadSpritePaletteLoop

loadSprites:
  LDX #$00
loadSpriteTitleLoop:
  LDA sprite_title, x
  STA $0200, x
  INX
  CPX #$24
  BNE loadSpriteTitleLoop

  LDX #$00
loadSpriteCharacterLoop:
  LDA sprite_character, x
  STA $0230, x
  INX
  CPX #$10
  BNE loadSpriteCharacterLoop

  LDA #$1F
  STA figure

  LDA #$88
  STA PPUCTRL

  LDA #%00010000
  STA PPUMASK

generateSound:
  LDA #%10111111
  STA APU_PULSE_1_CONTROL_1

loadNotes:
  LDA #$1
  STA APU_STATUS

  LDA #$00
  STA APU_PULSE_1_CONTROL_4

  LDX #$00
loadNotesLoop:
  LDA notes, x
  STA APU_PULSE_1_CONTROL_3
  INX
  JSR delay
  JSR delay
  CPX #$7
  BNE loadNotesLoop

  LDA #$0
  STA APU_STATUS

infiniteLoop:
  JMP infiniteLoop

NMI:
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA

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

  RTI

; -----------------------------------------------------------
; --------------------------- DATA --------------------------
; ------------------------------------------------------------
background_palette:
  .byte $22, $29, $1A, $0F
  .byte $22, $36, $17, $0F
  .byte $22, $30, $21, $0F
  .byte $22, $27, $17, $0F

sprite_palette:
  .byte $22, $16, $27, $18
  .byte $22, $1A, $30, $27
  .byte $22, $16, $30, $27
  .byte $22, $0F, $36, $17

sprite_title:
  .byte $60, $11, $00, $6C
  .byte $60, $18, $00, $78
  .byte $60, $15, $00, $84
  .byte $60, $0A, $00, $90

  .byte $80, $16, $02, $66
  .byte $80, $1E, $02, $72
  .byte $80, $17, $02, $7E
  .byte $80, $0D, $02, $8A
  .byte $80, $18, $02, $96

sprite_character:
  .byte $10, $B0, $01, $08
  .byte $10, $B2, $01, $0F
  .byte $18, $B1, $01, $08
  .byte $18, $B3, $01, $0F

notes:
  .byte $FD, $E2, $D2, $BD, $A9, $9F, $8E

.segment "VECTORS"
  .word NMI
  .word RESET
  .word 0

.segment "CHARS"
  .incbin "mario.chr"
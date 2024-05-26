; -----------------------------------------------------------
; -------------------------- INIT ---------------------------
; -----------------------------------------------------------
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

; Clear Memory
vblankwait1:       ; Subroutine to wait for vblank
  BIT PPUSTATUS   ; Check PPUSTATUS
  BPL vblankwait1  ; Loop until vblank starts (bit 7 is set)
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

vblankwait2:       ; Subroutine to wait for vblank
  BIT PPUSTATUS   ; Check PPUSTATUS
  BPL vblankwait2  ; Loop until vblank starts (bit 7 is set)

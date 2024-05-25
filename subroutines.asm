; -----------------------------------------------------------
; ----------------------- SUBROUTINES -----------------------
; -----------------------------------------------------------
vblankwait:       ; Subroutine to wait for vblank
  BIT $2002
  BPL vblankwait
  TXA
  RTS

delay:            ; Subroutine to wait in general
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
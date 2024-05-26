; -----------------------------------------------------------
; ----------------------- SUBROUTINES -----------------------
; -----------------------------------------------------------

delay:  ; Subroutine to wait in general
  TXA   ;
  PHA   ;
  TYA   ;
  PHA   ; Push registers X and Y onto the stack to save their previous values

  LDX #$FF
outer_loop:
  LDY #$FF
inner_loop:
  DEY
  BNE inner_loop
  DEX
  BNE outer_loop

  
  PLA   ;
  TAY   ;
  PLA   ;
  TAX   ; Restore the values of X and Y by popping them from the stack

  RTS   ; Return from subroutine
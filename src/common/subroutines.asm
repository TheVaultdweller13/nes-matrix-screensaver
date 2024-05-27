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


random:
  LDA seed        ; Load the current seed value into the accumulator
  
  ASL             ; Shifts all bits in the accumulator one position to the left 
                  ; The most significant bit (MSB) is moved 
                  ; into the carry flag (C), and the least 
                  ; significant bit (LSB) is set to 0.

  BCC no_eor      ; If no carry (MSB was 0), skip EOR
  EOR #$1D        ; XOR A with 0x1D to apply the polynomial for feedback
no_eor:
  STA seed        ; Store the new seed value back to memory
  RTS             ; Return from subroutine
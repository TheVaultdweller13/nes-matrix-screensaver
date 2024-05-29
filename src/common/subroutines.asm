.segment "STARTUP"
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
; -----------------------------------------------------------

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
; -----------------------------------------------------------
print_sprites:
  ; TODO: Improve the logic of sprite generation,
  ; and fix the bug in assigning non-randomized positions
    LDA sprites, x
    STA $0200, x
    
    JSR random
    STA $0201 ; Tile Number byte of the 1st character

    JSR random
    STA $0205 ; Tile Number byte of the 2nd character

    JSR random
    STA $0209 ; Tile Number byte of the 3rd character

    JSR random
    STA $020D ; Tile Number byte of the 4th character

    JSR random
    STA $0211 ; Tile Number byte of the 5th character

    JSR random
    STA $0215 ; Tile Number byte of the 6th character

    JSR random
    STA $0219 ; Tile Number byte of the 7th character

    JSR random
    STA $021D ; Tile Number byte of the 8th character

    CPX #$20
    BEQ end
  increment:
    INX
    JMP end
  end:
    RTS
; -----------------------------------------------------------
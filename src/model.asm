initializeModel:

updateModel:
  ; Update character table
characterTableUpdateLoop:
  LDY #$40                            ; store an iteration counter in Y (dec 64)
  JSR random                          ; generate a random position to update
  TXA                                 ; store it in X
  JSR random                          ; generate a random new character
  AND #%01111111                      ; limit random number to selectable chars
  TSA character_table, X              ; write the random character to position
  DEY                                 ; decrement iteration counter
  BNE characterTableUpdateLoop        ; continue until counter = 0

  ; Update illumination table
lightTableUpdateLoop:
  ; Y = 480
  LDY #$01E0                          ; store an iteration counter in Y

  ; A = light_table[Y]
  LDA light_table, Y                  ; load light_table[Y] to A
  ; A = A & 0x70
  AND #%01110000                      ; select lower 3 bits from high nibble
  ; we want to bitshift this high nibble to the right to make it a low nibble
  ; A >> 4
  LSR                                 ; logical shift right 1
  LSR                                 ; logical shift right 2
  LSR                                 ; logical shift right 3
  LSR                                 ; logical shift right 4
  ; we push the predecessor on the stack as an argument to the update function
  PHA                                 ; stack A

  ; A = light_table[Y]
  LDA light_table, Y                  ; load light_table[Y] to A
  ; A = A & 0x07
  AND #$00000111                      ; select lower 3 bits from low nibble
  ; lightTableCurrent = A
  ; we push the current on the stack as an argument to the update function
  PHA                                 ; stack A
  JSR updateLightLevel                ; call subroutine

  DEY
  BNE lightTableUpdateLoop

  ; Return to caller
  RTS

; Subroutine to update light level
updateLightLevel:
  ; TODO
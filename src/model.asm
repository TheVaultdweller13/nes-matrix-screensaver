initializeModel:

updateModel:
  ; Update character table
characterTableUpdateLoop:
  LDY #$40                      ; store an iteration counter in Y (dec 64)
  JSR random                    ; generate a random position to update
  TXA                           ; store it in X
  JSR random                    ; generate a random new character
  AND #%01111111                ; limit random number to selectable characters
  TSA character_table, X        ; write the random character to the random pos
  DEY                           ; decrement iteration counter
  BNQ characterTableUpdateLoop  ; continue until counter = 0

  ; Update illumination table
lightTableUpdateLoop:
  LDY #$01E0                    ; store an iteration counter in Y (dec 480)
  TYA                           ; copy counter to A
  DEC                           ; decrement A 
  LDA light_table, A            ; load light_table[Y-1] to A
  AND #%00000111                ; select lower 4 bits
  CMP #%00000111                ; if predecessor light level is > 7
  ; TODO: Code to handle the different situations
  DEY
  BNQ lightTableUpdateLoop

  ; Return to caller
  RTS
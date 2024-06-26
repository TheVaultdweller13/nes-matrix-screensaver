; -----------------------------------------------------------
; ------------------------ PALETTES -------------------------
; -----------------------------------------------------------

palette:
  ; background palette
  .byte $0F, $0F, $0F, $0F
  .byte $0F, $0F, $0F, $0F
  .byte $0F, $0F, $0F, $0F
  .byte $0F, $0F, $0F, $0F
  ; sprite palette  
  .byte $0F, $19, $29, $2A
  .byte $0F, $13, $29, $2A
  .byte $0F, $16, $29, $2A
  .byte $0F, $38, $29, $2A


sprites:
  ; Y Position, Tile number, Attributes, X Position
  .byte $08, $01, $00, $06
  .byte $08, $02, $00, $27
  .byte $08, $03, $00, $4A
  .byte $08, $04, $00, $6D
  .byte $08, $05, $00, $90
  .byte $08, $06, $00, $B3
  .byte $08, $07, $00, $D6
  .byte $08, $08, $00, $F4


; -----------------------------------------------------------
; ------------------------- SOUND ---------------------------
; -----------------------------------------------------------

notes:
; A, B, C, D, E, F, G.
  .byte $FD, $E2, $D2, $BD, $A9, $9F, $8E
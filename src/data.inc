; -----------------------------------------------------------
; ------------------------- PALETTES ------------------------
; ------------------------------------------------------------

background_palette:
  .byte $22 ,$29 ,$1A ,$0F       ; Background palette 1
  .byte $22 ,$36 ,$17 ,$0F       ; Background palette 2
  .byte $22 ,$30 ,$21 ,$0F       ; Background palette 3
  .byte $22 ,$27 ,$17 ,$0F       ; Background palette 4

sprite_palette:
  .byte $22 ,$16 ,$27 ,$18       ; Sprite palette 1
  .byte $22 ,$1A ,$30 ,$27       ; Sprite palette 2
  .byte $22 ,$16 ,$30 ,$27       ; Sprite palette 3
  .byte $22 ,$0F ,$36 ,$17       ; Sprite palette 4

sprite_title:
  ; Y Position, Tile number, Attributes, X Position
  .byte $60,  $11,  $00,  $6C   ; H
  .byte $60,  $18,  $00,  $78   ; O
  .byte $60,  $15,  $00,  $84   ; L
  .byte $60,  $0A,  $00,  $90   ; A

  .byte $80,  $16,  $02,  $66   ; M
  .byte $80,  $1E,  $02,  $72   ; U
  .byte $80,  $17,  $02,  $7E   ; N
  .byte $80,  $0D,  $02,  $8A   ; D
  .byte $80,  $18,  $02,  $96   ; O

sprite_character:
  ; Y Position, Tile number, Attributes, X Position
  .byte $10, $B0, $01, $08   ; sprite 0
  .byte $10, $B2, $01, $0F   ; sprite 1
  .byte $18, $B1, $01, $08   ; sprite 0
  .byte $18, $B3, $01, $0F   ; sprite 1


; -----------------------------------------------------------
; ------------------------- SOUND ------------------------
; ------------------------------------------------------------

notes:
; A, B, C, D, E, F, G.
  .byte $FD, $E2, $D2, $BD, $A9, $9F, $8E
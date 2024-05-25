; -----------------------------------------------------------
; --------------------------- PPU ---------------------------
; -----------------------------------------------------------
;     PPUMASK ($2001)
;     
;     76543210
;     ||||||||
;     |||||||+- Grayscale (0: normal color; 1: AND all palette entries
;     |||||||   with 0x30, effectively producing a monochrome display;
;     |||||||   note that colour emphasis STILL works when this is on!)
;     ||||||+-- Disable background clipping in leftmost 8 pixels of screen
;     |||||+--- Disable sprite clipping in leftmost 8 pixels of screen
;     ||||+---- Enable background rendering
;     |||+----- Enable sprite rendering
;     ||+------ Intensify reds (and darken other colors)
;     |+------- Intensify greens (and darken other colors)
;     +-------- Intensify blues (and darken other colors)
; -----------------------------------------------------------

  LDA $2002       ; Read PPU status to reset the high/low latch

  LDA #$3F        ; Flag 00111111
  STA $2006       ; Write the high byte of $3F00 address

  LDA #$00        ; Flag 00000000
  STA $2006       ; Write the low byte of $3F00 address

LoadPalettes:
  LDX #$00                      ; Reset X register for the coming loop
LoadBackgroundPaletteLoop:
  LDA background_palette, x     ; Load palette byte
  STA $2007                     ; Write to PPU
  INX                           ; Set index to next byte
  CPX #$20
  BNE LoadBackgroundPaletteLoop ;	If x = $20, 32 bytes copied, all done

  LDX #$00                      ; Reset X register for the coming loop
LoadSpritePaletteLoop:
  LDA sprite_palette, x         ; Load palette byte
  STA $2027                     ; Write to PPU
  INX                           ; Set index to next byte
  CPX #$10
  BNE LoadSpritePaletteLoop     ; If x = $10, all done

LoadSprites:
  LDX #$00                      ; Start at 0
LoadSpriteTitleLoop:
  LDA sprite_title, x           ; Load data from address (sprites + x)
  STA $0200, x                  ; Store into RAM address ($0200 + x)
  INX                           ; Increment X
  CPX #$30                      ; Check against 48 (hex 30)
  BNE LoadSpriteTitleLoop       ; If x = $30, 48 bytes copied, all done

  LDX #$00                      ; Reset X register for the coming loop
LoadSpriteCharacterLoop:
  LDA sprite_character, x       ; Load data from address (sprite_character + x)
  STA $0230, x                  ; Store into RAM address ($0230 + x)
  INX                           ; Increase pointer
  CPX #$10                      ; Until we've reached 16
  BNE LoadSpriteCharacterLoop   ; Else, iterate

  LDA #$1F                      ; 00011111 (animation pointer, confusing)
  STA figure                    ; Write to "figure" (0x00)

; -----------------------------------------------------------
  LDA #$88          ; enable NMI, sprites from Pattern Table 2
                    ; ($80 from pattern table 1)
  STA $2000

	LDA #%00010000
  STA $2001       ; Enable background and sprites
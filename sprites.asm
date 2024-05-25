; -----------------------------------------------------------
; ------------------------- SPRITES -------------------------
; -----------------------------------------------------------

; View the PPU registers information in the PPU section 
; of the "registers.asm" file.

  LDA PPUSTATUS   ; Read PPU status to reset the high/low latch

  LDA #$3F        ; Flag 00111111
  STA PPUADDR     ; Write the high byte of $3F00 address

  LDA #$10        ; Flag 00000000
  STA PPUADDR     ; Write the low byte of $3F00 address

LoadPalettes:
  LDX #$00                      ; Reset X register for the coming loop
LoadBackgroundPaletteLoop:
  LDA background_palette, x     ; Load palette byte
  STA PPUDATA                   ; Write to PPU
  INX                           ; Set index to next byte
  CPX #$20
  BNE LoadBackgroundPaletteLoop ;	If x = $20, 32 bytes copied, all done

  LDX #$00                      ; Reset X register for the coming loop
LoadSpritePaletteLoop:
  LDA sprite_palette, x         ; Load palette byte
  STA PPUDATA                   ; Write to PPU
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
  STA PPUCTRL

  LDA #%00010000
  STA PPUMASK       ; Enable sprites
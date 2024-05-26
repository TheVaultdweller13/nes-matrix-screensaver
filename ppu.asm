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

loadPalettes:
  LDX #$00                      ; Reset X register for the coming loop
loadBackgroundPaletteLoop:
  LDA background_palette, x     ; Load palette byte
  STA PPUDATA                   ; Write to PPU
  INX                           ; Set index to next byte
  CPX #$20
  BNE loadBackgroundPaletteLoop ; If x = 0x20, 32 bytes copied, all done

  LDX #$00                      ; Reset X register for the coming loop
loadSpritePaletteLoop:
  LDA sprite_palette, x         ; Load palette byte
  STA PPUDATA                   ; Write to PPU
  INX                           ; Set index to next byte
  CPX #$10
  BNE loadSpritePaletteLoop     ; If x = $10, all done

loadSprites:
  LDX #$00                      ; Start at 0
loadSpriteTitleLoop:
  LDA sprite_title, x           ; Load data from address (sprites + x)
  STA $0200, x                  ; Store into RAM address ($0200 + x)
  INX                           ; Increment X
  CPX #$24                      
  BNE loadSpriteTitleLoop

  LDX #$00                      ; Reset X register for the coming loop
loadSpriteCharacterLoop:
  LDA sprite_character, x
  STA $0230, x
  INX
  CPX #$10
  BNE loadSpriteCharacterLoop

  LDA #$1F                      ; 00011111 (animation pointer, confusing)
  STA figure                    ; Write to "figure" (0x00)

; -----------------------------------------------------------
  LDA #$88          ; enable NMI, sprites from Pattern Table 2
                    ; ($80 from pattern table 1)
  STA PPUCTRL

  LDA #%00010000
  STA PPUMASK       ; Enable sprites
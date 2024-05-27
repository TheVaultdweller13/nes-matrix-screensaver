; -----------------------------------------------------------
; ------------------------- SPRITES -------------------------
; -----------------------------------------------------------

; View the PPU registers information in the PPU section 
; of the "registers" file.
  LDA PPUSTATUS   ; Read PPU status to reset the high/low latch

start_seed:
  LDA #$14
  STA seed
loadPalettes:
  LDA #$3F                ; Flag 00111111
  STA PPUADDR             ; Write the high byte of $3F00 address

  LDA #00                 ; Flag 00000000
  STA PPUADDR             ; Write the low byte of $3F00 address

  LDX #$00                ; reset register x
loadPalettesLoop:
  LDA palette, x          ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA PPUDATA             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to 0x20
  BNE loadPalettesLoop  ; Branch to LoadPalettesLoop if compare was 
                        ; Not Equal to zero
                        ; if compare was equal to 32, keep going down

loadSprites:
  LDX #$00
loadSpritesLoop:
  LDA sprites, x
  STA $0200, x
  INX
  JSR random
  STA $201
  CPX #$10
  BNE loadSpritesLoop
                        
; -----------------------------------------------------------
  LDA #%10000000        ; enable NMI, sprites from Pattern Table 0
  STA PPUCTRL

  LDA #%00010000   ; no intensify (black background), enable sprites
  STA PPUMASK
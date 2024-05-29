; -----------------------------------------------------------
; -------------------- HEADERS CONFIG -----------------------
; -----------------------------------------------------------
.include "header.asm"
; -----------------------------------------------------------
; ---------------- CONSTANTS AND VARIABLES ------------------
; -----------------------------------------------------------
.include "common/registers.asm"
.include "common/variables.asm"
; -----------------------------------------------------------
; -------------------- GENERAL INCLUDES ---------------------
; -----------------------------------------------------------
.include "common/subroutines.asm"
; -----------------------------------------------------------
; -------------------------- MAIN ---------------------------
; -----------------------------------------------------------
.segment "CODE"
main:
.include "init.asm"
.include "ppu.asm"
.include "apu.asm"

start_seed:
  LDA #$14
  STA seed

clear_registers:
  LDA #$00
  TAX
  TAY
infiniteLoop:
  JMP infiniteLoop
; -----------------------------------------------------------
; -------------------------- NMI ----------------------------
; -----------------------------------------------------------
; Reference guide: https://www.nesdev.org/wiki/NMI
nmi:
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA

  ; TODO: Review movement logic
  ; LDA figure
  ; STA $0233
  ; STA $023B
  ; TAX
  ; CLC
  ; ADC #$08
  ; STA $0237
  ; STA $023F
  ; INX
  ; STX figure
  
  JSR print_sprites
  
  RTI

; -----------------------------------------------------------
; -------------------------- DATA ---------------------------
; -----------------------------------------------------------
.include "data.asm"
; -----------------------------------------------------------
; -------------------- VECTORS SETUP ------------------------
; -----------------------------------------------------------
.segment "VECTORS"
  .word nmi
  .word main
  .word 0
; -----------------------------------------------------------
; -------------------- CHARACTER SPRITES --------------------
; -----------------------------------------------------------
.segment "CHARS"
.incbin "sprites/font-8x8.chr"
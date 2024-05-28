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
  
  ; TODO: Improve the logic of sprite generation,
  ; and fix the bug in assigning non-randomized positions
  LDA sprites, x
  STA $0200, x
  
  JSR random
  STA $201 ; x -> position of the 1º character

  JSR random
  STA $205 ; -> x position of the 2º character

  JSR random
  STA $209 ; -> x position of the 3º character

  JSR random
  STA $20D ; -> x position of the 4º character

  JSR random
  STA $211 ; -> x position of the 5º character

  JSR random
  STA $215 ; -> x position of the 6º character

  JSR random
  STA $219 ; -> x position of the 7º character

  JSR random
  STA $21D ; -> x position of the 8º character

  INX
  ; END TODO
  
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
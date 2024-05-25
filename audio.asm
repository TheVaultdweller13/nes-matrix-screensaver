; -----------------------------------------------------------
; ------------------------- AUDIO ---------------------------
; -----------------------------------------------------------
; The APU has 5 channels: 
; Square 1, Square 2, Triangle, Noise and DMC (Pre-recorded-sounds)
;
;       APUFLAGS ($4015)
;       76543210
;        |||||
;        ||||+- Square 1 (0: disable; 1: enable)
;        |||+-- Square 2
;        ||+--- Triangle
;        |+---- Noise
;        +----- DMC
; -----------------------------------------------------------
 GenerateSound:
 ; Notes reference:
 ; NTSC: https://nerdy-nights.nes.science/downloads/missing/NotesTableNTSC.txt
 ; PAL:  https://nerdy-nights.nes.science/downloads/missing/NotesTablePAL.txt
 
  LDA #%10111111  ; Duty 10, Length Counter Disabled, Saw Envelopes disabled,
                  ; Volume F
  STA $4000

 LoadNotes:
  LDA #$1
  STA $4015  ; Activate a channel square 1
  
  LDA #$00
  STA $4003  ; Configure hight 3-bits of period

  LDX #$00
 LoadNotesLoop:
  LDA notes, x
  STA $4002  ; Configure low 8-bits of period

  INX
 
  JSR delay
  JSR delay
 
  CPX #$7
  BNE LoadNotesLoop

  LDA #$0
  STA $4015  ; Disable square 1
 

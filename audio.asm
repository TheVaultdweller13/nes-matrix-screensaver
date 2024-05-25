; -----------------------------------------------------------
; ------------------------- AUDIO ---------------------------
; -----------------------------------------------------------
 GenerateSound: 
  LDA #%10111111  ; Duty 10, Length Counter Disabled, Saw Envelopes disabled,
                  ; Volume F
  STA APU_PULSE_1_CONTROL_1

 LoadNotes:
  LDA #$1
  STA APU_STATUS  ; Activate a channel square 1
  
  LDA #$00
  STA APU_PULSE_1_CONTROL_4  ; Configure hight 3-bits of period

  LDX #$00
 LoadNotesLoop:
  LDA notes, x
  STA APU_PULSE_1_CONTROL_3  ; Configure low 8-bits of period

  INX
 
  JSR delay
  JSR delay
 
  CPX #$7
  BNE LoadNotesLoop

  LDA #$0
  STA APU_STATUS  ; Disable square 1
 

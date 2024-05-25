; -----------------------------------------------------------
; ------------------------- AUDIO ---------------------------
; -----------------------------------------------------------
 GenerateSound:
 ; Notes reference:
 ; NTSC: https://nerdy-nights.nes.science/downloads/missing/NotesTableNTSC.txt
 ; PAL:  https://nerdy-nights.nes.science/downloads/missing/NotesTablePAL.txt
 
   LDA #%10111111 ; duty 10, Length Counter Disabled, Saw Envelopes disabled,
                  ; Volume F
   STA $4000
 
 LoadNotes:
   ; CHANNEL SQUARE 1
   LDA #$1
   STA $4015
   LDX #$00
 
   LDA #$00
   STA $4003
 
 LoadNotesLoop:
   LDA notes, x
   STA $4002
     
   INX
 
   JSR delay
   JSR delay
 
   CPX #$7
   BNE LoadNotesLoop
 
 ; END CHANNEL
   LDA #%0000000
   STA $4015

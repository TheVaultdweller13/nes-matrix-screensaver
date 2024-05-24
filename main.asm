;	----------------------- CART CONFIG -----------------------
  .inesprg 1 ; 1x 16KB PRG code
  .ineschr 1 ; 1x  8KB CHR data
  .inesmap 0 ; mapper 0 = NROM, no bank swapping
  .inesmir 1 ; background mirroring
; -----------------------------------------------------------
  .rsset $0000
  
player_x .rs 1

  .bank 0
  .org  $8000
RESET:
  SEI        ; ignore IRQs
  CLD        ; disable decimal mode
  LDX #$40
  STX $4017 ; disable APU frame IRQ
  LDX #$ff
  TXS        ; Set up stack
  INX        ; now X = 0
  STX $2000  ; disable NMI
  STX $2001  ; disable rendering
  STX $4010  ; disable DMC IRQs

; Read PPU status to clear any pending flags and prepare for further synchronization.
  BIT $2002

vblankwait1:
  BIT $2002
  BPL vblankwait1
  TXA

clrmem:
  STA $000,x
  STA $100,x
  STA $200,x
  STA $300,x
  STA $400,x
  STA $500,x
  STA $600,x
  STA $700,x
  INX
  BNE clrmem

vblankwait2:
  BIT $2002
  BPL vblankwait2
; ----------------- SPRITES -------------------
LoadPalettes:
  LDA   $2002   ; read PPU status to reset the high/low latch
  LDA   #$3F
  STA   $2006   ; write the high byte of $3F00 address
  LDA   #$00
  STA   $2006   ; write the low byte of $3F00 address
  LDX   #$00
LoadBackgroundPaletteLoop:
  LDA   background_palette, x     ; Load palette byte
  STA   $2007                     ; Write to PPU
  INX                             ; Set index to next byte
  CPX   #$20
  BNE   LoadBackgroundPaletteLoop ;	If x = $20, 32 bytes copied, all done
  LDX #$00

LoadSpritePaletteLoop:
  LDA sprite_palette, x     ;load palette byte
  STA $2007                 ;write to PPU
  INX                       ;set index to next byte
  CPX #$10            
  BNE LoadSpritePaletteLoop ; if x = $10, all done

LoadSpriteTitle:
  LDX #$00                ; start at 0
LoadSpriteTitleLoop:
  LDA sprite_title, x          ; Load data from address (sprites + x)
  STA $0200, x            ; Store into RAM address ($0200 + x)
  INX                     ; Increment X
  CPX #$30                ; Check against 48 (hex 30)
  BNE LoadSpriteTitleLoop     ; If x = $30, 48 bytes copied, all done

  LDA #$10          ; enable sprites
  STA $2001

LoadSpriteCharacter:
  LDX #$00
LoadSpriteCharacterLoop:
  LDA sprite_character, x
  STA $0230, x
  INX
  CPX #$10
  BNE LoadSpriteCharacterLoop

  LDA $0201
  STA player_x

  
;------
  LDA #$88          ; enable NMI, sprites from Pattern Table 2 ($80 from pattern table 1)
  STA $2000

  LDA #$10          ; enable sprites
  STA $2001

; -------------------------------------------
; ----------------- AUDIO -------------------
;;;; GenerateSound:
;;;; ; Notes reference:
;;;; ; NTSC: https://nerdy-nights.nes.science/downloads/missing/NotesTableNTSC.txt
;;;; ; PAL:  https://nerdy-nights.nes.science/downloads/missing/NotesTablePAL.txt
;;;; 
;;;;   LDA #%10111111 ;Duty 10, Length Counter Disabled, Saw Envelopes disabled, Volume F
;;;;   STA $4000
;;;; 
;;;; LoadNotes:
;;;;   ; CHANNEL SQUARE 1
;;;;   LDA #$1
;;;;   STA $4015
;;;;   LDX #$00
;;;; 
;;;;   LDA #$00
;;;;   STA $4003
;;;; 
;;;; LoadNotesLoop:
;;;;   LDA notes, x
;;;;   STA $4002
;;;;     
;;;;   INX
;;;; 
;;;;   JSR delay
;;;;   JSR delay
;;;; 
;;;;   CPX #$7
;;;;   BNE LoadNotesLoop
;;;; 
;;;; ; END CHANNEL
;;;;   LDA #%0000000
;;;;   STA $4015

; -------------------------------------------

delay:
  TXA
  PHA
  TYA
  PHA

  LDX #$FF
outer_loop:
  LDY #$FF
inner_loop:
  DEY
  BNE inner_loop
  DEX
  BNE outer_loop

  PLA
  TAY
  PLA
  TAX
  RTS

InfiniteLoop:
  JMP   InfiniteLoop

NMI:
  LDA   #$00
  STA   $2003 ; set the low byte (00) of the RAM address
  LDA   #$02
  STA   $4014 ; set the high byte (02) of the RAM address, start the transfer

  LDA player_x
  STA $0233
  STA $023B
  TAX
  CLC
  ADC #$08
  STA $0237
  STA $023F
  INX
  STX player_x

  RTI         ; return from interrupt
; -------------------------------------------
  .bank 1
  .org  $E000
; ---------- PALETTES AND SPRITES ----------
background_palette:
  .db $22 ,$29 ,$1A ,$0F       ;background palette 1
  .db $22 ,$36 ,$17 ,$0F       ;background palette 2
  .db $22 ,$30 ,$21 ,$0F       ;background palette 3
  .db $22 ,$27 ,$17 ,$0F       ;background palette 4
  
sprite_palette:
  .db $22 ,$16 ,$27 ,$18       ;sprite palette 1
  .db $22 ,$1A ,$30 ,$27       ;sprite palette 2
  .db $22 ,$16 ,$30 ,$27       ;sprite palette 3
  .db $22 ,$0F ,$36 ,$17       ;sprite palette 4
   
sprite_title:
  ; Y Position, Tile number, Attributes, X Position
  .db $60,  $1E,  $00,  $42   ; U
  .db $60,  $17,  $00,  $51   ; N

  .db $60,  $0A,  $00,  $6F   ; A
  .db $60,  $0B,  $00,  $7E   ; B
  .db $60,  $1B,  $00,  $8D   ; R
  .db $60,  $0A,  $00,  $9C   ; A
  .db $60,  $23,  $00,  $AB   ; Z
  .db $60,  $18,  $00,  $BA   ; O   
  
  .db $80,  $15,  $00,  $72   ; L
  .db $80,  $18,  $00,  $7E   ; O
  .db $80,  $0B,  $00,  $8A   ; B
  .db $80,  $18,  $00,  $96   ; O

sprite_character:
  ; Y Position, Tile number, Attributes, X Position
  .db $10, $B0, $00, $10   ;sprite 0
  .db $10, $B2, $00, $18   ;sprite 1
  .db $18, $B1, $00, $10   ;sprite 0
  .db $18, $B3, $00, $18   ;sprite 1

; C, D, E, F, G, A, B.
notes:
  .db $D2, $BD, $A9, $9F, $8E, $FD, $E2

; -------------------------------------------
  .org  $FFFA   ; First of the three vectors starts here
  .dw   NMI     ; When an NMI happens (once per frame if enabled) the 
                ; processor will jump to the label NMI:
  .dw   RESET   ; When the processor first turns on or is reset, it will jump
                ; to the label RESET:
  .dw   0       ; external interrupt IRQ is not used in this tutorial
; -------------------------------------------
  .bank 2
  .org  $0000
  .incbin "mario.chr" ; includes 8KB graphics file from SMB1

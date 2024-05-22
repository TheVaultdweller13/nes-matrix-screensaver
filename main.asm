;	----------------------- CART CONFIG -----------------------
  .inesprg 1 ; 1x 16KB PRG code
  .ineschr 1 ; 1x  8KB CHR data
  .inesmap 0 ; mapper 0 = NROM, no bank swapping
  .inesmir 1 ; background mirroring
; -----------------------------------------------------------

  .bank 0
  .org  $C000
RESET:
  SEI        ; ignore IRQs
  CLD        ; disable decimal mode
  LDX #$40
  STX $4017  ; disable APU frame IRQ
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

LoadPalettes:
  LDA   $2002		; read PPU status to reset the high/low latch
  LDA   #$3F
  STA   $2006		; write the high byte of $3F00 address
  LDA   #$00
  STA   $2006		; write the low byte of $3F00 address
  LDX   #$00
LoadPalettesLoop:
  LDA   palette, x				; Load palette byte
  STA   $2007 						; Write to PPU
  INX     								; Set index to next byte
  CPX   #$20							; Check against 32 (hex 30)
  BNE   LoadPalettesLoop	;	If x = $20, 32 bytes copied, all done

LoadSprites:
  LDX #$00              ; start at 0
LoadSpritesLoop:
  LDA sprites, x        ; Load data from address (sprites + x)
  STA $0200, x          ; Store into RAM address ($0200 + x)
  INX                   ; Increment X
  CPX #$30              ; Check against 48 (hex 30)
  BNE LoadSpritesLoop   ; If x = $30, 48 bytes copied, all done
	
            
  LDA #%10001000        ; enable NMI, sprites from Pattern Table 1
  STA $2000

  LDA #%00010000        ; enable sprites
  STA $2001

GenerateSound:
  LDA #%10111111 ;Duty 10, Length Counter Disabled, Saw Envelopes disabled, Volume F
  STA $4000

	; CHANNEL SQUARE 1
	;		C
	LDA #%00000001
  STA $4015
	LDA #$AA   
  STA $4002
  LDA #$01
  STA $4003
	JSR delay
  ;		D
	LDA #%00000001
  STA $4015
	LDA #$7B 
  STA $400
  LDA #$01
  STA $4003
	JSR delay

	; 	E
  LDA #%00000001
  STA $4015
	LDA #$52
  STA $4002
  LDA #$01
  STA $4003
	JSR delay

	;		F
  LDA #%00000001
  STA $4015
	LDA #$3F
  STA $4002
  LDA #$01
  STA $4003
  JSR delay

	;		G
  LDA #%00000001
  STA $4015
	LDA #$1C
  STA $4002
  LDA #$01
  STA $4003
  JSR delay

	;		A
	LDA #%00000001
  STA $4015
	LDA #$FE
  STA $4002
  LDA #$00
  STA $4003
	JSR delay

	;		B
	LDA #%00000001
  STA $4015
	LDA #$E1
  STA $4002
  LDA #$00
  STA $4003
	JSR delay


; END CHANNEL
	LDA #%0000000
  STA $4015

InfiniteLoop:
  JMP   InfiniteLoop

NMI:
  LDA   #$00
  STA   $2003 ; set the low byte (00) of the RAM address
  LDA   #$02
  STA   $4014 ; set the high byte (02) of the RAM address, start the transfer

  RTI     		; return from interrupt

delay:
  LDX #$FF
delay_loop1:
  LDY #$FF
delay_loop2:
  DEY
  BNE delay_loop2
  DEX
  BNE delay_loop1
  RTS

  .bank 1
  .org  $E000
palette:
  .db $0F,$00,$10,$20,$0F,$01,$21,$31,$0F,$00,$10,$20,$0F,$01,$21,$31  ; Background palette data
  .db $0F,$07,$16,$27,$0F,$06,$16,$26,$0F,$16,$26,$36,$0F,$16,$26,$36  ; Sprite palette data

sprites:
	; 	Y Position, Tile number, Attributes, X Position
  .db 		$60, 				$1E, 				$00, 				$42   ; U
  .db 		$60, 				$17, 				$00, 				$51   ; N

  .db 		$60, 				$0A, 				$00, 				$6F   ; A
  .db 		$60, 				$0B, 				$00, 				$7E   ; B
  .db 		$60, 				$1B, 				$00, 				$8D   ; R
  .db 		$60, 				$0A, 				$00, 				$9C   ; A
  .db 		$60, 				$23, 				$00, 				$AB   ; Z
  .db 		$60, 				$18, 				$00, 				$BA   ; O

  .db 		$80, 				$15, 				$00, 				$72   ; L
  .db 		$80, 				$18, 				$00, 				$7E   ; O
  .db 		$80, 				$0B, 				$00, 				$8A   ; B
  .db 		$80, 				$18, 				$00, 				$96   ; O

  .org  $FFFA 	; First of the three vectors starts here

  .dw   NMI 		; When an NMI happens (once per frame if enabled) the 
          			; processor will jump to the label NMI:
  .dw   RESET 	; When the processor first turns on or is reset, it will jump
          			; to the label RESET:
  .dw   0 			; external interrupt IRQ is not used in this tutorial

  .bank 2
  .org  $0000
  .incbin "mario.chr" ; includes 8KB graphics file from SMB1



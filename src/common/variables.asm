figure: .res 1              ; Reserve 1 byte in zero page memory
seed: .res 1                ; Semilla para el LFSR

; Table for the character in each screen position
;
; Each position in this table contains a byte that represents a character from
; the font sprite sheet.
;
; To save memory we only represent 1 quarter of the screen, then, we replicate
; the same table in each quadrant but adding a random value to it.
character_table: .res 240

; Table for the character illumination level
;
; This table contains 4 bits for each element on the screen. Each group
; represents the character's horizontal mirroring (true/false) and the
; character's light level (from 0-8) represented by increasingly brighter colors
; on the palette.
;
; b0: horizontally mirror character
; b1: light value 0
; b2: light value 1
; b3: light value 2
light_table: .res 480

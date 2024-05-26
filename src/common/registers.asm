; -----------------------------------------------------------
; --------------------------- PPU ---------------------------
; -----------------------------------------------------------

; Reference guide: https://www.nesdev.org/wiki/PPU_registers

PPUCTRL = $2000   ; https://www.nesdev.org/wiki/PPU_registers#PPUCTRL
PPUMASK = $2001   ; https://www.nesdev.org/wiki/PPU_registers#PPUMASK
PPUSTATUS = $2002 ; https://www.nesdev.org/wiki/PPU_registers#PPUSTATUS
PPUADDR = $2006   ; https://www.nesdev.org/wiki/PPU_registers#PPUADDR
PPUDATA = $2007   ; https://www.nesdev.org/wiki/PPU_registers#PPUDATA
OAMADDR = $2003   ; https://www.nesdev.org/wiki/PPU_registers#OAMADDR
OAMDMA = $4014    ; https://www.nesdev.org/wiki/PPU_registers#OAMDMA

; -----------------------------------------------------------
; --------------------------- APU ---------------------------
; -----------------------------------------------------------

; Reference guide: https://www.nesdev.org/wiki/APU_registers

APU_PULSE_1_CONTROL_1 = $4000
APU_PULSE_1_CONTROL_3 = $4002
APU_PULSE_1_CONTROL_4 = $4003
APU_DMC_1 = $4010
APU_STATUS = $4015 ; Mentioned as APUFLAGS in some guides
APU_FRAME_COUNTER = $4017

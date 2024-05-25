ASM = nesasm

INPUT = main.asm
OUTPUT = main.nes

build : $(INPUT)

run : build
	fceux $(OUTPUT)

main.nes : $(INPUT)
	$(ASM) $(INPUT)

clean :
	rm $(OUTPUT) main.fns

.PHONY : clean

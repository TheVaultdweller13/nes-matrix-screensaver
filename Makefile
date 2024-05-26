ASM = ca65
LINKER = ld65

SOURCE_DIR = src
CONFIG = nes.cfg

INPUT = $(SOURCE_DIR)/main.asm
OBJECT = $(SOURCE_DIR)/main.o
OUTPUT = $(SOURCE_DIR)/main.nes

all: build

run : build
	fceux $(OUTPUT)

build : $(OUTPUT)

$(OUTPUT) : $(OBJECT)
	$(LINKER) $(OBJECT) -C $(CONFIG) -o $(OUTPUT)

$(OBJECT) : $(INPUT)
	$(ASM) $(INPUT)

clean :
	rm -f $(OUTPUT) $(SOURCE_DIR)/*.o $(SOURCE_DIR)/*.nes

.PHONY : clean

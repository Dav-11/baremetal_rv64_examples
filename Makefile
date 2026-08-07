OUT_DIR = .bin
SRC_DIR = src

LLD 	?= /opt/homebrew/bin/ld.lld
CLANG 	?= /opt/homebrew/opt/llvm/bin/clang
QEMU	?= qemu-system-riscv64

S_NAME		?= add
SRC_FILE 		= $(SRC_DIR)/$(S_NAME).c
LINKER_SCRIPT 	= $(SRC_DIR)/$(S_NAME).ld
OBJ_NAME 		= $(OUT_DIR)/$(S_NAME).o
ELF_NAME 		= $(OUT_DIR)/$(S_NAME).elf

.PHONY: all
all: $(ELF_NAME)

$(OUT_DIR):
	mkdir -p $@

$(OUT_DIR)/entry.o: $(SRC_DIR)/entry.asm $(OUT_DIR)
	$(CLANG) \
		--target=riscv64 \
		-march=rv64gc \
		-mabi=lp64d \
		-mcmodel=medany \
		-c $(SRC_DIR)/entry.asm \
		-o $@

$(OUT_DIR)/entry_gem5.o: $(SRC_DIR)/entry_gem5.asm $(OUT_DIR)
	$(CLANG) \
		--target=riscv64 \
		-march=rv64gc \
		-mabi=lp64d \
		-mcmodel=medany \
		-c $(SRC_DIR)/entry_gem5.asm \
		-o $@

$(OBJ_NAME): $(SRC_FILE) $(OUT_DIR)
	$(CLANG) \
		--target=riscv64 \
		-march=rv64gc \
		-mabi=lp64d \
		-mcmodel=medany \
		-ffreestanding \
		-c $(SRC_FILE) \
		-o $@

$(ELF_NAME): $(OUT_DIR)/entry_gem5.o $(OBJ_NAME) $(LINKER_SCRIPT)
	$(LLD) \
		-T $(LINKER_SCRIPT) \
		$(OUT_DIR)/entry_gem5.o \
		$(OBJ_NAME) \
		-o $@

.PHONY: run
run: $(ELF_NAME)
	$(QEMU) \
		-machine virt \
		-nographic \
		-bios none \
		-kernel $(ELF_NAME)

clean:
	rm -rf $(OUT_DIR)/*.o $(OUT_DIR)/*.elf
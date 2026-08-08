
# Folders
OUT_DIR := .bin
SRC_DIR := src

# Executables
LLD 	?= /opt/homebrew/bin/ld.lld
CLANG 	?= /opt/homebrew/opt/llvm/bin/clang
QEMU	?= qemu-system-riscv64

# Flags
C_FLAGS 	?= --target=riscv64 -march=rv64gc -mabi=lp64d -mcmodel=medany -ffreestanding
ASM_FLAGS 	?= --target=riscv64 -march=rv64gc -mabi=lp64d

# Sources
C_SRCS  	:= $(wildcard $(SRC_DIR)/*.c)
ASM_SRCS  	:= $(wildcard $(SRC_DIR)/*.asm)
LD_SRCS  	:= $(wildcard $(SRC_DIR)/*.ld)

# output files
C_OBJS		:= $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.o, $(C_SRCS))
ASM_OBJS	:= $(patsubst $(SRC_DIR)/%.asm, $(OUT_DIR)/%.o, $(ASM_SRCS))
OBJS		:= $(C_OBJS) $(ASM_OBJS)
ELFS		:= \
	$(OUT_DIR)/multi_slice.elf


.PHONY: all
all: $(OBJS) $(ELFS)

$(OUT_DIR):
	mkdir -p $@

$(OUT_DIR)/%.o: $(SRC_DIR)/%.c | $(OUT_DIR)
	$(CLANG) \
		$(C_FLAGS) \
		-Dmain=main_$(subst .,_,$(subst -,_,$(basename $(notdir $*)))) \
		-c $< \
		-o $@

$(OUT_DIR)/%.o: $(SRC_DIR)/%.asm | $(OUT_DIR)
	$(CLANG) \
		$(ASM_FLAGS) \
		-c $< \
		-o $@

$(OUT_DIR)/multi_slice.elf: $(OUT_DIR)/add_entry.o $(OUT_DIR)/select_entry.o $(OUT_DIR)/add.o $(OUT_DIR)/select.o $(SRC_DIR)/multi_slice.ld
	$(LLD) \
		-T $(SRC_DIR)/multi_slice.ld \
		$(OUT_DIR)/add_entry.o \
		$(OUT_DIR)/select_entry.o \
		$(OUT_DIR)/add.o \
		$(OUT_DIR)/select.o \
		-o $@

.PHONY: run
run: $(OUT_DIR)/multi_slice.elf
	$(QEMU) \
		-machine virt \
		-nographic \
		-bios none \
		-kernel $(OUT_DIR)/multi_slice.elf

clean:
	rm -rf $(OUT_DIR)/*.o $(OUT_DIR)/*.elf
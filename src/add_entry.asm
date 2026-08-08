.section .text.entry_add
.global _start_add

_start_add:
    # 1. Set up the stack pointer
    .option push
    .option norelax
    la sp, _stack_top_add
    .option pop

    # 2. Call main_add using jump-and-link
    jal main_add

    # 3. Exit gem5 simulation
    li a0, 0            # delay = 0
    .word 0x4200007b    # gem5 m5_exit instruction

park:
    wfi
    j park

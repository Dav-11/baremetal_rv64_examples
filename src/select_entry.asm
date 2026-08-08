.section .text.entry_select
.global _start_select

_start_select:
    # 1. Set up the stack pointer
    .option push
    .option norelax
    la sp, _stack_top_select
    .option pop

    # 2. Call main_select using jump-and-link
    jal main_select

    # 3. Exit gem5 simulation
    li a0, 0            # delay = 0
    .word 0x4200007b    # gem5 m5_exit instruction

park:
    wfi
    j park

.equ TARGET_HART, 1 # replace with core ID

.section .text.entry_select
.global _start_select

_start_select:
    # 0. Ensure only core TARGET_HART is running this code, else goto exit_sim
    csrr a0, mhartid
    li a1, TARGET_HART
    bne a0, a1, exit_sim

    # 1. Set up the stack pointer
    .option push
    .option norelax
    la sp, _stack_top_select
    .option pop

    # 2. Call main_select using jump-and-link
    jal main_select

    j exit_sim

exit_sim:
    # Exit gem5 simulation
    li a0, 0            # delay = 0
    .word 0x4200007b    # gem5 m5_exit instruction

park:
    wfi
    j park

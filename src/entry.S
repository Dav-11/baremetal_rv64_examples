.section .text.entry
.global _start

_start:
    # 1. Only allow hart 0 to run the main code; park others
    csrr a0, mhartid
    bnez a0, park

    # 2. Set up the stack pointer
    .option push
    .option norelax
    la sp, _stack_top
    .option pop

    # 3. Call main
    tail main

park:
    wfi
    j park

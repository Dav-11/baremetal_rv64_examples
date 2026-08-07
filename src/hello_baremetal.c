#define UART0 ((volatile char *)0x10000000)

void main(void) {
    const char *str = "Hello, Bare-Metal RISC-V!\n";
    while (*str) {
        *UART0 = *str++;
    }
    while (1); // Halt loop
}

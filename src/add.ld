ENTRY(_start)

MEMORY
{
  ram (rwx) : ORIGIN = 0x00000000, LENGTH = 128M
}

SECTIONS
{
  .text : {
    *(.text.entry)
    *(.text*)
  } > ram

  .rodata : {
    *(.rodata*)
  } > ram

  .data : {
    *(.data*)
  } > ram

  .bss : {
    *(.bss*)
  } > ram

  . = ALIGN(16);
  . += 0x1000; /* 4KB Stack space */
  _stack_top = .;
}
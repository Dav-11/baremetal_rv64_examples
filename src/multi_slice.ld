ENTRY(_start_add)

MEMORY
{
  /* The address of the first instruction for each slice is defined here by the ORIGIN of each memory region. */
  slice_add (rwx)    : ORIGIN = 0x00000000, LENGTH = 1M
  slice_select (rwx) : ORIGIN = 0x00100000, LENGTH = 1M
}

SECTIONS
{
  /* ==================== ADD SLICE ==================== */
  .add_text : {
    KEEP(*(.text.entry_add))
    *entry_add.o(.text*)
    *add.o(.text*)
  } > slice_add

  .add_rodata : {
    *add.o(.rodata*)
  } > slice_add

  .add_data : {
    *add.o(.data*)
  } > slice_add

  .add_bss : {
    *add.o(.bss*)
  } > slice_add

  .add_stack : {
    . = ALIGN(16);
    . += 0x1000; /* 4KB Stack space for ADD program */
    _stack_top_add = .;
  } > slice_add

  /* ==================== SELECT SLICE ==================== */
  .select_text : {
    KEEP(*(.text.entry_select))
    *entry_select.o(.text*)
    *select.o(.text*)
  } > slice_select

  .select_rodata : {
    *select.o(.rodata*)
  } > slice_select

  .select_data : {
    *select.o(.data*)
  } > slice_select

  .select_bss : {
    *select.o(.bss*)
  } > slice_select

  .select_stack : {
    . = ALIGN(16);
    . += 0x1000; /* 4KB Stack space for SELECT program */
    _stack_top_select = .;
  } > slice_select

  /* Discard compiler/linker attributes and debug/exception frames not needed for baremetal execution */
  /DISCARD/ : {
    *(.eh_frame)
    *(.comment)
    *(.riscv.attributes)
  }
}

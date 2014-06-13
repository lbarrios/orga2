/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

    Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

/* Bool */
/* -------------------------------------------------------------------------- */
#define TRUE                    0x00000001
#define FALSE                   0x00000000
#define ERROR                   1


/* Misc */
/* -------------------------------------------------------------------------- */
#define CANT_TANQUES            8
#define PAGE_SIZE               0x00001000 /* 4Kbytes */
#define TASK_SIZE               2 * 4096
#define CAMPO_SIZE              50
#define IDENTITY_MAPPING_LAST_BYTE 0xDC3FFF
#define KERNEL_STACK_ADDR		0x27000


/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_IDX_NULL_DESC           0

/* Offsets en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_OFF_NULL_DESC           (GDT_IDX_NULL_DESC      << 3)

/* Paginacion */
/* -------------------------------------------------------------------------- */
#define PAGE_DIR_FIRST_ENTRY 0x27000
#define FIRST_PAGE_TABLE 0x28000
#define PAGE_DIR_ENTRY_SIZE 0x4 /* 4bytes */
#define PAGE_TABLE_ENTRY_SIZE 0x4 /* 4bytes */
#define PAGE_DIR_ENTRY_COUNT 1024
#define PAGE_TABLE_ENTRY_COUNT 1024

/* MMU */
/* -------------------------------------------------------------------------- */
#define MMU_ADDRESS 0x100000


#endif  /* !__DEFINES_H__ */

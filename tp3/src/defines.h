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

/* Segmentación */
/* -------------------------------------------------------------------------- */
#define GDT_KERNEL_CODE_SEGMENT_DESCRIPTOR (8<<3)
#define GDT_USER_CODE_SEGMENT_DESCRIPTOR (9<<3)
#define GDT_KERNEL_DATA_SEGMENT_DESCRIPTOR (10<<3)
#define GDT_USER_DATA_SEGMENT_DESCRIPTOR (11<<3)
#define GDT_VIDEO_SEGMENT_DESCRIPTOR (12<<3)

/* Paginacion */
/* -------------------------------------------------------------------------- */
#define KERNEL_PAGE_DIR_FIRST_ENTRY 0x27000
#define FIRST_PAGE_TABLE 0x28000
#define PAGE_DIR_ENTRY_SIZE 0x4 /* 4bytes */
#define PAGE_TABLE_ENTRY_SIZE 0x4 /* 4bytes */
#define PAGE_DIR_ENTRY_COUNT 1024
#define PAGE_TABLE_ENTRY_COUNT 1024

/* MMU */
/* -------------------------------------------------------------------------- */
#define MMU_ADDRESS 0x100000


//CCASSERT - 強制編譯時斷言
#define CCASSERT(predicate) _x_CCASSERT_LINE(predicate, __LINE__)
#define _x_CCASSERT_LINE(predicate, line) typedef char constraint_violated_on_line_##line[2*((predicate)!=0)-1];
//典型的使用：
/* Use:
To assert in compilation time :)
Si la condición es falsa, entonces la compilación falla

Ejemplo:
	CCASSERT(sizeof(_someVariable)==4)
*/


float frand( int *seed )
{
    union
    {
        float fres;
        unsigned int ires;
    };

    seed[0] *= 16807;

    ires = ((((unsigned int)seed[0])>>9 ) | 0x3f800000);
    return fres - 1.0f;
}

#endif  /* !__DEFINES_H__ */

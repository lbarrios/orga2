/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de la tabla de descriptores globales
*/

#include "gdt.h"

#define SEG_DATA_R          0x00 // Read-Only
#define SEG_DATA_R_A        0x01 // Read-Only, accessed
#define SEG_DATA_RW         0x02 // Read/Write
#define SEG_DATA_RW_A       0x03 // Read/Write, accessed
#define SEG_DATA_R_EXP      0x04 // Read-Only, expand-down
#define SEG_DATA_R_EXP_A    0x05 // Read-Only, expand-down, accessed
#define SEG_DATA_RW_EXP     0x06 // Read/Write, expand-down
#define SEG_DATA_RW_EXP_A   0x07 // Read/Write, expand-down, accessed
#define SEG_CODE_X          0x08 // Execute-Only
#define SEG_CODE_X_A        0x09 // Execute-Only, accessed
#define SEG_CODE_XR         0x0A // Execute/Read
#define SEG_CODE_XR_A       0x0B // Execute/Read, accessed
#define SEG_CODE_X_C        0x0C // Execute-Only, conforming
#define SEG_CODE_X_C_A      0x0D // Execute-Only, conforming, accessed
#define SEG_CODE_XR_C       0x0E // Execute/Read, conforming
#define SEG_CODE_XR_CA      0x0F // Execute/Read, conforming, accessed

gdt_entry gdt[GDT_COUNT] = {
  /* Descriptor nulo*/
  /* Offset = 0x00 */
  [GDT_IDX_NULL_DESC] = (gdt_entry) {
    (unsigned short)    0x0000,         /* limit[0:15]  */
    (unsigned short)    0x0000,         /* base[0:15]   */
    (unsigned char)     0x00,           /* base[23:16]  */
    (unsigned char)     0x00,           /* type         */
    (unsigned char)     0x00,           /* s            */
    (unsigned char)     0x00,           /* dpl          */
    (unsigned char)     0x00,           /* p            */
    (unsigned char)     0x00,           /* limit[16:19] */
    (unsigned char)     0x00,           /* avl          */
    (unsigned char)     0x00,           /* l            */
    (unsigned char)     0x00,           /* db           */
    (unsigned char)     0x00,           /* g            */
    (unsigned char)     0x00,           /* base[31:24]  */
  },
  { (int) 0, (int) 0 },
  { (int) 0, (int) 0 },
  { (int) 0, (int) 0 },
  { (int) 0, (int) 0 },
  { (int) 0, (int) 0 },
  { (int) 0, (int) 0 },
  { (int) 0, (int) 0 },
  // Segmento de código para Kernel (nivel 0)
  {//indice 8
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = SEG_CODE_X, // 1000 en binario, Code Execute-Only
    .s  = 1, // Código/Datos
    .dpl = 0, // Nivel de privilegio 0
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  },
  // Segmento de código para Usuario (nivel 3)
  {
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = SEG_CODE_X, // 1000 en binario, Code Execute-Only
    .s  = 1, // Código/Datos
    .dpl = 3, // Nivel de privilegio 3
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  },
  // Segmento de datos para Kernel (nivel 0)
  {
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = SEG_DATA_RW, // 1000 en binario, Data Read-Only
    .s  = 1, // Código/Datos
    .dpl = 0, // Nivel de privilegio 0
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  },
  // Segmento de datos para Usuario (nivel 3)
  {
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = SEG_DATA_RW, // 1000 en binario, Data Read-Only
    .s = 1, // Código/Datos
    .dpl = 3, // Nivel de privilegio 3
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  },
  {//indice 12
    .base_0_15 = 0x8000,
    .base_23_16 = 0xB,
    .base_31_24 = 0,
    .limit_0_15 = 0x1F40,
    .limit_16_19 = 0,
    .type = 2,
    .s = 1,
    .dpl = 0,
    .p = 1,
    .avl = 0,
    .l = 0,
    .db = 1,
    .g = 0
  },
  {
    .base_0_15 = 0x8000,
    .base_23_16 = 0xB,
    .base_31_24 = 0,
    .limit_0_15 = 0x1F40,
    .limit_16_19 = 0,
    .type = 2,
    .s = 1,
    .dpl = 0,
    .p = 1,
    .avl = 0,
    .l = 0,
    .db = 1,
    .g = 0
  },
  // tres descriptores de TSS, nulos
  { (int) 0, (int) 0 }, //indice 14 -> 0x70
  { (int) 0, (int) 0 }, //indice 15 -> 0x78
  { (int) 0, (int) 0 }  //indice 16 -> 0x80
};

gdt_descriptor GDT_DESC = {
    sizeof(gdt) - 1,
    (unsigned int)(unsigned long)&gdt// El compilador me estaba haciendo bulling
};

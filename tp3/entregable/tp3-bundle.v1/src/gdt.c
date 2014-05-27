/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de la tabla de descriptores globales
*/

#include "gdt.h"

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
  { (int) 0, (int) 0 },
  {
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = 8, // 1000 en binario, Code Execute-Only
    .s  = 1, // Código/Datos
    .dpl = 0, // Nivel de privilegio 0
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  },
  {
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = 8, // 1000 en binario, Code Execute-Only
    .s  = 1, // Código/Datos
    .dpl = 3, // Nivel de privilegio 3
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  },
  {
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = 0, // 1000 en binario, Data Read-Only
    .s  = 1, // Código/Datos
    .dpl = 0, // Nivel de privilegio 0
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  },
  {
    .base_0_15 = 0,
    .base_23_16 = 0,
    .base_31_24 = 0,
    // Hay que direccionar 187648 bloques de 4 kbytes
    // o sea 0x2DCFF
    .limit_0_15 = 0xDCFF,
    .limit_16_19 = 0x2,
    .type = 0, // 1000 en binario, Data Read-Only
    .s  = 1, // Código/Datos
    .dpl = 3, // Nivel de privilegio 3
    .p = 1, // 1 = Presente
    .avl = 0, // A disposición del programador
    .l = 0, // Va en 0 cuando estás en 32 bits
    .db = 1, // 0=16bits, 1=32bits
    .g = 1 // Granularidad, bloques de 4k
  }
};

gdt_descriptor GDT_DESC = {
    sizeof(gdt) - 1,
    (unsigned int) &gdt
};

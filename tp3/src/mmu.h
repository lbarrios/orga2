/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#ifndef __MMU_H__
#define __MMU_H__

#include "defines.h"
#include "i386.h"
#include "tss.h"
#include "game.h"

#define PAGE_DIR_ENTRY_NOT_PRESENT (int) 0
#define PAGE_TABLE_ENTRY_NOT_PRESENT (int) 0


typedef struct str_page_dir_entry {
  unsigned char present:1;
  unsigned char read_write:1;
  unsigned char user_supervisor:1;
  unsigned char write_through:1;
  unsigned char cache_disable:1;
  unsigned char accessed:1;
  unsigned char ignored:1;
  unsigned char page_size:1;
  unsigned char global:1;
  unsigned char trash:3;
  unsigned int  table_base:20;
} __attribute__((__packed__, aligned (8))) page_dir_entry;


typedef struct str_page_table_entry {
  unsigned char present:1;
  unsigned char read_write:1;
  unsigned char user_supervisor:1;
  unsigned char write_through:1;
  unsigned char cache_disable:1;
  unsigned char accessed:1;
  unsigned char dirty:1;
  unsigned char attribute_index:1;
  unsigned char global:1;
  unsigned char trash:3;
  unsigned int  page_base:20;
} __attribute__((__packed__, aligned (8))) page_table_entry;


void mmu_inicializar();
void mmu_inicializar_dir_kernel();


#endif	/* !__MMU_H__ */

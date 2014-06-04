/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"

void mmu_inicializar() {

}


void mmu_inicializar_dir_kernel() {
    int i, j;
    for (i = 0; i < 1024; i++) {
        page_dir_entry *pde = (page_dir_entry*)(PAGE_DIR_FIRST_ENTRY + i * 4);
        *pde = (const page_dir_entry){0};//PAGE_DIR_ENTRY_NOT_PRESENT;
    }
    for (i = 0; i < 4; i++) {
        page_dir_entry *pde = (page_dir_entry*)(PAGE_DIR_FIRST_ENTRY + i * 4);
        pde->present = 1; 
        pde->read_write = 1; 
        pde->table_base = 0x28000 + i * 0x1000; 
        for (j = 0; j < 1024; j++) {
            page_table_entry *pte = (page_table_entry*)(pde->table_base + j * 4);
            *pte = (const page_table_entry){0}; //PAGE_TABLE_ENTRY_NOT_PRESENT;
        }
    }
    int offset = 0;
    while (offset < 0xDC3FFF) {
        page_table_entry *pte = (page_table_entry*) (FIRST_PAGE_TABLE + offset); // 0x28000
        pte->table_base = offset;
        pte->read_write = 1;
        pte->present = 1;
        offset += 4;
    }
}

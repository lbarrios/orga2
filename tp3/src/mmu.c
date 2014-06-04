/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"

void mmu_inicializar() {

}


void mmu_inicializar_dir_kernel()
{
  int i, j;
  // Recorro las 1024 entradas del Directorio de Páginas y las lleno con entradas nulas
  for (i = 0; i < PAGE_DIR_ENTRY_COUNT; i++)
  {
    // Obtengo la dirección de la entrada de directorio con la cuenta
    // Dirección Base + (indice*4), sabiendo que cada página ocupa 4 Bytes
    page_dir_entry *pde = (page_dir_entry*)(PAGE_DIR_FIRST_ENTRY + (i*4));
    // Guardo una entrada de directorio nula (no presente)
    *pde = (const page_dir_entry){0};
  }

  // Luego recorro las 4 primeras entradas del directorio y las habilito
  for (i = 0; i < 4; i++)
  {
    // Obtengo la dirección de la entrada sobre la que estoy iterando
    page_dir_entry *pde = (page_dir_entry*)(PAGE_DIR_FIRST_ENTRY + (i*4));
    // Marco el bit de presente (presente)
    pde->present = 1;
    // Marco el bit de read/write (write)
    pde->read_write = 1;
    // Sabiendo que cada tabla ocupa 4KB, ya que son 4 bytes por entrada de tabla
    // y son 1024 entradas, y que las 4 tablas son consecutivas, marco el
    // bit de "base de tabla" como la dirección de la base de la primera tabla
    // sumado al índice*TAM_TABLA, o sea (índice*4K) => (0x28000 + 0x1000*i).
    // (¡¡¡Todo esto shifteado 12 posiciones hacia la derecha!!!)
    pde->table_base = ( (FIRST_PAGE_TABLE+ (i * PAGE_SIZE)) >> 12 );
    // Para cada tabla a la que estoy apuntando
    // recorro sus 1024 entradas y las lleno con entradas nulas
    for (j = 0; j < PAGE_TABLE_ENTRY_COUNT; j++)
    {
      // Obtengo la dirección de la entrada de tabla
      // usando la base de tabla seteada anteriormente + 4*indice
      page_table_entry *pte = (page_table_entry*)(pde->table_base + j * 4);
      // Gurado una entrada de tabla nula (no presente)
      *pte = (const page_table_entry){0};
    }
  }

  // Como la paginación es identity mapping para las direcciones físicas
  // {0x0 ... 0xDC3FFF), seteo una variable page_offset en cero, y voy recorriendo
  // las entradas de las tablas definidas anteriormente en un while, aumentando
  // en cada iteración el entry_offset con el tamaño de la entrada de tabla
  // (PAGE_TABLE_ENTRY_SIZE, 4), y el page_offset con el tamaño de una página
  // (PAGE_SIZE, 4K = 4096) siempre que mi offset sea menor a 0xDC3FFF
  int entry_offset = 0;
  int page_offset = 0;
  while ( page_offset < IDENTITY_MAPPING_LAST_BYTE )// 0xDC3FFF
  {
    // Sabiendo que las tablas están consecutivas, voy a obtenerlas a partir de
    // la primer entrada de la primer tabla, sumando el entry_offset
    page_table_entry *pte = (page_table_entry*) (FIRST_PAGE_TABLE + entry_offset);
    // Le asigno como dirección base de la página el page_offset shifteado 12
    // veces a la derecha, de esta forma logro hacer identity mapping
    pte->page_base = (page_offset>>12);
    // read_write = 1 (página de escritura)
    pte->read_write = 1;
    // present = 1 (página presente)
    pte->present = 1;
    page_offset += PAGE_SIZE;
    entry_offset += PAGE_TABLE_ENTRY_SIZE;
  }

}
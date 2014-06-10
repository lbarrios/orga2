/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"

void mmu_inicializar() {
  unsigned int tanque;
  // Apunto la struct mmu a la dirección de la constante MMU_ADDR
  mmu_t* mmu = (mmu_t*) MMU_ADDRESS;
  // Seteo la base de páginas libres a la constante FREE_PAGES_BASE
  mmu->free_pages_base = (void*) FREE_PAGES_BASE;
  // Seteo la cantidad de páginas usadas en 0
  mmu->used_pages = 0;
  // Inicializo el directorio de páginas para cada tanque
  for(tanque = 0; tanque < CANT_TANQUES; tanque ++)
  {
    mmu_inicializar_dir_tarea( tanque );
  }
}

inline void* mmu_get_free_page()
{
  mmu_t* mmu = (mmu_t*) MMU_ADDRESS;
  return (void*) FREE_PAGES_BASE + (PAGE_SIZE)*(mmu->used_pages++);
}

void mmu_inicializar_dir_kernel()
{
  unsigned int i, j;
  // Recorro las 1024 entradas del Directorio de Páginas y las lleno con entradas nulas
  for (i = 0; i < PAGE_DIR_ENTRY_COUNT; i++)
  {
    // Obtengo la dirección de la entrada de directorio con la cuenta
    // Dirección Base + (indice*4), sabiendo que cada página ocupa 4 Bytes
    page_dir_entry *pde = (page_dir_entry*)(PAGE_DIR_FIRST_ENTRY + (i*4));
    // Guardo una entrada de directorio nula (no presente)
    *pde = NOT_PRESENT_DIR_ENTRY;
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
    pde->table_base = ( (FIRST_PAGE_TABLE + (i * PAGE_TABLE_ENTRY_SIZE * PAGE_TABLE_ENTRY_COUNT)) >> 12 );
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

void mmu_inicializar_dir_tarea (unsigned int tarea)
{
  unsigned int i,j;
  void* pagina_libre;
  // Obtengo la dirección de la estructura mmu
  mmu_t* mmu = (mmu_t*) MMU_ADDRESS;

  // Creamos las PAGE_DIR_ENTRY_COUNT (1024) entradas del directorio de páginas
  for (i = 0; i < PAGE_DIR_ENTRY_COUNT; i++)
  {
    // Obtengo la dirección de la entrada sobre la que estoy iterando
    page_dir_entry* pde = (page_dir_entry*) &(mmu->task_page_dir[tarea]) + (i * PAGE_DIR_ENTRY_SIZE);
    // Guardo una entrada "nula" (descriptor de tabla no presente)
    *pde = NOT_PRESENT_DIR_ENTRY;
  }
  // Recorro las 4 primeras entradas del directorio y las habilito
  for (i = 0; i < 4; i++)
  {
    // Obtengo la dirección de la entrada sobre la que estoy iterando
    page_dir_entry* pde = (page_dir_entry*) (&(mmu->task_page_dir[tarea]) + (i * PAGE_DIR_ENTRY_SIZE));
    // Marco el bit de presente (presente)
    pde->present = 1;
    // Marco el bit de read/write (write)
    pde->read_write = 1;
    // Obtengo una página de memoria del pool de paginas libres
    pagina_libre = mmu_get_free_page();
    // Guardo los 20 bits más significativos de la base de la tabla
    pde->table_base = ((int)pagina_libre)>>12;
    // Para cada tabla a la que estoy apuntando
    for (j = 0; j < PAGE_TABLE_ENTRY_COUNT; j++)
    {
      // Obtengo la dirección de la entrada de tabla
      page_table_entry *pte = (page_table_entry*)(pde->table_base + (j * PAGE_TABLE_ENTRY_SIZE));
      // Gurado una entrada de tabla nula (no presente)
      *pte = NOT_PRESENT_TABLE_ENTRY;
    }
  }
  int entry_offset = 0;
  int page_offset = 0;
  while ( page_offset < IDENTITY_MAPPING_LAST_BYTE )// 0xDC3FFF
  {
    // Sabiendo que las tablas están consecutivas, voy a obtenerlas a partir de
    // la primer entrada de la primer tabla, sumando el entry_offset
    page_table_entry *pte = (page_table_entry*) (mmu->task_page_dir[tarea].pde[0].table_base << 12) + entry_offset;
    // Le asigno como dirección base de la página el page_offset shifteado 12
    // veces a la derecha, de esta forma logro hacer identity mapping
    pte->page_base = (page_offset>>12);
    // La página es de escritura
    pte->read_write = 1;
    // La página está presente
    pte->present = 1;
    // Sumo PAGE_SIZE al offset de páginas
    page_offset += PAGE_SIZE;
    // Sumo PAGE_TABLE_ENTRY_SIZE al offset de entradas
    entry_offset += PAGE_TABLE_ENTRY_SIZE;
  }
  // Reemplazar las siguientes dos líneas por un randomizador
  void* code_page_1 = 0x40000 + (0x2000 * tarea);
  void* code_page_2 = 0x41000 + (0x2000 * tarea);
  mmu_mapear_pagina(TASK_FIRST_CODE_PAGE, mmu->task_page_dir[0], code_page_1, 0)
  mmu_mapear_pagina(TASK_SECOND_CODE_PAGE, mmu->task_page_dir[0], code_page_2, 0)
}
void mmu_mapear_pagina(unsigned int virtual, unsigned int cr3, unsigned int fisica, unsigned int atributos)
{
  unsigned int directorio = (virtual>>22);
  unsigned int tabla = ((virtual<<10)>>22);
  page_dir* pd = (page_dir*) cr3;
  page_dir_entry* pde = (page_dir_entry*) pd + (directorio*PAGE_DIR_ENTRY_SIZE);
  page_table_entry* pte = (page_table_entry*) (pde->table_base<<12);
  //unsigned int offset;
}

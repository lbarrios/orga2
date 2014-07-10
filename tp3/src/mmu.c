/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"

void mmu_inicializar()
{
	BOCHSDEBUG("Iniciando MMU...")
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

void* mmu_get_free_page()
{
  mmu_t* mmu = (mmu_t*) MMU_ADDRESS;
  return (void*) (FREE_PAGES_BASE + (PAGE_SIZE)*((unsigned long)mmu->used_pages++));
}

void mmu_inicializar_dir_kernel()
{
  unsigned long i, j;
  // Recorro las 1024 entradas del Directorio de Páginas y las lleno con entradas nulas
  for (i = 0; i < PAGE_DIR_ENTRY_COUNT; i++)
  {
    // Obtengo la dirección de la entrada de directorio con la cuenta
    // Dirección Base + (indice*4), sabiendo que cada entrada ocupa 4 Bytes
    page_dir_entry *pde = (page_dir_entry*)(KERNEL_PAGE_DIR_FIRST_ENTRY + (i*PAGE_DIR_ENTRY_SIZE));
    // Guardo una entrada de directorio nula (no presente)
    *pde = NOT_PRESENT_DIR_ENTRY;
  }

  // Luego recorro las 4 primeras entradas del directorio y las habilito
  for (i = 0; i < 4; i++)
  {
    // Obtengo la dirección de la entrada sobre la que estoy iterando
    page_dir_entry *pde = (page_dir_entry*)(KERNEL_PAGE_DIR_FIRST_ENTRY + (i*4));
    // Marco el bit de presente (presente)
    pde->present = PTE_PRESENT;
    // Marco el bit de read/write (write)
    pde->read_write = PTE_WRITE;
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
      page_table_entry *pte = (page_table_entry*)((pde->table_base<<12) + (j*4));
      // Gurado una entrada de tabla nula (no presente)
      *pte = NOT_PRESENT_TABLE_ENTRY;
    }
  }

  // Como la paginación es identity mapping para las direcciones físicas
  // {0x0 ... 0xDC3FFF), seteo una variable page_offset en cero, y voy recorriendo
  // las entradas de las tablas definidas anteriormente en un while, aumentando
  // en cada iteración el entry_offset con el tamaño de la entrada de tabla
  // (PAGE_TABLE_ENTRY_SIZE, 4), y el page_offset con el tamaño de una página
  // (PAGE_SIZE, 4K = 4096) siempre que mi offset sea menor a 0xDC3FFF
  unsigned long entry_offset = 0;
  unsigned long page_offset = 0;
  while ( page_offset < IDENTITY_MAPPING_LAST_BYTE )// 0xDC3FFF
  {
    // Sabiendo que las tablas están consecutivas, voy a obtenerlas a partir de
    // la primer entrada de la primer tabla, sumando el entry_offset
    page_table_entry *pte = (page_table_entry*) (FIRST_PAGE_TABLE + entry_offset);
    // Le asigno como dirección base de la página el page_offset shifteado 12
    // veces a la derecha, de esta forma logro hacer identity mapping
    pte->page_base = (page_offset>>12);
    // read_write = 1 (página de escritura)
    pte->read_write = PTE_WRITE;
    // present = 1 (página presente)
    pte->present = PTE_PRESENT;
    page_offset += PAGE_SIZE;
    entry_offset += PAGE_TABLE_ENTRY_SIZE;
  }
}

void mmu_inicializar_dir_tarea (unsigned int tarea)
{
  BD("Iniciando mmu tarea ") char debugtarea = '1'; debugtarea += tarea; BD(debugtarea) BD(".....") BDENTER()
  unsigned long i,j;
  void* pagina_libre;
  // Obtengo la dirección de la estructura mmu
  mmu_t* mmu = (mmu_t*) MMU_ADDRESS;

  // Creamos las PAGE_DIR_ENTRY_COUNT (1024) entradas del directorio de páginas
  for (i = 0; i < PAGE_DIR_ENTRY_COUNT; i++)
  {
    // Obtengo la dirección de la entrada sobre la que estoy iterando
    page_dir_entry* pde = (page_dir_entry*) &(mmu->task_page_dir[tarea].pde[i]);
    // Guardo una entrada "nula" (descriptor de tabla no presente)
    *pde = NOT_PRESENT_DIR_ENTRY;
  }
  // Recorro las 4 primeras entradas del directorio y las habilito
  for (i = 0; i < 4; i++)
  {
    // Obtengo la dirección de la entrada sobre la que estoy iterando
    page_dir_entry* pde = (page_dir_entry*) &(mmu->task_page_dir[tarea].pde[i]);
    // Marco el bit de presente (presente)
    pde->present = PTE_PRESENT;
    // Marco el bit de read/write (write)
    pde->read_write = PTE_WRITE;
    // Obtengo una página de memoria del pool de paginas libres
    //BOCHSDEBUG("pido pagina libre")
    pagina_libre = mmu_get_free_page();
    // Guardo los 20 bits más significativos de la base de la tabla
    pde->table_base = ((unsigned long)pagina_libre)>>12;
    // Para cada tabla a la que estoy apuntando
    for (j = 0; j < PAGE_TABLE_ENTRY_COUNT; j++)
    {
      // Obtengo la dirección de la entrada de tabla
      page_table_entry *pte = (page_table_entry*)((pde->table_base<<12) + (j * PAGE_TABLE_ENTRY_SIZE));
      // Guardo una entrada de tabla nula (no presente)
      *pte = NOT_PRESENT_TABLE_ENTRY;
    }
  }
  unsigned long page_offset = 0;
  unsigned long dir_entry_offset = 0;
  unsigned long table_entry_offset = 0;
  // adonde ponemos que es de nivel 0 este mapeo? como dice el enunciado, no lo entiendo...
  while ( page_offset < IDENTITY_MAPPING_LAST_BYTE)// 0xDC3FFF
  {
    dir_entry_offset = (page_offset>>22);
    table_entry_offset = ((page_offset<<10)>>22);
    // Sabiendo que las tablas están consecutivas, voy a obtenerlas a partir de
    // la primer entrada de la primer tabla, sumando el table_entry_offset
    page_dir* pd = &(mmu->task_page_dir[tarea]);
    page_dir_entry* pde = &(pd->pde[dir_entry_offset]);
    //BD(" reservando en pde == &(pd->pde[1]) == ") BDPOINTER(pde) BDENTER()
    page_table_entry *pte = (page_table_entry*) ((pde->table_base << 12) + (table_entry_offset * PAGE_TABLE_ENTRY_SIZE));
    // Le asigno como dirección base de la página el page_offset shifteado 12
    // veces a la derecha, de esta forma logro hacer identity mapping
    pte->page_base = (page_offset>>12);
    // La página es de escritura
    pte->read_write = PTE_WRITE;
    // La página está presente
    pte->present = PTE_PRESENT;
    // Sumo PAGE_SIZE al offset de páginas
    page_offset += PAGE_SIZE;
  }
  // 
  //Obtengo las dos páginas físicas de código de la tarea usando un randomizador
  //
  // Obtengo el time stamp counter
  int seed = time();
  // Dirección base del mapa
  unsigned long base_addr = GAME_MAP_FIRST_ADDRESS;
  // 
  //Usando TSC como seed, corro frand() que me devuelve un float entre 0 y 1
  //y luego multiplico ese número por el tamaño del mapa en bytes, obteniendo
  //así un offset para mi tarea
  //

  unsigned long offset_1 = (unsigned long)(frand(&seed)*(GAME_MAP_LAST_ADDRESS - GAME_MAP_FIRST_ADDRESS));
  unsigned long offset_2 = (unsigned long)(frand(&seed)*(GAME_MAP_LAST_ADDRESS - GAME_MAP_FIRST_ADDRESS));
  
  //primero pruebo con no randoms
  //unsigned long offset_1 = 0x1000;
  //unsigned long offset_2 = 0x2000;

  // Uso una máscara para quitar los últimos 12 bits de la dirección obtenida
  unsigned long bitmask = 0xFFFFF000;
  unsigned long code_page_1_addr = (base_addr + offset_1) & bitmask;
  unsigned long code_page_2_addr = (base_addr + offset_2) & bitmask;

  marcar_pos_inicial(code_page_2_addr, tarea);
  marcar_pos_inicial(code_page_1_addr, tarea);

  // tengo que copiar el codigo de la tarea a tal direccion fisica
  int *base_codigo1 = (int*)(long)(0x10000 + tarea*2*0x1000);
  int *base_codigo2 = (int*)(long)(0x10000 + tarea*2*0x1000+0x1000);

  int *copioAca1 = (int*)code_page_1_addr;
  int *copioAca2 = (int*)code_page_2_addr;

  for (i = 0; i < 0x1000/sizeof(int); i++) {
    copioAca1[i] = base_codigo1[i];
    copioAca2[i] = base_codigo2[i];
  }


  BD(" code_page_1_addr ") BDPOINTER(code_page_1_addr) BDENTER()
  BD(" code_page_2_addr ") BDPOINTER(code_page_2_addr) BDENTER()
  // Obtengo el puntero a la dirección física de la página
  void* code_page_1 = (void*) ( code_page_1_addr );
  void* code_page_2 = (void*) ( code_page_2_addr );
  // Casteo una estructura de atributos con todos los valores en 0
  page_table_attributes attr = NOT_PRESENT_PAGE_TABLE_ATTRIBUTES;
  // Marco la página presente
  attr.present = PTE_PRESENT;
  // Marco la página como de escritura
  attr.read_write = PTE_WRITE;
  // Marco la página como "de usuario"
  attr.user_supervisor = PTE_USER;
  // Mapeo las dos páginas de código de la tarea
  mmu_mapear_pagina(TASK_FIRST_CODE_PAGE, &(mmu->task_page_dir[tarea]), code_page_1, attr);
  mmu_mapear_pagina(TASK_SECOND_CODE_PAGE, &(mmu->task_page_dir[tarea]), code_page_2, attr);
  //page_dir_entry *debugD = &(mmu->task_page_dir[tarea].pde[0x200]);
  //page_table_entry *debugT1 = (page_table_entry*)((debugD->table_base)<<12);
  //page_table_entry *debugT2 = (page_table_entry*)(((debugD->table_base)<<12) + PAGE_TABLE_ENTRY_SIZE);
  //BD("debug d ") BDPOINTER(debugD)
  //BD("debug t1 ") BDPOINTER(debugT1)
  //BD("debug t2 ") BDPOINTER(debugT2)
}

void mmu_mapear_pagina(unsigned long virtual_addr, page_dir* cr3, void* fisica, page_table_attributes atributos)
{
  //BD(" virtual_addr ") BDPOINTER(virtual_addr) BDENTER()
  BD(" cr3 ") BDPOINTER(cr3) BDENTER()
  //BD(" fisica ") BDPOINTER(fisica) BDENTER()
  // Obtengo el índice que voy a utilizar para acceder a la entrada correspondiente en el directorio de páginas
  unsigned long pde_index = (virtual_addr>>22);
  // Obtengo el índice que voy a utilizar para acceder a la entrada correspondiente en la tabla de páginas
  unsigned long pte_index = ((virtual_addr<<10)>>22);
  // Obtengo un puntero al directorio de páginas de la tarea
  BD("pde_index: ") BDPOINTER(pde_index) BDENTER()
  BD("pte_index: ") BDPOINTER(pte_index) BDENTER()
  page_dir* pd = cr3;
  // Obtengo un puntero a la entrada correspondiente al índice pde_index
  page_dir_entry* pde = &(pd->pde[pde_index]);
  BD("pde: ") BDPOINTER(pde) BDENTER()
  // Me fijo si el bit de presente está marcado
  if ( !(pde->present == (unsigned char)1) )
  {
    // La tabla de páginas todavía no existe; así que la tengo que crear
    pde->present = PTE_PRESENT;
    pde->user_supervisor = PTE_USER;
    pde->read_write = PTE_WRITE;
    // Obtengo un pedazo de memoria en el que guardar la nueva tabla de páginas
    pde->table_base = ((unsigned long)mmu_get_free_page()>>12);
    BD(" creando tabla cuyo indice es: ") BDPOINTER((unsigned long)pde->table_base) BDENTER()
    // Reemplazo todas las entradas de la nueva tabla de páginas por un descriptor de página no presente
    long i;
    for(i=0;i<PAGE_TABLE_ENTRY_COUNT;i++)
    {
      *(page_table_entry*)((((unsigned long)pde->table_base)<<12) + i * PAGE_DIR_ENTRY_SIZE) = NOT_PRESENT_TABLE_ENTRY;
    }
  } 
  // En este punto, ya sea porque ya existía o porque la acabo de crear, la tabla de páginas ya existe.

  // Obtengo la dirección de la entrada de la tabla de página que se corresponde con el pte_index
  page_table_entry* pte = (page_table_entry*) ((((unsigned long)pde->table_base<<12) + pte_index * PAGE_DIR_ENTRY_SIZE));
  // Asigno el valor base de la página los 20 bits más significativos de la dirección física
  pte->page_base = (((unsigned long)fisica)>>12);
  PTE_LOAD_ATTRIBUTES((*pte), atributos);
}

void mmu_unmapear_pagina(unsigned long virtual_addr, void* cr3)
{
  // Obtengo el índice que voy a utilizar para acceder a la entrada correspondiente en el directorio de páginas
  unsigned long pde_index = (virtual_addr>>22);
  // Obtengo el índice que voy a utilizar para acceder a la entrada correspondiente en la tabla de páginas
  unsigned long pte_index = ((virtual_addr<<10)>>22);
  // Obtengo un puntero al directorio de páginas de la tarea
  page_dir* pd = (page_dir*) cr3;
  // Obtengo un puntero a la entrada correspondiente al índice pde_index
  page_dir_entry* pde = (page_dir_entry*) pd + (pde_index*PAGE_DIR_ENTRY_SIZE);
  // Obtengo la dirección de la entrada de la tabla de página que se corresponde con el pte_index
  page_table_entry* pte = (page_table_entry*) (((unsigned long)pde->table_base<<12) + pte_index);
  // Reemplazo el descriptor por un descriptor de página no presente
  *pte = NOT_PRESENT_TABLE_ENTRY;
}

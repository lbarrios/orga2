/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#include "tss.h"

// TSS
tss tss_inicial = (const tss) {0};
tss tss_next_1 = (const tss) {0xffff};
tss tss_next_2 = (const tss) {0xffff};

// Contextos backup
tss tss_idle;
tss tss_tanques[CANT_TANQUES];

void tss_inicializar()
{
  gdt_entry* gdte;

  /* 
  Inicializo el descriptor de tarea inicial
  */
  // Obtengo la dirección del descriptor de tarea inicial
  gdte = &(gdt[GDT_INIT_DESCRIPTOR]);
  // Guardo en la parte baja del atributo base los bits menos 
  // significativos de la dirección tss_inicial (se trunca automáticamente)
  gdte->base_0_15 = ((long)&(tss_inicial));
  // Pongo los 8 bits del medio, shifteando 16 veces
  gdte->base_23_16 = ((long)&(tss_inicial))>>16;
  // Pongo los 8 bits más significativos shifteando 24 veces
  gdte->base_31_24 = ((long)&(tss_inicial))>>24;
  // El tipo de descriptor es NOT_BUSY
  gdte->type = GDT_TSS_NOT_BUSY_DESCRIPTOR_TYPE;
  // El descriptor está presente
  gdte->p = GDT_PRESENT;
  // Guardo en límite el tamaño del TSS
  gdte->limit_0_15 = TSS_SIZE;

  /* 
  Inicializo el descriptor de tarea 1
  */
  // Obtengo la dirección del descriptor de tarea 1
  gdte = &(gdt[GDT_TASK1_DESCRIPTOR]);
  // En adelante se omiten comentarios, es igual a GDT_INIT
  gdte->base_0_15 = ((long)&(tss_next_1));
  gdte->base_23_16 = ((long)&(tss_next_1))>>16;
  gdte->base_31_24 = ((long)&(tss_next_1))>>24;
  gdte->type = GDT_TSS_NOT_BUSY_DESCRIPTOR_TYPE;
  gdte->p = GDT_PRESENT;
  gdte->limit_0_15 = TSS_SIZE;

  /* 
  Inicializo el descriptor de tarea 2
  */
  // Obtengo la dirección del descriptor de tarea 2
  gdte = &(gdt[GDT_TASK2_DESCRIPTOR]);
  // En adelante se omiten comentarios, es igual a GDT_INIT
  gdte->base_0_15 = ((long)&(tss_next_2));
  gdte->base_23_16 = ((long)&(tss_next_2))>>16;
  gdte->base_31_24 = ((long)&(tss_next_2))>>24;
  gdte->type = GDT_TSS_NOT_BUSY_DESCRIPTOR_TYPE;
  gdte->p = GDT_PRESENT;
  gdte->limit_0_15 = TSS_SIZE;
}

void tss_inicializar_idle()
{
  // Descriptor de código
  tss_next_1.cs = GDT_KERNEL_CODE_SEGMENT_DESCRIPTOR;
  // Descriptores de datos
  tss_next_1.ds = GDT_KERNEL_DATA_SEGMENT_DESCRIPTOR;
  tss_next_1.es = tss_next_1.ds;
  tss_next_1.gs = tss_next_1.ds;
  tss_next_1.ss = tss_next_1.ds;
  tss_next_1.fs = tss_next_1.ds;
  // Instruction Pointer
  tss_next_1.eip = IDLE_TASK_ADDR;
  // Stack
  tss_next_1.esp = KERNEL_STACK_ADDR;
  tss_next_1.ebp = KERNEL_STACK_ADDR;
  // Paginación
  tss_next_1.cr3 = KERNEL_PAGE_DIR_FIRST_ENTRY;

  /*
  // Casteo el page dir
  page_dir* pd_idle = (page_dir*) tss_next_1.cr3;
  // Obtengo la pde correspondiente a la direcciòn lògica 0x80000000 
  page_dir_entry* pde = &((pd_idle->pde)[TASK_FIRST_CODE_PAGE>>22]);
  // Marco el bit de presente (presente)
    pde->present = PTE_PRESENT;
    // Marco el bit de read/write (write)
    pde->read_write = PTE_WRITE;
    // Obtengo la dirección base de la page_table
    pde->table_base = (unsigned long)mmu_get_free_page();
    // Marco todas "no presentes"
    int j;
    for (j = 0; j < PAGE_TABLE_ENTRY_COUNT; j++)
    {
      // Obtengo la dirección de la entrada de tabla
      page_table_entry *pte = (page_table_entry*)((pde->table_base<<12) + (j * PAGE_TABLE_ENTRY_SIZE));
      // Gurado una entrada de tabla nula (no presente)
      *pte = NOT_PRESENT_TABLE_ENTRY;
    }
    // Marco presentes las dos páginas de la tarea
      // Se que estan en la misma tabla, sino esto podría ocasionar un BUG !!!
      page_table_entry *pte1 = (page_table_entry*)((pde->table_base<<12) + (((TASK_FIRST_CODE_PAGE<<10)>>22) * PAGE_TABLE_ENTRY_SIZE));
      page_table_entry *pte2 = (page_table_entry*)((pde->table_base<<12) + (((TASK_SECOND_CODE_PAGE<<10)>>22) * PAGE_TABLE_ENTRY_SIZE));
      // Marco el bit de presente (presente)
      pte1->present = PTE_PRESENT;
      pte2->present = PTE_PRESENT;
      // Marco el bit de read/write (write)
      pte1->read_write = PTE_WRITE;
      pte2->read_write = PTE_WRITE;
      // Obtengo la dirección base de la page_table
      pte1->page_base = IDLE_TASK_ADDR;
      pte2->page_base = IDLE_TASK_ADDR + PAGE_SIZE;
  // flags, bit 1 reservado en 1, los demás en 0
  */
  /* ACTIVAR INTERRUPCIONES ABAJO */
  tss_next_1.eflags = 0x202;
  // INTERRUPCIONES DESHABILITADAS
  tss_next_1.eflags = 0x2;
}

void tss_inicializar_tanques()
{
  int i;
  for (i = 0; i < CANT_TANQUES; ++i)
  {
    // Descriptor de código
    tss_tanques[i].cs = GDT_USER_CODE_SEGMENT_DESCRIPTOR + 3;
    // Descriptor de datos
    tss_tanques[i].ds = GDT_USER_DATA_SEGMENT_DESCRIPTOR + 3;
    tss_tanques[i].es = tss_tanques[i].ds;
    tss_tanques[i].gs = tss_tanques[i].ds;
    tss_tanques[i].ss = tss_tanques[i].ds;
    tss_tanques[i].fs = tss_tanques[i].ds;
    // Instruction Pointer
    tss_tanques[i].eip = TASK_FIRST_CODE_PAGE;
    // Stack, el stack crece desde el tope de la segunda página, hacia abajo
    tss_tanques[i].esp = TASK_SECOND_CODE_PAGE + PAGE_SIZE;
    tss_tanques[i].ebp = TASK_SECOND_CODE_PAGE + PAGE_SIZE;

    tss_tanques[i].esp0 = (long) mmu_get_free_page() + PAGE_SIZE;
    // estara bien esto?
    tss_tanques[i].ss0 = GDT_KERNEL_DATA_SEGMENT_DESCRIPTOR;
    // Paginación, el cr3 lo tengo en la struct mmu, que ya está inicializada
    mmu_t* mmu = (mmu_t*) MMU_ADDRESS;
    tss_tanques[i].cr3 = (unsigned long) &(mmu->task_page_dir[i]);
    // EFLAGS con interrupciones activas
    tss_tanques[i].eflags = 0x202;
    // TEMP sin interrupciones
    tss_tanques[i].eflags = 0x2;
  }
  //tss_next_1 = tss;//tss_tanques[0];
  tss_next_2 = tss_tanques[0];
}

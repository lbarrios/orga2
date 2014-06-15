/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#include "tss.h"

// GDT
tss tss_next_1;
tss tss_next_2;
tss tss_inicial;

// Contextos backup
tss tss_idle;
tss tss_tanques[CANT_TANQUES];

void tss_inicializar()
{
	gdt_entry* gdte;

	gdte = &(gdt[GDT_INIT_DESCRIPTOR]);
	gdte->base_0_15 = ((long)&(tss_inicial));
	gdte->base_23_16 = ((long)&(tss_inicial))>>16;
	gdte->base_31_24 = ((long)&(tss_inicial))>>24;
	gdte->type = GDT_TSS_NOT_BUSY_DESCRIPTOR_TYPE;
	gdte->p = 1;
	gdte->limit_0_15 = TSS_SIZE;

	gdte = &(gdt[GDT_TASK1_DESCRIPTOR]);
	gdte->base_0_15 = ((long)&(tss_next_1));
	gdte->base_23_16 = ((long)&(tss_next_1))>>16;
	gdte->base_31_24 = ((long)&(tss_next_1))>>24;
	gdte->type = GDT_TSS_NOT_BUSY_DESCRIPTOR_TYPE;
	gdte->p = 1;
	gdte->limit_0_15 = TSS_SIZE;

	gdte = &(gdt[GDT_TASK2_DESCRIPTOR]);
	gdte->base_0_15 = ((long)&(tss_next_2));
	gdte->base_23_16 = ((long)&(tss_next_2))>>16;
	gdte->base_31_24 = ((long)&(tss_next_2))>>24;
	gdte->type = GDT_TSS_NOT_BUSY_DESCRIPTOR_TYPE;
	gdte->p = 1;
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
	// Descriptor de video
	tss_next_1.fs = GDT_VIDEO_SEGMENT_DESCRIPTOR;
	// Instruction Pointer
	tss_next_1.eip = IDLE_TASK_ADDR;
	// Stack
	tss_next_1.esp = KERNEL_STACK_ADDR;
	tss_next_1.ebp = KERNEL_STACK_ADDR;
	// Paginación
	tss_next_1.cr3 = KERNEL_PAGE_DIR_FIRST_ENTRY;
	// flags
	tss_next_1.eflags = 0x2; // ¿Esto está bien?
}

void tss_inicializar_tanques()
{
  int i;
	for (i = 0; i < CANT_TANQUES; ++i)
	{
		// Descriptor de código
		tss_tanques[i].cs = GDT_USER_CODE_SEGMENT_DESCRIPTOR;
		// Descriptor de datos
		tss_tanques[i].ds = GDT_USER_DATA_SEGMENT_DESCRIPTOR;
		tss_tanques[i].es = tss_tanques[i].ds;
		tss_tanques[i].gs = tss_tanques[i].ds;
		tss_tanques[i].ss = tss_tanques[i].ds;
		// Descriptor de video
		tss_tanques[i].fs = GDT_VIDEO_SEGMENT_DESCRIPTOR;
		// Instruction Pointer
		tss_tanques[i].eip = TASK_FIRST_CODE_PAGE;
		// Stack
		/*
		tss_tanques[i].esp = ??
		tss_tanques[i].ebp = ??
		*/
		// Paginación
		mmu_t* mmu = (mmu_t*) MMU_ADDRESS;
		tss_tanques[i].cr3 = (unsigned long) &(mmu->task_page_dir[i]);
		//tss_tanques[i]
	}
}

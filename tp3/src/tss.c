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
	tss_next_1.eip = IDLE_TASK_ADDR;
	tss_next_1.esp = KERNEL_STACK_ADDR;
	tss_next_1.ebp = KERNEL_STACK_ADDR;
}

void tss_inicializar_tanques()
{

}
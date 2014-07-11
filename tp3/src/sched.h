/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCHED_H__
#define __SCHED_H__

#include "screen.h"
#include "tss.h"

unsigned long sched_proximo_indice();
void matar_tarea_actual();
unsigned char indice_actual;

#define TASK1_NEXT 1
#define TASK2_NEXT 2
#define NO_TASK_SWITCH 0

#endif	/* !__SCHED_H__ */

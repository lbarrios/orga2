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

#define TASK1_NEXT 1
#define TASK2_NEXT 2

#endif	/* !__SCHED_H__ */

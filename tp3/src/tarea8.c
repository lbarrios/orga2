/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "colors.h"
#include "defines.h"
#include "game.h"
#include "syscall.h"

void task() {
  /* No tocar */
  DEBUG("entrando en tarea ocho")
  #ifdef NOCORRE8
  DEBUG("la tarea 8 está congelada!!")
  while(1) { __asm __volatile("mov $1, %%eax":::"eax"); }
  #endif
  /* Tarea 8 */
  unsigned int i,j;
  direccion dir[4] = { N, E, S, O };
  int d = 0;
  int counter = 3;
  for(i=0;i<100;i++) {
      for(j=0;j<counter;j++)
         syscall_mover(dir[d]);
      counter = counter + 2;
      d = (d + 1) % 4;   
  }
  while(1) { __asm __volatile("mov $8, %%eax":::"eax"); }
}

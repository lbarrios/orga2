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
    /* Tarea 6 */
  char debug[40] = "entrando tarea seis\n";
  IMPRIMIR(debug)
  //while(1) syscall_mover(SO);
 while(1) { __asm __volatile("mov $1, %%eax":::"eax"); }

#ifdef NOCORRE6
while(1) { __asm __volatile("mov $1, %%eax":::"eax"); }
#endif

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
  while(1) { __asm __volatile("mov $6, %%eax":::"eax"); }
}

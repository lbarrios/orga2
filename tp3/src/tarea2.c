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
    /* Tarea 2 */
  unsigned int i,j;
  char debug[40] = "entrando tarea dos\n";
  IMPRIMIR(debug)
  //while(1) syscall_mover(N);
 while(1) { __asm __volatile("mov $1, %%eax":::"eax"); }

#ifdef NOCORRE2
while(1) { __asm __volatile("mov $1, %%eax":::"eax"); }
#endif

  direccion dir[4] = { N, E, S, O };
  int d = 0;
  int counter = 3;
  for(i=0;i<100;i++) {
      for(j=0;j<counter;j++)
          syscall_mover(dir[d]);
      counter = counter + 2;
      d = (d + 1) % 4; 
  }
  while(1) { __asm __volatile("mov $2, %%eax":::"eax"); }
}

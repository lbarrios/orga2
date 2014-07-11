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
  DEBUG("entrando en tarea dos")
  #ifdef NOCORRE2
  DEBUG("la tarea 2 está congelada!!")
  while(1) { __asm __volatile("mov $1, %%eax":::"eax"); }
  #endif

  syscall_mover(E);
  syscall_mover(E);
  syscall_mover(E);
  syscall_mover(E);
  syscall_mover(E);
  int a = 0;
  int b = 1000;
  int c = b/a;
  c++;

  /* Tarea 2 */
  direccion dir[4] = { N, E, S, O };
  int d = 0,i,j;
  int counter = 3;
  for(i=0;i<100;i++) {
      for(j=0;j<counter;j++)
          syscall_mover(dir[d]);
      counter = counter + 2;
      d = (d + 1) % 4; 
  }
  while(1) { __asm __volatile("mov $2, %%eax":::"eax"); }
}

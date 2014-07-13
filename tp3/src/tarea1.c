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
  DEBUG("entrando en tarea uno")
  #ifdef NOCORRE1
  DEBUG("la tarea 1 está congelada!!")
  while(1) { __asm __volatile("mov $1, %%eax":::"eax"); }
  #endif
  /* Tarea 1 */
  // este es el codigo que vamos a mandar para la batalla
  // vamos a hacer una doble muralla de minas y luego tirar misiles
  // notar que la muralla se hace en forma de espiral, cubriendose a si misma
  // llenamos espacio al principio para que no nos puedan matar con misiles de tamaño menor o igual a 1024
  char defensa[1024]; // este numero hay que tunearlo bien
  defensa[0] = defensa[0]; // para que no tire warning

  syscall_mover(N);
  syscall_mover(O);
  syscall_mover(O);

  syscall_minar(N);
  syscall_mover(E);
  syscall_minar(N);
  syscall_mover(E);
  syscall_minar(N);
  syscall_mover(E);
  syscall_minar(N);
  syscall_minar(NE);

  syscall_minar(E);
  syscall_mover(S);
  syscall_minar(E);
  syscall_mover(S);
  syscall_minar(E);
  syscall_minar(SE);

  syscall_minar(S);
  syscall_mover(O);
  syscall_minar(S);
  syscall_mover(O);
  syscall_minar(S);
  syscall_minar(SO);

  syscall_minar(O);
  syscall_mover(N);
  syscall_minar(O);
  syscall_minar(NO);

  syscall_mover(E);
  
  syscall_minar(NO);
  syscall_minar(N);
  syscall_minar(NE);
  syscall_minar(O);
  syscall_minar(E);
  syscall_minar(SO);
  syscall_minar(S);
  syscall_minar(SE);

  int x;
  int y;
  for (x = -25; x < 25; x++)
  {
      for (y = -25; y < 25; y++)
      {
         if (x >= -2 && x <= 2 && y >= -2 && y <= 2) continue;
         syscall_misil(x, y, (unsigned long)0x8001000, 0x1000); // todo mi stack
      }
  }
  while(1){}
}

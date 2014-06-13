/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "sched.h"

unsigned char flag_pause = 0;
unsigned char indice_actual = 0;
unsigned char tareas_muertas[8] = {0,0,0,0,0,0,0,0};

unsigned short sched_proximo_indice()
{
  indice_actual = (indice_actual++)%8;
  if(tareas_muertas[indice_actual])
  {
  	indice_actual = sched_proximo_indice();
  }
  return indice_actual;
}

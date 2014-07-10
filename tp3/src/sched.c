/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "sched.h"
#define TAREA_ACTUAL_IDLE 200

unsigned char flag_pause = 0;
unsigned char flag_idle = 0;
unsigned char tarea_actual[2] = {TAREA_ACTUAL_IDLE, 0};
unsigned char indice_actual = 7;
unsigned char tss_actual = GDT_TASK1_DESCRIPTOR;
unsigned char tareas_muertas[8] = {0,0,0,0,0,0,0,0};

unsigned long sched_proximo_indice()
{
  if(flag_pause==1 || flag_idle==1)
  {
    BD("entrando en tarea idle")BDENTER()
  }
  else
  {
    int i = 0;
    do
    {
      indice_actual = (indice_actual+1)%8;
      i++;
    } while (tareas_muertas[indice_actual] && i<8);
    BD("indice actual = ")BDPOINTER((long)indice_actual)BDENTER()
  }
  if(tss_actual == GDT_TASK1_DESCRIPTOR)
  {
    // Resguardo el contexto de la tarea de la tss_next_1
    unsigned char tarea_a_resguardar;
    tarea_a_resguardar = tarea_actual[1];
    if(tarea_a_resguardar==TAREA_ACTUAL_IDLE)
    {
      tss_idle = tss_next_2;
    }
    else
    {
      tss_tanques[tarea_a_resguardar] = tss_next_2;
    }
    /* 
      Pongo la nueva tarea
    */
    // Me fijo si va la idle o una tarea
    if(flag_pause==1 || flag_idle==1)
    {
      tss_next_2 = tss_idle;
      tarea_actual[1] = TAREA_ACTUAL_IDLE;
      flag_idle=0;
    }
    else
    {
      tss_next_2 = tss_tanques[indice_actual];
      tarea_actual[1] = indice_actual;      
    }
  }
  else
  {
    // Resguardo el contexto de la tarea de la tss_next_2
    unsigned char tarea_a_resguardar;
    tarea_a_resguardar = tarea_actual[0];
    if(tarea_a_resguardar==TAREA_ACTUAL_IDLE)
    {
      tss_idle = tss_next_1;
    }
    else
    {
      tss_tanques[tarea_a_resguardar] = tss_next_1;
    }
    /* 
      Pongo la nueva tarea
    */
    // Me fijo si va la idle o una tarea
    if(flag_pause==1 || flag_idle==1)
    {
      tss_next_1 = tss_idle;
      tarea_actual[0] = TAREA_ACTUAL_IDLE;
      flag_idle=0;
    }
    else
    {
      tss_next_1 = tss_tanques[indice_actual];
      tarea_actual[0] = indice_actual;
    }
  }

  if(tss_actual == GDT_TASK1_DESCRIPTOR)
  {
    tss_actual = GDT_TASK2_DESCRIPTOR;
    return TASK2_NEXT;
  }
  else
  {
    tss_actual = GDT_TASK1_DESCRIPTOR;
    return TASK1_NEXT;
  }

// Viejo
/*

  int i = 0;
  if( flag_pause != 1 )
  {
    do
    {
      indice_actual = (indice_actual+1)%8;
      i++;
    } while (!tareas_muertas[indice_actual] && i<8);
  }
  else
  {
    i = 8;
  }
  if( i==8 )
  {
    // Ejecuto tarea idle
    if(tss_actual == GDT_TASK1_DESCRIPTOR)
    {
      // Pongo la tarea idle en el descriptor de tss 2
      tss_next_2 = tss_idle;
      // Pongo la tarea IDLE como tarea_actual en TSS 2
      tarea_actual[1] = TAREA_ACTUAL_IDLE;
      // El nuevo tss_actual va a ser task 2
      tss_actual = GDT_TASK2_DESCRIPTOR;
      return 2;
    }
    else
    {
      // Pongo la tarea idle en el descriptor de tss 1
      tss_next_1 = tss_idle;
      // Pongo la tarea IDLE como tarea_actual en TSS 1
      tarea_actual[0] = TAREA_ACTUAL_IDLE;
      // El nuevo tss_actual va a ser task 1
      tss_actual = GDT_TASK1_DESCRIPTOR;
      return 1;
    }
  }
  else
  {
    // Salto a la próxima tarea
    if(tss_actual == GDT_TASK1_DESCRIPTOR)
    {
      // Resguardo el contexto de la tarea actual
      int tarea = tarea_actual[0];
      // Solo resguardo si la tarea anterior no era idle
      if( tarea != TAREA_ACTUAL_IDLE )
      {
        tss_tanques[tarea] = tss_next_1;
      }
      // Pongo la siguiente tarea en el TSS que no está busy
      tss_next_2 = tss_tanques[indice_actual];
      // Pongo la tarea indice_actual como tarea_actual en TSS 2
      tarea_actual[1] = indice_actual;
      // El nuevo tss_actual va a ser task 2
      tss_actual = GDT_TASK2_DESCRIPTOR;
      return 2;
    }
    else
    {
      // Resguardo el contexto de la tarea actual
      int tarea = tarea_actual[1];
      if( tarea != TAREA_ACTUAL_IDLE )
      {
        tss_tanques[tarea] = tss_next_2;
      }
      // Pongo la siguiente tarea en el TSS que no está busy
      tss_next_1 = tss_tanques[indice_actual];
      // Pongo la tarea indice_actual como tarea_actual en TSS 1
      tarea_actual[0] = indice_actual;
      // El nuevo tss_actual va a ser task 1
      tss_actual = GDT_TASK1_DESCRIPTOR;
      return 1;
    }
  }
*/
}

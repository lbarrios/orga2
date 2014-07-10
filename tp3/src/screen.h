/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCREEN_H__
#define __SCREEN_H__

#include "colors.h"
#include "game.h"



typedef struct pixel_s {
    unsigned char ascii;
    unsigned char color;
} __attribute__((__packed__)) pixel;


/* Definicion de la pantalla */
#define VIDEO_FILS 50
#define VIDEO_COLS 80


#endif  /* !__SCREEN_H__ */

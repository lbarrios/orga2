/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#ifndef __GAME_H__
#define __GAME_H__

#include "defines.h"
#include "screen.h"
#include "mmu.h"

#define GAME_MAP_FIRST_ADDRESS 0x400000
#define GAME_MAP_LAST_ADDRESS 0xDC3FFF

typedef enum direccion_e { NE = 12, N  = 11, NO = 14,
                           E  = 22, C  = 0,  O  = 44,
                           SE = 32, S  = 33, SO = 34 } direccion;

#define SIZE_MAP 2500 // esto es el size en pixeles

typedef enum {PASTO, INICIAL, PISADO, SUPERPUESTO, MINA, MISIL, MUERTO} Estado;

typedef unsigned char Tank;

typedef struct EstadoCasilla_s
{            
    Estado current_state;
    Tank tank_number;
    unsigned char mapeado_por_tarea[CANT_TANQUES];
} EstadoCasilla;

extern unsigned int siguiente_a_mapear[];
extern EstadoCasilla map_state[];
extern unsigned int posiciones[];

void game_inicializar();

void marcar_pos_inicial();

unsigned int game_mover(unsigned int id, direccion d);

unsigned int game_misil(unsigned int id, int val_x, int val_y, unsigned int misil, unsigned int size);

unsigned int game_minar(unsigned int id, direccion d);

#endif  /* !__GAME_H__ */

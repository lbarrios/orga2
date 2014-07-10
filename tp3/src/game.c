/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "game.h"
#include "screen.h"

#define SIZE_MAP 2500 // esto es el size en pixeles

typedef enum {PASTO, INICIAL, PISADO, SUPERPUESTO, MINA, MISIL, MUERTO} Estado;

typedef unsigned char Tank;

typedef struct EstadoCasilla_s
{            
    Estado current_state;
    Tank tank_number;
} EstadoCasilla;

EstadoCasilla map_state[SIZE_MAP];
unsigned int posiciones[CANT_TANQUES];

void game_inicializar() {
    EstadoCasilla pasto;
    pasto.current_state = PASTO;
    pasto.tank_number = 0;

    int i;
    for (i = 0; i < SIZE_MAP; i++)
    {
        map_state[i] = pasto;
    }
}

unsigned int fisica_a_casillero(unsigned int fisica)
{
    return (fisica - GAME_MAP_FIRST_ADDRESS)>>12;
}


void marcar_pos_inicial(unsigned int fisica, unsigned int tanque)
{
    unsigned int casilla = fisica_a_casillero(fisica);
    EstadoCasilla *estado = &map_state[casilla];
    estado->current_state = INICIAL;
    estado->tank_number = tanque;
    posiciones[tanque] = casilla;
}


unsigned int game_mover(unsigned int id, direccion d) {
    BD("game_mover id=")BDPOINTER((unsigned long)id)BD(" d=")BDPOINTER((unsigned long)d)BDENTER()
    return TRUE;


    /*
    int nueva_pos;
    EstadoCasilla estado_nueva_pos;
    switch (estado_nueva_pos->current_state) {

        case PASTO:
            estado_nueva_pos->current_state = PISADO;
            estado_nueva_pos->tank_number = NUMERODETANQUE;
            mmu_mapear_pagina(args);
            break;

        case INICIAL:
            if (estado_nueva_pos->tank_number != NUMERODETANQUE)
            {
                estado_nueva_pos->current_state = SUPERPUESTO;
                estado_nueva_pos->tank_number = 0;
                mmu_mapear_pagina(args); // aunque ya sea de otro?
            }
            break;

        case PISADO:
            if (estado_nueva_pos->tank_number != NUMERODETANQUE)
            {
                estado_nueva_pos->current_state = SUPERPUESTO;
                estado_nueva_pos->tank_number = 0;
                mmu_mapear_pagina(args); // aunque ya sea de otro?
            }
            break;

        case SUPERPUESTO:
            if (estado_nueva_pos->tank_number != NUMERODETANQUE)
            {
                mmu_mapear_pagina(args); // aunque ya sea de otro?
            }
            break;

        case MINA:
            desalojar_tarea(NUMERODETANQUE);
            break;
            
        case MISIL:
            // que pasa?
            break;

        case MUERTO:
            // superpones?
            break;

        default:
            // Kernel bug?
            break;
    };
 
    return TRUE;
    */
}

unsigned int game_misil(unsigned int id, int val_x, int val_y, unsigned int misil, unsigned int size) {
    BD("game_misil")VAR(id)VAR(val_x)VAR(val_y)VAR(misil)VAR(size)BDENTER()
    return TRUE;
    
    /*
    int posicion;
    
    //usar un buffer?
    return TRUE;
    */
}

unsigned int game_minar(unsigned int id, direccion d) {
    BD("game_minar id=")BDP(id)BD(" d=")BDPOINTER((unsigned long)d)BDENTER()
    return TRUE;

    /*
    int posicion;
    map_state[posicion].current_state = MINA;
    map_state[posicion].tank_number = NUMERODETANQUE;

    return TRUE;
    */
}

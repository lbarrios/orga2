/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "game.h"

char campo_minado[CAMPO_SIZE][CAMPO_SIZE];


void game_inicializar() {
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
    BD("game_misil ")VAR(id)VAR(val_x)VAR(val_y)VAR(misil)VAR(size)BDENTER()
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

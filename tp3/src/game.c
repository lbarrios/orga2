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


    int nueva_pos;
    EstadoCasilla estado_nueva_pos;
    switch (estado_nueva_pos->current_state) {
        case PASTO:
            estado_nueva_pos->current_state = PISADO;
            estado_nueva_pos->tank_number = NUMERODETANQUE;
            mapear_pagina(args);
            break;
        case INICIAL:
            if (estado_nueva_pos->)

            color = COLOR_INICIAL; break;
        case PISADO:
            color = COLOR_PISADO; break;
        case SUPERPUESTO:
            color = COLOR_SUPERPUESTO; break;
        case MINA:
            color = COLOR_MINA; break;
        case MISIL:
            color = COLOR_MISIL; break;
        case MUERTO:
            color = COLOR_MUERTO; break;
        default:
            // Kernel bug?
            break;
    };
 
    return TRUE;
}

unsigned int game_misil(unsigned int id, int val_x, int val_y, unsigned int misil, unsigned int size) {
    return TRUE;
}

unsigned int game_minar(unsigned int id, direccion d) {
    return TRUE;
}




/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "game.h"
#include "screen.h"
#include "mmu.h"


unsigned int siguiente_a_mapear[CANT_TANQUES] = {0x8003000, 0x8003000, 0x8003000, 0x8003000, 0x8003000, 0x8003000, 0x8003000};
EstadoCasilla map_state[SIZE_MAP];
unsigned int posiciones[CANT_TANQUES];
// la idea de causa de muerte es:
// va a tener el numero de la excepcion
// o 100 que significa muerte por mina
// o 101 que significa todavia vivo (igual no hace falta mostrarlo, si sigue vivo)
unsigned char causa_de_muerte[CANT_TANQUES];

void game_inicializar() {
    EstadoCasilla pasto;
    pasto.current_state = PASTO;
    pasto.tank_number = 0;
    int i;
    for(i = 0; i < CANT_TANQUES; i++) {
        unmapear_a_tarea(&pasto, i);
        causa_de_muerte[i] = VIVITO_Y_COLEANDO;
    }

    for (i = 0; i < SIZE_MAP; i++)
    {
        //BD(" map_state[i] ") BDPOINTER(&map_state[i]) BDENTER()
        map_state[i] = pasto;
    }
    BD(" map_state[i] ") BDPOINTER(&map_state[i]) BDENTER()
}

void anota_causa_de_muerte(unsigned int numero_excepcion)
{
    causa_de_muerte[indice_actual] = (unsigned char)numero_excepcion;
}

unsigned int fisica_a_casillero(unsigned int fisica)
{
    return (fisica - GAME_MAP_FIRST_ADDRESS)>>12;
}

unsigned int casillero_a_fisica(unsigned int casillero)
{
    return (casillero<<12) + GAME_MAP_FIRST_ADDRESS;
}

void marcar_pos_inicial(unsigned int fisica, unsigned int tanque)
{
    unsigned int casilla = fisica_a_casillero(fisica);
    VAR(casilla)VAR(tanque)
    EstadoCasilla *estado = &map_state[casilla];
    estado->current_state = INICIAL;
    estado->tank_number = tanque;
    posiciones[tanque] = casilla;
}


void esta_casilla_es_mia(unsigned int nueva_pos, Tank id)
{
    unsigned int *virtual = &siguiente_a_mapear[id];
    mmu_t* mmu = (mmu_t*) MMU_ADDRESS;
    page_dir *cr3 = &(mmu->task_page_dir[id]);
    void *fisica = (void*)casillero_a_fisica(nueva_pos);
    // Casteo una estructura de atributos con todos los valores en 0
    page_table_attributes attr = NOT_PRESENT_PAGE_TABLE_ATTRIBUTES;
    // Marco la página presente
    attr.present = PTE_PRESENT;
    // Marco la página como de escritura
    attr.read_write = PTE_WRITE;
    // Marco la página como "de usuario"
    attr.user_supervisor = PTE_USER;
    mmu_mapear_pagina(*virtual, cr3, fisica, attr);
    *virtual += PAGE_SIZE;
    //unsigned int v = *virtual;
    //VAR(v)
}


unsigned int game_mover(unsigned int id, direccion d) {
    BD("game_mover")VAR(id)VAR(d)BDENTER()
    if (d == C) return TRUE;
    
    int nueva_pos = posiciones[id] + SIZE_MAP;
    switch (d) {
        case NO:
            nueva_pos -= 1;
            nueva_pos -= 50;
            break;

        case N:
            nueva_pos -= 50;
            break;

        case NE:
            nueva_pos += 1;
            nueva_pos -= 50;
            break;

        case O:
            nueva_pos -= 1;
            break;

        case C:
            break;

        case E:
            nueva_pos += 1;
            break;

        case SO:
            nueva_pos -= 1;
            nueva_pos += 50;
            break;

        case S:
            nueva_pos += 50;
            break;

        case SE:
            nueva_pos += 1;
            nueva_pos += 50;
            break;
    }
    nueva_pos = nueva_pos % SIZE_MAP;
    posiciones[id] = nueva_pos;

    EstadoCasilla *estado_nueva_pos = &map_state[nueva_pos];
    switch (estado_nueva_pos->current_state) {
        case PASTO:
            estado_nueva_pos->current_state = PISADO;
            estado_nueva_pos->tank_number = id;
            esta_casilla_es_mia(nueva_pos, id);
            mapear_a_tarea(estado_nueva_pos, id);
            break;

        case INICIAL:
            if (estado_nueva_pos->tank_number != id)
            {
                estado_nueva_pos->current_state = SUPERPUESTO;
                estado_nueva_pos->tank_number = 0;
                esta_casilla_es_mia(nueva_pos, id);
                mapear_a_tarea(estado_nueva_pos, id);
            }
            break;

        case PISADO:
            if (estado_nueva_pos->tank_number != id)
            {
                estado_nueva_pos->current_state = SUPERPUESTO;
                estado_nueva_pos->tank_number = 0;
                esta_casilla_es_mia(nueva_pos, id);
                mapear_a_tarea(estado_nueva_pos, id);
            }
            break;

        case SUPERPUESTO:
            if (mapeado_a_tarea(estado_nueva_pos, id) == 0)
            {
                esta_casilla_es_mia(nueva_pos, id);
                mapear_a_tarea(estado_nueva_pos, id);
            }
            break;

        case MINA:
            estado_nueva_pos->current_state = MUERTO;
            estado_nueva_pos->tank_number = id;
            causa_de_muerte[id] = MUERTE_POR_MINA;
            matar_tarea_actual();
            break;
            
        case MISIL:
            if (mapeado_a_tarea(estado_nueva_pos, id) == 0)
            {
                esta_casilla_es_mia(nueva_pos, id);
                mapear_a_tarea(estado_nueva_pos, id);
            }
            break;

        case MUERTO:
            if (mapeado_a_tarea(estado_nueva_pos, id) == 0)
            {
                esta_casilla_es_mia(nueva_pos, id);
                mapear_a_tarea(estado_nueva_pos, id);
            }
            break;

        default:
            // Kernel bug?
            break;
    };
 
    return siguiente_a_mapear[id];
}

unsigned int game_misil(unsigned int id, int val_x, int val_y, unsigned int misil, unsigned int size) {
    BD("game_misil")VAR(id)VAR(val_x)VAR(val_y)VAR(misil)VAR(size)BDENTER()
    
    int pos_misil = posiciones[id] + SIZE_MAP + SIZE_MAP;
    if(val_x>0)
    {
        val_x = val_x % 50;
    }
    else
    {
        val_x = -val_x; 
        val_x = val_x % 50;
        val_x = -val_x;
    }
    if(val_y>0)
    {
        val_y = val_y % 50;
    }
    else
    {
        val_y = -val_y; 
        val_y = val_y % 50;
        val_y = -val_y;
    }
    pos_misil += val_x;
    pos_misil += val_y*50;

    pos_misil = pos_misil % SIZE_MAP;
    EstadoCasilla *estado = &map_state[pos_misil];
    estado->current_state = MISIL;
    estado->tank_number = id;

    unsigned int fisica = casillero_a_fisica(pos_misil);

    char *copio = (char*) misil;
    char *pego = (char*) fisica;
    int i;
    for(i = 0; i < size; i++)
    {
        pego[i] = copio[i];
    }

    return TRUE;
}

unsigned int game_minar(unsigned int id, direccion d) {
    BD("game_minar id=")BDP(id)BD(" d=")BDPOINTER((unsigned long)d)BDENTER()

    int pos_mina = posiciones[id] + SIZE_MAP;
    switch (d) {
        case NO:
            pos_mina -= 1;
            pos_mina -= 50;
            break;

        case N:
            pos_mina -= 50;
            break;

        case NE:
            pos_mina += 1;
            pos_mina -= 50;
            break;

        case O:
            pos_mina -= 1;
            break;

        case C:
            break;

        case E:
            pos_mina += 1;
            break;

        case SO:
            pos_mina -= 1;
            pos_mina += 50;
            break;

        case S:
            pos_mina += 50;
            break;

        case SE:
            pos_mina += 1;
            pos_mina += 50;
            break;
    }
    pos_mina = pos_mina % SIZE_MAP;
    EstadoCasilla *estado = &map_state[pos_mina];
    estado->current_state = MINA;
    estado->tank_number = id;

    return TRUE;
}



unsigned char mapeado_a_tarea(EstadoCasilla *ec, int i)
{
    if(i==0) {return ec->mapeado_a_tarea0;}
    if(i==1) {return ec->mapeado_a_tarea1;}
    if(i==2) {return ec->mapeado_a_tarea2;}
    if(i==3) {return ec->mapeado_a_tarea3;}
    if(i==4) {return ec->mapeado_a_tarea4;}
    if(i==5) {return ec->mapeado_a_tarea5;}
    if(i==6) {return ec->mapeado_a_tarea6;}
    if(i==7) {return ec->mapeado_a_tarea7;}
    return -1;
}
void unmapear_a_tarea(EstadoCasilla *ec, int i)
{
    if(i==0) {ec->mapeado_a_tarea0 = 0;}
    if(i==1) {ec->mapeado_a_tarea1 = 0;}
    if(i==2) {ec->mapeado_a_tarea2 = 0;}
    if(i==3) {ec->mapeado_a_tarea3 = 0;}
    if(i==4) {ec->mapeado_a_tarea4 = 0;}
    if(i==5) {ec->mapeado_a_tarea5 = 0;}
    if(i==6) {ec->mapeado_a_tarea6 = 0;}
    if(i==7) {ec->mapeado_a_tarea7 = 0;}
}
void mapear_a_tarea(EstadoCasilla *ec, int i)
{
    if(i==0) {ec->mapeado_a_tarea0 = 1;}
    if(i==1) {ec->mapeado_a_tarea1 = 1;}
    if(i==2) {ec->mapeado_a_tarea2 = 1;}
    if(i==3) {ec->mapeado_a_tarea3 = 1;}
    if(i==4) {ec->mapeado_a_tarea4 = 1;}
    if(i==5) {ec->mapeado_a_tarea5 = 1;}
    if(i==6) {ec->mapeado_a_tarea6 = 1;}
    if(i==7) {ec->mapeado_a_tarea7 = 1;}
}

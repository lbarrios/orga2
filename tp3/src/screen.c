/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

void print_tank_context( int tank )
{
    //int t = (tank<1 || tank>8) ? (1) : (tank);
    
    //tss contexto;
    


}

#include "screen.h"
#define SIZE_MAP 2500 // esto es el size en pixeles
#define SIZE_PIXEL 2 // size en bytes
#define MAP_FIRST_PIXEL 0xB8000 // esperemos que asi sea

typedef enum {PASTO, INICIAL, PISADO, SUPERPUESTO, MINA, MISIL, MUERTO} Estado;

typedef struct pixel_s {
    unsigned char ascii;
    unsigned char color;
} __attribute__((__packed__)) pixel;

typedef unsigned char Tank;

typedef struct EstadoCasilla_s
{            
    Estado current_state;
    Tank tank_number;
} EstadoCasilla;

EstadoCasilla map_state[SIZE_MAP];

pixel colorea_pixel(EstadoCasilla s)
{
    Estado current_state = s.current_state;
    Tank t = s.tank_number;
    unsigned char color;
    switch (current_state) {
        case PASTO:
            color = COLOR_PASTO; break;
        case INICIAL:
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
    pixel res; 
    res.color = color;
    if (current_state == PASTO) res.ascii = 0;
    else if (current_state == SUPERPUESTO) res.ascii = 'x';
    else res.ascii = t + '0';

    return res;
}


void print_map ()
{
    int i, j;
    for (i = 0; i < 50; i++)
    {
        for (j = 0; j < 50; j++)
        {
            pixel *pixel_actual = ((pixel*)MAP_FIRST_PIXEL) + 80*i + j;
            EstadoCasilla estado_actual = map_state[i*50+j];
            *pixel_actual = colorea_pixel(estado_actual);
        }
    }
}

void screen_inicializar ()
{
    EstadoCasilla pasto;
    pasto.current_state = PASTO;
    pasto.tank_number = 0;

    int i;
    for (i = 0; i < SIZE_MAP; i++)
    {
        map_state[i] = pasto;
    }

    //importante: marcar las casillas INICIAL

    print_map();
}
/*
void screen_proximo_reloj ()
{

}
*/

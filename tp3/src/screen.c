/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/
#include "screen.h"

#define SIZE_PIXEL 2 // size en bytes
#define MAP_FIRST_PIXEL 0xB8000 // esperemos que asi sea

#define GUARDA_CONTEXTO(reg) \
  p = (pixel*) ((long)MAP_FIRST_PIXEL + (long)(i*80) + 51); \
  p->ascii = i; \
  p->color = i; \
  i++;

void print_tank_context( int tank )
{
    /*
    int i = 0;
    pixel* p;
    //int t = (tank<0 || tank>8) ? (1) : (tank);
    //tss& contexto = tss_tanques[t];
    GUARDA_CONTEXTO(eax)
    GUARDA_CONTEXTO(ebx)
    GUARDA_CONTEXTO(ecx)
    GUARDA_CONTEXTO(edx)
    */
}

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
    print_map();
}
/*
void screen_proximo_reloj ()
{

}
*/

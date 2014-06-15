/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "screen.h"
#define SIZE_MAP 2500 // esto es el size en pixeles
#define SIZE_PIXEL 2 // size en bytes
#define MAP_FIRST_PIXEL 0xB8000 // esperemos que asi sea

// los campos van a valer 0 todos si es fondo verde, y si no, el numero del tanque
typedef struct EstadoCasilla_s
{            
    char pisado;
    char mina;
    char muerto;
} EstadoCasilla;

typedef unsigned short pixel;

//EstadoCasilla map_state[SIZE_MAP];

void print_tank_context( int tank )
{
	//int t = (tank<1 || tank>8) ? (1) : (tank);
}

#define verdeCampo 0xA000

void print_map ()
{
    int i, j;
    for (i = 0; i < 50; i++)
    {
        for (j = 0; j < 50; j++)
        {
            pixel *pixel_actual = ((pixel*)MAP_FIRST_PIXEL) + 80*i + j;
            //EstadoCasilla estado_actual = map_state[i*50+j];
            *pixel_actual = verdeCampo;//C_FG_BLUE + C_BG_BLUE;
            //pixel_actual++;
        }
        //pixel_actual += 30;
    }
}
/*
void screen_proximo_reloj ()
{

}
*/

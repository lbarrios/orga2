/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/
#include "screen.h"

#define SIZE_PIXEL 2 // size en bytes
#define MAP_FIRST_PIXEL 0xB8000 // esperemos que asi sea
#define BASE_CLOCKS_TAREAS (MAP_FIRST_PIXEL + 48*160 + 54*2)
#define BASE_CONTEXTO (MAP_FIRST_PIXEL+(2*(5*80))+(50*2)+(2*2))

//p->color = COLOR_PISADO;
//buffer[j]=(reg_txt)[j];
//BD("Escribiendo en pantalla: ")VAR(i)VAR(j)VAR(p)VAR(p->ascii)BDENTER()
//BD("Escribiendo en pantalla: ")VAR(i)VAR(j)VAR(p)VAR(p->ascii)BDENTER()
//BD("Escribiendo contexto: ")BD(reg_txt)BDENTER()

#define ADDLINE2(a,b) a ## b
#define ADDLINE(a) TOKEN_CONCATENATE2(a, __LINE__)

#define GUARDA_CONTEXTO2(reg,reg_txt) \
char ADDLINE(buffer) [] = reg_txt; \
for(j=0;j<sizeof(reg_txt);j++){ \
  p = ((pixel*)BASE_CONTEXTO) + (i*80) + j; \
  p->ascii = ADDLINE(buffer) [j]; \
} \
p = ((pixel*)BASE_CONTEXTO) + (i*80) + j; \
p->ascii = '0'; \
j++; \
p = ((pixel*)BASE_CONTEXTO) + (i*80) + j; \
p->ascii = 'x'; \
j++; \
for(k=j;k<j+8;k++){ \
  p = ((pixel*)BASE_CONTEXTO) + (i*80) + k; \
  p->ascii = '0' + ( ( ( contexto -> reg ) << (4*(k-j)) ) >> 28 ); \
  if(p->ascii>'9'){ p->ascii = p->ascii + 'A' - ('0' + 10); } \
} \
i++;

#define GUARDA_CONTEXTO(reg) GUARDA_CONTEXTO2( reg, #reg )


unsigned char clocks_tanques[CANT_TANQUES];

void print_tank_context( char tank )
{
		BD("Escribiendo contexto de: ")VAR(tank)BDENTER()
    int t = (tank<0 || tank>7) ? (0) : (tank);
    tss *contexto = &(tss_tanques[t]);
//    unsigned char* buffer;
    int i=0, j, k;
    pixel* p;

    GUARDA_CONTEXTO(eax)
    GUARDA_CONTEXTO(ebx)
    GUARDA_CONTEXTO(ecx)
    GUARDA_CONTEXTO(edx)
    GUARDA_CONTEXTO(eip)
    GUARDA_CONTEXTO(cr3)
    /*
    */
}

void avanzar_clock_tarea(unsigned char t)
{
    unsigned char c = clocks_tanques[t];
    if (c == '-') c = '\\';
    else if (c == '\\') c = '|';
    else if (c == '|') c = '/';
    else c = '-';
    clocks_tanques[t] = c;
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

void print_tanks_clocks()
{
    int i;
    for (i = 0; i < CANT_TANQUES; i++)
    {
        pixel *p = ((pixel*)(BASE_CLOCKS_TAREAS) + 2*i);
        if (tareas_muertas[i])
        {
            p->color = COLOR_MUERTO;
            p->ascii = 'x';
        }
        else p->ascii = clocks_tanques[i];
    }
}

void pintar_fondos()
{
    //pinto el fondo de los relojes de las tareas
    int i, j;
    for (i = 47; i < 50; i++)
    {
        for (j = 53; j < 70; j++)
        {
            pixel *pixel_actual = ((pixel*)MAP_FIRST_PIXEL) + 80*i + j;
            pixel_actual->color = COLOR_PISADO;
            pixel_actual->ascii = 0;
        }
    }
    
    // pinto el fondo del titulo
    i = 4;
    for (j = 52; j < 80; j++)
    {
        pixel *pixel_actual = ((pixel*)MAP_FIRST_PIXEL) + 80*i + j;
        pixel_actual->color = COLOR_MUERTO;
        pixel_actual->ascii = 0;
    }

    // pinto el fondo gris
    for (i = 5; i < 38; i++)
    {
        for (j = 52; j < 80; j++)
        {
            pixel *pixel_actual = ((pixel*)MAP_FIRST_PIXEL) + 80*i + j;
            //pixel_actual->color = COLOR_FONDO_GRIS;
            pixel_actual->color = COLOR_PISADO;
            pixel_actual->ascii = 0;
        }
    }
    
    // pinto el fondo de la causa de muerte
    for (i = 39; i < 42; i++)
    {
        for (j = 52; j < 80; j++)
        {
            pixel *pixel_actual = ((pixel*)MAP_FIRST_PIXEL) + 80*i + j;
            pixel_actual->color = COLOR_MUERTO;
            pixel_actual->ascii = 0;
        }
    }
    
}

void print_screen()
{
    print_map();
    print_tanks_clocks();
}

void screen_inicializar ()
{
    print_map();
    pintar_fondos();
}
/*
void screen_proximo_reloj ()
{

}
*/

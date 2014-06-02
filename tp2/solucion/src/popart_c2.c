#include "tp2.h"

#define _STEP 153

rgb_t colors[] =
{
  {255,   0,   0},
  {127,   0, 127},
  {255,   0, 255},
  {  0,   0, 255},
  {  0, 255, 255},
  {  0, 255, 255} // Cuando pixel = {255,255,255} la división da 5.
};

void popart_c ( unsigned char* src, unsigned char* dst, int cols, int filas, int src_row_size, int dst_row_size )
{
  int tot_x = cols * 3;
  int x=0;
  int y=0;
  long i;
  int eax;

  CICLO_FILAS:
    CICLO_COLUMNAS:
      // Obtengo el índice para src
      i = ( x ) + ( y * src_row_size );
      // Obtengo la suma de los tres colores y calculo el índice correspondiente a la matriz colors dividiendola por _STEP
      eax = src[i + 0] + src[i + 1] + src[i + 2];
      eax = eax / _STEP;
      // Usando el índice i_color, obtengo de la matriz colors el color que voy a guardar en dst
      //rgb_t color = *(rgb_t*)(colors + eax);
      rgb_t color = colors[eax];
      // Calculo el índice para dst
      i = ( x ) + ( y * dst_row_size );
      // Guardo los valores en las posiciones correspondientes de dst
      dst[i + 0] = color.b;
      dst[i + 1] = color.g;
      dst[i + 2] = color.r;

      x = x + 3;
      if( x < tot_x )
      {
        goto CICLO_COLUMNAS;
      }

    x = 0;
    y = y + 1;
    if( y < filas )
    {
      goto CICLO_FILAS;
    }

    return;
}


// pixel 2,84: 255,255,255 da problemas

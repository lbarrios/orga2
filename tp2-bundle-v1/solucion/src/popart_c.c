
#include "tp2.h"

#define MAX_SUM 755
#define _STEP 153

rgb_t colors[] =
{
  {255,   0,   0},
  {127,   0, 127},
  {255,   0, 255},
  {  0,   0, 255},
  {  0, 255, 255}
};

void popart_c ( unsigned char* src, unsigned char* dst, int cols, int filas, int src_row_size, int dst_row_size )
{
  int x, y;
  long i_src, i_dst;

  for ( y = 0; y < filas; y++ )
  {
    for ( x = 0; x < cols; x++ )
    {
      // Obtengo el índice para src
      i_src = ( 3 * x ) + ( y * src_row_size );
      // Obtengo la suma de los tres colores
      short sum = src[i_src + 0] + src[i_src + 1] + src[i_src + 2];
      // Calculo el índice correspondiente a la matriz colors dividiendo la suma por _STEP
      short i_color = sum / _STEP;
      // Usando el índice i_color, obtengo de la matriz colors el color que voy a guardar en dst
      rgb_t color = colors[i_color];
      // Calculo el índice para dst
      i_dst = ( 3 * x ) + ( y * dst_row_size );
      // Guardo los valores en las posiciones correspondientes de dst
      dst[i_dst + 0] = color.r;
      dst[i_dst + 1] = color.g;
      dst[i_dst + 2] = color.b;
    }
  }
}



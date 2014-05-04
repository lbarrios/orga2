
#include "tp2.h"

#define MIN(x,y) ( x < y ? x : y )
#define MAX(x,y) ( x > y ? x : y )
#define round(x) ((x)>=0?(int)((x)+0.5):(int)((x)-0.5))

#define P 2

void ldr_c    (
    unsigned char *src,
    unsigned char *dst,
    int cols,
    int filas,
    int src_row_size,
    int dst_row_size,
	int alfa)
{
    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

    int max = 4876875;


    for (int i = 0; i < filas; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            rgb_t *p_d = (rgb_t*) &dst_matrix[i][j * 3];
            rgb_t *p_s = (rgb_t*) &src_matrix[i][j * 3];
            if (i < 2 || j < 2 || i + 2 >= filas || j + 2 >= cols) {
                *p_d = *p_s;
            } else {
                int suma_vecinos = 0;
                for (int x = i - 2; x <= i + 2; x++) {
                    for (int y = j - 2; y <= j + 2; y++) {
                        suma_vecinos += src_matrix[x][y * 3];
                        suma_vecinos += src_matrix[x][y * 3 + 1];
                        suma_vecinos += src_matrix[x][y * 3 + 2];
                    }
                }
                /*
                int multiplico = src_matrix[i][j * 3] * alfa * suma_vecinos;
                float divido = multiplico / max;
                int x = 5;
                int y = 5;
                x += round(divido);
                float multiplico_f = multiplico;
                float divido_i = multiplico_f / max;
                y += round(divido_i);
                */

                dst_matrix[i][j * 3] = MIN(255, MAX(0, src_matrix[i][j * 3] + (src_matrix[i][j * 3] * alfa * suma_vecinos) / max));
                dst_matrix[i][j * 3 + 1] = MIN(255, MAX(0, src_matrix[i][j * 3 + 1] + (src_matrix[i][j * 3 + 1] * alfa * suma_vecinos) / max));
                dst_matrix[i][j * 3 + 2] = MIN(255, MAX(0, src_matrix[i][j * 3 + 2] + (src_matrix[i][j * 3 + 2] * alfa * suma_vecinos) / max));
                /* 
                if (i == 174 && j == 169) {
                    printf("%d\n", dst_matrix[i][j * 3 + 2]);
                    printf("%d, %d\n", x, y);
                }
                */
            }
        }
    }
}

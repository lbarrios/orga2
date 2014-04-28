#include "tp2.h"


void tiles_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size,
	int tamx,
	int tamy,
	int offsetx,
	int offsety)
{
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int i_d = 0, i_s = 0; i_d < filas; i_d++, i_s++) {
		for (int j_d = 0, j_s = 0; j_d < cols; j_d++, j_s++) {
			rgb_t *p_d = (rgb_t*)&dst_matrix[i_d][j_d*3];
			rgb_t *p_s = (rgb_t*)&src_matrix[i_s][j_s*3];
                        //*p_d = *p_s;
                        //porque int?
                        int ind_x = (i_d % tamy) + offsety;
                        int ind_y = (j_d % tamx) + offsetx;
                        p_d->b = src_matrix[ind_x][ind_y*3];
                        p_d->g = src_matrix[ind_x][ind_y*3 + 1];
                        p_d->r = src_matrix[ind_x][ind_y*3 + 2];
		}
	}

}
/*
{
    #define ancho  (col * 3)
    #define ancho_tile (tamx * 3)
    #define tile (src + offsetx * 3 + offsety * src_row_size)
.ciclo_horizontal:
    cmp ind_d_x + 16, ancho
    jg .conRetroceso
    cmp ind_t_x + 16, ancho_tile
    jg .conRetroceso_tile
    mov xmm, [tile[ind_t_x][ind_t_y]]
    mov dest[ind_d_x][ind_d_y], xmm
    jmp .ciclo_horizontal
}
*/








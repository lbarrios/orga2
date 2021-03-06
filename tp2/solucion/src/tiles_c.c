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
                        int ind_x = (i_d % tamy) + offsety;
                        int ind_y = (j_d % tamx) + offsetx;
                        p_d->b = src_matrix[ind_x][ind_y*3];
                        p_d->g = src_matrix[ind_x][ind_y*3 + 1];
                        p_d->r = src_matrix[ind_x][ind_y*3 + 2];
		}
	}

}


#include <math.h>
#include "tp2.h"


bool between(unsigned int val, unsigned int a, unsigned int b)
{
	return a <= val && val <= b;
}


void temperature_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size)
{
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int i_d = 0, i_s = 0; i_d < filas; i_d++, i_s++) {
		for (int j_d = 0, j_s = 0; j_d < cols; j_d++, j_s++) {
			rgb_t *p_s = (rgb_t*)&src_matrix[i_s][j_s*3];
			rgb_t *p_d = (rgb_t*)&dst_matrix[i_d][j_d*3];
			rgb_t color;
			int t = ( p_s->r + p_s->g + p_s->b ) / 3;
			if( t<32 ){
				color.r = 0;
				color.g = 0;
				color.b = 128 + t*4;
				*p_d = color;
				continue;
			}
			if( t<96 ){
				color.r = 0;
				color.g = (t-32)*4;
				color.b = 255;
				*p_d = color;
				continue;
			}
			if( t<160 ){
				color.r = (t-96)*4;
				color.g = 255;
				color.b = 255 - ((t-96)*4);
				*p_d = color;
				continue;
			}
			if( t<224 ){
				color.r = 255;
				color.g = 255 - ((t-160)*4);
				color.b = 0;
				*p_d = color;
				continue;
			}
			color.r = 255 - ((t-224)*4);
			color.g = 0;
			color.b = 0;
			*p_d = color;
		}
	}
}

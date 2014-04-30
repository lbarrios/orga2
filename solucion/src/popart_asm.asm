global popart_asm

section .data

colors:
  DB 255,   0,   0
  DB 127,   0, 127
  DB 255,   0, 255
  DB   0,   0, 255
  DB   0, 255, 255
  DB   0, 255, 255

section .text

%define _STEP 153

; void popart_c ( unsigned char* src, unsigned char* dst, int cols, int filas, int src_row_size, int dst_row_size )
; {
;   int tot_x = cols * 3;
;   int x=0;
;   int y=0;
;   long i;
;   int eax;

;   CICLO_FILAS:
;     CICLO_COLUMNAS:
;       // Obtengo el índice para src
;       i = ( x ) + ( y * src_row_size );
;       // Obtengo la suma de los tres colores y calculo el índice correspondiente a la matriz colors dividiendola por _STEP
;       eax = src[i + 0] + src[i + 1] + src[i + 2];
;       eax = eax / _STEP;
;       // Usando el índice i_color, obtengo de la matriz colors el color que voy a guardar en dst
;       //rgb_t color = *(rgb_t*)(colors + eax);
;       rgb_t color = colors[eax];
;       // Calculo el índice para dst
;       i = ( x ) + ( y * dst_row_size );
;       // Guardo los valores en las posiciones correspondientes de dst
;       dst[i + 0] = color.b;
;       dst[i + 1] = color.g;
;       dst[i + 2] = color.r;

;       x = x + 3;
;       if( x < tot_x )
;       {
;         goto CICLO_COLUMNAS;
;       }

;     x = 0;
;     y = y + 1;
;     if( y < filas )
;     {
;       goto CICLO_FILAS;
;     }

;     return;
; }

;void tiles_asm(unsigned char *src,
;              unsigned char *dst,
;              int cols,
;              int filas,
;              int src_row_size,
;              int dst_row_size );

mascara: 
db 0x00, 0x01, 0x02, 0x80
db 0x03, 0x04, 0x05, 0x80
db 0x06, 0x07, 0x08, 0x80
db 0x09, 0x0A, 0x0B, 0x80
mascara_back:
db 0x00, 0x01, 0x02, 0x04
db 0x05, 0x06, 0x08, 0x09
db 0x0A, 0x0C, 0x0D, 0x0E
db 0x80, 0x80, 0x80, 0x80

align 16
mascara_r: 
db 0x02, 0x80, 0x80, 0x80
db 0x05, 0x80, 0x80, 0x80
db 0x08, 0x80, 0x80, 0x80
db 0x0B, 0x80, 0x80, 0x80
mascara_r_back:
db 0x00, 0x80, 0x80, 0x80
db 0x00, 0x80, 0x80, 0x80
db 0x00, 0x80, 0x80, 0x80
db 0x00, 0x80, 0x80, 0x80
mascara_g: 
db 0x01, 0x80, 0x80, 0x80
db 0x04, 0x80, 0x80, 0x80
db 0x07, 0x80, 0x80, 0x80
db 0x0A, 0x80, 0x80, 0x80
mascara_g_back:
db 0x80, 0x80, 0x80, 0x80
db 0x80, 0x80, 0x80, 0x80
db 0x80, 0x80, 0x80, 0x80
db 0x80, 0x80, 0x80, 0x80
mascara_b: 
db 0x00, 0x80, 0x80, 0x80
db 0x03, 0x80, 0x80, 0x80
db 0x06, 0x80, 0x80, 0x80
db 0x09, 0x80, 0x80, 0x80
mascara_b_back:
db 0x80, 0x80, 0x80, 0x80
db 0x80, 0x80, 0x80, 0x80
db 0x80, 0x80, 0x80, 0x80
db 0x80, 0x80, 0x80, 0x80

popart_asm:
%define m_r xmm15
%define m_r_back xmm14
%define m_g xmm13
%define m_g_back xmm12
%define m_b xmm11
%define m_b_back xmm10
movdqa m_r, [mascara_r]
movdqa m_r_back, [mascara_r_back]
movdqa m_g, [mascara_g]
movdqa m_g_back, [mascara_g_back]
movdqa m_b, [mascara_b]
movdqa m_b_back, [mascara_b_back]

%define src rdi
%define dst rsi
%define cols rdx
%define filas rcx
%define src_row_size r8
%define dst_row_size r9
mov edx, edx
mov ecx, ecx
mov r8d, r8d; transformo src_row_size a qword
mov r9d, r9d; transformo dst_row_size a qword

lea cols, [cols*4 - cols]; hago cols= cols*3

%define y r12
%define x r13
xor y,y
xor x,x

%define i_src r14
mov i_src, src

%define i_dst r15
mov i_dst, dst

.ciclo_filas:
  .ciclo_columnas:
    %define r xmm0
    %define g xmm1
    %define b xmm2
    movdqu r, [i_src+x]
    movdqa g, r
    movdqa b, r
    
    pshufb r, [mascara_r]
    pshufb g, [mascara_g]
    pshufb b, [mascara_b]

    %define rgbsum r
    paddw rgbsum, g
    paddw rgbsum, b

    ;;código
    pshufb xmm0, xmm15

    movdqu [i_dst+x], xmm0
    add x,12; incremento x en 1
    cmp x, cols; comparo x con la cantidad de columnas
    jl .ciclo_columnas; si es menor o igual, sigo iterando
    je .fin_ciclo_columnas; si es igual no hago nada
    mov x, cols; si es mayor, le asigno x=cols-16 e itero una última vez
      sub x, 16;
      jmp .ciclo_columnas
  .fin_ciclo_columnas:
  
  xor x, x ; pongo x en 0
  add qword i_src, src_row_size; sumo al índice src una fila_src entera
  add qword i_dst, dst_row_size; sumo al índice dst una fila_dst entera
  inc y; incremento y en 1
  cmp y, filas
  jl .ciclo_filas

ret

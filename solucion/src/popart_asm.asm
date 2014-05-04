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

result_mask:
db 0x02, 0x01, 0x00
db 0x06, 0x05, 0x04
db 0x0A, 0x09, 0x08
db 0x0E, 0x0D, 0x0C
db 0x80, 0x80, 0x80, 0x80

ffffffffffffffffffffffffffffffff:
db 0xff, 0xff, 0xff, 0xff
db 0xff, 0xff, 0xff, 0xff
db 0xff, 0xff, 0xff, 0xff
db 0xff, 0xff, 0xff, 0xff

p152d:
dd 152, 152, 152, 152

p305d:
dd 305, 305, 305, 305

p458d:
dd 458, 458, 458, 458

p611d:
dd 611, 611, 611, 611

pcolors_a:
db 0, 0, 255, 0
db 0, 0, 255, 0
db 0, 0, 255, 0
db 0, 0, 255, 0

pcolors_b:
db 127, 0, 127, 0
db 127, 0, 127, 0
db 127, 0, 127, 0
db 127, 0, 127, 0

pcolors_c:
db 255, 0, 255, 0
db 255, 0, 255, 0
db 255, 0, 255, 0
db 255, 0, 255, 0

pcolors_d:
db 255, 0, 0, 0
db 255, 0, 0, 0
db 255, 0, 0, 0
db 255, 0, 0, 0

pcolors_e:
db 255, 255, 0, 0
db 255, 255, 0, 0
db 255, 255, 0, 0
db 255, 255, 0, 0

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
    
    ; traigo los 4 pixeles fuente y los replico en r, g y b
    movdqu r, [i_src+x]
    movdqa g, r
    movdqa b, r
    
    ; r=[r4,r3,r2,r1], g=[g4,g3,g2,g1], b=[b4,b3,b2,b1]
    pshufb r, [mascara_r]
    pshufb g, [mascara_g]
    pshufb b, [mascara_b]

    ; rgbsum=[(r+g+b)4,(r+g+b)3,(r+g+b)2,(r+g+b)1]
    %define  rgbsum r
    paddw    rgbsum, g
    paddw    rgbsum, b

    ; voy a generar sucesivas máscaras de bits 
    ; en donde el registro va a valer "ffff" en los dwords 
    ; que cumplan las condiciones que le pido

    ;; veo cuales son < 153
    %define   lw153d xmm1
    movdqa    lw153d, rgbsum; traigo una copia del registro original
      ;lw153d = rgbsum
    pcmpgtd   lw153d, [p152d]; veo cuales son mayores a 152
      ;lw153d = {x: x>152}
    pxor      lw153d, [ffffffffffffffffffffffffffffffff]; invierto el resultado
      ;lw153d = {x: x<=152}
      ;lw153d = {x: x<153}
    
    ;; veo cuales son >=153 y <306
    %define   gte153_lw306d xmm2
    movdqa    gte153_lw306d, rgbsum; traigo una copia del registro original
      ;gte153_lw306d = rgbsum
    pcmpgtd   gte153_lw306d, [p305d]; veo cuales son mayores a 305
      ;gte153_lw306d = {x: x>305}
    por       gte153_lw306d, lw153d; agrego los menores a 153
      ;gte153_lw306d = {x: x<153 v x>305}
    pxor      gte153_lw306d, [ffffffffffffffffffffffffffffffff]; invierto el resultado
      ;gte153_lw306d = {x: x>=153 ^ x<=305}
      ;gte153_lw306d = {x: x>=153 ^ x<306}

    ;; veo cuales son >=306 y <459
    %define   gte306_lw459d xmm3
    movdqa    gte306_lw459d, rgbsum; traigo una copia del registro original
      ;gte306_lw459d = rgbsum
    pcmpgtd   gte306_lw459d, [p458d]; veo cuales son mayores a 458
      ;gte306_lw459d = {x: x>458}
    por       gte306_lw459d, lw153d; agrego los menores a 153
      ;gte306_lw459d = {x: x<153 v x>458}
    por       gte306_lw459d, gte153_lw306d; agrego los >=153 y <306
      ;gte306_lw459d = {x: x<153 v (x>=153 ^ x<306) v x>458}
      ;gte306_lw459d = {x: x<306 v x>458}
    pxor      gte306_lw459d, [ffffffffffffffffffffffffffffffff]; invierto el resultado
      ;gte306_lw459d = {x: x>=306 ^ x<=458}
      ;gte306_lw459d = {x: x>=306 ^ x<459}

    ;; veo cuales son >=459 y <612
    %define   gte459_lw612d rgbsum
      ;gte459_lw612d = rgbsum
    pcmpgtd   gte459_lw612d, [p611d]; veo cuales son mayores a 611
      ;gte459_lw612d = {x: x>611}
    por       gte459_lw612d, lw153d; agrego los menores a 153
    por       gte459_lw612d, gte153_lw306d; agrego los >=153 y <306
    por       gte459_lw612d, gte306_lw459d; agrego los >=306 y <459
      ;gte459_lw612d = {x: x<459 v x>611}
    pxor      gte459_lw612d, [ffffffffffffffffffffffffffffffff]; invierto el resultado
      ;gte459_lw612d = {x: x>=459 ^ x<=611}
      ;gte459_lw612d = {x: x>=459 ^ x<612}
    
    ;; veo los otros casos
    %define   otherwise xmm4
    ; mezclo todas las condiciones en un mismo registro
    movdqa    otherwise, lw153d
    por       otherwise, gte153_lw306d
    por       otherwise, gte306_lw459d
    por       otherwise, gte459_lw612d
    pxor      otherwise, [ffffffffffffffffffffffffffffffff]; luego invierto el resultado

    ; ahora, utilizando las máscaras de bits, voy a hacer "and"
    ; contra los valores que deberían tener los registros para cada situación

    pand      lw153d,        [pcolors_a]
    pand      gte153_lw306d, [pcolors_b]
    pand      gte306_lw459d, [pcolors_c]
    pand      gte459_lw612d, [pcolors_d]
    pand      otherwise,     [pcolors_e]

    ; ahora fusiono todos los resultados
    %define result_d gte459_lw612d
    por       result_d, lw153d
    por       result_d, gte153_lw306d
    por       result_d, gte306_lw459d
    por       result_d, otherwise

    ; ahora reacomodo el resultado porque lo tengo en dwords
    %define result result_d
    pshufb  result, [result_mask]

    movdqu [i_dst+x], result
    add x,12; incremento x en 1
    cmp x, cols; comparo x con la cantidad de columnas
    jl .ciclo_columnas; si es menor o igual, sigo iterando
    je .fin_ciclo_columnas; si es igual no hago nada
    mov x, cols; si es mayor, le asigno x=cols-16 e itero una última vez
      sub x, 12;
      jmp .ciclo_columnas
  .fin_ciclo_columnas:
  
  xor x, x ; pongo x en 0
  add qword i_src, src_row_size; sumo al índice src una fila_src entera
  add qword i_dst, dst_row_size; sumo al índice dst una fila_dst entera
  inc y; incremento y en 1
  cmp y, filas
  jl .ciclo_filas

ret

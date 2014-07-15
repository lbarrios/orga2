global popart_asm

section .data

align 16
colors:
  DB 255,   0,   0
  DB 127,   0, 127
  DB 255,   0, 255
  DB   0,   0, 255
  DB   0, 255, 255
  DB   0, 255, 255

align 16
mask_shuf_last_src:
db 0x04, 0x05, 0x06, 0x07
db 0x08, 0x09, 0x0A, 0x0B
db 0x0C, 0x0D, 0x0E, 0x0F
db 0x80, 0x80, 0x80, 0x80

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

%define _STEP 153

section .text

popart_asm:
push r12
push r13
push r14
push r15

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
sub cols, 16

%define y r12
%define x r13
xor y,y
xor x,x

%define i_src r14
mov i_src, src

%define i_dst r15
mov i_dst, dst

dec filas

;%define prefetch xmm5
;movdqu prefetch, [i_src+x]

; Para el experimento 2
movdqu xmm0, [i_src+x]
movdqu xmm6, [p152d]
movdqu xmm7, [ffffffffffffffffffffffffffffffff]
movdqu xmm8, [p305d]
movdqu xmm9, [p458d]
movdqu xmm10, [p611d]

.ciclo_filas:
  .ciclo_columnas:
    %define r xmm0
    %define g xmm1
    %define b xmm2
    
    ; traigo los 4 pixeles fuente y los replico en r, g y b
    ;movdqu r, [i_src+x]
    ;movdqu r, prefetch
    movdqa g, r
    movdqa b, r
    ;movdqu prefetch, [i_src+x+12]
    ;jmp .guarda ; Para experimento 2

    ; r=[r4,r3,r2,r1], g=[g4,g3,g2,g1], b=[b4,b3,b2,b1]
    ;pshufb r, [mascara_r]
    ;pshufb g, [mascara_g]
    ;pshufb b, [mascara_b]
    pshufb r, xmm0
    pshufb g, xmm0
    pshufb b, xmm0

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
    pcmpgtd   lw153d, xmm6;[p152d]; veo cuales son mayores a 152
      ;lw153d = {x: x>152}
    pxor      lw153d, xmm7; invierto el resultado
      ;lw153d = {x: x<=152}
      ;lw153d = {x: x<153}
    
    ;; veo cuales son >=153 y <306
    %define   gte153_lw306d xmm2
    movdqa    gte153_lw306d, rgbsum; traigo una copia del registro original
      ;gte153_lw306d = rgbsum
    pcmpgtd   gte153_lw306d, xmm6;xmm8; veo cuales son mayores a 305
      ;gte153_lw306d = {x: x>305}
    por       gte153_lw306d, lw153d; agrego los menores a 153
      ;gte153_lw306d = {x: x<153 v x>305}
    pxor      gte153_lw306d, xmm7; invierto el resultado
      ;gte153_lw306d = {x: x>=153 ^ x<=305}
      ;gte153_lw306d = {x: x>=153 ^ x<306}

    ;; veo cuales son >=306 y <459
    %define   gte306_lw459d xmm3
    movdqa    gte306_lw459d, rgbsum; traigo una copia del registro original
      ;gte306_lw459d = rgbsum
    pcmpgtd   gte306_lw459d, xmm9; veo cuales son mayores a 458
      ;gte306_lw459d = {x: x>458}
    por       gte306_lw459d, lw153d; agrego los menores a 153
      ;gte306_lw459d = {x: x<153 v x>458}
    por       gte306_lw459d, gte153_lw306d; agrego los >=153 y <306
      ;gte306_lw459d = {x: x<153 v (x>=153 ^ x<306) v x>458}
      ;gte306_lw459d = {x: x<306 v x>458}
    pxor      gte306_lw459d, xmm7; invierto el resultado
      ;gte306_lw459d = {x: x>=306 ^ x<=458}
      ;gte306_lw459d = {x: x>=306 ^ x<459}

    ;; veo cuales son >=459 y <612
    %define   gte459_lw612d rgbsum
      ;gte459_lw612d = rgbsum
    pcmpgtd   gte459_lw612d, xmm10; veo cuales son mayores a 611
      ;gte459_lw612d = {x: x>611}
    por       gte459_lw612d, lw153d; agrego los menores a 153
    por       gte459_lw612d, gte153_lw306d; agrego los >=153 y <306
    por       gte459_lw612d, gte306_lw459d; agrego los >=306 y <459
      ;gte459_lw612d = {x: x<459 v x>611}
    pxor      gte459_lw612d, xmm7; invierto el resultado
      ;gte459_lw612d = {x: x>=459 ^ x<=611}
      ;gte459_lw612d = {x: x>=459 ^ x<612}
    
    ;; veo los otros casos
    %define   otherwise xmm4
    ; mezclo todas las condiciones en un mismo registro
    movdqa    otherwise, lw153d
    por       otherwise, gte153_lw306d
    por       otherwise, gte306_lw459d
    por       otherwise, gte459_lw612d
    pxor      otherwise, xmm7; luego invierto el resultado

    ; ahora, utilizando las máscaras de bits, voy a hacer "and"
    ; contra los valores que deberían tener los registros para cada situación

;    pand      lw153d,        [pcolors_a]
;    pand      gte153_lw306d, [pcolors_b]
;    pand      gte306_lw459d, [pcolors_c]
;    pand      gte459_lw612d, [pcolors_d]
;    pand      otherwise,     [pcolors_e]

    ; ahora fusiono todos los resultados
    %define result_d gte459_lw612d
    por       result_d, lw153d
    por       result_d, gte153_lw306d
    por       result_d, gte306_lw459d
    por       result_d, otherwise


;;;; Agrego muchas instrucciones del mismo tipo
; (experimento 2)

; 0
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

; ; 100

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

; ; 200

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

; ; 300

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

; ; 400

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise
;     por       result_d, lw153d
;     por       result_d, gte153_lw306d
;     por       result_d, gte306_lw459d
;     por       result_d, otherwise

; 500


    ; ahora reacomodo el resultado porque lo tengo en dwords
    %define result result_d
    pshufb  result, [result_mask]

    .guarda:
    movdqu [i_dst+x], result
    add x,12; incremento x en 1
    cmp x, cols; comparo x con la cantidad de columnas
    jb .ciclo_columnas; si es menor o igual, sigo iterando
    mov x, cols; si es mayor, le asigno x=cols-16 e itero una última vez
    sub x, 2;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



    %define r xmm0
    %define g xmm1
    %define b xmm2
    
    ; traigo los 4 pixeles fuente y los replico en r, g y b
    movdqu r, [i_src+x]
    movdqa g, r
    movdqa b, r
    ;jmp .guarda2 ; Para experimento 2

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
    pxor      lw153d, xmm7; invierto el resultado
      ;lw153d = {x: x<=152}
      ;lw153d = {x: x<153}
    
    ;; veo cuales son >=153 y <306
    %define   gte153_lw306d xmm2
    movdqa    gte153_lw306d, rgbsum; traigo una copia del registro original
      ;gte153_lw306d = rgbsum
    pcmpgtd   gte153_lw306d, xmm8; veo cuales son mayores a 305
      ;gte153_lw306d = {x: x>305}
    por       gte153_lw306d, lw153d; agrego los menores a 153
      ;gte153_lw306d = {x: x<153 v x>305}
    pxor      gte153_lw306d, xmm7; invierto el resultado
      ;gte153_lw306d = {x: x>=153 ^ x<=305}
      ;gte153_lw306d = {x: x>=153 ^ x<306}

    ;; veo cuales son >=306 y <459
    %define   gte306_lw459d xmm3
    movdqa    gte306_lw459d, rgbsum; traigo una copia del registro original
      ;gte306_lw459d = rgbsum
    pcmpgtd   gte306_lw459d, xmm9; veo cuales son mayores a 458
      ;gte306_lw459d = {x: x>458}
    por       gte306_lw459d, lw153d; agrego los menores a 153
      ;gte306_lw459d = {x: x<153 v x>458}
    por       gte306_lw459d, gte153_lw306d; agrego los >=153 y <306
      ;gte306_lw459d = {x: x<153 v (x>=153 ^ x<306) v x>458}
      ;gte306_lw459d = {x: x<306 v x>458}
    pxor      gte306_lw459d, xmm7; invierto el resultado
      ;gte306_lw459d = {x: x>=306 ^ x<=458}
      ;gte306_lw459d = {x: x>=306 ^ x<459}

    ;; veo cuales son >=459 y <612
    %define   gte459_lw612d rgbsum
      ;gte459_lw612d = rgbsum
    pcmpgtd   gte459_lw612d, xmm10; veo cuales son mayores a 611
      ;gte459_lw612d = {x: x>611}
    por       gte459_lw612d, lw153d; agrego los menores a 153
    por       gte459_lw612d, gte153_lw306d; agrego los >=153 y <306
    por       gte459_lw612d, gte306_lw459d; agrego los >=306 y <459
      ;gte459_lw612d = {x: x<459 v x>611}
    pxor      gte459_lw612d, xmm7; invierto el resultado
      ;gte459_lw612d = {x: x>=459 ^ x<=611}
      ;gte459_lw612d = {x: x>=459 ^ x<612}
    
    ;; veo los otros casos
    %define   otherwise xmm4
    ; mezclo todas las condiciones en un mismo registro
    movdqa    otherwise, lw153d
    por       otherwise, gte153_lw306d
    por       otherwise, gte306_lw459d
    por       otherwise, gte459_lw612d
    pxor      otherwise, xmm7; luego invierto el resultado

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

    .guarda2:
    movdqu [i_dst+x], result

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov x, cols

    %define r xmm0
    %define g xmm1
    %define b xmm2
    
    ; traigo los 4 pixeles fuente y los replico en r, g y b
    movdqu r, [i_src+x]
    pshufb r, [mask_shuf_last_src]
    movdqa g, r
    movdqa b, r
    ;jmp .guarda3 ; Para experimento 2
    
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
    pxor      lw153d, xmm7; invierto el resultado
      ;lw153d = {x: x<=152}
      ;lw153d = {x: x<153}
    
    ;; veo cuales son >=153 y <306
    %define   gte153_lw306d xmm2
    movdqa    gte153_lw306d, rgbsum; traigo una copia del registro original
      ;gte153_lw306d = rgbsum
    pcmpgtd   gte153_lw306d, xmm8; veo cuales son mayores a 305
      ;gte153_lw306d = {x: x>305}
    por       gte153_lw306d, lw153d; agrego los menores a 153
      ;gte153_lw306d = {x: x<153 v x>305}
    pxor      gte153_lw306d, xmm7; invierto el resultado
      ;gte153_lw306d = {x: x>=153 ^ x<=305}
      ;gte153_lw306d = {x: x>=153 ^ x<306}

    ;; veo cuales son >=306 y <459
    %define   gte306_lw459d xmm3
    movdqa    gte306_lw459d, rgbsum; traigo una copia del registro original
      ;gte306_lw459d = rgbsum
    pcmpgtd   gte306_lw459d, xmm9; veo cuales son mayores a 458
      ;gte306_lw459d = {x: x>458}
    por       gte306_lw459d, lw153d; agrego los menores a 153
      ;gte306_lw459d = {x: x<153 v x>458}
    por       gte306_lw459d, gte153_lw306d; agrego los >=153 y <306
      ;gte306_lw459d = {x: x<153 v (x>=153 ^ x<306) v x>458}
      ;gte306_lw459d = {x: x<306 v x>458}
    pxor      gte306_lw459d, xmm7; invierto el resultado
      ;gte306_lw459d = {x: x>=306 ^ x<=458}
      ;gte306_lw459d = {x: x>=306 ^ x<459}

    ;; veo cuales son >=459 y <612
    %define   gte459_lw612d rgbsum
      ;gte459_lw612d = rgbsum
    pcmpgtd   gte459_lw612d, xmm10; veo cuales son mayores a 611
      ;gte459_lw612d = {x: x>611}
    por       gte459_lw612d, lw153d; agrego los menores a 153
    por       gte459_lw612d, gte153_lw306d; agrego los >=153 y <306
    por       gte459_lw612d, gte306_lw459d; agrego los >=306 y <459
      ;gte459_lw612d = {x: x<459 v x>611}
    pxor      gte459_lw612d, xmm7; invierto el resultado
      ;gte459_lw612d = {x: x>=459 ^ x<=611}
      ;gte459_lw612d = {x: x>=459 ^ x<612}
    
    ;; veo los otros casos
    %define   otherwise xmm4
    ; mezclo todas las condiciones en un mismo registro
    movdqa    otherwise, lw153d
    por       otherwise, gte153_lw306d
    por       otherwise, gte306_lw459d
    por       otherwise, gte459_lw612d
    pxor      otherwise, xmm7; luego invierto el resultado

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

    .guarda3:
    pextrb [i_dst+x+10], result, 6
    pextrb [i_dst+x+11], result, 7
    pextrb [i_dst+x+12], result, 8
    pextrb [i_dst+x+13], result, 9
    pextrb [i_dst+x+14], result, 10
    pextrb [i_dst+x+15], result, 11

    ;movdqu [i_dst+x], result

  .fin_ciclo_columnas:
  
  xor x, x ; pongo x en 0
  add qword i_src, src_row_size; sumo al índice src una fila_src entera
  add qword i_dst, dst_row_size; sumo al índice dst una fila_dst entera
  inc y; incremento y en 1
  cmp y, filas
  jb .ciclo_filas

pop r15
pop r14
pop r13
pop r12

ret
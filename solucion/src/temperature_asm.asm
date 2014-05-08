global temperature_asm

section .data

align 16
mascara_r:
db 0x02, 0x80, 0x80, 0x80
db 0x05, 0x80, 0x80, 0x80
db 0x08, 0x80, 0x80, 0x80
db 0x0B, 0x80, 0x80, 0x80
mascara_g:
db 0x01, 0x80, 0x80, 0x80
db 0x04, 0x80, 0x80, 0x80
db 0x07, 0x80, 0x80, 0x80
db 0x0A, 0x80, 0x80, 0x80
mascara_b:
db 0x00, 0x80, 0x80, 0x80
db 0x03, 0x80, 0x80, 0x80
db 0x06, 0x80, 0x80, 0x80
db 0x09, 0x80, 0x80, 0x80

packedsingle3:
dd 3.0,3.0,3.0,3.0

p31d:
dd 31, 31, 31, 31
p32d:
dd 32, 32, 32, 32
mask_32:
db 128, 0x00, 0x00, 0x00
db 128, 0x00, 0x00, 0x00
db 128, 0x00, 0x00, 0x00
db 128, 0x00, 0x00, 0x00
mask_t_32_plus:
db 0xff, 0x00, 0x00, 0x00
db 0xff, 0x00, 0x00, 0x00
db 0xff, 0x00, 0x00, 0x00
db 0xff, 0x00, 0x00, 0x00

p95d:
dd 95, 95, 95, 95
p96d:
dd 96, 96, 96, 96
mask_96:
db 255, 0x00, 0x00, 0x00
db 255, 0x00, 0x00, 0x00
db 255, 0x00, 0x00, 0x00
db 255, 0x00, 0x00, 0x00
mask_t_96_plus:
db 0x00, 0xff, 0x00, 0x00
db 0x00, 0xff, 0x00, 0x00
db 0x00, 0xff, 0x00, 0x00
db 0x00, 0xff, 0x00, 0x00


p159d:
dd 159, 159, 159, 159
p160d:
dd 160, 160, 160, 160
mask_160:
db 255, 255, 0x00, 0x00
db 255, 255, 0x00, 0x00
db 255, 255, 0x00, 0x00
db 255, 255, 0x00, 0x00
mask_t_160_plus:
db 0x00, 0x00, 0xff, 0x00
db 0x00, 0x00, 0xff, 0x00
db 0x00, 0x00, 0xff, 0x00
db 0x00, 0x00, 0xff, 0x00
mask_t_160_minus:
db 0xff, 0x00, 0x00, 0x00
db 0xff, 0x00, 0x00, 0x00
db 0xff, 0x00, 0x00, 0x00
db 0xff, 0x00, 0x00, 0x00

p223d:
dd 223, 223, 223, 223
p224d:
dd 224, 224, 224, 224
mask_224:
db 0x00, 255, 255, 0x00
db 0x00, 255, 255, 0x00
db 0x00, 255, 255, 0x00
db 0x00, 255, 255, 0x00
mask_t_224_minus:
db 0x00, 0xff, 0x00, 0x00
db 0x00, 0xff, 0x00, 0x00
db 0x00, 0xff, 0x00, 0x00
db 0x00, 0xff, 0x00, 0x00

mask_otherwise:
db 0x00, 0x00, 255, 0x00
db 0x00, 0x00, 255, 0x00
db 0x00, 0x00, 255, 0x00
db 0x00, 0x00, 255, 0x00
mask_t_otherwise_minus:
db 0x00, 0x00, 0xff, 0x00
db 0x00, 0x00, 0xff, 0x00
db 0x00, 0x00, 0xff, 0x00
db 0x00, 0x00, 0xff, 0x00

minusone:
db 0xff, 0xff, 0xff, 0xff
db 0xff, 0xff, 0xff, 0xff
db 0xff, 0xff, 0xff, 0xff
db 0xff, 0xff, 0xff, 0xff

mask_dword_to_byte:
db 0x00, 0x00, 0x00, 0x80
db 0x04, 0x04, 0x04, 0x80
db 0x08, 0x08, 0x08, 0x80
db 0x0C, 0x0C, 0x0C, 0x80

mask_shuf_last_src:
db 0x04, 0x05, 0x06, 0x07
db 0x08, 0x09, 0x0A, 0x0B
db 0x0C, 0x0D, 0x0E, 0x0F
db 0x80, 0x80, 0x80, 0x80

mask_shuf_last_dst:
db 0x80, 0x80, 0x80, 0x80
db 0x00, 0x01, 0x02, 0x02
db 0x04, 0x05, 0x06, 0x07
db 0x08, 0x09, 0x0A, 0x0B

mask_filter_last_dst:
db 0xff, 0xff, 0xff, 0xff
db 0x00, 0x00, 0x00, 0x00
db 0x00, 0x00, 0x00, 0x00
db 0x00, 0x00, 0x00, 0x00

result_mask:
db 0x00, 0x01, 0x02,
db 0x04, 0x05, 0x06,
db 0x08, 0x09, 0x0A,
db 0x0C, 0x0D, 0x0E,
db 0x80, 0x80, 0x80, 0x80

section .text

temperature_asm:
push r12
push r13
push r14
push r15

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Defino macros para parámetros que me vinieron de entrada; limpio las partes altas de ser necesario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%define src rdi
%define dst rsi
mov edx, edx; transformo cols a qword
%define cols rdx
mov ecx, ecx; transformo filas a qword
%define filas rcx
mov r8d, r8d; transformo src_row_size a qword
%define src_row_size r8
mov r9d, r9d; transformo dst_row_size a qword
%define dst_row_size r9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Multiplico cols por 3, ya que son 3 bytes por pixel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov rax, cols; rax=cols
shl cols, 2; cols = 4*cols
sub cols, rax; cols = 4*cols - rax = 4*cols-cols = (4-1)*cols = 3*cols

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Defino x e y dos registros "índices" que voy a usar para recorrer la matriz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%define y r12
%define x r13
xor y,y
xor x,x

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Defino b_src y b_dst, dos "bases" que voy a usar para recorrer la matriz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define b_src r14
mov b_src, src
%define b_dst r15
mov b_dst, dst

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Las filas empiezan de cero, así que resto una
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;dec filas
sub cols, 16

.ciclo_filas:
  .ciclo_columnas:
    ; defino los 3 registros en que voy a guardar los colores r, g y b
    %define r xmm0
    %define g xmm1
    %define b xmm2

    ; traigo los 4 pixeles desde fuente y los replico en los registros r, g y b
    movdqu r, [b_src+x]
    movdqa g, r
    movdqa b, r

    ; filtro para que quede r en r, g en g y b en b
    ; r=[r4,r3,r2,r1], g=[g4,g3,g2,g1], b=[b4,b3,b2,b1]
    pshufb r, [mascara_r]
    pshufb g, [mascara_g]
    pshufb b, [mascara_b]

    ; defino el registro rgbsum donde voy a guardar la suma de r+g+b
    %define  rgbsum r
    ; sumo sobre rgbsum
    ; rgbsum=[(r+g+b)4,(r+g+b)3,(r+g+b)2,(r+g+b)1]
    paddd    rgbsum, g
    paddd    rgbsum, b

    ; convierto a float
    cvtdq2ps rgbsum, rgbsum
    %define t rgbsum
    ; divido empaquetado por 3
    divps t, [packedsingle3]
    ; convierto a int con truncamiento
    cvttps2dq t, t


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    %define lw32 xmm1
    movdqa lw32, t
    pcmpgtd lw32, [p31d]
    pxor lw32, [minusone]

    %define gte32lw96 xmm2
    movdqa gte32lw96, t
    pcmpgtd gte32lw96, [p95d] ; x>95
    por gte32lw96, lw32; x>95 v x<32
    pxor gte32lw96, [minusone]; 32<=x<96

    %define gte96lw160 xmm3
    movdqa gte96lw160, t
    pcmpgtd gte96lw160, [p159d]; x>159
    por gte96lw160, gte32lw96;  {x>159} U {32<=x<96}
    por gte96lw160, lw32; {x>159} U {32<=x<96} U {x<32} = {x>159} U {x<96}
    pxor gte96lw160, [minusone];

    %define gte160lw224 xmm4
    movdqa gte160lw224, t
    pcmpgtd gte160lw224, [p223d]
    por gte160lw224, gte96lw160
    por gte160lw224, gte32lw96
    por gte160lw224, lw32
    pxor gte160lw224, [minusone]

    %define otherwise xmm5
    movdqa otherwise, gte160lw224
    por otherwise, gte96lw160
    por otherwise, gte32lw96
    por otherwise, lw32
    pxor otherwise, [minusone]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    %define lw32_t_plus xmm6
    movdqa lw32_t_plus, t
    pslld lw32_t_plus, 2
    pand lw32_t_plus, lw32
    pshufb lw32_t_plus, [mask_dword_to_byte]
    pand lw32_t_plus, [mask_t_32_plus]
    ;
    pand lw32, [mask_32]
    ; sumo
    paddb lw32, lw32_t_plus

    %define gte32lw96_t_plus xmm7
    movdqa gte32lw96_t_plus, t
    psubd gte32lw96_t_plus, [p32d]
    pslld gte32lw96_t_plus, 2
    pand gte32lw96_t_plus, gte32lw96
    pshufb gte32lw96_t_plus, [mask_dword_to_byte]
    pand gte32lw96_t_plus, [mask_t_96_plus]
    ;
    pand gte32lw96, [mask_96]
    ;
    paddb gte32lw96, gte32lw96_t_plus

    %define gte96lw160_t_plus xmm8
    movdqa gte96lw160_t_plus, t
    psubd gte96lw160_t_plus, [p96d]
    pslld gte96lw160_t_plus, 2
    pand gte96lw160_t_plus, gte96lw160
    pshufb gte96lw160_t_plus, [mask_dword_to_byte]
    pand gte96lw160_t_plus, [mask_t_160_plus]
    %define gte96lw160_t_minus xmm9
    movdqa gte96lw160_t_minus, t
    psubd gte96lw160_t_minus, [p96d]
    pslld gte96lw160_t_minus, 2
    pand gte96lw160_t_minus, gte96lw160
    pshufb gte96lw160_t_minus, [mask_dword_to_byte]
    movdqu xmm15, [mask_t_160_minus]
    pand gte96lw160_t_minus, [mask_t_160_minus]
    ;
    pand gte96lw160, [mask_160]
    ;
    paddb gte96lw160, gte96lw160_t_plus
    psubb gte96lw160, gte96lw160_t_minus

    %define gte160lw224_t_minus xmm10
    movdqa gte160lw224_t_minus, t
    psubd gte160lw224_t_minus, [p160d]
    pslld gte160lw224_t_minus, 2
    pand gte160lw224_t_minus, gte160lw224
    pshufb gte160lw224_t_minus, [mask_dword_to_byte]
    pand gte160lw224_t_minus, [mask_t_224_minus]
    ;
    pand gte160lw224, [mask_224]
    ;
    psubb gte160lw224, gte160lw224_t_minus

    %define otherwise_t_minus xmm11
    movdqa otherwise_t_minus, t
    psubd otherwise_t_minus, [p224d]
    pslld otherwise_t_minus, 2
    pand otherwise_t_minus, otherwise
    pshufb otherwise_t_minus, [mask_dword_to_byte]
    pand otherwise_t_minus, [mask_t_otherwise_minus]
    ;
    pand otherwise, [mask_otherwise]
    ;
    psubb otherwise, otherwise_t_minus



  	%define result_d otherwise
    por result_d, gte160lw224
    por result_d, gte96lw160
    por result_d, gte32lw96
    por result_d, lw32

    ; ahora reacomodo el resultado porque lo tengo en dwords
    %define result result_d
    pshufb  result, [result_mask]
    movdqu [b_dst+x], result
    

    add x,12; incremento x en 12
    cmp x, cols; comparo x con la cantidad de columnas
    jb .ciclo_columnas; si es menor o igual, sigo iterando
    mov x, cols; si es mayor, le asigno x=cols-16 e itero una última vez
      sub x, 2; x = tot_cols - 18
      ;jmp .ciclo_columnas






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










; defino los 3 registros en que voy a guardar los colores r, g y b
    %define r xmm0
    %define g xmm1
    %define b xmm2

    ; traigo los 4 pixeles desde fuente y los replico en los registros r, g y b
    movdqu r, [b_src+x]
    movdqa g, r
    movdqa b, r

    ; filtro para que quede r en r, g en g y b en b
    ; r=[r4,r3,r2,r1], g=[g4,g3,g2,g1], b=[b4,b3,b2,b1]
    pshufb r, [mascara_r]
    pshufb g, [mascara_g]
    pshufb b, [mascara_b]

    ; defino el registro rgbsum donde voy a guardar la suma de r+g+b
    %define  rgbsum r
    ; sumo sobre rgbsum
    ; rgbsum=[(r+g+b)4,(r+g+b)3,(r+g+b)2,(r+g+b)1]
    paddd    rgbsum, g
    paddd    rgbsum, b

    ; convierto a float
    cvtdq2ps rgbsum, rgbsum
    %define t rgbsum
    ; divido empaquetado por 3
    divps t, [packedsingle3]
    ; convierto a int con truncamiento
    cvttps2dq t, t


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    %define lw32 xmm1
    movdqa lw32, t
    pcmpgtd lw32, [p31d]
    pxor lw32, [minusone]

    %define gte32lw96 xmm2
    movdqa gte32lw96, t
    pcmpgtd gte32lw96, [p95d] ; x>95
    por gte32lw96, lw32; x>95 v x<32
    pxor gte32lw96, [minusone]; 32<=x<96

    %define gte96lw160 xmm3
    movdqa gte96lw160, t
    pcmpgtd gte96lw160, [p159d]; x>159
    por gte96lw160, gte32lw96;  {x>159} U {32<=x<96}
    por gte96lw160, lw32; {x>159} U {32<=x<96} U {x<32} = {x>159} U {x<96}
    pxor gte96lw160, [minusone];

    %define gte160lw224 xmm4
    movdqa gte160lw224, t
    pcmpgtd gte160lw224, [p223d]
    por gte160lw224, gte96lw160
    por gte160lw224, gte32lw96
    por gte160lw224, lw32
    pxor gte160lw224, [minusone]

    %define otherwise xmm5
    movdqa otherwise, gte160lw224
    por otherwise, gte96lw160
    por otherwise, gte32lw96
    por otherwise, lw32
    pxor otherwise, [minusone]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    %define lw32_t_plus xmm6
    movdqa lw32_t_plus, t
    pslld lw32_t_plus, 2
    pand lw32_t_plus, lw32
    pshufb lw32_t_plus, [mask_dword_to_byte]
    pand lw32_t_plus, [mask_t_32_plus]
    ;
    pand lw32, [mask_32]
    ; sumo
    paddb lw32, lw32_t_plus

    %define gte32lw96_t_plus xmm7
    movdqa gte32lw96_t_plus, t
    psubd gte32lw96_t_plus, [p32d]
    pslld gte32lw96_t_plus, 2
    pand gte32lw96_t_plus, gte32lw96
    pshufb gte32lw96_t_plus, [mask_dword_to_byte]
    pand gte32lw96_t_plus, [mask_t_96_plus]
    ;
    pand gte32lw96, [mask_96]
    ;
    paddb gte32lw96, gte32lw96_t_plus

    %define gte96lw160_t_plus xmm8
    movdqa gte96lw160_t_plus, t
    psubd gte96lw160_t_plus, [p96d]
    pslld gte96lw160_t_plus, 2
    pand gte96lw160_t_plus, gte96lw160
    pshufb gte96lw160_t_plus, [mask_dword_to_byte]
    pand gte96lw160_t_plus, [mask_t_160_plus]
    %define gte96lw160_t_minus xmm9
    movdqa gte96lw160_t_minus, t
    psubd gte96lw160_t_minus, [p96d]
    pslld gte96lw160_t_minus, 2
    pand gte96lw160_t_minus, gte96lw160
    pshufb gte96lw160_t_minus, [mask_dword_to_byte]
    movdqu xmm15, [mask_t_160_minus]
    pand gte96lw160_t_minus, [mask_t_160_minus]
    ;
    pand gte96lw160, [mask_160]
    ;
    paddb gte96lw160, gte96lw160_t_plus
    psubb gte96lw160, gte96lw160_t_minus

    %define gte160lw224_t_minus xmm10
    movdqa gte160lw224_t_minus, t
    psubd gte160lw224_t_minus, [p160d]
    pslld gte160lw224_t_minus, 2
    pand gte160lw224_t_minus, gte160lw224
    pshufb gte160lw224_t_minus, [mask_dword_to_byte]
    pand gte160lw224_t_minus, [mask_t_224_minus]
    ;
    pand gte160lw224, [mask_224]
    ;
    psubb gte160lw224, gte160lw224_t_minus

    %define otherwise_t_minus xmm11
    movdqa otherwise_t_minus, t
    psubd otherwise_t_minus, [p224d]
    pslld otherwise_t_minus, 2
    pand otherwise_t_minus, otherwise
    pshufb otherwise_t_minus, [mask_dword_to_byte]
    pand otherwise_t_minus, [mask_t_otherwise_minus]
    ;
    pand otherwise, [mask_otherwise]
    ;
    psubb otherwise, otherwise_t_minus



    %define result_d otherwise
    por result_d, gte160lw224
    por result_d, gte96lw160
    por result_d, gte32lw96
    por result_d, lw32

    ; ahora reacomodo el resultado porque lo tengo en dwords
    %define result result_d
    pshufb  result, [result_mask]
    movdqu [b_dst+x], result





  mov x, cols






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; defino los 3 registros en que voy a guardar los colores r, g y b
    %define r xmm0
    %define g xmm1
    %define b xmm2

    ; traigo los 4 pixeles desde fuente y los replico en los registros r, g y b
    movdqu r, [b_src+x]
    pshufb r, [mask_shuf_last_src]
    movdqa g, r
    movdqa b, r

    ; filtro para que quede r en r, g en g y b en b
    ; r=[r4,r3,r2,r1], g=[g4,g3,g2,g1], b=[b4,b3,b2,b1]
    pshufb r, [mascara_r]
    pshufb g, [mascara_g]
    pshufb b, [mascara_b]

    ; defino el registro rgbsum donde voy a guardar la suma de r+g+b
    %define  rgbsum r
    ; sumo sobre rgbsum
    ; rgbsum=[(r+g+b)4,(r+g+b)3,(r+g+b)2,(r+g+b)1]
    paddd    rgbsum, g
    paddd    rgbsum, b

    ; convierto a float
    cvtdq2ps rgbsum, rgbsum
    %define t rgbsum
    ; divido empaquetado por 3
    divps t, [packedsingle3]
    ; convierto a int con truncamiento
    cvttps2dq t, t


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    %define lw32 xmm1
    movdqa lw32, t
    pcmpgtd lw32, [p31d]
    pxor lw32, [minusone]

    %define gte32lw96 xmm2
    movdqa gte32lw96, t
    pcmpgtd gte32lw96, [p95d] ; x>95
    por gte32lw96, lw32; x>95 v x<32
    pxor gte32lw96, [minusone]; 32<=x<96

    %define gte96lw160 xmm3
    movdqa gte96lw160, t
    pcmpgtd gte96lw160, [p159d]; x>159
    por gte96lw160, gte32lw96;  {x>159} U {32<=x<96}
    por gte96lw160, lw32; {x>159} U {32<=x<96} U {x<32} = {x>159} U {x<96}
    pxor gte96lw160, [minusone];

    %define gte160lw224 xmm4
    movdqa gte160lw224, t
    pcmpgtd gte160lw224, [p223d]
    por gte160lw224, gte96lw160
    por gte160lw224, gte32lw96
    por gte160lw224, lw32
    pxor gte160lw224, [minusone]

    %define otherwise xmm5
    movdqa otherwise, gte160lw224
    por otherwise, gte96lw160
    por otherwise, gte32lw96
    por otherwise, lw32
    pxor otherwise, [minusone]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    %define lw32_t_plus xmm6
    movdqa lw32_t_plus, t
    pslld lw32_t_plus, 2
    pand lw32_t_plus, lw32
    pshufb lw32_t_plus, [mask_dword_to_byte]
    pand lw32_t_plus, [mask_t_32_plus]
    ;
    pand lw32, [mask_32]
    ; sumo
    paddb lw32, lw32_t_plus

    %define gte32lw96_t_plus xmm7
    movdqa gte32lw96_t_plus, t
    psubd gte32lw96_t_plus, [p32d]
    pslld gte32lw96_t_plus, 2
    pand gte32lw96_t_plus, gte32lw96
    pshufb gte32lw96_t_plus, [mask_dword_to_byte]
    pand gte32lw96_t_plus, [mask_t_96_plus]
    ;
    pand gte32lw96, [mask_96]
    ;
    paddb gte32lw96, gte32lw96_t_plus

    %define gte96lw160_t_plus xmm8
    movdqa gte96lw160_t_plus, t
    psubd gte96lw160_t_plus, [p96d]
    pslld gte96lw160_t_plus, 2
    pand gte96lw160_t_plus, gte96lw160
    pshufb gte96lw160_t_plus, [mask_dword_to_byte]
    pand gte96lw160_t_plus, [mask_t_160_plus]
    %define gte96lw160_t_minus xmm9
    movdqa gte96lw160_t_minus, t
    psubd gte96lw160_t_minus, [p96d]
    pslld gte96lw160_t_minus, 2
    pand gte96lw160_t_minus, gte96lw160
    pshufb gte96lw160_t_minus, [mask_dword_to_byte]
    movdqu xmm15, [mask_t_160_minus]
    pand gte96lw160_t_minus, [mask_t_160_minus]
    ;
    pand gte96lw160, [mask_160]
    ;
    paddb gte96lw160, gte96lw160_t_plus
    psubb gte96lw160, gte96lw160_t_minus

    %define gte160lw224_t_minus xmm10
    movdqa gte160lw224_t_minus, t
    psubd gte160lw224_t_minus, [p160d]
    pslld gte160lw224_t_minus, 2
    pand gte160lw224_t_minus, gte160lw224
    pshufb gte160lw224_t_minus, [mask_dword_to_byte]
    pand gte160lw224_t_minus, [mask_t_224_minus]
    ;
    pand gte160lw224, [mask_224]
    ;
    psubb gte160lw224, gte160lw224_t_minus

    %define otherwise_t_minus xmm11
    movdqa otherwise_t_minus, t
    psubd otherwise_t_minus, [p224d]
    pslld otherwise_t_minus, 2
    pand otherwise_t_minus, otherwise
    pshufb otherwise_t_minus, [mask_dword_to_byte]
    pand otherwise_t_minus, [mask_t_otherwise_minus]
    ;
    pand otherwise, [mask_otherwise]
    ;
    psubb otherwise, otherwise_t_minus



    %define result_d otherwise
    por result_d, gte160lw224
    por result_d, gte96lw160
    por result_d, gte32lw96
    por result_d, lw32

    ; ahora reacomodo el resultado porque lo tengo en dwords
    %define result result_d
    pshufb  result, [result_mask]
    
    pextrb [b_dst+x+10], result, 6
    pextrb [b_dst+x+11], result, 7
    pextrb [b_dst+x+12], result, 8
    pextrb [b_dst+x+13], result, 9
    pextrb [b_dst+x+14], result, 10
    pextrb [b_dst+x+15], result, 11


    ;pshufb  result, [mask_shuf_last_dst]
    ;movdqu xmm15, [b_dst+x]
    ;pshufb xmm15, [mask_filter_last_dst]
    ;paddb result, xmm15
    ;movdqu [b_dst+x], result





  .fin_ciclo_columnas:
  xor x, x ; pongo x en 0
  add qword b_src, src_row_size; sumo al índice src una fila_src entera
  add qword b_dst, dst_row_size; sumo al índice dst una fila_dst entera
  inc y; incremento y en 1
  cmp y, filas
  jb .ciclo_filas



pop r15
pop r14
pop r13
pop r12

ret
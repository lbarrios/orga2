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


section .text

temperature_asm:

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
shl cols, 4; cols = 4*cols
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
    paddw    rgbsum, g
    paddw    rgbsum, b

    ; convierto a float
    cvtdq2ps rgbsum, rgbsum
    ; divido empaquetado por 3
    movdqa xmm1, [packedsingle3]
    divps rgbsum, xmm1
    ; convierto a int con truncamiento
    cvttps2dq rgbsum, rgbsum

  	%define result xmm0
    movdqu [b_dst+x], result
    add x,12; incremento x en 1
    cmp x, cols; comparo x con la cantidad de columnas
    jl .ciclo_columnas; si es menor o igual, sigo iterando
    je .fin_ciclo_columnas; si es igual no hago nada
    mov x, cols; si es mayor, le asigno x=cols-16 e itero una última vez
      sub x, 12;
      jmp .ciclo_columnas
  .fin_ciclo_columnas:
  xor x, x ; pongo x en 0
  add qword b_src, src_row_size; sumo al índice src una fila_src entera
  add qword b_dst, dst_row_size; sumo al índice dst una fila_dst entera
  inc y; incremento y en 1
  cmp y, filas
  jl .ciclo_filas


ret
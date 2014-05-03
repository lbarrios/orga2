
global ldr_asm

section .data
nada: DQ 0
mask_borrar_last_byte: DB 0xFF, 0xFF, 0xFF, 0xFF,
                       DB 0xFF, 0xFF, 0xFF, 0xFF,
                       DB 0xFF, 0xFF, 0xFF, 0xFF,
                       DB 0xFF, 0xFF, 0xFF, 0x00

todosUnos:             DW 0x01, 0x01, 0x01, 0x01,
                       DW 0x01, 0x01, 0x01, 0x01,

section .text
;void ldr_asm    (
	;unsigned char *src,
	;unsigned char *dst,
	;int cols,
	;int filas,
	;int src_row_size,
	;int dst_row_size)
        ;int alfa

ldr_asm:
    push rbp
    mov rbp, rsp
    
    ;extiendo parametros para que sean todos quadword
    mov edx, edx ;esto supuestamente limpia la parte alta
    mov ecx, ecx
    mov r8d, r8d
    mov r9d, r9d

    xor r10, r10
    mov r10, [rbp + 16]

    %define src rdi
    %define dst rsi
    %define cols rdx
    %define filas rcx
    %define src_row_size r8
    %define dst_row_size r9
    %define alfa r10
    %define src_it r11
    %define dst_it r12
       
    mov src_it, src
    mov dst_it, dst


    ;esto es provisiorio, me pongo en una posicion del medio para poder probar la funcion
    add src_it, 6
    add src_it, src_row_size 
    add src_it, src_row_size

.toma16:
    ;primero COMPARA si llegaste al final de la fila

    ;primero obtengo sumargb
    ;primero te fijas si no estas en los bordes
    
    ; obtengo la fila de arriba. en r13 me voy a guardar la direccion de memoria
    mov r13, src_it
    sub r13, 6
    sub r13, src_row_size
    sub r13, src_row_size

    movdqu xmm0, [r13] ;xmm0: b6 | r5 g5 b5 | ... | r1 g1 b1
    ;voy a poner el b6, que no lo tengo que contar, en 0
    movdqu xmm14, [mask_borrar_last_byte]
    pand xmm0, xmm14
    ;voy a extender
    pxor xmm15, xmm15
    movdqu xmm1, xmm0
    punpcklbw xmm1, xmm15 ;xmm1: g3 b3 | r2 g2 b2 | r1 g1 b1
    punpckhbw xmm0, xmm15 ;xmm0: 0 | r5 g5 b5 | r4 g4 b4 | r23


    ;agarro la segunda fila
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, xmm14
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
    
    ;acumulo suma
    paddw xmm1, xmm3
    paddw xmm0, xmm2


    ;agarro la tercer fila
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, xmm14
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
    
    ;acumulo suma
    paddw xmm1, xmm3
    paddw xmm0, xmm2

    ;agarro la cuarta fila
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, xmm14
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
    
    ;acumulo suma
    paddw xmm1, xmm3
    paddw xmm0, xmm2

    ;agarro la quinta fila
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, xmm14
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
    
    ;acumulo suma
    paddw xmm1, xmm3
    paddw xmm0, xmm2
    
    ;ahora tengo que sumar horizontalmente
    ;primero sumo xmm0 y xmm1
    paddusw xmm0, xmm1
    ;ahora la horizontal
    phaddw xmm0, xmm15
    phaddw xmm0, xmm15
    phaddw xmm0, xmm15


.fin:
    pop rbp
    ret

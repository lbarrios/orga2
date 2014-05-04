
global ldr_asm

section .data
nada: DQ 0
mask_borrar_last_byte: 
DB 0xFF, 0xFF, 0xFF, 0xFF,
DB 0xFF, 0xFF, 0xFF, 0xFF,
DB 0xFF, 0xFF, 0xFF, 0xFF,
DB 0xFF, 0xFF, 0xFF, 0x00

todosUnos:             DW 0x01, 0x01, 0x01, 0x01,
                       DW 0x01, 0x01, 0x01, 0x01

mask_solo_g_y_b_mem:
DB 0x06, 0x80, 0x80, 0x80,
DB 0x07, 0x80, 0x80, 0x80, 
DB 0x80, 0x80, 0x80, 0x80,
DB 0x80, 0x80, 0x80, 0x80

mask_solo_r_mem:
DB 0x08, 0x80, 0x80, 0x80,
DB 0x80, 0x80, 0x80, 0x80, 
DB 0x80, 0x80, 0x80, 0x80,
DB 0x80, 0x80, 0x80, 0x80

mask_r_g_y_b_mem:
DB 0x06, 0x80, 0x07, 0x80,
DB 0x08, 0x80, 0x80, 0x80, 
DB 0x80, 0x80, 0x80, 0x80,
DB 0x80, 0x80, 0x80, 0x80

max_enmemoria: DQ 4876875.0, 4876875.0

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
    %define alfa_registrocomun r10
    %define src_it r11
    %define dst_it r12
       
    mov src_it, src
    mov dst_it, dst

    ;voy a guardar el valor de max.
    movdqu xmm6, [max_enmemoria] ;queda xmm6: max | max
    %define max xmm6

    ;voy a guardar el valor de alfa como double dos veces
    movd xmm7, r10d
    pinsrd xmm7, r10d, 1 ;super instruccion!
    cvtdq2pd xmm7, xmm7
    %define alfa xmm7
    
    %define sumargb xmm8

    movdqu xmm9, [mask_solo_g_y_b_mem]
    movdqu xmm10, [mask_solo_r_mem]
    movdqu xmm11, [mask_r_g_y_b_mem]
    %define mask_solo_g_y_b xmm9
    %define mask_solo_r xmm10
    %define mask_r_g_y_b xmm11

    %define src_ij_gb xmm5
    %define src_ij_r xmm4
    

    ;esto es provisorio, me pongo en una posicion del medio para poder probar la funcion
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


    ;agarro la tercer fila ;aca especialmente me la tengo que guardar
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, xmm14
    movdqu xmm5, xmm2 ;despues la voy a tener que usar
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
.debug1:
    
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

    movdqu xmm8, xmm0
    movd eax, xmm8 ;aca uso fuertemente que xmm8 esta limpio excepto por la primer word
    pinsrd xmm8, eax, 1
    cvtdq2pd xmm8, xmm8 ;queda xmm8 = sumargb | sumargb

    ; ahora tengo max, alfa, sumargb en xmm6, xmm7, xmm8 repetido como double precision
.antesdelshuffle:
    ;en xmm5 tengo la fila que me interesa
    movdqa xmm4, xmm5 ;notar el aligned, esto se puede hacer con registros
    movdqa xmm3, xmm5
    pshufb xmm5, mask_solo_g_y_b
    pshufb xmm4, mask_solo_r
    pshufb xmm3, mask_r_g_y_b
    cvtdq2pd xmm5, xmm5 
    cvtdq2pd xmm4, xmm4 

    ;ahora procedo a hacer las mult y divisiones
    mulpd src_ij_gb, alfa
    mulpd src_ij_r, alfa
    mulpd src_ij_gb, sumargb
    mulpd src_ij_r, sumargb
    divpd src_ij_gb, max
    divpd src_ij_r, max
    
    ;trunco pasando a signed int
    cvttpd2dq src_ij_gb, src_ij_gb 
    cvttpd2dq src_ij_r, src_ij_r 

    ;ahora tengo que hacer varias cosas mas.
    ;voy a mover var r al al lado de los otros
    movd eax, src_ij_r
    pinsrd src_ij_gb, eax, 2

    ;paso de signed int a signed double
    packssdw src_ij_gb, src_ij_gb

    ;sumo con el original
    paddw src_ij_gb, xmm3
    
    ;ahora debo volver a byte, saturando
    packuswb src_ij_gb, src_ij_gb

    ;escribo a memoria, escribo un byte de mas al pedo
    movd [dst_it], src_ij_gb


.fin:
    pop rbp
    ret

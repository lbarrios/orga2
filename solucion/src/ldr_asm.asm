
;podes asumir que tiene por lo menos 5 pixeles de alto, dijo David

global ldr_asm

section .data
nada: DQ 0
mask_borrar_last_byte: 
DB 0xFF, 0xFF, 0xFF, 0xFF,
DB 0xFF, 0xFF, 0xFF, 0xFF,
DB 0xFF, 0xFF, 0xFF, 0xFF,
DB 0xFF, 0xFF, 0xFF, 0x00

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

mask_final:
DB 0x01, 0x02, 0x03, 0x04,
DB 0x05, 0x06, 0x07, 0x08, 
DB 0x09, 0x0A, 0x0B, 0x0C,
DB 0x0D, 0x0E, 0x0F, 0x80

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
    
    push rbx
    push r12
    push r13
    push r14
    push r15

    ;extiendo parametros para que sean todos quadword
    mov edx, edx ;esto supuestamente limpia la parte alta
    mov ecx, ecx
    mov r8d, r8d
    mov r9d, r9d

    xor r10, r10
    mov r10, [rbp + 16]

    ;src viene en rdi
    ;dst viene en rsi
    ;cols viene en rdx
    ;filas viene en rcx
    %define src_row_size r8
    %define dst_row_size r9
    ;alfa_registrocomun viene en r10
    %define src_it r11
    %define dst_it r12
    %define col_byte r14
    %define ancho_total_byte r10

       
    mov src_it, rdi
    mov dst_it, rsi

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
    movdqu xmm12, [mask_final]
    movdqu xmm13, [mask_borrar_last_byte]
    %define mask_solo_g_y_b xmm9
    %define mask_solo_r xmm10
    %define mask_r_g_y_b xmm11
    %define mask_final xmm12
    %define mask_borrar_last_byte xmm13

    %define src_ij_gb xmm5
    %define src_ij_r xmm4
    

    ;esto es provisorio, me pongo en una posicion del medio para poder probar la funcion
    ;add src_it, 6
    ;add src_it, src_row_size 
    ;add src_it, src_row_size

    xor col_byte, col_byte
    
    lea r10, [rdx * 3]
    
    %define estoyAlFinal rsi
    mov rsi, rdi ;src
    sub rcx, 1 ;pensa, tenes que avanzar 'filas - 1' filas
    mov rax, rcx
    mul src_row_size
    add rsi, rax ; esperemos que haya funcionado el mul
    ;esto rompe rdx
    add rsi, ancho_total_byte
    sub rsi, 15


    %define yaEstoyEnBorde rdi
    mov yaEstoyEnBorde, ancho_total_byte
    sub yaEstoyEnBorde, 6
    

.copio16:
    lea r15, [col_byte + 16]
    cmp r15, ancho_total_byte
    ja .conRetrocesoPrimeraFila
    movdqu xmm0, [src_it]
    movdqu [dst_it], xmm0
    add col_byte, 16
    add src_it, 16
    add dst_it, 16
    jmp .copio16

.conRetrocesoPrimeraFila:
    cmp col_byte, ancho_total_byte
    je .segundaFila
    ;sea rax lo que tengo que retroceder
    mov rax, col_byte
    add rax, 16
    sub rax, ancho_total_byte
    sub col_byte, rax
    sub src_it, rax
    sub dst_it, rax
    jmp .copio16

.segundaFila:
    ;me posiciono bien
    xor col_byte, col_byte
    sub src_it, ancho_total_byte
    add src_it, src_row_size
    sub dst_it, ancho_total_byte
    add dst_it, dst_row_size

.copio16segundaFila:
    lea r15, [col_byte + 16]
    cmp r15, ancho_total_byte
    ja .conRetrocesoSegundaFila
    movdqu xmm0, [src_it]
    movdqu [dst_it], xmm0
    add col_byte, 16
    add src_it, 16
    add dst_it, 16
    jmp .copio16segundaFila

;esperemos que tenga por lo menos 3 filas, jaja

.conRetrocesoSegundaFila:
    cmp col_byte, ancho_total_byte
    je .terceraFila
    ;sea rax lo que tengo que retroceder
    mov rax, col_byte
    add rax, 16
    sub rax, ancho_total_byte
    sub col_byte, rax
    sub src_it, rax
    sub dst_it, rax
    jmp .copio16segundaFila

.terceraFila:
    ;me posiciono bien
    xor col_byte, col_byte
    sub src_it, ancho_total_byte
    add src_it, src_row_size
    sub dst_it, ancho_total_byte
    add dst_it, dst_row_size

    ;agarro los dos primeros pixeles de borde
    movq xmm0, [src_it]
    movq [dst_it], xmm0
    add col_byte, 6
    add src_it, 6
    add dst_it, 6

.procesaPixel:
    ;primero COMPARA si llegaste al final de la fila
    cmp col_byte, yaEstoyEnBorde
    je .copiaDosBordes

    ;primero obtengo sumargb
    ;primero te fijas si no estas en los bordes
    
    ; obtengo la fila de arriba. en r13 me voy a guardar la direccion de memoria
    mov r13, src_it
    sub r13, 6
    sub r13, src_row_size
    sub r13, src_row_size

    movdqu xmm0, [r13] ;xmm0: b6 | r5 g5 b5 | ... | r1 g1 b1
    ;voy a poner el b6, que no lo tengo que contar, en 0
    pand xmm0, mask_borrar_last_byte
    ;voy a extender
    pxor xmm15, xmm15
    movdqu xmm1, xmm0
    punpcklbw xmm1, xmm15 ;xmm1: g3 b3 | r2 g2 b2 | r1 g1 b1
    punpckhbw xmm0, xmm15 ;xmm0: 0 | r5 g5 b5 | r4 g4 b4 | r23


    ;agarro la segunda fila
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, mask_borrar_last_byte
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
    
    ;acumulo suma
    paddw xmm1, xmm3
    paddw xmm0, xmm2


    ;agarro la tercer fila ;aca especialmente me la tengo que guardar
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, mask_borrar_last_byte
    movdqu xmm5, xmm2 ;despues la voy a tener que usar
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
    
    ;acumulo suma
    paddw xmm1, xmm3
    paddw xmm0, xmm2

    ;agarro la cuarta fila
    add r13, src_row_size
    movdqu xmm2, [r13]
    pand xmm2, mask_borrar_last_byte
    movdqu xmm3, xmm2
    punpcklbw xmm3, xmm15
    punpckhbw xmm2, xmm15
    
    ;acumulo suma
    paddw xmm1, xmm3
    paddw xmm0, xmm2

    ;agarro la quinta fila
    add r13, src_row_size
    ;imortante, me fijo si es la ultima fila de la matriz
    cmp r13, estoyAlFinal
    je .esElUltimoPixelAProcesar
    movdqu xmm2, [r13]
    pand xmm2, mask_borrar_last_byte
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

    ;no te olvides de actualizar iteradores
    add col_byte, 3
    add src_it, 3
    add dst_it, 3
    jmp .procesaPixel

.copiaDosBordes:
    ;aca estoy leyendo y escribiendo sobre el padding/siguiente fila
    movq xmm0, [src_it]
    movq [dst_it], xmm0
    ;paso a la siguiente fila
    xor col_byte, col_byte
    add src_it, 6
    sub src_it, ancho_total_byte
    add src_it, src_row_size
    add dst_it, 6
    sub dst_it, ancho_total_byte
    add dst_it, dst_row_size
    ;copio 2 pixeles de borde izquierdo
    movq xmm0, [src_it]
    movq [dst_it], xmm0
    add col_byte, 6
    add src_it, 6
    add dst_it, 6
    jmp .procesaPixel

.esElUltimoPixelAProcesar:
    ; me corro uno a la izquierda
    sub r13, 1
    movdqu xmm2, [r13]
    ; tengo que shiftear una posicion
    pshufb xmm2, mask_final

    pand xmm2, mask_borrar_last_byte ;no hace falta ;)
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

    add col_byte, 3
    add src_it, 3
    add dst_it, 3
    

    ;ahora paso a copiar dos filas
    
    ;primero los dos pixels de borde

    movq xmm0, [src_it]
    movq [dst_it], xmm0
    xor col_byte, col_byte
    add src_it, 6
    sub src_it, ancho_total_byte
    add src_it, src_row_size
    add dst_it, 6
    sub dst_it, ancho_total_byte
    add dst_it, dst_row_size

    ;ahora debo copiar dos filas

.copio16_final:
    lea r15, [col_byte + 16]
    cmp r15, ancho_total_byte
    ja .conRetrocesoPrimeraFila_final
    movdqu xmm0, [src_it]
    movdqu [dst_it], xmm0
    add col_byte, 16
    add src_it, 16
    add dst_it, 16
    jmp .copio16_final

.conRetrocesoPrimeraFila_final:
    cmp col_byte, ancho_total_byte
    je .segundaFila_final
    ;sea rax lo que tengo que retroceder
    mov rax, col_byte
    add rax, 16
    sub rax, ancho_total_byte
    sub col_byte, rax
    sub src_it, rax
    sub dst_it, rax
    jmp .copio16_final

.segundaFila_final:
    ;me posiciono bien
    xor col_byte, col_byte
    sub src_it, ancho_total_byte
    add src_it, src_row_size
    sub dst_it, ancho_total_byte
    add dst_it, dst_row_size

.copio16segundaFila_final:
    lea r15, [col_byte + 16]
    cmp r15, ancho_total_byte
    ja .conRetrocesoSegundaFila_final
    movdqu xmm0, [src_it]
    movdqu [dst_it], xmm0
    add col_byte, 16
    add src_it, 16
    add dst_it, 16
    jmp .copio16segundaFila_final

;esperemos que tenga por lo menos 3 filas, jaja

.conRetrocesoSegundaFila_final:
    cmp col_byte, ancho_total_byte
    je .fin
    ;sea rax lo que tengo que retroceder
    mov rax, col_byte
    add rax, 16
    sub rax, ancho_total_byte
    sub col_byte, rax
    sub src_it, rax
    sub dst_it, rax
    jmp .copio16segundaFila_final

.fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    pop rbp
    ret

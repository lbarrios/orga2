global tiles_asm

section .data

src: DQ 0
dst: DQ 0
filas: DD 0
cols: DD 0
src_row_size: DD 0
dst_row_size: DD 0
tamx: DD 0
tamy: DD 0
offsetx: DD 0
offsety: DD 0
ancho: DD 0
ancho_tile: DD 0
tile: DQ 0

section .text

tiles_asm:
    ;armo stack frame
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13
    push r14
    push r15

    ;tomo parametros
    mov [src], rdi
    mov [dst], rsi
    mov [cols], edx
    mov [filas], ecx
    mov [src_row_size], r8d
    mov [dst_row_size], r9d
    mov eax, [rbp + 16]
    mov [tamx], eax
    mov eax, [rbp + 24]
    mov [tamy], eax
    mov eax, [rbp + 32]
    mov [offsetx], eax
    mov eax, [rbp + 40]
    mov [offsety], eax
    
    ;armo mis variables
    %define f_d r8
    %define c_d r9
    %define f_t r10 
    %define c_t r11
    ; r12 <- src_row_size
    ; r13 <- dst
    %define dst_it r14
    ; r15 <- tile
    %define ancho rdx
    %define ancho_tile rcx
    %define tile_it rsi

    xor r8, r8
    xor r9, r9
    xor r10, r10
    xor r11, r11
    xor r12, r12
    mov r12d, [src_row_size]
    mov r13, [dst]
    mov r14, r13
    
    mov r15, [src]
    xor rax, rax
    mov eax, [offsetx]
    lea rax, [rax * 3]
    add r15, rax
    xor rax, rax
    mov eax, [offsety]
    mul r12d
    ; resultado en edx:eax
    add r15, rax

    xor rdx, rdx
    mov edx, [cols]
    lea rdx, [rdx * 3]
    xor rcx, rcx
    mov ecx, [tamx]
    lea rcx, [rcx * 3]
    mov rsi, r15


.toma16: 
    lea rdi, [c_d + 16]
    cmp rdi, ancho
    ja .conRetroceso
    lea rdi, [c_t + 16]
    cmp rdi, ancho_tile
    ja .conRetrocesoTile
    movdqu xmm1, [tile_it]
    movdqu [dst_it], xmm1
    add c_d, 16
    add c_t, 16
    add tile_it, 16
    add dst_it, 16
    jmp .toma16


.conRetroceso:
    cmp c_d, ancho
    je .nuevaFila
    ;sea rdi lo que tengo que retroceder
    mov rdi, c_d
    add rdi, 16
    sub rdi, ancho
    sub c_d, rdi
    sub c_t, rdi
    sub tile_it, rdi
    sub dst_it, rdi
    jmp .toma16_copiando_una_vez


.toma16_copiando_una_vez:
    ;copio de la misma imagen destino
    mov rdi, dst_it
    sub rdi, ancho_tile
    push tile_it
    mov tile_it, rdi
    movdqu xmm1, [tile_it]
    movdqu [dst_it], xmm1
    pop tile_it
    add c_d, 16
    add c_t, 16
    add tile_it, 16
    add dst_it, 16
    jmp .nuevaFila 
     

.conRetrocesoTile:
    cmp c_t, ancho_tile
    je .nuevaFilaTile
    ;sea rdi lo que tengo que retroceder
    mov rdi, c_t
    add rdi, 16
    sub rdi, ancho_tile
    sub c_d, rdi
    sub c_t, rdi
    sub tile_it, rdi
    sub dst_it, rdi
    jmp .toma16


.nuevaFilaTile:
    xor c_t, c_t
    sub tile_it, ancho_tile
    jmp .toma16


.nuevaFila:
    inc f_d
    inc f_t
    xor rax, rax
    mov eax, [filas]
    cmp f_d, rax
    je .fin
    xor rax, rax
    mov eax, [tamy]
    cmp f_t, rax
    je .vamosArribaTile
    ; actualizo dst_it
    sub dst_it, ancho
    xor rax, rax
    mov eax, [dst_row_size]
    add dst_it, rax
    ; actualizo tile_it
    sub tile_it, c_t
    xor rax, rax
    mov eax, [src_row_size]
    add tile_it, rax
    xor c_d, c_d
    xor c_t, c_t
    jmp .toma16


.vamosArribaTile:
    xor f_t, f_t
    sub dst_it, ancho
    xor rax, rax
    mov eax, [dst_row_size]
    add dst_it, rax
    mov tile_it, r15 ;en r15 tengo el puntero a la tile
    xor c_d, c_d
    xor c_t, c_t
    jmp .toma16


.fin:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx

    pop rbp
    ret

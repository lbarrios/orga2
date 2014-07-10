; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

ORG 0x00020000 ;; TASK_IDLE_CODE

BITS 32

%include "imprimir.mac"

idle:
     inc edi
     imprimir_debug idle_msg, idle_len, 0x07, 2, 0
     .loopear:
        inc dword [numero]
        cmp dword [numero], 0x4
        jb .imprimir

    .reset_contador:
        mov dword [numero], 0x0

    .imprimir:
        ; Imprimir 'reloj'
        mov ebx, dword [numero]
        add ebx, message1
        imprimir_texto_mp ebx, 1, 0x0f, 49, 76
        mov ebx, chirimbolo_open
        imprimir_texto_mp ebx, 1, 0x0f, 49, 76-1
        mov ebx, chirimbolo_close
        imprimir_texto_mp ebx, 1, 0x0f, 49, 76+1

    jmp .loopear

numero:   dd 0x00000000

message1: db '|'
message2: db '/'
message3: db '-'
message4: db '\'

chirimbolo_open: db '('
chirimbolo_close: db ')'

idle_msg: db 'Entrando en tarea idle...',0
idle_len: equ $ - idle_msg

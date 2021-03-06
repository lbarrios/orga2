; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "imprimir.mac"
extern flag_pause
extern flag_idle
extern indice_actual
extern print_screen
extern matar_tarea_actual
extern anota_causa_de_muerte

%define SIZEOF_INT 4

BITS 32

sched_tarea_offset:     dd 0x00
sched_tarea_selector:   dw 0x00

;; macro para poner los mensajes de las excepciones :)
%macro exc_msg 2
exc_msg_ %+ %1 DB %2
exc_msg_len_%1 equ $ - exc_msg_ %+ %1
%endmacro

; valor de retorno de syscall_mover
retorno_mover_final: DD 0

;; mensajes de las excepciones del procesador
exc_msg 0, "Divide Error - Fault (#DE)"
exc_msg 1, "Debug - Fault / Trap (#DB)"
exc_msg 2, "NMI Interrupt - Interrupt (--)"
exc_msg 3, "Breakpoint - Trap (#BP)"
exc_msg 4, "Overflow - Trap (#OF)"
exc_msg 5, "Bound Range Exceeded - Fault (#BR)"
exc_msg 6, "Invalid Opcode / UnDefined - Fault (#UD)"
exc_msg 7, "Device Not Available - Fault (#NM)"
exc_msg 8, "Double Fault - Abort (#DF)"
exc_msg 9, "Coprocessor Segment Overrun - Fault (--)"
exc_msg 10, "Invalid TSS - Fault (#TS)"
exc_msg 11, "Segment Not Present - Fault (#NP)"
exc_msg 12, "Stack-Segment Fault - Fault (#SS)"
exc_msg 13, "General Protection Fault - Fault (#GP)"
exc_msg 14, "Page Fault - Fault (#PF)"
exc_msg 15, "Reserved (--)"
exc_msg 16, "x87 Floating-Point Exception - Fault (#MF)"
exc_msg 17, "Alignment Check - Fault (#AC)"
exc_msg 18, "Machine Check - Abort (#MC)"
exc_msg 19, "SIMD Floating-Point Exception - Fault (#XM/#XF)"
exc_msg 20, "Virtualization Exception - Fault (#VE)"
exc_msg 21, "RESERVED (--)"
exc_msg 22, "RESERVED (--)"
exc_msg 23, "RESERVED (--)"
exc_msg 24, "RESERVED (--)"
exc_msg 25, "RESERVED (--)"
exc_msg 26, "RESERVED (--)"
exc_msg 27, "RESERVED (--)"
exc_msg 28, "RESERVED (--)"
exc_msg 29, "RESERVED (--)"
exc_msg 30, "Security Exception (#SX)"
exc_msg 31, "RESERVED (--)"

causa_mina_msg db 'Muerte por Mina'
causa_mina_len equ $ - causa_mina_msg

viva_todavia_msg db 'Vivita y Coleando'
viva_todavia_len equ $ - viva_todavia_msg

;; PIC
extern fin_intr_pic1

;; Sched
extern sched_proximo_indice
;; Game
extern game_mover
extern game_misil
extern game_minar

;; SCREEN
extern print_tank_context

;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

%macro if_causa_de_muerte 1
    cmp eax, %1
    je .imprimi_%1
    jmp .next%1
.imprimi_%1:
    imprimir_texto_mp exc_msg_%1, exc_msg_len_%1, 0x4f, 40, 52
    jmp .fin
.next%1:
%endmacro

global print_causa_de_muerte

print_causa_de_muerte:
    mov eax, [esp + 4] ; aca recibo el numero de causa de muerte
    if_causa_de_muerte 0
    if_causa_de_muerte 1
    if_causa_de_muerte 2
    if_causa_de_muerte 3
    if_causa_de_muerte 4
    if_causa_de_muerte 5
    if_causa_de_muerte 6
    if_causa_de_muerte 7
    if_causa_de_muerte 8
    if_causa_de_muerte 9
    if_causa_de_muerte 10
    if_causa_de_muerte 11
    if_causa_de_muerte 12
    if_causa_de_muerte 13
    if_causa_de_muerte 14
    if_causa_de_muerte 15
    if_causa_de_muerte 16
    if_causa_de_muerte 17
    if_causa_de_muerte 18
    if_causa_de_muerte 19
    if_causa_de_muerte 20
    if_causa_de_muerte 21
    if_causa_de_muerte 22
    if_causa_de_muerte 23
    if_causa_de_muerte 24
    if_causa_de_muerte 25
    if_causa_de_muerte 26
    if_causa_de_muerte 27
    if_causa_de_muerte 28
    if_causa_de_muerte 29
    if_causa_de_muerte 30
    if_causa_de_muerte 31

    cmp eax, 100
    je .porMina
    jmp .vivaTodavia
.porMina:
    imprimir_texto_mp causa_mina_msg, causa_mina_len, 0x4f, 40, 52
    jmp .fin
.vivaTodavia:
    imprimir_texto_mp viva_todavia_msg, viva_todavia_len, 0x4f, 40, 52
.fin:
    ret

%macro ISR 1
global _isr%1

_isr%1:
    cli
    pushad
    imprimir_debug exc_msg_%1, exc_msg_len_%1, 0x07, 0, 0
    call matar_tarea_actual
    mov eax, %1
    push eax
    call anota_causa_de_muerte
    pop eax
    mov byte [flag_idle], 0x1

    call sched_proximo_indice
    cmp ax, 1
    je .jmp_tss_1
    
    jmp 0x80:0 ; Selector tss_next_2
    jmp .fin_final

    .jmp_tss_1:
    jmp 0x78:0 ; selector tss_next_1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.fin_final:
    ;;;;;;;;;;;;este codigo no se deberia ejecutar jamas;;;;;;;;;;
    popad
    iret
%endmacro

;;
;; Datos
;; -------------------------------------------------------------------------- ;;
; Scheduler
isrnumero:           dd 0x00000000
isrClock:            db '|/-\'

;;
;; Rutina de atención de las EXCEPCIONES
;; -------------------------------------------------------------------------- ;;

ISR 0
ISR 1
ISR 2
ISR 3
ISR 4
ISR 5
ISR 6
ISR 7
ISR 8
ISR 9
ISR 10
ISR 11
ISR 12
ISR 13
ISR 14
ISR 15
ISR 16
ISR 17
ISR 18
ISR 19
ISR 20
ISR 21
ISR 22
ISR 23
ISR 24
ISR 25
ISR 26
ISR 27
ISR 28
ISR 29
ISR 30
ISR 31

;;
;; Rutina de atención del RELOJ
;; -------------------------------------------------------------------------- ;;
clock_msg DB  "TIC DE CLOCK"
clock_len EQU $ - clock_msg
global _isr32
_isr32:
    cli
    pushad
    call print_screen
    ; El macro de abajo es un poco molesto, activar solo en caso de ser necesario
    ;imprimir_debug clock_msg, clock_len, 0, 0, 0
    call proximo_reloj
    call fin_intr_pic1
    call sched_proximo_indice

    cmp ax, 1
    je .jmp_tss_1
    cmp ax, 2
    je .jmp_tss_2
    jmp .fin

    .jmp_tss_2:
    jmp 0x80:0 ; Selector tss_next_2
    jmp .fin

    .jmp_tss_1:
    jmp 0x78:0 ; selector tss_next_1

    .fin:
    popad
    iret

;;
;; Rutina de atención del TECLADO
;; -------------------------------------------------------------------------- ;;

;;
;; Defines para rutina de atención del teclado
;;
%define BREAK_1 0x02
%define BREAK_2 0x03
%define BREAK_3 0x04
%define BREAK_4 0x05
%define BREAK_5 0x06
%define BREAK_6 0x07
%define BREAK_7 0x08
%define BREAK_8 0x09
%define BREAK_P 0x19


teclado_msg DB  "Se presiono la tecla: 0"
teclado_len EQU $ - teclado_msg

pause_msg DB  "La pausa está en: 0"
pause_len EQU $ - pause_msg


global _isr33
_isr33:
    cli
    pushad
    call fin_intr_pic1
    in al, 0x60 ; leo scan code
    cmp al, BREAK_1
    je .key_1
    cmp al, BREAK_2
    je .key_2
    cmp al, BREAK_3
    je .key_3
    cmp al, BREAK_4
    je .key_4
    cmp al, BREAK_5
    je .key_5
    cmp al, BREAK_6
    je .key_6
    cmp al, BREAK_7
    je .key_7
    cmp al, BREAK_8
    je .key_8
    cmp al, BREAK_P
    je .key_P
    jmp .fin

    .key_1:
        mov BYTE [teclado_msg + teclado_len - 1], '1'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov eax, 1000
        mov edi, 1
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_2:
        mov BYTE [teclado_msg + teclado_len - 1], '2'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov edi, 2
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_3:
        mov BYTE [teclado_msg + teclado_len - 1], '3'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov edi, 3
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_4:
        mov BYTE [teclado_msg + teclado_len - 1], '4'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov edi, 4
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_5:
        mov BYTE [teclado_msg + teclado_len - 1], '5'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov edi, 5
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_6:
        mov BYTE [teclado_msg + teclado_len - 1], '6'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov edi, 6
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_7:
        mov BYTE [teclado_msg + teclado_len - 1], '7'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov edi, 7
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_8:
        mov BYTE [teclado_msg + teclado_len - 1], '8'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov edi, 8
        push edi
        call print_tank_context
        pop edi
        jmp .fin
    .key_P:
        mov BYTE [teclado_msg + teclado_len - 1], 'P'
        imprimir_debug teclado_msg, teclado_len, 0, 0, 0
        mov dl, [flag_pause]
        xor dl, 1
        mov [flag_pause], dl
        MOV BYTE [pause_msg + pause_len -1], '0'
        ADD BYTE [pause_msg + pause_len -1], dl
        imprimir_debug pause_msg, pause_len, 0, 0, 0
        jmp .fin

    .fin:
    popad
    sti
    iret

global _isr60
_isr60:
    cli
    pushad
    imprimir_debug eax, ebx, 0x07, 0, 0
    popad
    iret


;;
;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;
%define SYS_MOVER     0x83D
%define SYS_MISIL     0x911
%define SYS_MINAR     0x355
global _isr82
_isr82:
    cli
    pushad

    cmp eax, SYS_MOVER
    je .llamaMover
    cmp eax, SYS_MISIL
    je .llamaMisil
    cmp eax, SYS_MINAR
    je .llamaMinar
    jmp .fin_final ;;;;por las dudas;;;;;

.llamaMover:
    push ebx
    xor edx, edx
    mov dl, [indice_actual]
    push edx
    call game_mover
    
    ;;;;;;;;;;;;;;;;;;;; aca hay un valor de retorno, no te olvides ;;;;;;;;;;;;;;;;;;;;;;;;;;;

    pop edi

    ;mov [retorno_mover_array + edi * SIZEOF_INT], eax

    pop ebx
    push eax
    jmp .fin

.llamaMisil:
    push esi
    push edx
    push ecx
    push ebx
    xor eax, eax
    mov al, [indice_actual]
    push eax
    call game_misil
    pop eax
    pop ebx
    pop ecx
    pop edx
    pop esi
    push eax
    jmp .fin

.llamaMinar:
    push ebx
    xor eax, eax
    mov al, [indice_actual]
    push eax
    call game_minar
    pop eax
    pop ebx
    push eax
    jmp .fin

.fin:
    ;;;;;;;;;;;;;;;; saltar a la idle ;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov byte [flag_idle], 0x1

    call sched_proximo_indice
    cmp ax, 1
    je .jmp_tss_1
    
    jmp 0x80:0 ; Selector tss_next_2
    jmp .fin_final

    .jmp_tss_1:
    
    jmp 0x78:0 ; selector tss_next_1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.fin_final:
    ;xor edi, edi
    ;mov dl, [indice_actual]

    ;mov eax, [retorno_mover_array + edi*SIZEOF_INT]
    pop eax
    mov [retorno_mover_final], eax
    popad
    mov eax, [retorno_mover_final]
    iret


;; Funciones Auxiliares
;; -------------------------------------------------------------------------- ;;
proximo_reloj:
        pushad
        inc DWORD [isrnumero]
        mov ebx, [isrnumero]
        cmp ebx, 0x4
        jl .ok
                mov DWORD [isrnumero], 0x0
                mov ebx, 0
        .ok:
                add ebx, isrClock
                imprimir_texto_mp ebx, 1, 0x0f, 49, 79
                popad
        ret
        
        

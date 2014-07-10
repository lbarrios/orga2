; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "imprimir.mac"
extern flag_pause
extern flag_idle
extern indice_actual
extern print_map

BITS 32

sched_tarea_offset:     dd 0x00
sched_tarea_selector:   dw 0x00

;; macro para poner los mensajes de las excepciones :)
%macro exc_msg 2
exc_msg_ %+ %1 DB %2
exc_msg_len_%1 equ $ - exc_msg_ %+ %1
%endmacro

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

%macro ISR 1
global _isr%1

_isr%1:
  xchg bx, bx
  mov eax, %1
  imprimir_debug exc_msg_%1, exc_msg_len_%1, 0x07, 0, 0
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
    pushad
    call print_map
    imprimir_debug clock_msg, clock_len, 0, 0, 0
    call proximo_reloj
    call fin_intr_pic1
    call sched_proximo_indice
    cmp ax, 1
    je .jmp_tss_1
    
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
%define BREAK_1 0
%define BREAK_2 0
%define BREAK_3 0
%define BREAK_4 0
%define BREAK_5 0
%define BREAK_6 0
%define BREAK_7 0
%define BREAK_8 0
%define BREAK_P 0

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

    .key_1:
        mov edi, 1
        call print_tank_context
        jmp .fin
    .key_2:
        mov edi, 2
        call print_tank_context
        jmp .fin
    .key_3:
        mov edi, 3
        call print_tank_context
        jmp .fin
    .key_4:
        mov edi, 4
        call print_tank_context
        jmp .fin
    .key_5:
        mov edi, 5
        call print_tank_context
        jmp .fin
    .key_6:
        mov edi, 6
        call print_tank_context
        jmp .fin
    .key_7:
        mov edi, 7
        call print_tank_context
        jmp .fin
    .key_8:
        mov edi, 8
        call print_tank_context
        jmp .fin
    .key_P:
        mov dl, [flag_pause]
        xor dl, dl
        mov [flag_pause], dl
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
    je .fin ;;;;por las dudas;;;;;

.llamaMover:
    push ebx
    xor eax, eax
    mov al, [indice_actual]
    push eax
    call game_mover
    pop eax
    pop ebx
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
    jmp .fin

.llamaMinar:
    push ebx
    xor eax, eax
    mov al, [indice_actual]
    push eax
    call game_minar
    pop eax
    pop ebx
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
    popad
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
        
        

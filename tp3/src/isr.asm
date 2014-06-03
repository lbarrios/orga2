; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "imprimir.mac"

BITS 32

sched_tarea_offset:     dd 0x00
sched_tarea_selector:   dw 0x00

;; mensajes de las excepciones del procesador
exc_msg_0 DB "Divide Error (#DE)" ; notar que no ponen :
exc_msg_len_0 equ $ - exc_msg_0

exc_msg_1 DB "RESERVED (#DB)"
exc_msg_len_1 equ $ - exc_msg_1

exc_msg_2 DB "NMI Interrupt (--)"
exc_msg_len_2 equ $ - exc_msg_2

exc_msg_3 DB "Breakpoint (#BP)"
exc_msg_len_3 equ $ - exc_msg_3

;; PIC
extern fin_intr_pic1

;; Sched
extern sched_proximo_indice
;; Game
extern game_mover
extern game_misil
extern game_minar

;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

%macro ISR 1
global _isr%1

_isr%1:
    imprimir_texto_mp exc_msg_%1, exc_msg_len_%1, 0x07, %1, 0 ; aca imprime en la linea %1, es peligroso
    ; que mas hay que hacer?
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

;;
;; Rutina de atención del RELOJ
;; -------------------------------------------------------------------------- ;;

;;
;; Rutina de atención del TECLADO
;; -------------------------------------------------------------------------- ;;

;;
;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;
%define SYS_MOVER     0x83D
%define SYS_MISIL     0x911
%define SYS_MINAR     0x355



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
        
        

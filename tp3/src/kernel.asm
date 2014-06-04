; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "imprimir.mac"
extern GDT_DESC
extern IDT_DESC
extern idt_inicializar
extern mmu_inicializar_dir_kernel

global start


;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
iniciando_mr_msg db     'Iniciando kernel (Modo Real)...'
iniciando_mr_len equ    $ - iniciando_mr_msg

iniciando_mp_msg db     'Iniciando kernel (Modo Protegido)...'
iniciando_mp_len equ    $ - iniciando_mp_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida
    imprimir_texto_mr iniciando_mr_msg, iniciando_mr_len, 0x07, 0, 0

    ; Habilitar A20
    call habilitar_A20
    
    ; Cargar la GDT
    lgdt [GDT_DESC]
    

    ; Setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Saltar a modo protegido
    jmp 0x40:modo_protegido ; jmp far

BITS 32
modo_protegido:
    ; Establecer selectores de segmentos
    xor eax, eax
    mov ax, 1010000b
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov ss, ax

    mov ax, 1100000b
    mov fs, ax
    
    ; Establecer la base de la pila
    mov esp, 0x27000
    ; Imprimir mensaje de bienvenida
    imprimir_texto_mp iniciando_mp_msg, iniciando_mp_len, 0x07, 2, 0

    pintar_campo_verde

    ; Cargar interrupciones del procesador
    call idt_inicializar
    lidt [IDT_DESC]
    ;int 0
    ;int 1
    ;int 2
    ;int 3







    ; Inicializar pantalla
    
    ; Inicializar el manejador de memoria
    
    ; Inicializar el directorio de paginas
    call mmu_inicializar_dir_kernel
    
    ; Cargar directorio de paginas
    mov eax, 0x27000
    mov cr3, eax
    
    ; Habilitar paginacion
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    
    xchg bx, bx
    ; Inicializar tss
    
    ; Inicializar tss de la tarea Idle
    
    ; Inicializar tss de las tanques
    
    ; Inicializar el scheduler
    
    ; Inicializar la IDT
    
    ; Inicializar Game
    
    ; Cargar IDT
    
    ; Configurar controlador de interrupciones
    
    ; pintar posiciones inciales de tanques
    
    ; Cargar tarea inicial

    ; Habilitar interrupciones
 
    ; Saltar a la primera tarea: Idle

    ; Ciclar infinitamente (por si algo sale mal...)
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"

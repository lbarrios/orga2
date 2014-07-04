; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "imprimir.mac"
extern GDT_DESC
extern IDT_DESC
extern idt_inicializar
extern mmu_inicializar
extern mmu_inicializar_dir_kernel
extern tss_inicializar
extern tss_inicializar_idle
extern tss_inicializar_tanques
extern habilitar_pic
extern resetear_pic
extern deshabilitar_pic
extern print_map
extern screen_inicializar

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

paginacion_habilitada_msg db     'Paginacion Habilitada!!! :)'
paginacion_habilitada_len equ    $ - paginacion_habilitada_msg

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
    mov ds, ax ; data segment
    mov es, ax
    mov gs, ax
    mov ss, ax ;stack segment
    ; memoria de video
    mov ax, 1100000b
    mov fs, ax
    
    ; Establecer la base de la pila
    mov esp, 0x27000
    mov ebp, 0x27000

    ; Imprimir mensaje de bienvenida
    ;pintar_campo_verde ; reemplazar luego por un inicializador "de verdad"

    imprimir_texto_mp iniciando_mp_msg, iniciando_mp_len, 0x07, 2, 0

    ; Cargar interrupciones del procesador
    ; Inicializar la IDT
    call idt_inicializar
    lidt [IDT_DESC]

    ; Inicializar pantalla
    call screen_inicializar

    ; Inicializar el directorio de paginas
    call mmu_inicializar_dir_kernel
    
    ; Cargar directorio de paginas
    mov eax, 0x27000
    mov cr3, eax

    ; Habilitar paginacion
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    ; Imprimo un mensaje de paginación habilitada.
    imprimir_texto_mp paginacion_habilitada_msg, paginacion_habilitada_len, 0x07, 2, 0

    ; Inicializar el manejador de memoria
    call mmu_inicializar



    ; Habilito paginación con el directorio de la 1er tarea
    ;mov eax, 0x100000
    ;mov cr3, eax

    ; Imprimo un color en el primer pixel de la pantalla
    ;mov ax, 0xD040
    ;mov word [fs:0], ax


    ; Inicializar tss
    call tss_inicializar

    ; Inicializar tss de la tarea Idle
    call tss_inicializar_idle ; aca falla con Page Fault
    
    ; Inicializar tss de las tanques
    call tss_inicializar_tanques

    ; Inicializar el scheduler

    ; Inicializar Game
    
    ; Cargar IDT
    
    ; Configurar controlador de interrupciones
    call deshabilitar_pic
    call resetear_pic
    call habilitar_pic    
    ; pintar posiciones inciales de tanques
    
    ; Cargar tarea inicial

    ;call print_map
    ;xchg bx, bx
    ; Habilitar interrupciones
    ;sti
    cli

    ;luego ya no
    ;xchg bx, bx
    ; Saltar a la primera tarea: Idle
    mov ax, 0x70; Cargo en ax el offset_gdt de la tarea init
    ltr ax; Pongo en el TR la tarea init
    jmp 0x80:0 ; jmp far a la tarea idle

    ; Ciclar infinitamente (por si algo sale mal...)
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF

    jmp $
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"

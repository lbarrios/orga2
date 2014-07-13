/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

    Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

/* Bool */
/* -------------------------------------------------------------------------- */
#define TRUE                    0x00000001
#define FALSE                   0x00000000
#define ERROR                   1


/* Misc */
/* -------------------------------------------------------------------------- */
#define CANT_TANQUES            8
#define PAGE_SIZE               0x00001000 /* 4Kbytes */
#define TASK_SIZE               2 * 4096
#define CAMPO_SIZE              50
#define IDENTITY_MAPPING_LAST_BYTE 0xDC3FFF
#define KERNEL_STACK_ADDR		0x27000


/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_IDX_NULL_DESC           0

/* Offsets en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_OFF_NULL_DESC           (GDT_IDX_NULL_DESC      << 3)

/* Segmentación */
/* -------------------------------------------------------------------------- */
#define GDT_KERNEL_CODE_SEGMENT_DESCRIPTOR (8<<3)
#define GDT_USER_CODE_SEGMENT_DESCRIPTOR (9<<3)
#define GDT_KERNEL_DATA_SEGMENT_DESCRIPTOR (10<<3)
#define GDT_USER_DATA_SEGMENT_DESCRIPTOR (11<<3)
#define GDT_VIDEO_SEGMENT_DESCRIPTOR (12<<3)

/* Paginacion */
/* -------------------------------------------------------------------------- */
#define KERNEL_PAGE_DIR_FIRST_ENTRY 0x27000
#define FIRST_PAGE_TABLE 0x28000
#define PAGE_DIR_ENTRY_SIZE 0x4 /* 4bytes */
#define PAGE_TABLE_ENTRY_SIZE 0x4 /* 4bytes */
#define PAGE_DIR_ENTRY_COUNT 1024
#define PAGE_TABLE_ENTRY_COUNT 1024

/* MMU */
/* -------------------------------------------------------------------------- */
#define MMU_ADDRESS 0x100000 // como se que está aca?


//CCASSERT - 強制編譯時斷言
#define CCASSERT(predicate) _x_CCASSERT_LINE(predicate, __LINE__)
#define _x_CCASSERT_LINE(predicate, line) typedef char constraint_violated_on_line_##line[2*((predicate)!=0)-1];
//典型的使用：
/* Use:
To assert in compilation time :)
Si la condición es falsa, entonces la compilación falla

Ejemplo:
	CCASSERT(sizeof(_someVariable)==4)
*/

static inline int time()
{
    int ret;
    asm volatile ( "rdtsc" : "=A"(ret) );
    return ret;
}

static inline float frand( int *seed )
{
    union
    {
        float fres;
        unsigned int ires;
    } r;

    seed[0] *= 16807;

    r.ires = ((((unsigned int)seed[0])>>9 ) | 0x3f800000);
    return r.fres - 1.0f;
}

#define OUTPUTDEBUG

#ifdef OUTPUTDEBUG

int bochsdebugi;
char* bochsdebug;
unsigned long bochsdebugpointer;
char bochsdebugpointerchar[430];
#define BOCHSDEBUG(string) for(bochsdebugi=0;bochsdebugi<sizeof(string);bochsdebugi++) { bochsdebug = (char*)&(string); oute9( bochsdebug[bochsdebugi] ); }
#define BDT(string) for(bdi=0;bdi<sizeof(string);bdi++) { bdp = (char*)&(string); oute9( bdp[bdi] ); }
#define BD(s) BOCHSDEBUG(s)
#define BDENTER() oute9(10);
#define BDPOINTER(var) bochsdebugpointer = (long)(void*)(long)var;bochsdebugpointerchar[0]='0';bochsdebugpointerchar[1]='x';bochsdebugpointerchar[2]=(char)((bochsdebugpointer)>>28)+'0';bochsdebugpointerchar[3]=(char)((bochsdebugpointer<<4) >>28)+'0';bochsdebugpointerchar[4]=(char)((bochsdebugpointer<<  8) >>28)+'0';bochsdebugpointerchar[5]=(char)((bochsdebugpointer<< 12) >>28)+'0';bochsdebugpointerchar[6]=(char)((bochsdebugpointer<< 16) >>28)+'0';bochsdebugpointerchar[7]=(char)((bochsdebugpointer<< 20) >>28)+'0';bochsdebugpointerchar[8]=(char)((bochsdebugpointer<< 24) >>28)+'0';bochsdebugpointerchar[9]=(char)((bochsdebugpointer<< 28) >>28)+'0';for(bochsdebugi=2;bochsdebugi<10;bochsdebugi++){ if(bochsdebugpointerchar[bochsdebugi]>'9'){ bochsdebugpointerchar[bochsdebugi]=bochsdebugpointerchar[bochsdebugi]-'9'+('A'-1); } } BD(bochsdebugpointerchar)
#define BDP(var) BDPOINTER(var)
#define VAR(var) BD(" ")BD(#var)BD("=")BDP(var)BD(" ")
#define IMPRIMIR(s) syscall_debug(s, sizeof(s));
#define DEBUG(string)char TOKEN_CONCATENATE2(debug, __LINE__ ) [sizeof(string)] = string;IMPRIMIR( TOKEN_CONCATENATE2(debug, __LINE__ ) );

#else

#define BOCHSDEBUG(string)
#define BDT(string)
#define BD(s)
#define BDENTER() 
#define BDPOINTER(var)
#define BDP(var)
#define VAR(var)
#define IMPRIMIR(s)
#define DEBUG(string)

#endif

/*** MACROS PARA BLOQUEAR TAREAS ***/



/** --------------------------------------------- **/
/**
 * Comentar / Descomentar
 * la siguiente línea para
 * permitir o bloquear
 * TODAS las tareas
 */
/** --------------------------------------------- **/
// #define NO_CORREN_LAS_TAREAS
/** --------------------------------------------- **/



/** --------------------------------------------- **/
/**
 * Comentar / Descomentar
 * cada línea para
 * permitir o bloquear
 * individualmente
 */
/** --------------------------------------------- **/
//#define NOCORRE1 1
//#define NOCORRE2 1
//#define NOCORRE3 1
//#define NOCORRE4 1
//#define NOCORRE5 1
//#define NOCORRE6 1
//#define NOCORRE7 1
//#define NOCORRE8 1
/** --------------------------------------------- **/


/** --------------------------------------------- **/
/**
 * NO TOCAR LO SIGUIENTE
 */
#ifdef NO_CORREN_LAS_TAREAS
    #ifndef NOCORRE1
        #define NOCORRE1 1
    #endif
    #ifndef NOCORRE2
        #define NOCORRE2 1
    #endif
    #ifndef NOCORRE3
        #define NOCORRE3 1
    #endif
    #ifndef NOCORRE4
        #define NOCORRE4 1
    #endif
    #ifndef NOCORRE5
        #define NOCORRE5 1
    #endif
    #ifndef NOCORRE6
        #define NOCORRE6 1
    #endif
    #ifndef NOCORRE7
        #define NOCORRE7 1
    #endif
    #ifndef NOCORRE8
        #define NOCORRE8 1
    #endif
#endif
/** --------------------------------------------- **/

#define TOKEN_CONCATENATE(a,b) a ## b
#define TOKEN_CONCATENATE2(a,b) TOKEN_CONCATENATE(a, b)

#endif  /* !__DEFINES_H__ */


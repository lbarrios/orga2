
#ifndef __TP2__H__
#define __TP2__H__

#include <stdbool.h>

#define FILTRO_C   0
#define FILTRO_ASM 1

typedef struct rgb_t
{
  unsigned char b, g, r;
} __attribute__( ( packed ) ) rgb_t;

typedef struct rgb16_t
{
  unsigned short b, g, r;
} __attribute__( ( packed ) ) rgb16_t;

typedef struct rgb32_t
{
  unsigned int b, g, r;
} __attribute__( ( packed ) ) rgb32_t;


typedef struct buffer_info_t
{
  int width, height, width_with_padding;
  unsigned char* bytes;
  unsigned int tipo;
} buffer_info_t;


typedef struct configuracion_t
{
  char* nombre_filtro;
  int  tipo_filtro;
  buffer_info_t src, dst;
  void* extra_config;

  char* archivo_entrada;
  char  archivo_salida[255];
  char* carpeta_salida;
  bool es_video;
  bool verbose;
  bool frames;
  bool nombre;
  char archivo_tiempo[255];
  char* extra_archivo_salida;
  bool tiempo;
  int cant_iteraciones;
} configuracion_t;

#define SWITCH_C_ASM(config,c_ver,asm_ver) ( config->tipo_filtro == FILTRO_C ? c_ver : asm_ver )
#define C_ASM(config) ( SWITCH_C_ASM(config,"C","ASM") )

typedef void ( lector_params_fn_t ) ( configuracion_t* config, int, char* [] );
typedef void ( aplicador_fn_t ) ( configuracion_t* );
typedef void ( mostrador_ayuda_fn_t ) ( void );

typedef struct filtro_t
{
  char* nombre;
  lector_params_fn_t*   leer_params;
  mostrador_ayuda_fn_t* ayuda;
  aplicador_fn_t*       aplicador;
} filtro_t;

#define DECLARAR_FILTRO(nombre) lector_params_fn_t leer_params_##nombre; \
  mostrador_ayuda_fn_t ayuda_##nombre; \
  aplicador_fn_t aplicar_##nombre;

#define DEFINIR_FILTRO(nombre) {#nombre, leer_params_##nombre, ayuda_##nombre, aplicar_##nombre }

extern filtro_t filtros[];


void imprimir_tiempos_ejecucion( unsigned long long int start, unsigned long long int end, int cant_iteraciones );

void      procesar_opciones( int argc, char** argv, configuracion_t* config );
filtro_t* detectar_filtro( configuracion_t* config );


#endif   /* !__TP2__H__ */


#ifndef KERNEL_H_
#define KERNEL_H_


#include <commons/collections/dictionary.h>
#include <commons/collections/list.h>
#include <semaphore.h>
#include <stdlib.h>
#include <time.h>
#include <sys/types.h>

/*
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <commons/string.h>
*/

#include "../../utilguenguencha/src/tipos_guenguencha.h"
#include "../../utilguenguencha/src/comunicacion.h"
#include "../../utilguenguencha/src/parser.h"
#include "../../utilguenguencha/src/utils.h"


extern int READS, WRITES;
extern double WRITE_LAT, READ_LAT;
extern t_list* MEM_LOAD;

extern t_log * LOGGER_METRICS;

typedef struct{
	Instruccion* instruccion;
	Instruccion* instruccionAProcesar;
	int quantumProcesado;
	int numeroInstruccion;
	bool fin_proceso;
}Proceso;

typedef struct {
	int id_memoria;
	Instruction_set instruccion;
	t_timestamp tiempo;
}AcumMetrics;

typedef struct {
	int id_memoria;
	int cantidad_ins_sel;
	int cantidad_instrucciones;
}AcumuladorMemoria;

extern pthread_mutex_t mutexRecursosCompartidos;
extern sem_t semaforoSePuedePlanificar, semaforoNewToReady, semaforoFinalizar;

// Funciones del proceso
void configuracion_inicial(void);
void actualizar_configuracion(t_config* conf);
void retorno_consola(char* leido);
void iniciarEstados();
void leerArchivo(char * path);
void encolar(t_list * cola, Proceso * proceso);
Proceso* desencolar(t_list * cola);
Memoria * desencolarMemoria(t_list * lista, int posicion);
void putTablaSafe(t_dictionary * dic, char* key, char * value);
Memoria *get_memoria(int idMemoria, Consistencias consistencia);
char* getTablasSafe(t_dictionary * dic, char*key);
void ejecutar();
void iniciarEstructurasAsociadas();
Instruccion * dameSiguiente(char * path, int numeroInstruccion);
void lanzar_gossiping();
void newToReady();
void logicaCreate(Proceso * proceso);
void logicaRun(Proceso * proceso);
void logicaDescribe(Proceso * proceso);
void logicaJournal(Proceso * proceso);
void logicaDrop(Proceso * proceso);
void logicaSelect(Proceso * proceso);
void logicaAdd(Proceso * proceso);
void logicaInsert(Proceso * proceso);
void logicaMetrics(Proceso * proceso);
void calculoMetrics();
void inicializarValoresMetrics();
void loguear_metrics(t_log*);
void *TH_confMonitor(void * p);
Consistencias obtenerConsistencia(char * nombreTabla);
int generarHash(char * nombreTabla, int tamLista);
void mostrarId(Memoria * memoria);
void enviar_journal(Memoria *memoria);
bool existe_memoria_en(Memoria *mem1, t_list* lista);
void agregarSiNoExiste(t_list * list, Memoria *m);
t_list *dame_lista_de_consistencia(Consistencias consistencia);
pthread_mutex_t dame_mutex_de_consistencia(Consistencias consistencia);
void asignar_memoria_a_consistencia(Memoria * memoria, Consistencias consistencia);
void finalizar_procesos(void);
AcumuladorMemoria* dameAcumulador(int id_memoria, t_list* lista_acumuladores);
char* leer_linea(char* path, int linea);
void quitarSiExiste(t_list * list, Memoria *m);
int posicion_memoria_en(Memoria *mem1, t_list* lista);
void desasignar_bajas(t_list* lista_vieja);


// Variables del proceso
extern t_list *estadoReady;
extern t_list *estadoNew;
extern t_list *estadoExit;

// tablas del proceso
extern t_list *acum30sMetrics;
extern t_dictionary * metrics;

extern char * IP_MEMORIA_PPAL;
extern char* PUERTO_MEMORIA_PPAL;
extern int QUANTUM;
extern int MULTIPROCESAMIENTO;
extern uint32_t REFRESH_METADATA;
extern uint32_t RETARDO;
extern int TAMANO_MAXIMO_LECTURA_ARCHIVO;
extern int HILOS_KERNEL;
extern int SEGUNDOS_METRICS;
extern int PREGUNTAR_POR_MEMORIAS;
extern int TIEMPO_DESCRIBE;

extern t_list *lista_ec;
extern t_list *lista_sc;
extern t_list *lista_shc;
extern t_list *lista_disp;

extern pthread_mutex_t mutex_disp;
extern pthread_mutex_t mutex_sc;
extern pthread_mutex_t mutex_ec;
extern pthread_mutex_t mutex_shc;

extern pthread_mutex_t mutex_metrics;

/*
	Describes
*/
typedef struct {
	char * tablename;
	Consistencias consistencia;
}Table_Metadata;



extern t_list * lista_de_tablas;
extern pthread_mutex_t lista_de_tablas_mx;
void realizarDescribeGeneral(void);

#endif /* KERNEL_H_ */

// ----------- Arqo P4 -----------------------
// Programa que crea hilos utilizando OpenMP
//
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int tid,nthr,nproc;
	//int arg;
	nproc = omp_get_num_procs();
	printf("Hay %d cores disponibles\n", nproc);

	/*
	if (argc == 2)
     		arg = atoi( argv[1] );	
        else
        	arg = nproc;  
	nthr = omp_get_max_threads();
	*/

	printf("HILOS CON VARIABLE DE ENTORNO:\n");
	printf("Me han pedido que lance %d hilos\n", nproc);
	#pragma omp parallel private(tid)
	{
		tid = omp_get_thread_num();
		nthr = omp_get_num_threads();
		printf("Hola, soy el hilo %d de %d\n", tid, nthr);
	}
	printf("\n");

	printf("HILOS CON FUNCION SET:\n");
	nthr = 8;
	omp_set_num_threads(nthr);
	printf("Me han pedido que lance %d hilos\n", nthr);
	#pragma omp parallel private(tid)
	{
		tid = omp_get_thread_num();
		nthr = omp_get_num_threads();
		printf("Hola, soy el hilo %d de %d\n", tid, nthr);
	}
	printf("\n");

	printf("HILOS CON CLAUSULA EN REGION PARALELA:\n");
	nthr = 4;
	printf("Me han pedido que lance %d hilos\n", nthr);
	#pragma omp parallel private(tid) num_threads(nthr)
	{
		tid = omp_get_thread_num();
		nthr = omp_get_num_threads();
		printf("Hola, soy el hilo %d de %d\n", tid, nthr);
	}
	
	return 0;
}

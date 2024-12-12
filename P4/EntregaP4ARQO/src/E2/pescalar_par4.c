#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include "arqo4.h"

int main(int argc, char *argv[])
{
	tipo *A=NULL, *B=NULL;
	long long k=0;
	struct timeval fin,ini;
	double sum=0;

	int nproc;
	unsigned long long m;

	if (argc == 2 ||argc == 3)
	{
		m = strtoull(argv[1], NULL, 10);
		printf("Tamanio del vector = %llu\n", m);	
	}
	else
	{	
		m = M;
		printf("Tamanio por defecto = %llu\n", m);
	}

	A = generateVectorOne(m);
	B = generateVectorOne(m);
	if ( !A || !B )
	{
		printf("Error when allocationg matrix\n");
		freeVector(A);
		freeVector(B);
		return -1;
	}
	
	nproc=omp_get_num_procs();
	omp_set_num_threads(nproc);   

	if ( argc == 3) //Ejecucion paralela
	{
		printf("PARALELIZACION: Se han lanzado %d hilos.\n",nproc);
		gettimeofday(&ini,NULL);
		/* Bloque de computo */
		sum = 0;
		
			#pragma omp parallel for reduction (+ : sum)
		for(k=0;k<m;k++)
		{
			sum = sum + A[k]*B[k];
		}

		/* Fin del computo */
		gettimeofday(&fin,NULL);
	}
	else //Ejecucion no paralela
	{
		printf("EJECUCION EN SERIE\n");
		gettimeofday(&ini,NULL);
		/* Bloque de computo */
		sum = 0;
		
		for(k=0;k<m;k++)
		{
			sum = sum + A[k]*B[k];
		}

		/* Fin del computo */
		gettimeofday(&fin,NULL);
	}


	printf("Resultado: %f\n",sum);
	printf("Tiempo: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	freeVector(A);
	freeVector(B);

	return 0;
}

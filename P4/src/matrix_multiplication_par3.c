// P3 arq 2024-2025
// Suma elementos de una matríz por filas
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

#include "arqo3.h"

tipo compute(tipo **matrix,int n);
void multiply_matrix(tipo **m1,tipo **m2, tipo **m_res, int n);

int main( int argc, char *argv[])
{
	int n, i, j;
	char debug = 'n';
	tipo **m1=NULL, **m2=NULL, **m_res=NULL;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if( argc!=2)
	{
		if(argc !=3)
		{
			printf("Error! Use: ./%s <matrix size>\n", argv[0]);
			return -1;
		}
		debug = argv[2][0];
	}

	n=atoi(argv[1]);


	m1=generateMatrix(n);
	if( !m1 )
	{
		return -1;
	}

	m2=generateMatrix(n);
	if( !m2 )
	{
		freeMatrix(m1);
		return -1;
	}

	m_res = generateEmptyMatrix(n);
	if( !m_res )
	{
		freeMatrix(m1);
		freeMatrix(m2);
		return -1;
	}

	gettimeofday(&ini,NULL); 

	/* Main computation */
	multiply_matrix(m1,m2,m_res,n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);

	if(debug == 'd')
	{
		printf("Matriz resultante\n");
		for(i=0; i<n; i++)
		{
			for(j=0; j<n; j++)
			{
				printf("%lf		", m_res[i][j]);
			}
			printf("\n");
		}
	}

	freeMatrix(m1);
	freeMatrix(m2);
	freeMatrix(m_res);
	return 0;
}

void multiply_matrix(tipo **m1,tipo **m2, tipo **m_res, int n)
{
	int i, j, k;

	if(!m1 || !m2 || !m_res)
		return;

	#pragma omp parallel for private(j, k)
	for(i = 0; i < n; i++)
	{
		for(j = 0; j < n; j++)
		{
			for(k = 0; k < n; k++)
			{
				#pragma omp atomic
				m_res[i][j] += m1[i][k] * m2[k][j];
			}
		}
	}

	return;
}
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#include <immintrin.h>

#define ARRAY_SIZE 2048
#define NUMBER_OF_TRIALS 1000000

/*
 * Statically allocate our arrays.  Compilers can
 * align them correctly.
 */
static double a[ARRAY_SIZE], b[ARRAY_SIZE], c = 0;

int main(int argc, char *argv[]) {

    struct timeval* t_ini = NULL;
    struct timeval* t_final = NULL;
    int i, ii,t;
    //double m = 1.0001;
    double t_result_sec = 0;
    double t_result_usec = 0;
    double t_result = 0;

    __m256d mm = {1.0001, 1.0001, 1.0001, 1.0001};
    __m256d sum = {0.0, 0.0, 0.0, 0.0};
    __m256d va = {0.0, 0.0, 0.0, 0.0};
    __m256d vb = {0.0, 0.0, 0.0, 0.0}; 
    __m256d tmp = {0.0, 0.0, 0.0, 0.0};   
 
    __m256d vib = {-4.0, -3.0, -2.0, -1.0}; 
    __m256d via = {-3.0, -2.0, -1.0, 0.0}; 
    __m256d index = {4.0, 4.0, 4.0, 4.0}; 

    if (!(t_ini = (struct timeval*)malloc(sizeof (struct timeval)))) {
        printf("Error al crear estructuras de tiempo");
        return 1; 
    }

    if (!(t_final = (struct timeval*)malloc(sizeof (struct timeval)))) {
        free(t_ini);
        printf("Error al crear estructuras de tiempo");
        return 1; 
    }


    /* Populate A and B arrays */
    for (i=0; i < ARRAY_SIZE; i+= 4) {

        vib = _mm256_add_pd(vib, index);
        _mm256_store_pd(&b[i], vib);
        //b[i] = i;

        via = _mm256_add_pd(via, index);
        _mm256_store_pd(&a[i], via);
        //a[i] = i+1;
    }

    //Medida de rendimiento
    if (gettimeofday(t_ini, NULL) != 0)
    {
        free(t_ini);
        free(t_final);
        printf("Error al obtener tiempo inicial");
        return 1;
    }

    /* Perform an operation a number of times */
    for (t=0; t < NUMBER_OF_TRIALS; t++) {
        /*BUCLE A VECTORIZAR*/
        for (i=0; i < ARRAY_SIZE; i += 4) {
            va = _mm256_loadu_pd(&a[i]); //carga 4 dobles (256 bits) desde memoria (no hace falta que esten alineados) y los devuelve
            vb = _mm256_loadu_pd(&b[i]);
            tmp = _mm256_fmadd_pd(mm, va, vb); // multiplica datos de precision doble mm y va y el resultado lo suma a los datos en vb y devuelve el resultado
            sum = _mm256_add_pd(tmp, sum);
        }
    }

    for (ii = 0; ii < 4; ii++) {
        c += sum[ii];
    }


    if (gettimeofday(t_final, NULL) != 0)
    {
        free(t_ini);
        free(t_final);
        printf("Error al obtener tiempo final");
        return 1;
    }
    
    t_result_sec = t_final->tv_sec - t_ini->tv_sec;
    t_result_usec = t_final->tv_usec - t_ini->tv_usec;

    if(t_result_usec < 0) 
    {
        t_result_sec --;
        t_result_usec *= -1;        
    }

    t_result = t_result_sec*1000000 + t_result_usec;

    free(t_ini);
    free(t_final);

    printf("Los microsegundos que ha tardado han sido: %lf \n", t_result);
    printf("El resultado es: %f\n", c);
    return 0;
}

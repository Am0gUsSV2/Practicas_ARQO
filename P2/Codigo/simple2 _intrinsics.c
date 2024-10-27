#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

#include <xmmintrin.h> // Para SSE
#include <emmintrin.h> // Para SSE2
#include <pmmintrin.h> // Para SSE3
#include <immintrin.h> // Para AVX y AVX2

#define ARRAY_SIZE 2048
#define NUMBER_OF_TRIALS 1000000

/*
 * Statically allocate our arrays.  Compilers can
 * align them correctly.
 */
static double a[ARRAY_SIZE], b[ARRAY_SIZE], c;

int main(int argc, char *argv[]) {

    struct timeval* t_ini = NULL;
    struct timeval* t_final = NULL;
    int i,t;
    __m256d mm = {1.0001, 1.0001, 1.0001, 1.0001};
    __m256 sum = {0.0, 0.0, 0.0, 0.0};

    t_ini = (struct timeval*)malloc(sizeof (struct timeval));
    t_final = (struct timeval*)malloc(sizeof (struct timeval));
    if(!t_ini || !t_final)
    {
        printf("Error al crear estructuras de tiempo");
        return 1;
    }

    double m = 1.0001;
    double t_result_sec = 0;
    double t_result_usec = 0;
    double t_result = 0;
    //Medida de rendimiento
    if (gettimeofday(t_ini, NULL) != 0)
    {
        free(t_ini);
        free(t_final);
        printf("Error al obtener tiempo inicial");
        return 1;
    }
    /* Populate A and B arrays */
    for (i=0; i < ARRAY_SIZE; i++) {
        b[i] = i;
        a[i] = i+1;
    }

    /* Perform an operation a number of times */
    for (t=0; t < NUMBER_OF_TRIALS; t++) {
        /*BUCLE A VECTORIZAR*/
        for (i=0; i < ARRAY_SIZE; i += 4) {
            c += m*a[i] + b[i];
        }
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
    return 0;
}

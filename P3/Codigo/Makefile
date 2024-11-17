LIBS = 
LIB_DIR =  
FLAGS = -O3 -g -Wall -D_GNU_SOURCE

.PHONY: clean all

all: fast slow mul_matrix tr_mul_matrix

fast: fast.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

slow: slow.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

mul_matrix: matrix_multiplication.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

tr_mul_matrix: transposed_matrix_multiplication.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ fast slow mul_matrix tr_mul_matrix

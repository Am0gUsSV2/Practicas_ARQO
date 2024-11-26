CC = gcc
LIBS = -lgomp -lm
LIB_DIR =  
FLAGS = -g -Wall -D_GNU_SOURCE -fopenmp
E1_DIR = E1/
E2_DIR = E2/
E3_DIR = E3/
E4_DIR = E4/
E5_DIR = E5/
UTILS_DIR = utils/
BIN_DIR = bin/
EXE_DIR = exe/
TARGET = omp1 omp2 pescalar_serie pescalar_par1 pescalar_par2 pescalar_par3 pescalar_par4 matrix_multiplication matrix_multiplication_par1 matrix_multiplication_par2 matrix_multiplication_par3 edgeDetector pi_serie pi_par1 pi_par2 pi_par3 pi_par4 pi_par5 pi_par6 pi_par7

.PHONY: clean all

all: $(TARGET) clear

exedir:
	mkdir -p $(EXE_DIR)

omp1: $(E1_DIR)omp1.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

omp2: $(E1_DIR)omp2.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pescalar_serie: $(E2_DIR)pescalar_serie.c $(UTILS_DIR)arqo4.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pescalar_par1: $(E2_DIR)pescalar_par1.c $(UTILS_DIR)arqo4.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pescalar_par2: $(E2_DIR)pescalar_par2.c $(UTILS_DIR)arqo4.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pescalar_par3: $(E2_DIR)pescalar_par3.c $(UTILS_DIR)arqo4.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pescalar_par4: $(E2_DIR)pescalar_par4.c $(UTILS_DIR)arqo4.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

matrix_multiplication: $(E3_DIR)matrix_multiplication.c $(UTILS_DIR)arqo3.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

matrix_multiplication_par1: $(E3_DIR)matrix_multiplication_par1.c $(UTILS_DIR)arqo3.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

matrix_multiplication_par2: $(E3_DIR)matrix_multiplication_par2.c $(UTILS_DIR)arqo3.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

matrix_multiplication_par3: $(E3_DIR)matrix_multiplication_par3.c $(UTILS_DIR)arqo3.c
	$(CC) $(FLAGS) -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_serie: $(E4_DIR)pi_serie.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_par1: $(E4_DIR)pi_par1.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_par2: $(E4_DIR)pi_par2.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_par3: $(E4_DIR)pi_par3.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_par4: $(E4_DIR)pi_par4.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_par5: $(E4_DIR)pi_par5.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_par6: $(E4_DIR)pi_par6.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

pi_par7: $(E4_DIR)pi_par7.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $(EXE_DIR)$@ $^ $(LIBS)

edgeDetector: $(E5_DIR)edgeDetector.c $(E5_DIR)stb_image_write.h $(E5_DIR)stb_image.h
	$(CC) $(FLAGS) -std=gnu99 -I$(UTILS_DIR) $(LIB_DIR) -o $(EXE_DIR)$@ $(E5_DIR)edgeDetector.c $(LIBS)

stb_image.h:
	@echo "Los ficheros de cabecera de stb se deberían descarga automáticamente"
	@echo "En caso de fallo, descargadlo de https://raw.githubusercontent.com/nothings/stb/master/stb_image.h"
	wget --no-check-certificate https://raw.githubusercontent.com/nothings/stb/master/stb_image.h

stb_image_write.h:
	@echo "Los ficheros de cabecera de stb se deberían descarga automáticamente"
	@echo "En caso de fallo, descargadlo de https://raw.githubusercontent.com/nothings/stb/master/stb_image_write.h"
	wget --no-check-certificate https://raw.githubusercontent.com/nothings/stb/master/stb_image_write.h

clean:
	rm -f $(EXE_DIR)*
	
clear:
	rm -f $(EXE_DIR)*.o $(EXE_DIR)*~

#!/bin/bash

# inicializar variables
fDAT=E3executiontimes.dat
# fPNG=slow_fast_time.png
thread1=0
thread2=0
thread3=0
thread4=0
N=1800

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG

# generar el fichero DAT vacío
touch $fDAT

make -C .. clean

make -C ..

echo "Running E3..."
echo "                       Tiempos de ejecucion (s)                       " >> $fDAT
echo "Version/#hilos    |       1      |       2      |       3      |      4" >> $fDAT
echo "Matrix multiplication serie"

thread1=$("../exe/matrix_multiplication" $N | grep 'time' | awk '{print $3}')
echo "Serie             |   ${thread1//./,}   |   ${thread1//./,}   |   ${thread1//./,}   |   ${thread1//./,}" >> $fDAT

for ((i = 1 ; i <= 3 ; i += 1)); do
	echo "Midiendo tiempos del bucle $i"
	echo "1 hilo"
	thread1=$("../exe/matrix_multiplication_par$i" $N 1 | grep 'time' | awk '{print $3}')
	echo "2 hilos"
	thread2=$("../exe/matrix_multiplication_par$i" $N 2 | grep 'time' | awk '{print $3}')
	echo "3 hilos"
	thread3=$("../exe/matrix_multiplication_par$i" $N 3 | grep 'time' | awk '{print $3}')
	echo "4 hilos"
	thread4=$("../exe/matrix_multiplication_par$i" $N 4 | grep 'time' | awk '{print $3}')

	echo "Paralela,bucle$i   |   ${thread1//./,}   |   ${thread2//./,}   |   ${thread3//./,}   |   ${thread4//./,}" >> $fDAT
done

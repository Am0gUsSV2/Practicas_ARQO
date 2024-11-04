# Ejemplo script, para P3 arq 2024-2025

#!/bin/bash

# inicializar variables
Ninicio=200
Npaso=200
Nfinal=2000
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
i=0
maxiteraciones=10

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG

# generar el fichero DAT vacío
touch $fDAT

make clean

make

echo "Running slow and fast..."
# bucle para N desde P hasta Q 
#for N in $(seq $Ninicio $Npaso $Nfinal);
for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	echo "N: $N / $Nfinal..."
	for ((i = 1, slowTime = 0, fastTime = 0; i <= $maxiteraciones ; i += 1)); do
		echo "Iteracion numero $i del tamanio de matriz $N"
		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		nslowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		nfastTime=$(./fast $N | grep 'time' | awk '{print $3}')
		slowTime=$(echo "$slowTime + $nslowTime" | bc)
		fastTime=$(echo "$fastTime + $nfastTime" | bc)
	done
	echo "SlowTime es: $slowTime"
	echo "FastTime es: $fastTime"
	slowTime=$(echo "scale=10; $slowTime / $i" | bc)
	fastTime=$(echo "scale=10; $fastTime / $i" | bc)
	echo "SlowTime despues es: $slowTime"
	echo "FastTime despues es: $fastTime"

	echo "$N	$slowTime	$fastTime" >> $fDAT
done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

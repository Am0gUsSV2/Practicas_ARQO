#!/bin/bash

# inicializar variables
Ninicio=2000
Npaso=2000
Nfinal=20000
fDAT=time_slow_fast.dat
fPNG=slow_fast_time.png
i=0
maxiteraciones=10

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG

# generar el fichero DAT vacío
touch $fDAT

make clean

make

echo "Running slow and fast..."

for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	echo "N: $N / $Nfinal..."
	for ((i = 1, slowTime = 0, fastTime = 0; i <= $maxiteraciones ; i += 1)); do
		echo "Iteracion numero $i del tamanio de matriz $N"
		nslowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		nfastTime=$(./fast $N | grep 'time' | awk '{print $3}')
		slowTime=$(echo "$slowTime + $nslowTime" | bc)
		fastTime=$(echo "$fastTime + $nfastTime" | bc)
	done
	
	slowTime=$(echo "scale=10; $slowTime / $i" | bc)
	fastTime=$(echo "scale=10; $fastTime / $i" | bc)

	echo "$N	$slowTime	$fastTime" >> $fDAT
done

echo "Generating plot..."
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

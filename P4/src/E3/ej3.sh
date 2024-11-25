#!/bin/bash

# inicializar variables
# Ninicio=2000
# Npaso=2000
# Nfinal=20000
fDAT=E3times.dat
# fPNG=slow_fast_time.png
i=0
maxiteraciones=10
nthreads=1
maxthreads=4
one_thread=0
two_threads=0
three_threads=0
four_threads=0
one_thread_aux=0
two_threads_aux=0
three_threads_aux=0
four_threads_aux=0
N=1000

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG

# generar el fichero DAT vacío
touch $fDAT

make clean

make

echo "Running E3..."
echo "Matrix multiplication serie"
for ((i = 1, one_thread = 0; i <= $maxiteraciones ; i += 1)); do
	one_thread_aux=$(./matrix_multiplication $N | grep 'time' | awk '{print $3}')
	one_thread=$(echo "$one_thread + $one_thread_aux" | bc)
done

one_thread=$(echo "scale=10; $one_thread / $maxiteraciones" | bc)
echo "$one_thread" >> $fDAT

for ((nthreads = 1 ; nthreads <= maxthreads ; nthreads += 1)); do
	echo "N: $N / $Nfinal..."

	nslowTime=$(./slow $N | grep 'time' | awk '{print $3}')
	nfastTime=$(./fast $N | grep 'time' | awk '{print $3}')
	slowTime=$(echo "$slowTime + $nslowTime" | bc)
	fastTime=$(echo "$fastTime + $nfastTime" | bc)

	
	slowTime=$(echo "scale=10; $slowTime / $i" | bc)
	fastTime=$(echo "scale=10; $fastTime / $i" | bc)

	echo "$N	$slowTime	$fastTime" >> $fDAT
done

# echo "Generating plot..."
# gnuplot << END_GNUPLOT
# set title "Slow-Fast Execution Time"
# set ylabel "Execution time (s)"
# set xlabel "Matrix Size"
# set key right bottom
# set grid
# set term png
# set output "$fPNG"
# plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
#      "$fDAT" using 1:3 with lines lw 2 title "fast"
# replot
# quit
# END_GNUPLOT
#!/bin/bash

# inicializar variables
Ninicio=512
Npaso=256
Nfinal=2048
fDAT=E3.3times.dat
fSPE=E3.3speedup.dat
fPNG=E3_3.png
i=0
maxiteraciones=10
nthreads=4
n_result_aux=0
n_result=0
par_result_aux=0
par_result=0
aceleracion=0
N=0

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG

# generar el fichero DAT vacío
touch $fDAT

make clean

make

echo "Running E3.3..."
echo "Matrix multiplication serie"

for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	echo "N: $N / $Nfinal..."
	n_result=$("../bin/matrix_multiplication" $N | grep 'time' | awk '{print $3}')
	par_result=$("../bin/matrix_multiplication_par2" $N $nthreads | grep 'time' | awk '{print $3}')

	aceleracion=$(echo "scale=10; $n_result / $par_result" | bc)
	echo "$N"	"$n_result"		"$par_result"	"$aceleracion" >> $fDAT
done

echo "Generating plot times E3.3 ..."
gnuplot << END_GNUPLOT
set title "Serie-Parallel Execution Time"
set ylabel "Execution time(s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "Serie", \
     "$fDAT" using 1:3 with lines lw 2 title "Parallel"
replot
quit
END_GNUPLOT

echo "Generating plot speedup E3.3 ..."
gnuplot << END_GNUPLOT
set title "Serie-Parallel Speedup"
set ylabel "Speedup"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fSPE"
plot "$fDAT" using 1:2 with lines lw 2 title "Serie", \
     "$fDAT" using 1:3 with lines lw 2 title "Parallel"
replot
quit
END_GNUPLOT
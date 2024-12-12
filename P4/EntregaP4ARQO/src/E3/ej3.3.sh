#!/bin/bash

# inicializar variables
Ninicio=512
Npaso=512
Nfinal=4096
fDAT=E3.3times.dat
fSPNG=E3_3_speedup.png
fPNG=E3_3_Ex_times.png
n_result=0
par_result=0
aceleracion_n=1
aceleracion_par=0
N=0
nthreads=4

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG $fSPNG

# generar el fichero DAT vacío
touch $fDAT

make -C .. clean

make -C ..

echo "Running E3.3..."
echo "Matrix multiplication serie"

for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	echo "N: $N / $Nfinal..."
	echo "Serie matrix multiplication"
	n_result=$("../exe/matrix_multiplication" $N | grep 'time' | awk '{print $3}')
	echo "Parallel loop 3 matrix multiplication"
	par_result=$("../exe/matrix_multiplication_par3" $N $nthreads | grep 'time' | awk '{print $3}')
	aceleracion_par=$(echo "scale=10; $n_result / $par_result" | bc)
	echo "$N"	"$n_result"		"$par_result"	"$aceleracion_n"	"$aceleracion_par" >> $fDAT
done

echo "Generating plot times E3.3 ..."
gnuplot << END_GNUPLOT
set title "Serie-Parallel-Loop3 Execution Time"
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
set title "Serie-Parallel-Loop3 Speedup"
set ylabel "Speedup"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fSPNG"
plot "$fDAT" using 1:4 with lines lw 2 title "Serie", \
     "$fDAT" using 1:5 with lines lw 2 title "Parallel"
replot
quit
END_GNUPLOT
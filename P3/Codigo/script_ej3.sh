#!/bin/bash

# inicializar variables
Ninicio=1000
Npaso=500
Nfinal=1000
fDAT=time_slow_fast.dat
fPNG=slow_fast_time.png
i=0
maxi=1
L1_size=0
L1_base=1024
LL_cache=8388608 #8MB
associativity=1
line_size=64
slow_raw_file_name=slowgrind.dat
slow_annotate_file_name=slowannotate.dat
fast_annotate_file_name=fastannotate.dat

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG

# generar el fichero DAT vacío
touch $fDAT

make clean

make

echo "Running slow and fast with cachegrind..."

for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	echo "N: $N / $Nfinal..."
	for ((i = 1; i <= $maxi ; i += 1)); do

		tam_cache=$(echo "scale=10; $L1_base * $i" | bc)
		echo "Tamanio cache L1 = $L1_size"

		valgrind --tool=cachegrind --cachegrind-out-file=$slow_raw_file_name --I1=$L1_size,$associativity,$line_size --D1=$L1_size,$associativity,$line_size --I1=$LL_cache,$associativity,$line_size ./slow $N 
		cg_annotate $slow_raw_file_name | head -n 30 >> $slow_annotate_file_name
		valgrind --tool=cachegrind --cachegrind-out-file=$fast_raw_file_name --I1=$L1_size,$associativity,$line_size --D1=$L1_size,$associativity,$line_size --I1=$LL_cache,$associativity,$line_size ./fast $N
		cg_annotate $fast_raw_file_name | head -n 30 >> $fast_annotate_file_name

	done
	
	# slowTime=$(echo "scale=10; $slowTime / $i" | bc)
	# fastTime=$(echo "scale=10; $fastTime / $i" | bc)

	# echo "$N	$slowTime	$fastTime" >> $fDAT
done

# echo "Generating plot..."
# # llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# # estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
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


#valgrind --tool=cachegrind --I1=1024,1,64 --D1=1024,1,64 --I1=8388608,1,64 ./slow 1000



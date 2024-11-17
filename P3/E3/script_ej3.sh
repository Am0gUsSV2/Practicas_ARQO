#!/bin/bash

# inicializar variables
Ninicio=1000
Npaso=500
Nfinal=4000
i=1
maxi=4
L1_size=0
L1_base=1024
LL_cache=8388608 #8MB
associativity=1
line_size=64
D1mr_slow=0
D1mw_slow=0
D1mr_fast=0
D1mw_fast=0
slow_raw_file_name=slowgrindE.dat
slow_annotate_file_name=annotate_slowE.dat
fast_raw_file_name=fastgrindE.dat
fast_annotate_file_name=annotate_fastE.dat
rPNG=cache_lectura.png
wPNG=cache_escritura.png

# borrar el fichero DAT y el fichero PNG
rm -f *.png
rm -f *.dat

make clean

make

echo "Running slow and fast with cachegrind..."

for ((i = 1; i <= $maxi ; i *= 2)); do

	L1_size=$(echo "scale=10; $L1_base * $i" | bc)
	echo "Tamanio cache L1 = $L1_size"

	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do

		echo "N: $N / $Nfinal..."
		echo "L1size= $L1_size"
		echo "fichero es el "
		valgrind --tool=cachegrind --cachegrind-out-file=$slow_raw_file_name --I1=$L1_size,$associativity,$line_size --D1=$L1_size,$associativity,$line_size --I1=$LL_cache,$associativity,$line_size ./slow $N 
		cg_annotate $slow_raw_file_name | head -n 30 >> $slow_annotate_file_name
		read D1mr_slow D1mw_slow < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $slow_annotate_file_name)
		valgrind --tool=cachegrind --cachegrind-out-file=$fast_raw_file_name --I1=$L1_size,$associativity,$line_size --D1=$L1_size,$associativity,$line_size --I1=$LL_cache,$associativity,$line_size ./fast $N
		cg_annotate $fast_raw_file_name | head -n 30 >> $fast_annotate_file_name
		read D1mr_fast D1mw_fast < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $fast_annotate_file_name)
		echo "$N	$D1mr_slow	$D1mw_slow	$D1mr_fast	$D1mw_fast	" >> cache_$L1_size.dat	
		rm -f *E.dat

	done
done

echo "Generating reading failures plot..."
gnuplot << END_GNUPLOT
set title "Read Failures"
set ylabel "Number of failures"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$rPNG"
plot "cache_1024.dat" using 1:2 with lines lw 2 title "1024B L1 slow", \
     "cache_2048.dat" using 1:2 with lines lw 2 title "2048B L1 slow", \
     "cache_4096.dat" using 1:2 with lines lw 2 title "4096B L1 slow", \
     "cache_1024.dat" using 1:4 with lines lw 2 title "1024B L1 fast", \
     "cache_2048.dat" using 1:4 with lines lw 2 title "2048B L1 fast", \
     "cache_4096.dat" using 1:4 with lines lw 2 title "4096B L1 fast"
replot
quit
END_GNUPLOT

echo "Generating writing failures plot..."
gnuplot << END_GNUPLOT
set title "Writing Failures"
set ylabel "Number of failures"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$wPNG"
plot "cache_1024.dat" using 1:3 with lines lw 2 title "1024B L1 slow", \
     "cache_2048.dat" using 1:3 with lines lw 2 title "2048B L1 slow", \
     "cache_4096.dat" using 1:3 with lines lw 2 title "4096B L1 slow", \
     "cache_1024.dat" using 1:5 with lines lw 2 title "1024B L1 fast", \
     "cache_2048.dat" using 1:5 with lines lw 2 title "2048B L1 fast", \
     "cache_4096.dat" using 1:5 with lines lw 2 title "4096B L1 fast"
replot
quit
END_GNUPLOT
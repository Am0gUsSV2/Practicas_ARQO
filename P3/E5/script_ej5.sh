#!/bin/bash

# inicializar variables
Ninicio=256
Npaso=256
Nfinal=2048

#variables para parte de valgrind
L1_size=32768
associativity=1
line_size1=32
line_size2=64
LL_cache=8388608 #8MB
D1mr_mm1=0
D1mw_mm1=0
D1mr_tmm1=0
D1mw_tmm1=0
D1mr_mm2=0
D1mw_mm2=0
D1mr_tmm2=0
D1mw_tmm2=0
mm_raw_file_name=mmgrind5E.dat
mm_annotate_file_name=annotate_mm5E.dat
tmm_raw_file_name=tmmgrind5E.dat
tmm_annotate_file_name=annotate_tmm5E.dat
fDAT=mult5.dat
rPNG=mult5_cache_read.png
wPNG=mult5_cache_write.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $rPNG $wPNG

make clean

make

echo "Running matrix multiplication and transposed matrix multiplication for line size analysis..."

for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do

	echo "N: $N / $Nfinal..."
	echo "Prueba con tamanio de linea = 32..."
	valgrind --tool=cachegrind --cachegrind-out-file=$mm_raw_file_name --I1=$L1_size,$associativity,$line_size1 --D1=$L1_size,$associativity,$line_size1 --LL=$LL_cache,$associativity,$line_size1 ./mul_matrix $N 
	cg_annotate $mm_raw_file_name | head -n 30 >> $mm_annotate_file_name
	read D1mr_mm1 D1mw_mm1 < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $mm_annotate_file_name)
	valgrind --tool=cachegrind --cachegrind-out-file=$tmm_raw_file_name --I1=$L1_size,$associativity,$line_size1 --D1=$L1_size,$associativity,$line_size1 --LL=$LL_cache,$associativity,$line_size1 ./tr_mul_matrix $N
	cg_annotate $tmm_raw_file_name | head -n 30 >> $tmm_annotate_file_name
	read D1mr_tmm1 D1mw_tmm1 < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $tmm_annotate_file_name)
	rm -f *E.dat

	echo "Prueba con tamanio de linea = 64..."
	valgrind --tool=cachegrind --cachegrind-out-file=$mm_raw_file_name --I1=$L1_size,$associativity,$line_size2 --D1=$L1_size,$associativity,$line_size2 --LL=$LL_cache,$associativity,$line_size2 ./mul_matrix $N 
	cg_annotate $mm_raw_file_name | head -n 30 >> $mm_annotate_file_name
	read D1mr_mm2 D1mw_mm2 < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $mm_annotate_file_name)
	valgrind --tool=cachegrind --cachegrind-out-file=$tmm_raw_file_name --I1=$L1_size,$associativity,$line_size2 --D1=$L1_size,$associativity,$line_size2 --LL=$LL_cache,$associativity,$line_size2 ./tr_mul_matrix $N
	cg_annotate $tmm_raw_file_name | head -n 30 >> $tmm_annotate_file_name
	read D1mr_tmm2 D1mw_tmm2 < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $tmm_annotate_file_name)
	rm -f *E.dat

	echo "$N		$D1mr_mm1		$D1mw_mm1		$D1mr_tmm1		$D1mw_tmm1		$D1mr_mm2		$D1mw_mm2		$D1mr_tmm2		$D1mw_tmm2" >> $fDAT
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
plot "$fDAT" using 1:2 with lines lw 2 title "LS=32, Normal", \
     "$fDAT" using 1:4 with lines lw 2 title "LS=32, Transposed", \
	 "$fDAT" using 1:6 with lines lw 2 title "LS=64, Normal", \
     "$fDAT" using 1:8 with lines lw 2 title "LS=64, Transposed" 
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
plot "$fDAT" using 1:3 with lines lw 2 title "LS=32, Normal", \
     "$fDAT" using 1:5 with lines lw 2 title "LS=32, Transposed", \
	 "$fDAT" using 1:7 with lines lw 2 title "LS=64, Normal", \
     "$fDAT" using 1:9 with lines lw 2 title "LS=64, Transposed" 
replot
quit
END_GNUPLOT
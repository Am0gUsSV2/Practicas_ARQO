#!/bin/bash

# inicializar variables
Ninicio=256
Npaso=256
Nfinal=2048
i=0
maxiteraciones=10
n_tiempo_normal=0
n_tiempo_transpuesta=0
tiempo_nomal=0
tiempo_transpuesta=0

#variables para parte de valgrind
D1mr_mm=0
D1mw_mm=0
D1mr_tmm=0
D1mw_tmm=0
mm_raw_file_name=mmgrindE.dat
mm_annotate_file_name=annotate_mmE.dat
tmm_raw_file_name=tmmgrindE.dat
tmm_annotate_file_name=annotate_tmmE.dat
fDAT=mult.dat
rPNG=mult_cache_read.png
wPNG=mult_cache_write.png
tPNG=mult_time.png


# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $rPNG $wPNG $tPNG

make clean

make

echo "Running matrix multiplication and transposed matrix multiplication..."

for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
	echo "N: $N / $Nfinal..."
    echo "Comienza la prueba de tiempos..."
	for ((i = 1, slowTime = 0, fastTime = 0; i <= $maxiteraciones ; i += 1)); do
		echo "Iteracion numero $i del tamanio de matriz $N"

		n_tiempo_normal=$(./mul_matrix $N | grep 'time' | awk '{print $3}')
		n_tiempo_transpuesta=$(./tr_mul_matrix $N | grep 'time' | awk '{print $3}')
		tiempo_nomal=$(echo "$tiempo_nomal + $n_tiempo_normal" | bc)
		tiempo_transpuesta=$(echo "$tiempo_transpuesta + $n_tiempo_transpuesta" | bc)

	done

	tiempo_nomal=$(echo "scale=10; $tiempo_nomal / $i" | bc)
	tiempo_transpuesta=$(echo "scale=10; $tiempo_transpuesta / $i" | bc)

    echo "Comienza la prueba con cachegrind..."
    valgrind --tool=cachegrind --cachegrind-out-file=$mm_raw_file_name ./mul_matrix $N 
    cg_annotate $mm_raw_file_name | head -n 30 >> $mm_annotate_file_name
    read D1mr_mm D1mw_mm < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $mm_annotate_file_name)
    valgrind --tool=cachegrind --cachegrind-out-file=$tmm_raw_file_name  ./tr_mul_matrix $N
    cg_annotate $tmm_raw_file_name | head -n 30 >> $tmm_annotate_file_name
    read D1mr_tmm D1mw_tmm < <(awk 'NR == 18 {gsub(",", ""); gsub(/\([^)]*\)/, ""); gsub(/PROGRAM TOTALS/, ""); print $5, $8}' $tmm_annotate_file_name)
    rm -f *E.dat

	echo "$N	$tiempo_nomal   $D1mr_mm    $D1mw_mm	$tiempo_transpuesta	   $D1mr_tmm    $D1mw_tmm" >> $fDAT
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
plot "$fDAT" using 1:3 with lines lw 2 title "Normal", \
     "$fDAT" using 1:6 with lines lw 2 title "Transposed"
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
plot "$fDAT" using 1:4 with lines lw 2 title "Normal", \
     "$fDAT" using 1:7 with lines lw 2 title "Transposed"
replot
quit
END_GNUPLOT

echo "Generating plot of multiplication time..."
gnuplot << END_GNUPLOT
set title "Matrix Multiplication Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$tPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "Normal", \
     "$fDAT" using 1:5 with lines lw 2 title "Transposed"
replot
quit
END_GNUPLOT

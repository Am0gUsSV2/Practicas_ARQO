#!/bin/bash

i=1
max_reps=10
n_serie_result_SD=0
n_serie_result_HD=0
n_serie_result_FHD=0
n_serie_result_4k=0
n_serie_result_8k=0
n_parallel_result_SD=0
n_parallel_result_HD=0
n_parallel_result_FHD=0
n_parallel_result_4k=0
n_parallel_result_8k=0

serie_result_SD=0
serie_result_HD=0
serie_result_FHD=0
serie_result_4k=0
serie_result_8k=0
parallel_result_SD=0
parallel_result_HD=0
parallel_result_FHD=0
parallel_result_4k=0
parallel_result_8k=0

spd_up_SD=0
spd_up_HD=0
spd_up_FHD=0
spd_up_4k=0
spd_up_8k=0
fDAT="E5.4.dat"

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT

# generar el fichero DAT vacío
touch $fDAT

rm -f img/*denoised.jpg img/*grad.jpg img/*grey.jpg

make -C .. clean

make -C .. edgeDetectorSerie 
make -C .. edgeDetectorParallel

echo "Running E5.4..."

for ((i = 1 ; i <= max_reps ; i += 1)); do
	echo "N: $i / $max_reps..."
	echo "edgeDetectorSerie SD..."
	n_serie_result_SD=$("../exe/edgeDetectorSerie" "../E5/img/SD.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorSerie HD..."
	n_serie_result_HD=$("../exe/edgeDetectorSerie" "../E5/img/HD.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorSerie FHD..."
	n_serie_result_FHD=$("../exe/edgeDetectorSerie" "../E5/img/FHD.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorSerie 4k..."
	n_serie_result_4k=$("../exe/edgeDetectorSerie" "../E5/img/4k.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorSerie 8k..."
	n_serie_result_8k=$("../exe/edgeDetectorSerie" "../E5/img/8k.jpg" | grep 'Tiempo' | awk '{print $2}')

	echo "edgeDetectorParallel SD..."
	n_parallel_result_SD=$("../exe/edgeDetectorParallel" "../E5/img/SD.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorParallel HD..."
	n_parallel_result_HD=$("../exe/edgeDetectorParallel" "../E5/img/HD.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorParallel FHD..."
    n_parallel_result_FHD=$("../exe/edgeDetectorParallel" "../E5/img/FHD.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorParallel 4k..."
	n_parallel_result_4k=$("../exe/edgeDetectorParallel" "../E5/img/4k.jpg" | grep 'Tiempo' | awk '{print $2}')
	echo "edgeDetectorParallel 8k..."
	n_parallel_result_8k=$("../exe/edgeDetectorParallel" "../E5/img/8k.jpg" | grep 'Tiempo' | awk '{print $2}')

    serie_result_SD=$(echo "$serie_result_SD + $n_serie_result_SD" | bc)
    serie_result_HD=$(echo "$serie_result_HD + $n_serie_result_HD" | bc)
    serie_result_FHD=$(echo "$serie_result_FHD + $n_serie_result_FHD" | bc)
    serie_result_4k=$(echo "$serie_result_4k + $n_serie_result_4k" | bc)
    serie_result_8k=$(echo "$serie_result_8k + $n_serie_result_8k" | bc)
    parallel_result_SD=$(echo "$parallel_result_SD + $n_parallel_result_SD" | bc)
    parallel_result_HD=$(echo "$parallel_result_HD + $n_parallel_result_HD" | bc)
    parallel_result_FHD=$(echo "$parallel_result_FHD + $n_parallel_result_FHD" | bc)
    parallel_result_4k=$(echo "$parallel_result_4k + $n_parallel_result_4k" | bc)
    parallel_result_8k=$(echo "$parallel_result_8k + $n_parallel_result_8k" | bc)

done
serie_result_SD=$(echo "scale=10; $serie_result_SD / $i" | bc)
serie_result_HD=$(echo "scale=10; $serie_result_HD / $i" | bc)
serie_result_FHD=$(echo "scale=10; $serie_result_FHD / $i" | bc)
serie_result_4k=$(echo "scale=10; $serie_result_4k / $i" | bc)
serie_result_8k=$(echo "scale=10; $serie_result_8k / $i" | bc)
parallel_result_SD=$(echo "scale=10; $parallel_result_SD / $i" | bc)
parallel_result_HD=$(echo "scale=10; $parallel_result_HD / $i" | bc)
parallel_result_FHD=$(echo "scale=10; $parallel_result_FHD / $i" | bc)
parallel_result_4k=$(echo "scale=10; $parallel_result_4k / $i" | bc)
parallel_result_8k=$(echo "scale=10; $parallel_result_8k / $i" | bc)

echo "Tiempo serie" "$serie_result_SD"	"$serie_result_HD"		"$serie_result_FHD"	"$serie_result_4k"	"$serie_result_8k" >> $fDAT
echo "Tiempo paralelo" "$parallel_result_SD"	"$parallel_result_HD"		"$parallel_result_FHD"	"$parallel_result_4k"	"$parallel_result_8k" >> $fDAT
echo "Aceleracion" $(echo "scale=10; $serie_result_SD / $parallel_result_SD" | bc)    $(echo "scale=10; $serie_result_HD / $parallel_result_HD" | bc) $(echo "scale=10; $serie_result_FHD / $parallel_result_FHD" | bc) $(echo "scale=10; $serie_result_4k / $parallel_result_4k" | bc) $(echo "scale=10; $serie_result_8k / $parallel_result_8k" | bc)  >> $fDAT
echo "FPS serie" $(echo "scale=10; 1 / $serie_result_SD" | bc)    $(echo "scale=10; 1 / $serie_result_HD" | bc) $(echo "scale=10; 1 / $serie_result_FHD" | bc) $(echo "scale=10; 1 / $serie_result_4k" | bc) $(echo "scale=10; 1 / $serie_result_8k" | bc) >> $fDAT
echo "FPS paralelo" $(echo "scale=10; 1 / $parallel_result_SD" | bc)    $(echo "scale=10; 1 / $parallel_result_HD" | bc) $(echo "scale=10; 1 / $parallel_result_FHD" | bc) $(echo "scale=10; 1 / $parallel_result_4k" | bc) $(echo "scale=10; 1 / $parallel_result_8k" | bc) >> $fDAT

tr '.' ',' < $fDAT > $fDAT
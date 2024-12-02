#!/bin/bash

# inicializar variables
i=0
max=7

rm -f img/*denoised.jpg img/*grad.jpg img/*grey.jpg

make -C .. clean

make -C .. edgeDetectorParallel

echo "edgeDetectorParallel"
"../exe/edgeDetectorParallel" "../E5/img/8k.jpg"
#!/bin/bash

# inicializar variables
i=0
max=7

rm -f img/*denoised.jpg img/*grad.jpg img/*grey.jpg

make -C .. clean

make -C .. edgeDetector

echo "edgeDetector"
"../exe/edgeDetector" "../E5/img/8k.jpg" "../E5/img/SD.jpg"
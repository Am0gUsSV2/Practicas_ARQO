#!/bin/bash

# inicializar variables
i=0
max=7

make -C .. clean

make -C .. edgeDetector

echo "edgeDetector"
"../exe/edgeDetector" "../E5/img/SD.jpg"
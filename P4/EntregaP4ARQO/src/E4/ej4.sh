#!/bin/bash

# inicializar variables
i=0
max=7

make -C .. clean

make -C .. pi_serie pi_par1 pi_par2 pi_par3 pi_par4 pi_par5 pi_par6 pi_par7

echo "pi_serie"
"../exe/pi_serie"

for ((i = 1 ; i <= max ; i += 1)); do
    echo "pi_par$i"
    "../exe/pi_par$i"
    echo ""
done

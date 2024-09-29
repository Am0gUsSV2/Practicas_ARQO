# arq0_riscv_pipe

Repo preliminar RISC V para Arquitectura de ordenadores (arqo) 2024

Código RTL (VHDL) del procesador RISC V unciclo y pipeline. Implementa un subconjunto del set de instrucciones.

Carpeta SIM con Testbench y modelos de memoria de datos e instrucciones.
El contenido de las memorias se carga desde los ficheros exportados desde el simulador RARS
El fichero runsim_arq_xxx.do compila y simula en modelsim/questasim
carpeta asm contiene ejemplos en ensamblador para RARS
carpeta images contiene imagenes de los circuitos

Hay 3 implementaciones:
- Uniciclo. Se ejecuta con do runsim_arq_unic.do
- Pipeline sin Riesgos. Se ejecuta con do runsim_arq_pip_noRisgos.do
- Pipeline con riesgos de datos y control. Se ejecuta con do runsim_arq_pipe.do



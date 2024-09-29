#-----------------------------------------------------
# Ejercicio 2
# Diego Forte Jara y Roberto Martin Alonso
#


# 1- cargar en dos registros los dos numeros a comparar
# 2- 

.data
lista:  .word 9, 7, 8, 6, 5, 4, 3, 2, 1, 0 # Lista de 10 numeros a ordenar
#lista_ordenada .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # Lista vacia

.text
main:    
    la t0, lista            # carga la dreccion del buffer en t0
    #la t1, lista_ordenada   # carga la direccion de la lista vacia en t1
    li t2, 0                # carga en t2 un cero para el bucle externo
    li t3, 1                # carga en t3 un cero para el bucle interno
    li t4, 10               # carga en t4 el tamanio maximo de la lista           

bucle_interno:
    lw t5, t2(t0)           # Cargar en el registro "t5" el elemento inicial
    lw t6, t3(t0)           # Cargar en el registro "t6" el segundo elemento de la lista
    bge t5, t6, continua    # Saltar si el segundo elemento es mayor que el primero
    jal es_menor

continua:
    addi t3, t3, 1                    # Se aumenta en 1 el indice del bucle interno
    blt t3, t4, bucle_interno     # Continua el bucle en caso de que el indice del bucle interno (t3) sea menor a 10
    lw s2, t2(t0)                 # Se guarda en s2 el valor de la lista en el indice t2 (bucle externo)
    lw s3, s1(t0)
    sw s2, s1(t0)                 # Se guarda en la lista en la posicion
    sw s3, t2(t0)
    addi t2, t2, 1                    # Suma 1 al indice del bucle externo
    blt t2, t4, bucle_interno
    jal fin

es_menor:
    and s1, s1, zero
    add s1, t3, zero
    jalr ra, 0(ra)

mas_1_bucle_externo:
    addi t2, t2, 1
    j bucle_interno

fin:
    beq zero, zero fin

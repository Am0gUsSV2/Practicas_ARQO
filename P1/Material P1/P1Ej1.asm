# Idea:

# int i
# int last = -1
# 
# for (x in array_size)
# 	for (elem in array)
# 		if elem > last (elem-last > 0)
# 			if elem < i (elem-i < 0)
# 				i = elem
# 	
# 	new_array[x] = i (sw en x*4 de la posicion de new_array)
# 	last = i (valor minimo)
# 	i= -1
	
.data

nums: .word 7, 13, 14, 5, 15, 2, 12, 1, 17, 19
array: .word

.text

	la a0, nums #Carga direccion nums
	la a3, array
	li a1, 0 #Carga 0 en A1, donde guardaremos el valor del nuevo array
	li t0, 0 #Inicializa el recorrido del array
	nop
	li s0, 10
	
	loop_read: #Bucle de lectura
	slli t1, t0, 2
	add t2, a0, t1
	lw t3, 0(t2)
	slt t4, a4, t3 #Compara si T3 > A4
	nop
	nop
	beq t4, zero, loop_advance #Salta si A4 > T3
	
	loop_cmp: #Solo esta para que se sepa que aqui se hace la segunda comparacion
	beq a2, zero, loop_swapvalue #Si A2 es 0, no hay que comparar.
	nop 
	nop
	slt t4, a2, t3 #Compara si A2 < T3
	nop 
	nop
	bne t4, zero, loop_advance #Salta si A2 > T3
	
	loop_swapvalue: #Solo esta para que se sepa que aqui se cambia el valor
	add a2, t3, zero	
	
	loop_advance: #Añade uno al bucle de lectura y lo continua si aun no ha leido todos los valores
	addi t0, t0, 1
	nop
	nop
	bne t0, s0, loop_read
	
	loop_write: #Escribe el valor obtenido en el nuevo array, y lo guarda como valor a comparar. Termina si se han escrito todos los valores
	slli t5, a1, 2
	nop
	nop
	add t6, a3, t5
	sw a2, 0(t6)
	addi a1, a1, 1 #Añade 1 al contador de escritura
	nop
	nop
	beq a1, s0, end
	add t0, zero, zero #Resetea el contador
	add a4, a2, zero
	add a2, zero, zero #Resetea A2
	j loop_read
	
	end:
	
	
	

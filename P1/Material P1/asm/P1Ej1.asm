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
#Version 3: A�adimos los nop y cambiamos los la (por hacer, usar el .text para hacer los cambios y meter dos nop en los auipc)
#Tipo R: Si hay conflicto, dos NOP
#LW: Si hay conflicto, tres NOP
#Branch y J: Debido a que se comprueba en ciclo M, aplicamos 3 NOP para que no ejecute ninguna instruccion nueva
	
.data

nums: .word 7, 13, 14, 5, 15, 2, 12, 1, 17, 19
array: .word

.text

	#la s0, nums # Carga la posicion de memoria inicial de la lista de numeros
	auipc s0,0x0000fc10
	nop
	nop
	addi s0,s0,0
	#la s1, array # Carga la posicion de memoria inicial del array donde vamos a guardar la lista ordenada
	auipc s1,0x0000fc10 
	nop
	nop
	addi s1,s1,0x00000018
	li a0, 0 # Carga 0 en A0, donde guardaremos el valor del nuevo array (Redundante)
	li a1, 0 # Inicializa el recorrido del array (Redundante)
	
	li s2, 40 # Limite del array (10*4)
	addi s3, zero, -1 # 0xFFFF, para utilizar para hacer Complemento A1 con XOR
	addi s4, zero, 1 # Usamos un valor constante de uno para usar BGE en el caso x > 0

	
	loop_read: #Bucle de lectura
	
		add t0, s0, t5 #Calculamos posicion de memoria
		nop
		nop
		lw t1, 0(t0) #Cargamos en T1 el valor de nums al que se ha accedido 
		nop
		nop
		nop
	
		xor t2, t1, s3 #Complemento A1
		nop
		nop
		addi t2, t2, 1 #Complemento A2
		nop
		nop
	
		add t3, a0, t2 #(A0-T2). Es una comparacion
		nop
		nop
		bge t3, zero, loop_advance #Salta si T3 es mayor que A0
		nop
		nop
		nop
	
	loop_cmp: #Solo esta para que se sepa que aqui se hace la segunda comparacion
	
		beq a2, zero, loop_swapvalue #Si A2 es 0, no hay que comparar.
		nop
		nop
		nop
		add t4, a2, t2 #Compara si A2 < T3
		nop
		nop
		blt t4, zero, loop_advance #Salta si A2 > T3
		nop
		nop
		nop
	
	loop_swapvalue: #Solo esta para que se sepa que aqui se cambia el valor
	
		add a2, t1, zero #Asignamos el valor en T1 (valor cargado de la lista) a A2 (valor a comparar)	
	
	loop_advance: #A�ade "uno" (cuatro) al bucle de lectura y lo continua si aun no ha leido todos los valores
		addi t5, t5, 4 # Como no podemos usar slli, debemos a�adir 4.
		nop
		nop
		bne t5, s2, loop_read # Comparamos con 40
		nop
		nop
		nop
	
	loop_write: #Escribe el valor obtenido en el nuevo array, y lo guarda como valor a comparar. Termina si se han escrito todos los valores
		add t0, s1, a1 #Calcula la direccion de escritura
		nop
		nop
		sw a2, 0(t0) #Guarda el valor en la posicion del array correspondiente
		addi a1, a1, 4 #A�ade "1" (4) al contador de escritura
		nop
		nop
		beq a1, s2, end #Comparamos con 40
		nop
		nop
		nop
		add t5, zero, zero #Resetea el contador de recorrido del array num a 0. En esta seccion, no necesitamos NOP
		add a0, a2, zero #Asignamos A2 (i) el valor de last (A0)
		add a2, zero, zero #Reseteamos A2
		j loop_read #Reiniciamos el programa
        	nop
        	nop
        	nop
	
	end: #Fin de programa
	
	
	

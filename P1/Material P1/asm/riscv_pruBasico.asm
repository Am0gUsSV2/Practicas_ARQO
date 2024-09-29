#-----------------------------------------------------
# Prueba simple para testar la ruta de datos
# G.Sutter sep 2024.
#

.data
buffer: .space 16
num0:   .word  1
num1:   .word  2
num2:   .word  4
num3:   .word  8
num4:   .word 16
num5:   .word 32
mask1:  .word 0xFFFFFF00
mask2:  .word 0x000000FF

.text
main:    la   t0, buffer          # carga la drecci�n del buffer en t0 (X5)
	 #lui  t0, %hi(buffer)    # Carga la parte alta de la dir buffer
	 #addi t0, t0, %lo(buffer)
	 li   t1, 8               # x6 = 8
  	 sw   t1, 0(t0)           # buff[0] = x6
	 lw   t2, 0(t0)           # x7 = buff[0]
	 bne  t1, t2, failure     # if x6 /= x7 fallo
	 li   t3, 56              # x28 = 56
	 sw   t3, 4(t0)
	 addi t0, t0, 4
	 lw   t4, 0(t0)
	 bne  t3, t4, failure
	 lw   t5, -4(t0)
	 bne  t5, t1, failure
	 li   t1, 0xFF00F007      # x6 = 0xFF00F007
	 li   t2, 0xFF            # x7 = FF
	 and  t1, t1, t2          # x6 debe queda 7
	 li   t3, 7
	 bne  t1, t3, failure
	 li   t2, 0xFFF           # x7 = FFF
	 not  t2, t2              # x7 = FFFF_F000
	 lui  t3, 0xFFFFF         # x28 = FFFFF << 12 = FFFF_F000
	 bne  t2, t3, failure
	 beq zero, zero, success  # jump (sala) a etiqueta success
	 addi t2, t2, 1	          # No se ejecuta
	 addi t2, t2, 1	          # No se ejecuta
	 
success: beq zero, zero, success
	
failure: beq zero, zero, failure
	

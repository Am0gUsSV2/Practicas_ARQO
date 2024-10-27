	.file	"simple2.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"Error al crear estructuras de tiempo"
	.align 8
.LC2:
	.string	"Error al obtener tiempo inicial"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC6:
	.string	"Error al obtener tiempo final"
	.section	.rodata.str1.8
	.align 8
.LC11:
	.string	"Los microsegundos que ha tardado han sido: %lf \n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB39:
	.cfi_startproc
	endbr64
	leaq	8(%rsp), %r10
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp
	movl	$16, %edi
	pushq	-8(%r10)
	pushq	%rbp
	movq	%rsp, %rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%r10
	.cfi_escape 0xf,0x3,0x76,0x60,0x6
	.cfi_escape 0x10,0xe,0x2,0x76,0x78
	.cfi_escape 0x10,0xd,0x2,0x76,0x70
	.cfi_escape 0x10,0xc,0x2,0x76,0x68
	subq	$48, %rsp
	call	malloc@PLT
	movl	$16, %edi
	movq	%rax, %r13
	call	malloc@PLT
	testq	%r13, %r13
	je	.L13
	movq	%rax, %r12
	testq	%rax, %rax
	je	.L13
	xorl	%esi, %esi
	movq	%r13, %rdi
	call	gettimeofday@PLT
	testl	%eax, %eax
	jne	.L19
	leaq	b(%rip), %rcx
	vmovdqa	.LC0(%rip), %xmm2
	leaq	a(%rip), %rdx
	vmovdqa	.LC3(%rip), %xmm4
	movq	%rcx, %rax
	vmovdqa	.LC4(%rip), %xmm3
	movq	%rdx, %rsi
	leaq	16384(%rcx), %rdi
.L6:
	vmovdqa	%xmm2, %xmm0
	addq	$32, %rax
	vpaddd	%xmm4, %xmm2, %xmm2
	vcvtdq2pd	%xmm0, %xmm1
	vmovapd	%xmm1, -32(%rax)
	vpshufd	$238, %xmm0, %xmm1
	vpaddd	%xmm3, %xmm0, %xmm0
	vcvtdq2pd	%xmm1, %xmm1
	addq	$32, %rsi
	vmovapd	%xmm1, -16(%rax)
	vcvtdq2pd	%xmm0, %xmm1
	vpshufd	$238, %xmm0, %xmm0
	vmovapd	%xmm1, -32(%rsi)
	vcvtdq2pd	%xmm0, %xmm0
	vmovapd	%xmm0, -16(%rsi)
	cmpq	%rdi, %rax
	jne	.L6
	vmovsd	c(%rip), %xmm3
	movl	$1000000, %esi
	vmovapd	.LC5(%rip), %ymm4
.L7:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L8:
	vmulpd	(%rdx,%rax), %ymm4, %ymm0
	vaddpd	(%rcx,%rax), %ymm0, %ymm0
	addq	$32, %rax
	vaddsd	%xmm3, %xmm0, %xmm1
	vunpckhpd	%xmm0, %xmm0, %xmm2
	vextractf128	$0x1, %ymm0, %xmm0
	vaddsd	%xmm2, %xmm1, %xmm1
	vaddsd	%xmm0, %xmm1, %xmm1
	vunpckhpd	%xmm0, %xmm0, %xmm0
	vaddsd	%xmm0, %xmm1, %xmm3
	cmpq	$16384, %rax
	jne	.L8
	subl	$1, %esi
	jne	.L7
	xorl	%esi, %esi
	movq	%r12, %rdi
	vmovsd	%xmm3, c(%rip)
	vzeroupper
	call	gettimeofday@PLT
	movl	%eax, %r14d
	testl	%eax, %eax
	jne	.L20
	movq	(%r12), %rax
	vxorps	%xmm1, %xmm1, %xmm1
	vxorpd	%xmm2, %xmm2, %xmm2
	subq	0(%r13), %rax
	vcvtsi2sdq	%rax, %xmm1, %xmm0
	movq	8(%r12), %rax
	subq	8(%r13), %rax
	vcvtsi2sdq	%rax, %xmm1, %xmm1
	vcomisd	%xmm1, %xmm2
	ja	.L21
.L11:
	movq	%r13, %rdi
	vmovsd	%xmm1, -64(%rbp)
	vmovsd	%xmm0, -56(%rbp)
	call	free@PLT
	movq	%r12, %rdi
	call	free@PLT
	vmovsd	-56(%rbp), %xmm0
	movl	$1, %edi
	movl	$1, %eax
	vmovsd	-64(%rbp), %xmm1
	leaq	.LC11(%rip), %rsi
	vmulsd	.LC10(%rip), %xmm0, %xmm0
	vaddsd	%xmm1, %xmm0, %xmm0
	call	__printf_chk@PLT
.L1:
	addq	$48, %rsp
	movl	%r14d, %eax
	popq	%r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	leaq	-8(%r10), %rsp
	.cfi_def_cfa 7, 8
	ret
.L21:
	.cfi_restore_state
	vsubsd	.LC8(%rip), %xmm0, %xmm0
	vxorpd	.LC9(%rip), %xmm1, %xmm1
	jmp	.L11
.L19:
	movq	%r13, %rdi
	movl	$1, %r14d
	call	free@PLT
	movq	%r12, %rdi
	call	free@PLT
	leaq	.LC2(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L1
.L20:
	movq	%r13, %rdi
	movl	$1, %r14d
	call	free@PLT
	movq	%r12, %rdi
	call	free@PLT
	leaq	.LC6(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L1
.L13:
	leaq	.LC1(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	movl	$1, %r14d
	jmp	.L1
	.cfi_endproc
.LFE39:
	.size	main, .-main
	.local	c
	.comm	c,8,8
	.local	b
	.comm	b,16384,32
	.local	a
	.comm	a,16384,32
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	0
	.long	1
	.long	2
	.long	3
	.align 16
.LC3:
	.long	4
	.long	4
	.long	4
	.long	4
	.align 16
.LC4:
	.long	1
	.long	1
	.long	1
	.long	1
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC5:
	.long	-611603343
	.long	1072693352
	.long	-611603343
	.long	1072693352
	.long	-611603343
	.long	1072693352
	.long	-611603343
	.long	1072693352
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC8:
	.long	0
	.long	1072693248
	.section	.rodata.cst16
	.align 16
.LC9:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC10:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

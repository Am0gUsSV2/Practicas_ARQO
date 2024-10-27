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
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	$16, %edi
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	call	malloc@PLT
	movl	$16, %edi
	movq	%rax, %r12
	call	malloc@PLT
	testq	%r12, %r12
	je	.L13
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L13
	xorl	%esi, %esi
	movq	%r12, %rdi
	call	gettimeofday@PLT
	testl	%eax, %eax
	jne	.L19
	leaq	b(%rip), %rcx
	leaq	a(%rip), %rdx
	movdqa	.LC0(%rip), %xmm2
	movdqa	.LC3(%rip), %xmm4
	movdqa	.LC4(%rip), %xmm3
	movq	%rcx, %rax
	movq	%rdx, %rsi
	leaq	16384(%rcx), %rdi
.L6:
	movdqa	%xmm2, %xmm0
	addq	$32, %rax
	paddd	%xmm4, %xmm2
	addq	$32, %rsi
	cvtdq2pd	%xmm0, %xmm1
	movaps	%xmm1, -32(%rax)
	pshufd	$238, %xmm0, %xmm1
	paddd	%xmm3, %xmm0
	cvtdq2pd	%xmm1, %xmm1
	movaps	%xmm1, -16(%rax)
	cvtdq2pd	%xmm0, %xmm1
	pshufd	$238, %xmm0, %xmm0
	cvtdq2pd	%xmm0, %xmm0
	movaps	%xmm1, -32(%rsi)
	movaps	%xmm0, -16(%rsi)
	cmpq	%rdi, %rax
	jne	.L6
	movsd	c(%rip), %xmm1
	movapd	.LC5(%rip), %xmm3
	movl	$1000000, %esi
.L7:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L8:
	movapd	(%rdx,%rax), %xmm0
	mulpd	%xmm3, %xmm0
	addpd	(%rcx,%rax), %xmm0
	addq	$16, %rax
	addsd	%xmm0, %xmm1
	unpckhpd	%xmm0, %xmm0
	addsd	%xmm0, %xmm1
	cmpq	$16384, %rax
	jne	.L8
	subl	$1, %esi
	jne	.L7
	xorl	%esi, %esi
	movq	%rbp, %rdi
	movsd	%xmm1, c(%rip)
	call	gettimeofday@PLT
	movl	%eax, %r13d
	testl	%eax, %eax
	jne	.L20
	movq	0(%rbp), %rax
	pxor	%xmm0, %xmm0
	subq	(%r12), %rax
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm0
	movq	8(%rbp), %rax
	subq	8(%r12), %rax
	pxor	%xmm2, %xmm2
	cvtsi2sdq	%rax, %xmm1
	comisd	%xmm1, %xmm2
	ja	.L21
.L11:
	movq	%r12, %rdi
	movsd	%xmm1, 8(%rsp)
	movsd	%xmm0, (%rsp)
	call	free@PLT
	movq	%rbp, %rdi
	call	free@PLT
	movsd	(%rsp), %xmm0
	movsd	8(%rsp), %xmm1
	leaq	.LC11(%rip), %rsi
	mulsd	.LC10(%rip), %xmm0
	movl	$1, %edi
	movl	$1, %eax
	addsd	%xmm1, %xmm0
	call	__printf_chk@PLT
.L1:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	movl	%r13d, %eax
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	subsd	.LC8(%rip), %xmm0
	xorpd	.LC9(%rip), %xmm1
	jmp	.L11
.L19:
	movq	%r12, %rdi
	movl	$1, %r13d
	call	free@PLT
	movq	%rbp, %rdi
	call	free@PLT
	leaq	.LC2(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L1
.L20:
	movq	%r12, %rdi
	movl	$1, %r13d
	call	free@PLT
	movq	%rbp, %rdi
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
	movl	$1, %r13d
	call	__printf_chk@PLT
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
	.align 16
.LC5:
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

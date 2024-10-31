	.file	"simple2.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"Error al crear estructuras de tiempo"
	.align 8
.LC1:
	.string	"Error al obtener tiempo inicial"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC3:
	.string	"Error al obtener tiempo final"
	.section	.rodata.str1.8
	.align 8
.LC8:
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
	leaq	b(%rip), %rcx
	leaq	a(%rip), %rdx
	movl	%eax, %r8d
	xorl	%eax, %eax
	testl	%r8d, %r8d
	jne	.L21
.L5:
	pxor	%xmm0, %xmm0
	leal	1(%rax), %esi
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, (%rcx,%rax,8)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%esi, %xmm0
	movsd	%xmm0, (%rdx,%rax,8)
	addq	$1, %rax
	cmpq	$2048, %rax
	jne	.L5
	movsd	c(%rip), %xmm1
	movsd	.LC2(%rip), %xmm2
	movl	$1000000, %esi
.L6:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L7:
	movsd	(%rdx,%rax), %xmm0
	mulsd	%xmm2, %xmm0
	addsd	(%rcx,%rax), %xmm0
	addq	$8, %rax
	addsd	%xmm0, %xmm1
	cmpq	$16384, %rax
	jne	.L7
	subl	$1, %esi
	jne	.L6
	xorl	%esi, %esi
	movq	%rbp, %rdi
	movsd	%xmm1, c(%rip)
	call	gettimeofday@PLT
	movl	%eax, %r13d
	testl	%eax, %eax
	jne	.L22
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
	ja	.L23
.L10:
	movq	%r12, %rdi
	movsd	%xmm1, 8(%rsp)
	movsd	%xmm0, (%rsp)
	call	free@PLT
	movq	%rbp, %rdi
	call	free@PLT
	movsd	(%rsp), %xmm0
	movsd	8(%rsp), %xmm1
	leaq	.LC8(%rip), %rsi
	mulsd	.LC7(%rip), %xmm0
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
.L23:
	.cfi_restore_state
	subsd	.LC5(%rip), %xmm0
	xorpd	.LC6(%rip), %xmm1
	jmp	.L10
.L21:
	movq	%r12, %rdi
	movl	$1, %r13d
	call	free@PLT
	movq	%rbp, %rdi
	call	free@PLT
	leaq	.LC1(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L1
.L22:
	movq	%r12, %rdi
	movl	$1, %r13d
	call	free@PLT
	movq	%rbp, %rdi
	call	free@PLT
	leaq	.LC3(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk@PLT
	jmp	.L1
.L13:
	leaq	.LC0(%rip), %rsi
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
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC2:
	.long	-611603343
	.long	1072693352
	.align 8
.LC5:
	.long	0
	.long	1072693248
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC6:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC7:
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

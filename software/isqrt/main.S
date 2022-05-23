	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a0,82
	call	isqrt
	sw	a0,-20(s0)
	li	a0,100
	call	isqrt
	sw	a0,-20(s0)
	li	a0,64
	call	isqrt
	sw	a0,-20(s0)
.L2:
	j	.L2
	.size	_start, .-_start
	.align	2
	.globl	isqrt
	.type	isqrt, @function
isqrt:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	li	a5,1073741824
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	j	.L4
.L6:
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	or	a5,a4,a5
	sw	a5,-28(s0)
	lw	a5,-24(s0)
	srli	a5,a5,1
	sw	a5,-24(s0)
	lw	a4,-36(s0)
	lw	a5,-28(s0)
	bltu	a4,a5,.L5
	lw	a4,-36(s0)
	lw	a5,-28(s0)
	sub	a5,a4,a5
	sw	a5,-36(s0)
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	or	a5,a4,a5
	sw	a5,-24(s0)
.L5:
	lw	a5,-20(s0)
	srli	a5,a5,2
	sw	a5,-20(s0)
.L4:
	lw	a5,-20(s0)
	bne	a5,zero,.L6
	lw	a5,-24(s0)
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	isqrt, .-isqrt
	.ident	"GCC: (g5964b5cd727) 11.1.0"

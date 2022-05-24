	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
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
	.size	main, .-main
	.align	2
	.globl	isqrt
	.type	isqrt, @function
isqrt:
	addi	sp,sp,-48
	sw	s0,44(sp)
	sw	s1,40(sp)
	sw	s2,36(sp)
	sw	s3,32(sp)
	sw	s4,28(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	s3,-36(s0)
	li	s1,1073741824
	li	s2,0
	j	.L4
.L5:
	srli	s1,s1,2
.L4:
	bgtu	s1,s3,.L5
	j	.L6
.L8:
	or	s4,s2,s1
	srli	s2,s2,1
	bltu	s3,s4,.L7
	sub	s3,s3,s4
	or	s2,s2,s1
.L7:
	srli	s1,s1,2
.L6:
	bne	s1,zero,.L8
	mv	a5,s2
	mv	a0,a5
	lw	s0,44(sp)
	lw	s1,40(sp)
	lw	s2,36(sp)
	lw	s3,32(sp)
	lw	s4,28(sp)
	addi	sp,sp,48
	jr	ra
	.size	isqrt, .-isqrt
	.ident	"GCC: (g5964b5cd727) 11.1.0"

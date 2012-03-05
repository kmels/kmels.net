## hello-world.s

	## by Robin Miyagi
	## http://www.geocities.com/SiliconValley/Ridge/2544/

	## Compile Instructions:
	##
	##-------------------------------------------------------------
	## as -o hello-world.o hello-world.s
	## ld -o hello-world -O0 hello-world.o

	## This file is a basic demonstration of the GNU
	## assembler,
	## `as'.

	## This program displays a friendly string on the screen
	## using
	## the write () system call
	################################################## ######################
	.section .data
hello:
	.ascii "Hello, world!\n"
hello_len:
	.long . - hello
	################################################## ######################
	.section .text
	.globl _start

_start:
	## display string using write () system call
	xorl %ebx, %ebx # %ebx = 0
	movl $4, %eax # write () system call
	xorl %ebx, %ebx # %ebx = 0
	incl %ebx # %ebx = 1, fd = stdout
	leal hello, %ecx # %ecx ---> hello
	movl hello_len, %edx # %edx = count
	int $0x80 # execute write () system call

	## terminate program via _exit () system call
	xorl %eax, %eax # %eax = 0
	incl %eax # %eax = 1 system call _exit ()
	xorl %ebx, %ebx # %ebx = 0 normal program return code
	int $0x80 # execute system call _exit ()
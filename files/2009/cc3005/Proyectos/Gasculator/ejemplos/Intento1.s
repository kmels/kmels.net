.text
.global main
main:
pushl $n
pushl $sfmt
call scanf
addl $8, %esp
addl $1, n
pushl n
pushl $fmt
call printf
addl $8, %esp
pushl $0
xorl %ebx, %ebx		# %ebx = 0
movl $4, %eax		# write () system call
xorl %ebx, %ebx		# %ebx = 0
incl %ebx		# %ebx = 1, fd = stdout
leal hello, %ecx	# %ecx ---> hello
movl hello_len, %edx	# %edx = count
int $0x80		# execute write () system call
pushl $hello
pushl $fmt1
call printf

call exit

.data
n:	.long 0
fmt:	.asciz "%d\n"
sfmt:	.asciz	"%d"
hello:	.ascii 	"Hello, world!\n"
hello_len: .long 	. - hello
fmt1:	.asciz "%s\n"
.text

.global main #Inicio del codigo, la ejecucion comienza en main

write:
  xorl %ebx, %ebx	# %ebx = 0
  movl $4, %eax		# write () system call
  xorl %ebx, %ebx	# %ebx = 0
  incl %ebx		# %ebx = 1, fd = stdout
  movl string, %ecx	# %ecx ---> hello
  movl string_size, %edx	# %edx = count
  int $0x80		# execute write () system call
  ret

read:
  xorl %ebx, %ebx	# %ebx = 0
  movl $3, %eax		# read () system call
  xorl %ebx, %ebx	# %ebx = 0
  movl $opt, %ecx	
  movl $256, %edx	# %edx = count
  int $0x80		# execute read () system call
  #movl %eax, opt_len
  ret

main:
  
  movl $bnv, string
  movl $bnv_length, string_size
  call write
  call read                                 
  
  movl opt, %eax #Determinar que opcion ingreso el usuario
  cmpl $49, %eax #Comparando el ingreso con las posibles opciones
  je opt1
  cmpl $50, %eax
  je opt2
  addl $8, %esp
  movl $0, opt
  movl $opt, string
  movl $opt_len, string_size
  call write
  jmp main

#Imprimir el mensaje 1 o el mensaje 2

opt1:
  movl $msg1, string
  movl $msg1_length, string_size
  call write
  call main

opt2:
  movl $msg2, string
  movl $msg2_length, string_size
  call write
  call exit

.data
string: .long 0
string_size: .long 0

bnv:	
.ascii "1. Imprimir mensaje 1\n2. Imprimir mensaje 2\n"
.equ bnv_length, . - bnv

msg1:	
.ascii "La queremos Marta Ligia\n"
.equ msg1_length, . - msg1

msg2:	
.ascii "Assembler es una clase bonita\n"
.equ msg2_length, . - msg1
opt_len: .long 4
opt: .long 0

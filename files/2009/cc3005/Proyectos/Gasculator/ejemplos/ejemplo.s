.text
.globl main #Inicio del codigo, la ejecucion comienza en main

main:
  pushl $bnv #Parametros para printf, lugar de memoria y tipo de dato
  pushl $ofmt
  call printf #Procedimiento que imprime en pantalla
  addl $8, %esp #Remover parametros de la pila
  #pushl $opt #Parametros para scanf, lugar donde se guardara el ingreso
  #pushl $ifmt #Formato del dato ingresado

#getopt:
  
  pushl $opt #Parametros para scanf, lugar donde se guardara el ingreso
  pushl $ifmt #Formato del dato ingresado
  call scanf #Solicitar que el usuario ingrese un dato
  movl opt, %eax #Determinar que opcion ingreso el usuario
  cmpl $49, %eax #Comparando el ingreso con las posibles opciones
  je opt1
  cmpl $50, %eax
  je opt2
  addl $8, %esp
  movl $0, opt
  jmp main

#Imprimir el mensaje 1 o el mensaje 2

opt1:
  addl $8, %esp
  pushl $msg1
  pushl $ofmt
  call printf
  call main

opt2:
  addl $8, %esp
  pushl $msg2
  pushl $ofmt
  call printf
  call exit

.data
#opt:	.long 0
ifmt:	.asciz "%s"
ofmt:	.asciz "%s\n"
bnv:	.asciz "1. Imprimir mensaje 1\n2. Imprimir mensaje 2\n"
msg1:	.asciz "La queremos Marta Ligia\n"
msg2:	.asciz "Assembler es una clase bonita\n"
opt:	.long 0
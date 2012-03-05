.text
main   		sw 	$t3 $t2 %4
		sw 	$t2 $t3 x4		
		LW      $t0 data
		J 	main		
		LW 	$t0 $t4 x4		
		J   	x40
		j  	hello_msg:
		bne $t2 $t4 %10
		bne $t0 $t1 etiqueta0
		bgez $t5 main
		bgez $t5 xFFF
		bgtz $t5 main
		bgtz $t5 xFFF
		bltz $t5 main
		bltz $t5 xFFF
		blez $t5 main
		blez $t5 xFF1
        	addi     $v1 $t1 xFF        
hello_msg:   	syscall               
        	addi      $v1 $t1 %10       
       		syscall  
etiqueta0 	beq $t0 $t1 etiqueta0

.data
Data 		.word xF
et32 		.word x10
tal2 		.asciiz "tal"
tal 		.ascii "dno"
etiqueta2 	.space 2
.ascii 		"ta"




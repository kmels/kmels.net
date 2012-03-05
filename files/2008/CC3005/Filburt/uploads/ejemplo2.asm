.text
main   		addi $t2 $t2 %5
HALT
		add $t2 $t2 #8
		addi $t1, $t1, 9
		J marthaligia
		JAL 	JAL2
		andi $t2 $t2 %1
		add 	$t2 $t3 $t2
		and  	$t2 $t2 $t4
		beq $t0 $t1 %21
		bne $t2 $t4 %10
		bne $t0 $t1 etiqueta0
		bgez $t5 main
		bgez $t5 xFFF
JAL3 		bgtz $t5 main
		bgtz $t5 xFFF
		bltz $t5 main
		bltz $t5 xFFF
		blez $t5 main
		blez $t5 xFF1		
LW 		$t0 x0
		sw 	$t3 main
		J 	JAL2
		J  	main
		nop
		syscall
JAL2 		jal JAL3
		
        	addi     $v1 $t1 xFF        
hello_msg:   	syscall               
        	addi      $v1 $t1 %10       
       		syscall  
etiqueta0 	beq $t0 $t1 etiqueta0

.data
Data 		.word x2
et32 		.word x4
tal2 		.asciiz "tal"
tal 		.ascii "dno"
etiqueta2 	.space 2
.ascii 		"ta"

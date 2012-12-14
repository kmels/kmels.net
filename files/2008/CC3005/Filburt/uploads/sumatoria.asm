.text
main 	
  		lw $t1 numero1
		addi $t2 $t2 %6
		addi $t3 $t3 %7
		addi $t4 $t4 %2
		addi $t0 $t0 %5
		add $t5 $t0 $t1
		add $t5 $t5 $t2
		add $t5 $t5 $t3
		add $t5 $t5 $t4
		
		andi $t9 $t9 %0
contador 	addi $t9 $t9 %1
		addi $t5 $t5 %-5
		bltz $t5 fin
		j contador
fin 		add $t9 $t9 %-1	 	
		nop
		
          


.data
numero1 	.word x5
et32 		.word x4
tal2 		.asciiz "tal"
tal 		.ascii "dno"
etiqueta2 	.space 2
.ascii 		"ta"

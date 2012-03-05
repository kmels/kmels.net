.MODEL SMALL
.STACK 64
.DATA



.CODE 
MAIN		PROC FAR
		MOV AX,@data		;inicializa segmento de datos
		.STARTUP		
NUM1 		DB	2		;almacenar en memoria el primer número a sumar
NUM2		DB	7		;almacenar en memoria el segundo número
NUM3		DB 	48		;número a sumar para obtener el ascii del número


		MOV CH, NUM1 
		MOV DH, NUM2
		MOV CL, NUM3

		ADD CH, DH		;sumar los dos primeros números, almacenar en AX
		ADD CH, CL		;sumar la suma anterior con el tercer número, en AX

		MOV AH, 02H		;Petición de la función para desplegar
		MOV DL, CH		;valor del caracter que esta almacenado en AX

		INT 21H			;llamar a la interrupción para mostrar mensaje

		MOV AH, 4CH
		INT 21H
MAIN		ENDP
		END MAIN

;Universidad del Valle de Guatemala
;CC3005 Programacion en Assembler
;Seccion 10
;Karen Andrea Tojin, Carne 08091
;Actividad de Participacion No. 2
;Fecha: Lunes 03 de Agosto de 2009

.MODEL SMALL
.STACK 64

;-------------------------------------------------------------------------------------------

.DATA
INPUT	DB 'Se compararan 2 numeros: ','$'
OUTPUT	DB '----------------------------------- ','$'
ENTRAR	DB	0DH, 0AH, '$'
NUM1	DB	8
NUM2	DB	2
MAYOR	DB 	?
MENOR	DB	?

;-------------------------------------------------------------------------------------------

.CODE

;Procedimiento para el despliegue

COUT	   PROC NEAR
		   MOV AH, 09H   			; peticion para desplegar
		   INT 21H       			; llama al DOS
		   RET
COUT	   ENDP

;-------------------------------------------------------------------------------------------

;Procedimiento para encontrar el mayor

NMAYOR		PROC NEAR
			CMP BL, BH				; Compara dos números
			JA MAYOR1				; Si es mayor el 1ero salta a MAYOR1
			JB MAYOR2				; Si es mayor el 2do salta a MAYOR2
MAYOR1:		MOV MAYOR, BL			; Coloca num1 en MAYOR
			MOV MENOR, BH			; Coloca num2 en MENOR
			JMP FINMAYOR
MAYOR2:		MOV MAYOR, BH			; Coloca num2 en MAYOR
			MOV MENOR, BL			; Coloca num1 en MAYOR
			
FINMAYOR:	RET
NMAYOR		ENDP

;-------------------------------------------------------------------------------------------

MAIN 		PROC FAR
			.STARTUP
			; Asignar los valores de los números al registro
			MOV	BL, NUM1
			MOV BH, NUM2
			
			; Despliegue mensaje de entrada
			LEA DX, INPUT
			CALL COUT
			
			; Imprimir enter
			LEA DX, ENTRAR
			CALL COUT
			
			; Despliegue mensaje de salida
			LEA DX, OUTPUT
			CALL COUT
			
			LEA DX, ENTRAR
			CALL COUT
			
			MOV DX, 0D;
			
			CALL NMAYOR
			MOV CX, WORD PTR MENOR
		
			; Imprime el numero mayor la cantidad de veces de el menor
CICLO:		MOV DL, MAYOR
			ADD DL, 30H
			MOV AH,02H						;Prerarar al registro AH
			INT 21H							;LLamar a interrupciones del DOS
			
			LEA DX, ENTRAR
			CALL COUT	
			MOV DX, 0D;
			
			LOOP CICLO
		
		
		MOV 	AH, 4CH
		INT		21H
MAIN	ENDP
		END 	MAIN
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
; *************************************************
;	Universidad del Valle de Guatemala
; 	Departamento de Computación
;	CC3005 - Programación en Assembler	
;
;	Carlos Eduardo López Camey
;	Carné #08107
;	Ejercicio Extra #4
;; *************************************************

.MODEL SMALL
.STACK 64
.DATA                    

Cadena 		DB "Una cadena"
FinDeCadena	DB "$"

; Inicio del codigo
.CODE
;-----------------------------------------------------------
principal	PROC
		MOV AX,@data            ;inicializa segmento de datos
		MOV DS,AX

		;Asignar Cadena
		
		;Leer Cantidad de caracteres
		MOV CX, 10
		
CICLO:	MOV BX, CX
		MOV AL, Cadena[BX] 
		SUB AL, 32H
		MOV Cadena[BX], AL
		LOOP CICLO
		
		
		INT 21H
principal	ENDP
;-----------------------------------------------------------
END principal

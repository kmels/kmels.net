; *************************************************
;	Universidad del Valle de Guatemala
; 	Departamento de Computación
;	CC3005 - Programación en Assembler	
;
;	Carlos Eduardo López Camey
;	Carné #08107
;	Ejercicio Extra #1
;; *************************************************


.MODEL SMALL
.STACK 64
.DATA                    

; Inicio del codigo
.CODE
;-----------------------------------------------------------
principal	PROC
       MOV AX,@data            ;inicializa segmento de datos
       MOV DS,AX

		MOV ax, 1234h
		MOV BX, AX
		MOV CX,AX
		ADD CH,AL
		ADD BL, AH
		ADD AX, 0FFFFh
		DEC BX		
		INC AX
	      
		MOV AH, 4CH   		;salida al DOS
		INT 21H
principal	ENDP
;-----------------------------------------------------------
END principal

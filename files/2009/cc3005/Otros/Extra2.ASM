; *************************************************
;	Universidad del Valle de Guatemala
; 	Departamento de Computación
;	CC3005 - Programación en Assembler	
;
;	Carlos Eduardo López Camey
;	Carné #08107
;	Ejercicio Extra #3
;; *************************************************

.MODEL SMALL
.STACK 64
.DATA                    

TresBytes 	DB	10H,20H, 30H
LaSuma		DB 	?

; Inicio del codigo
.CODE
;-----------------------------------------------------------
principal	PROC
       MOV AX,@data            ;inicializa segmento de datos
       MOV DS,AX

		MOV AL, TresBytes[0]		;AL = primer numero
		MOV BL, TresBytes[1]		;BL = segundo numero
		ADD BL, AL					;BL = BL + AL
		MOV CL, TresBytes[2]		;CL = tercer numero
		ADD CL, BL					;CL = CL + BL
		
		MOV LaSuma, CL				;LaSuma = CL
	      
		MOV AH, 4CH   		;salida al DOS
		INT 21H
principal	ENDP
;-----------------------------------------------------------
END principal

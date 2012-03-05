;Universidad del Valle de Guatemala
;Departamento de Computaci¢n
;Programa de operandos de tipo
.MODEL SMALL
.STACK 64
.DATA                    
; Definicion de datos
TOTAL		DW	1122H	   
WORDA		DW 	2672H		;Se guarda como 7226H
;-------------------------------------------------
; Inicio del codigo
.CODE
;-----------------------------------------------------------
principal	PROC
		MOV AX,@data           	;inicializa segmento de datos
		MOV DS,AX
          
		MOV AH, BYTE PTR TOTAL	   	; primer byte
		MOV BL, BYTE PTR TOTAL+1 	; segundo  byte
		MOV AX, WORD PTR TOTAL 		;2 bytes a AX
		MOV BYTE PTR TOTAL, 05  	;05 al primer byte

		MOV AH, 4CH   			;salida al DOS
		INT 21H
principal	ENDP
;-----------------------------------------------------------
END principal

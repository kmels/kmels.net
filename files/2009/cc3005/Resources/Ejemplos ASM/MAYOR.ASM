;Universidad del Valle de Guatemala
;Departamento de Computacion
;Programa de Ejemplo de saltos

.MODEL SMALL
.STACK 64
.DATA                    
; Definicion de datos
NUMEROS DB	1, 5, 6, 2, 8
CONT	DW	5
MAYOR	DW	?
;-------------------------------------------------
; Inicio del codigo
.CODE
;-----------------------------------------------------------
principal	PROC
       MOV AX,@data            	;inicializa segmento de datos
       MOV DS,AX				;
       
	   MOV CX, CONT				; inicializa contador
	   MOV AL, NUMEROS			; mueve primer numero, asume que es el mayor
	   MOV BX, 1				; inicializa indice de numeros
	   
SIGUE: MOV DL, NUMEROS[BX]		; Mueve numero a comparar a DX
	   INC BX					; apunta al siguiente numero
	   CMP DL, AL
	   JL  SALTO				; si es menor continuar comparando
	   MOV AL, DL				; es el nuevo mayor
SALTO: LOOP SIGUE
	   	   
	   MOV DL, AL				; caracter a desplegar
	   ADD DL, 30H				; para que despliegue el ASCII
	   MOV AH, 02H				; desplegar un caracter
	   INT 21H
	   
       MOV AH, 4CH   		;salida al DOS
	   INT 21H
principal	ENDP
;-----------------------------------------------------------
END principal

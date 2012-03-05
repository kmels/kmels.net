; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 28 de septiembre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; Cadena1.asm: Copia cadena 1 a cadena 2
; **********************************************************************************
.model small
.stack 64
.data	
;---------------------------------------------
LONGITUD	EQU	20
CADENA1		DB	20 DUP ('*')
CADENA2		DB	20 DUP (' ')
FIN			DB	'$'
;--------------------------------------------
.code

MAIN	PROC FAR

   	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	MOV ES, AX

	CLD						; izq a der
	MOV	CX, LONGITUD		; longitud de las cadenas
	LEA SI, CADENA1			; cadena fuente
	LEA	DI, CADENA2			; cadena destino
	REP	MOVSB				; copia 20 veces byte por byte

	MOV AH, 09h     	;muestra cadena destino
    LEA DX, CADENA2
    INT 21H

	MOV AH, 4CH   		;salida al DOS
	INT 21H

MAIN	ENDP
END	MAIN
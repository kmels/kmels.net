; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 28 de septiembre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; Cadena3.asm: Uso de STOSW
; **********************************************************************************
.model small
.stack 64
.data
;---------------------------------------------
LONGITUD	EQU	10
CADENA1		DB	10 DUP (' ')
FIN			DB 	'$'
;--------------------------------------------
.code

MAIN	PROC FAR

   	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	MOV ES, AX

	CLD				; izq a der
	MOV	AL, 01		; mover carita a CADENA1
	MOV	CX, LONGITUD			
	LEA	DI, CADENA1
	REP	STOSB

	MOV AH, 09h     	;muestra cadena destino
    LEA DX, CADENA1
    INT 21H

	MOV AH, 4CH   		;salida al DOS
	INT 21H

MAIN	ENDP
END	MAIN
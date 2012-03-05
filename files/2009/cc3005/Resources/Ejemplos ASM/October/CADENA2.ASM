; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 28 de septiembre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; Cadena2.asm: Inversion de cadenas
; **********************************************************************************
.model small
.stack 64
.data
;---------------------------------------------
LONGITUD	EQU	10
CADENA1		DB	'Ensamblado'
CADENA2		DB	10 DUP (' ')
FIN			DB	'$'
;--------------------------------------------
.code

MAIN	PROC FAR

   	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	MOV ES, AX

	CLD
	MOV	CX, LONGITUD			; longitud de la cadena
	LEA	SI, CADENA1				; carga dirección de cadena1
	LEA	DI, CADENA2+LONGITUD-1	; carga dir de cadena2-1
CICLO:
	LODSB				; obtiene el carácter en AL
	MOV [DI], AL
	DEC DI
	LOOP CICLO

	MOV AH, 09h     	;muestra cadena destino
    LEA DX, CADENA2
    INT 21H

	MOV AH, 4CH   		;salida al DOS
	INT 21H

MAIN	ENDP
END	MAIN
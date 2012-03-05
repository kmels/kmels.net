; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 28 de septiembre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; Cadena5.asm: busqueda de cadenas, busca la 'a'
; **********************************************************************************
.model small
.stack 64
.data
;---------------------------------------------
LONGITUD	DW	25
TEXTO		DB	'Programacion en assembler'
CANTIDAD	DB	?
MENSAJE1	DB	'El texto contiene letras a$'
MENSAJE2	DB	'El texto NO contiene letras a$'
;--------------------------------------------
.code

MAIN	PROC FAR

   	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	MOV ES, AX

	CLD						; izq a der
	MOV		AL, 'a'			; busca ‘a’ en TEXTO
	MOV		CX, LONGITUD
	LEA		DI, TEXTO
	REPNE	SCASB			; repite mientras no 
	JNE		SALIR			; sea igual o CX es 0
	LEA		DX, MENSAJE1	; si existen letras a
	JMP		PANTALLA
SALIR:
	LEA		DX, MENSAJE2
PANTALLA:
	MOV AH, 09h     		;muestra cadena destino
    INT 21H

	MOV AH, 4CH   		;salida al DOS
	INT 21H

MAIN	ENDP
END	MAIN
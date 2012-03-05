; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 28 de septiembre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; Cadena6.asm: buscar y reemplazar
; **********************************************************************************
.model small
.stack 64
.data
;---------------------------------------------
LONGITUD	DW	25
TEXTO		DB	'Programacion en assembler$'
CAR_BUSCA	DB	'o'	; caracter de busqueda
CAR_REEMP	DB	'O'	; caracter de reemplazo
;--------------------------------------------
.code

MAIN	PROC FAR

   	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	MOV ES, AX

	CLD						; izq a der
	MOV		AL, CAR_BUSCA	; busca en texto
	MOV		CX, LONGITUD
	LEA		DI, TEXTO
CIC:REPNE	SCASB			; repite mientras no sea igual o CX es 0
	JNZ		SALIR			; ¿se encontro el caracter?
	DEC		DI				; si, ajusta direccion
	MOV		DL, CAR_REEMP
	MOV 	BYTE PTR[DI], DL; reemplaza el caracter
	JMP 	CIC
SALIR:
	LEA		DX, TEXTO
	MOV AH, 09h     		; muestra cadena
    INT 21H

	MOV AH, 4CH   			;salida al DOS
	INT 21H

MAIN	ENDP
END	MAIN
; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 2 de Octubre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; macro.asm: Uso de macros con directiva LOCAL
; 
; **********************************************************************************
; Macro para inicializar el área de datos
INITZ 	MACRO			; define macro
		MOV AX, @data
		MOV DS, AX
		MOV ES, AX
		ENDM			; fin macro
; **********************************************************************************
;Macro para dividir con parametros
DIVIDE	MACRO DIVIDEND, DIVISOR, COCIENTE
		LOCAL COMP
		LOCAL SALIR
		;AX=dividendo, BX=divisor, CX=cociente
		MOV AX, DIVIDEND
		MOV BX, DIVISOR
		XOR CX, CX		; colocar cociente a cero
COMP:					; divide con restas sucesivas
		CMP AX, BX		; dividendo < divisor?
		JB	SALIR		; si, salir
		SUB AX, BX		; dividendo-divisor
		INC CX			; sumar al cociente
		JMP COMP
SALIR:
		MOV COCIENTE, CX; almacenar cociente
		ENDM
; **********************************************************************************
; Macro para desplegar en pantalla
DESP	MACRO CADENA
		MOV AH, 09H
		LEA DX, CADENA
		INT 21H
		ENDM
; **********************************************************************************
	.MODEL SMALL
	.STACK 64
; **********************************************************************************
; Area de datos
	.DATA
DIVDND	DW	160			; dividendo
DIVSOR	DW	80			; divisor
COCIEN	DW	?			; cociente
FIN		DB	'$', 0dh, 0ah
; **********************************************************************************
; Programa principal
	.CODE
BEGIN 	PROC FAR
		INITZ			; llamar al macro
		DIVIDE DIVDND, DIVSOR, COCIEN
		ADD COCIEN, 30H	; pasar a ascii para despliegue
		DESP COCIEN		; desplegar en pantalla
		MOV AX, 4C00H	; salir a DOS
		INT 21H
BEGIN	ENDP
		END BEGIN

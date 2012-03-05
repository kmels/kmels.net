; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 9 de Octubre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; archivo1.asm: Crear un archivo
; **********************************************************************************
DESP	MACRO CADENA
	MOV AH, 09H		; DESPLEGAR MENSAJE
	LEA DX, CADENA
	INT 21H
	ENDM
; **********************************************************************************
CREAR_A	MACRO NOM_ARCHIVO
	MOV	AH, 3CH			; PETICION
	MOV	CX, 00			; ATRIBUTO NORMAL
	LEA DX, NOM_ARCHIVO	; CADENA ASCIIZ
	INT 21H				; LLAMA AL DOS
	MOV	MANEJ, AX		; GUARDA EL MANEJADOR
	ENDM
; **********************************************************************************
CERRAR_A	MACRO MANEJADOR
	MOV	AH, 3EH	; PETICION
	MOV BX, MANEJADOR
	INT	21H
	ENDM
; **********************************************************************************
	.MODEL SMALL
	.STACK 64
; **********************************************************************************
; Area de datos
	.DATA
NOMBRE	DB	'CUENTAS.TXT',00h
MANEJ	DW	?
EXITO	DB	'El archivo se creo exitosamente. Manejador: $'
ERROR		DB	'No pudo crearse el archivo$'

; **********************************************************************************
; Programa principal
	.CODE
BEGIN 	PROC FAR
	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	
	CREAR_A NOMBRE
	JC	FALLO		; SI HAY ERROR, SALE
	DESP EXITO
	MOV DX,MANEJ	; GUARDA EN DL MANEJADOR DE ARCHIVO PARA DESPLIEGUE
	ADD DL, 30H		; CONVIERTE A ASCII
	MOV AH, 02H		; PETICION DE DESPLIEGUE DE UN CARACTER
	INT 21H
	CERRAR_A MANEJ	; CERRAR ARCHIVO ANTES DE SALIR
	JMP SALIR
FALLO:
	DESP ERROR
SALIR:
	MOV AX, 4C00H	; salir a DOS
	INT 21H
BEGIN	ENDP
		END BEGIN

; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 9 de Octubre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; archivo3.asm: abrir y leer desde un archivo
; **********************************************************************************
DESP	MACRO CADENA
	MOV AH, 09H		; DESPLEGAR MENSAJE
	LEA DX, CADENA
	INT 21H
	ENDM
; **********************************************************************************
ABRIR_A	MACRO NOM_ARCHIVO
	MOV AH, 3DH			; petición
	MOV AL, 00H			; modo sólo lectura
	LEA DX, NOM_ARCHIVO	; cadena ASCIIZ
	INT	21H
	MOV	MANEJ, AX		; guardar el manejador
	ENDM
; **********************************************************************************
LEER_A	MACRO MANEJADOR
	MOV	AH, 3FH			; petición
	MOV BX, MANEJ		; manejador
	MOV CX, 256			; longitud del registro
	LEA	DX, DATOS		; registro donde se leen datos
	INT 21H
	ENDM
; **********************************************************************************
	.MODEL SMALL
	.STACK 64
; **********************************************************************************
; Area de datos
	.DATA
NOMBRE		DB	'CUENTAS.TXT',00h
MANEJ		DW	?
EXITO		DB	'El archivo se abrio exitosamente. Manejador: $'
ERROR		DB	'No pudo abrirse el archivo$'
EXITO_L		DB	0DH,0AH,'El archivo se leyo exitosamente.$'
ERROR_L1	DB	'No pudo leerse del archivo$'
ERROR_L2	DB	'No se realizo la lectura completa del archivo$'
DATOS		DB	256 DUP(' ')	; datos que se leen del archivo
FIN			DB	'$'
; **********************************************************************************
; Programa principal
	.CODE
BEGIN 	PROC FAR
	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	
	; ABRIR EL ARCHIVO
	ABRIR_A NOMBRE
	JC	FALLO		; SI HAY ERROR, SALE
	DESP EXITO
	MOV DX,MANEJ	; GUARDA EN DL MANEJADOR DE ARCHIVO PARA DESPLIEGUE
	ADD DL, 30H		; CONVIERTE A ASCII
	MOV AH, 02H		; PETICION DE DESPLIEGUE DE UN CARACTER
	INT 21H
	
	; LEER DESDE EL ARCHIVO
	LEER_A MANEJ
	JC 	error1		; prueba por error
	CMP AX, 00		; en AX retorna el numero de bytes leídos
	JE	error2
	DESP EXITO_L
	DESP DATOS
	JMP SALIR
error1:
	DESP ERROR_L1
	JMP SALIR
error2:
	DESP ERROR_L2
	JMP SALIR
FALLO:
	DESP ERROR
SALIR:	
	MOV AX, 4C00H	; salir a DOS
	INT 21H
BEGIN	ENDP
		END BEGIN

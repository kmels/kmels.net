TITLE P09CTRNM (EXE) Acepta nombres y los centra en la pantalla
	.MODEL SMALL
	.STACK 64
;---------------------------------------------------------------
	.DATA
NAMEPAR	LABEL BYTE		; Lista de parametros nombre:
MAXNLEN	DB 20			; longitud maxima de nombre
NAMELEN	DB ?			; No. de caracteres introducidos
NAMEFLD DB 21 DUP(' ')	; nombre introducido
PROMPT	DB 'Nombre ? ', '$'
ENTRADA	DB 21 DUP(' ')	; cadena de entrada para funcion 3FH de INT 21H
;---------------------------------------------------------------
	.CODE
;----------------Programa principal-----------------------------
BEGIN	PROC FAR
	MOV AX,@data	; Iniciar registros de segmento
	MOV DS, AX
	MOV ES, AX
	CALL LIMPIAR	; Despejar pantalla
CICLO1:
	MOV DX,0000		; Fijar cursor en 00,00
	CALL CURSOR
	CALL MOSTRAR	; Exhibir indicacion
	CALL INGRESAR	; Proporciona entradas del nombre
	CALL LIMPIAR	; Despejar pantalla
	CMP NAMELEN,00	; Se ingreso el nombre ?
	JE SALTO1		; no, vaya a la salida
	CALL CODIFICAR	; Fijar campana y '$'
	CALL CENTRAR	; Centra y exhibe el nombre
	JMP CICLO1
SALTO1:
	CALL REGRESA
	MOV AX,4C00H		; Salir a DOS
	INT 21H
BEGIN	ENDP
;	--------------Exhibir indicador---------------------
MOSTRAR	PROC NEAR
	MOV AH, 09H		; Peticion de exhibicion
	LEA DX, PROMPT
	INT 21H
	RET
MOSTRAR ENDP
;	--------------Acepta entrada de nombre---------------
INGRESAR	PROC NEAR
	MOV AH, 0AH		; Peticion de teclado
	LEA DX, NAMEPAR	; entrada
	INT 21H
	RET
INGRESAR	ENDP
;	--------------Acepta entrada de nombre---------------
INGRESAR3F	PROC NEAR
	MOV AH, 3FH		; Peticion de teclado
	MOV BX, 00		; Manejador de archivo para teclado
	MOV CX, 20		; Maximo 20 caracteres
	LEA DX, ENTRADA	; cadena para entrada, no verifica el maximo
	INT 21H
	MOV NAMELEN, AL	; longitud ingresada esta en AX
	RET
INGRESAR3F	ENDP
;	--------------Fijar campana y delimitador '$'---------
CODIFICAR	PROC NEAR
	MOV BH, 00		; reemplaza caracter enter (0D)
	MOV BL, NAMELEN	; con el de campana (07H)
	MOV NAMEFLD [BX], 07
	MOV NAMEFLD [BX+1], '$'	; pone delimitador de exhibicion
	RET
CODIFICAR	ENDP
;	--------------Centrar y exhibir nombre----------------
CENTRAR	PROC NEAR
	MOV DL, NAMELEN	; Localiza columna central
	SHR DL, 1		; divide longitud en 2
	NEG DL			; invierte el seguro
	ADD DL, 40		; suma 40
	MOV DH, 12		; centra hilera
	CALL CURSOR	; fija cursor
	MOV AH, 09H		
	LEA DX, NAMEFLD	; exhibe nombre
	INT 21H
	RET
CENTRAR ENDP
;	--------------Despejar pantalla-----------------------
LIMPIAR	PROC NEAR
	MOV AX, 0600H	; peticion de recorrido de pantalla
	MOV BH, 0A8H	; color 07 para blanco y negro
					; Probar 30H, 14H, 23H, 7D
	MOV CX, 0000	; de 00,00
	MOV DX, 184FH	; A 24, 79
	INT 10H
	RET
LIMPIAR	ENDP
;	---------------Fijar fila y columna de cursor----------
CURSOR	PROC NEAR	; DX fija entrada
	MOV AH, 02H		; peticion de ubicar cursor pagina 0
	MOV BH, 00
	INT 10H
	RET
CURSOR	ENDP
;	---------------Regresar la pantalla a la normalidad ----
REGRESA	PROC NEAR
	MOV AX, 0600H	; peticion de recorrido de pantalla
	MOV BH, 07H		; color 07 para blanco y negro
	MOV CX, 0000	; de 00,00
	MOV DX, 184FH	; A 24, 79
	INT 10H
	RET
REGRESA	ENDP
END BEGIN

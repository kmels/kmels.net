
; **********************************************************************************
; Macro para inicializar el área de datos
; **********************************************************************************
INITZ 	MACRO			; define macro
		MOV AX, @data
		MOV DS, AX
		MOV ES, AX
		ENDM			; fin macro
; **********************************************************************************
; Macro para Pedir los caracteres
; **********************************************************************************
PEDIR	MACRO CAD, BUS, REM
		
		LEA DX, SMS1        	 ; carga la direccion de la cadena
		CALL COUT
		MOV AH, 0AH    			; peticion de la funcion de entrada
		LEA DX, CAD
		INT 21H	
		MOV AL, ACTLEN
		ADD AL, 1
		MOV MAXLENBUS, AL
		MOV MAXLENREE, AL
	
		LEA DX, ENTRAR
		CALL COUT
		XOR AH, AH
		
		LEA DX, SMS2         	; carga la direccion de la cadena
		CALL COUT
		MOV AH, 0AH    			; peticion de la funcion de entrada
		LEA DX, BUS
		INT 21H	
	
		XOR AH, AH
		LEA DX, ENTRAR
		CALL COUT
		LEA DX, SMS3
		CALL COUT
		MOV AH, 0AH    			; peticion de la funcion de entrada
		LEA DX, REM
		INT 21H	

		ENDM
; **********************************************************************************
; Macro para realizar la busqueda
; **********************************************************************************
REPLACE	MACRO 		; define macro
	LOCAL SALTO
	LOCAL CICLO
	LOCAL SALIRM
	
	CLD						; izq a der
	XOR		SI, SI
SALTO:
	MOV		AL, CAMPOBUS[SI]	; busca en texto
	MOV		CL, ACTLEN
	LEA		DI, CAMPO[SI]
CICLO:
	REPNE	SCASB				; repite mientras no sea igual o CX es 0
	;JNZ		SALIRM				; ?se encontro el caracter?
	DEC		DI					; si, ajusta direccion
	MOV		DL, CAMPOREE[SI]
	MOV 	BYTE PTR[DI], DL	; reemplaza el caracter
	INC 	SI
	CMP 	SI, 9
	JE 		SALIRM
	JNE 	SALTO
	JMP 	CICLO
SALIRM:
	INC 	CANTREM
	LEA DX, ENTRAR
	CALL COUT
	LEA DX, SMS4
	CALL COUT
	LEA	DX, CAMPO
	CALL COUT
	LEA DX, ENTRAR
	CALL COUT
	LEA DX, SMS5
	CALL COUT
	
	MOV DL, CANTREM
	ADD DL, 48
	MOV AH, 02H
	INT 21H
	ENDM			; fin macro
; **********************************************************************************
.MODEL SMALL
.STACK 64
.DATA
;****************************************************************************	
; Definicion de datos
;****************************************************************************	
SMS1 		DB 'Ingrese una cadena con maximno de 20 caracteres: $' ; cadena de despliegue
SMS2 		DB 'Ingrese los caracteres que desea buscar: $' 
SMS3 		DB 'Ingrese los caracteres por los que desea reemplazar: $'
SMS4 		DB 'Cadena reemplazada: $'
SMS5 		DB 'Cantidad de veces remplazadas: $'
CONT		DB	0
CREV		DB	0

LISTA  		LABEL BYTE                     ; inicio de la lista de parametros
MAXLEN 		DB    20                       ; numero maximo de caracteres de entrada
ACTLEN 		DB    ?                        ; numero real de caracteres de entrada
CAMPO  		DB    20 DUP (' ')             ; caracteres introducidos del teclado
FIN    		DB    '$'
ENTRAR  	DB 0DH, 0AH, '$'

LISTABUS  	LABEL BYTE                    ; inicio de la lista de parametros
MAXLENBUS 	DB    ?                       ; numero maximo de caracteres de entrada
ACTLENBUS 	DB    ?                       ; numero real de caracteres de entrada
CAMPOBUS  	DB    20 DUP (' ')            ; caracteres introducidos del teclado
FINBUS    	DB    '$'
ENTRARBUS  	DB 0DH, 0AH, '$'

LISTAREE  	LABEL BYTE                    ; inicio de la lista de parametros
MAXLENREE 	DB    ?                       ; numero maximo de caracteres de entrada
ACTLENREE 	DB    ?                       ; numero real de caracteres de entrada
CAMPOREE 	DB    20 DUP (' ')            ; caracteres introducidos del teclado
FINREE    	DB    '$'
ENTRARREE  	DB 0DH, 0AH, '$'

CANTREM 	DB 0
;****************************************************************************	
; Inicio del codigo
;****************************************************************************	
.CODE
;****************************************************************************	
; Procedimiento para reemplazar la cadena
;****************************************************************************		
REPLACEP PROC NEAR
 	INITZ
	CLD						; izq a der
	XOR		SI, SI
SALT:	
	MOV		AL, CAMPOBUS[SI]	; busca en texto
	MOV		CL, ACTLEN
	LEA		DI, CAMPO[SI]
CIC:REPNE	SCASB			; repite mientras no sea igual o CX es 0
	JNZ		SALIR			; ?se encontro el caracter?
	DEC		DI				; si, ajusta direccion
	MOV		DL, CAMPOREE[SI]
	MOV 	BYTE PTR[DI], DL; reemplaza el caracter
	INC 	SI
	CMP 	SI, 9
	JE 		SALIR
	JNE 	SALT
	JMP 	CIC
SALIR:
	RET
REPLACEP ENDP

;****************************************************************************	
; Procedimiento para tomar primer cadena
;****************************************************************************		
CIN	PROC NEAR
	MOV AH, 0AH    			; peticion de la funcion de entrada
	LEA DX, LISTA 			; carga la direccion de la lista de parametros
	INT 21H        			; llama al DOS
	MOV AL, ACTLEN
	ADD AL, 1
	MOV MAXLENBUS, AL
	MOV MAXLENREE, AL
	RET
CIN	ENDP
;****************************************************************************	
; Procedimiento para tomar primer cadena
;****************************************************************************		
CIN1 PROC NEAR
	MOV AH, 0AH    			; peticion de la funcion de entrada
	LEA DX, LISTABUS  		; carga la direccion de la lista de parametros
	INT 21H					; llama al DOS
	RET
CIN1 ENDP
;****************************************************************************	
; Procedimiento para tomar primer cadena
;****************************************************************************		
CIN2 PROC NEAR
	MOV AH, 0AH    			; peticion de la funcion de entrada
	LEA DX, LISTAREE  		; carga la direccion de la lista de parametros
	INT 21H        			; llama al DOS
	RET
CIN2 ENDP
;****************************************************************************	
; Procedimiento para imprimir texto
;****************************************************************************	
COUT PROC    NEAR           
	MOV AH, 09H	   		
    INT 21H
    RET
COUT ENDP	
;****************************************************************************
; Procedimiento para salir
;****************************************************************************
SALIDA PROC NEAR
	MOV AH, 4CH   			; salida al DOS
	INT 21H
SALIDA ENDP
;****************************************************************************
; Procedimiento Principal
;****************************************************************************
BEGIN	PROC FAR
	INITZ
	PEDIR LISTA, LISTABUS, LISTAREE
	;REPLACE
	
;----------------------------------------------------------------------------------------	
	CLD						; izq a der
	XOR		SI, SI

REV2:
	MOV		AL, CONT
	MOV		AH, ACTLENBUS
	CMP		AL, AH
	JE		RESET
	JMP		SALTO
	
RESET:
	MOV		CONT, 0
	XOR		SI, SI
	
SALTO:
	MOV		AL, CAMPOBUS[SI]	; busca en texto
	MOV		CL, ACTLEN
	LEA		DI, CAMPO[SI]
	

	
CICLO:
	REPNE	SCASB				; repite mientras no sea igual o CX es 0
	JNZ		SALIRM				; ?se encontro el caracter?
	INC		CONT
	DEC		DI					; si, ajusta direccion
	MOV		DL, CAMPOREE[SI]
	MOV 	BYTE PTR[DI], DL	; reemplaza el caracter
	INC 	SI
	;JE 	SALIRM
	;JNE 	SALTO
	JMP 	REV2
SALIRM:
	INC 	CANTREM
	LEA 	DX, ENTRAR
	CALL 	COUT
	LEA 	DX, SMS4
	CALL 	COUT
	LEA		DX, CAMPO
	CALL 	COUT
	LEA 	DX, ENTRAR
	CALL	 COUT
	LEA 	DX, SMS5
	CALL 	COUT
	
	MOV 	DL, CANTREM
	ADD 	DL, 48
	MOV 	AH, 02H
	INT 	21H
;------------------------------------------------------------------------------------	

	CALL SALIDA
BEGIN	ENDP
	END BEGIN

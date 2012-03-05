	;; ****************************************
	;; Author: Carlos Eduardo Lopez Camey
	;; Date: Oct 6, 2009
	;; UVG-CC3005 - Programacion en Assembler
	;; PreLab7.ASM Pre Laboratorio 7
	;;
	;; Descripcion:
	;; 
	;; ****************************************

	;;
	;; Macros
	;;
	
	ValidarQueSeaNumeros	MACRO	Cadena
	LOCAL Salirse_, estamal, comparar
		
		MOV BX,0
		
Comparar:
		CMP Cadena[BX], 0DH
		JE Salirse_			;termino cadena
		
		CMP Cadena[BX], 30H
		JB EstaMal6
		
		CMP Cadena[BX], 39H
		JA EstaMal6
		
		INC BX
		JMP Comparar
		
estamal6:
		MOV HayError, 1
		CopiarCadena_De_A MsgError_MalosCaracteres, MensajeDeError, 50
		
	Salirse_:
	ENDM
	
	
	CopiarCadena_De_A	MACRO	DesdeCual, EnCual, Tamano
		MOV CL, Tamano
		CLD		; de izquierda a derecha
		LEA SI, DesdeCual	; copiar de
		LEA DI, EnCual	; pegar en
		REP MOVSB	; copiar bytes Tamano veces
	ENDM

	EscribirMensaje	MACRO	Cadena
		PUSH DX
		LEA DX, Cadena
		CALL Desplegar
		POP DX
		CALL ImprimirEnter
	ENDM

	LeerCadenaYGuardarEn MACRO Lista
		PUSH AX
		PUSH DX
							
		LEA DX, Lista
		CALL LeerCadena
		
		POP DX
		POP AX
	ENDM
	
	getPosicionDeMemoria	MACRO	Fila,Columna	
		PUSH AX
		PUSH DX	
		PUSH BX
		
		XOR AX, AX
		MOV AL, ColumnaActual	
		MOV DX, 0	
		MOV BX, 12		
		MUL BX				;AX:=AX*Op
		MOV PosicionDeMemoria, AX			; Posicion en memoria = Columna en memoria
		
		XOR AX, AX
		MOV AL, FilaActual
		MOV DX, 0
		MOV BX, 120
		MUL BX
		ADD PosicionDeMemoria, AX			; Posicion en memoria = PosicionEn Memoria + Fila en memoria
		
		POP BX
		POP DX
		POP AX
	ENDM
	
	SumarCeldas	MACRO	Fila, ColumnaInicial, ColumnaFinal, QueMatriz
		LOCAL ProcederASumar, IrASalir1, SumarCelda, Salirse
		PUSH CX
		PUSH AX
		PUSH BX
				
		MOV CL, ColumnaFinal
		CMP CL, ColumnaInicial
		JB IrASalir1			;error
		JMP ProcederASumar
		
IrASalir1:
		JMP Salirse
		
ProcederASumar:				
		SUB CL, ColumnaInicial		;cuantos
		
		MOV AL, ColumnaInicial
		MOV ColumnaActual, AL		
		MOV Resultado, 0
		
SumarCelda:				
		guardarNumeroDeLaCelda_En	FilaActual, ColumnaActual, Numero, QueMatriz	
		MOV AL, Numero
		ADD Resultado, AL
		MOV DL, ColumnaFinal
		ADD DL, 1
		INC ColumnaActual
		CMP ColumnaActual, DL
		JNE	SumarCelda	
		
Salirse:
		POP BX
		POP AX
		POP CX	
	ENDM
	
	guardarNumeroDeLaCelda_En	MACRO	FilaActual, ColumnaActual, Numero, QueMatriz
		LOCAL EstabienN, devolverlo
		PUSH BX
		PUSH AX
		getPosicionDeMemoria	FilaActual, ColumnaActual
		MOV BX, PosicionDeMemoria
		
		MOV AL, QueMatriz[BX]
		
		CMP AL, 2			; es numero?
		JE EstaBienN		;si
		
		;no, error
		MOV HayError,1
		CopiarCadena_De_A MsgError_NoEsNumero, MensajeDeError, 25	
		JMP devolverlo
		
EstaBienN:
		MOV AL, QueMatriz[BX+1]
		MOV Numero, AL

devolverlo:		
		POP AX
		POP BX
	ENDM
	
	ConvertirCadenaANumero		MACRO	Cadena, Longitud, Numero
		Local Mult, Calcular1, Terminar
		PUSH CX
		PUSH BX
		PUSH DX
		PUSH AX
		
		MOV CL, 1
		
		; calcular unidades
		XOR BX, BX
		MOV BL, Longitud
		MOV DL, Cadena[BX-1]
		MOV Numero, DL
		SUB Numero, 30H
				
Calcular1:		
		PUSH CX
		PUSH DX
		
		MOV AL, 1
Mult:		
		MOV DL, 10
		MOV AH, 0
		MUL DL
		DEC CL
		CMP CL, 0
		JE Terminar
		JMP Mult
		
Terminar:
		POP DX
		POP CX

		MOV TemporalWord, AX			; almacenar 1*10 CX veces, en Temporalword		
		
		XOR BX, BX
		MOV BL, Longitud
		SUB BL, CL
		
		MOV AL, Cadena[BX-1]
		SUB AL, 30H
		MOV AH, 0					;para que multiplique		
		MUL TemporalWord			;Op=byte: AX:=AL*Op
		
		;si AX es 0, significa que el numero es 0, entonces añadir 10^(CX-1)
		CMP AX, 0
		JE EsCero
		JMP Sumarle
EsCero:
		MOV AX, TemporalWord
Sumarle:
		ADD WORD PTR Numero,  AX
		
		INC CL
		CMP CL, Longitud
		JNE Calcular1
		
		MOV AL, Numero
		POP AX
		POP DX
		POP BX
		POP CX
	ENDM
	
	
	ConvertirNumeroACadena			MACRO	Numero	, 	Cadena
		LOCAL Calcular,MultiplicarOtravez,TerminarHombre
		PUSH AX				; para multiplicar y dividir
		PUSH CX				; contador
		PUSH DX				; usado para multiplicar con contador
		PUSH BX				; Indice
		MOV CX, 4			;maximo numero a escribir es 2^16-1, es decir 65535 (5 digitos)
		MOV BX, 0
Calcular:							;a hacer 10 ^ CX
		PUSH CX
		PUSH DX
		MOV AX, 1				; AX = 1
MultiplicarOtraVez:							
		MOV DX, 10				
		MUL DX					; AX = DX * AX, i.e. AX = 10*AX, CX veces
		DEC CX
		CMP CX, 0
		
		JE TerminarHombre
		JMP MultiplicarOtraVez
TerminarHombre:		
		POP DX
		POP CX

		MOV TemporalWord, AX
		MOV AX, WORD PTR Numero			;Op=word: AX:=DX:AX / Op, DX = resto
		MOV DX, 0
		DIV	TemporalWord		; Es decir, AX = Numero / (10 ^ CX), DX = resto
		MOV WORD PTR Numero, DX			

		ADD AX, 30H				;AX = Num / (10 ^ CX) + 30H
		MOV WORD PTR Cadena[BX],  AX

		INC BX
		DEC CX
		CMP CX, 0
		JNZ Calcular
		; Las unidades quedaron en PosicionDeMemoria
		ADD Numero, 30H
		MOV AX, WORD PTR Numero
		MOV WORD PTR Cadena[BX],  AX
		
		
		MOV Cadena[BX+1], 24H			; el $
		 		
		POP BX
		POP DX
		POP CX
		POP AX
	ENDM
	
	ModificarContenidoDeCelda_ConNumero	MACRO 	Fila,Columna, QueNumero, QueMatriz
		PUSH BX
		PUSH AX
		getPosicionDeMemoria	Fila, Columna
		MOV BX, PosicionDeMemoria
		
		MOV QueMatriz[BX], 2			;especificar tipo numerico
		MOV AL, QueNumero
		MOV QueMatriz[BX+1], AL
		
		POP AX
		POP BX
	ENDM
	
	ModificarContenidoDeCelda_ConCadena	MACRO 	Fila,Columna, ArregloDeLaCadena, QueMatriz
		LOCAL CopiarCaracter1, copiarElProximo, SalirDeAqui, Estamal1, EstaBien1, Salirdeakii
		PUSH BX
		PUSH CX
		PUSH DI
		PUSH AX
		
		getPosicionDeMemoria Fila,Columna
		MOV BX, PosicionDeMemoria
		
		MOV QueMatriz[BX], 1			;especificar tipo cadena
		
		MOV CX, 10
CopiarCaracter1:
		MOV DI, 10
		SUB DI, CX
		MOV AL, ArregloDeLaCadena[DI]		;Caracter
		
		
		;validar
		
		CMP AL, 0DH
		JE copiarElProximo		;si es, no copiarlo..
		
		CMP AL, 20H
		JB EstaMal1
		
		CMP AL, 07EH
		JA EstaMal1
		
		JMP EstaBien1
Estamal1:
		MOV HayError, 1
		CopiarCadena_De_A MsgError_MalosCaracteres, MensajeDeError, 50
		JMP SalirDeAqui
		
		;verificar que no sea enter (no copiarlo)		
EstaBien1:		
		MOV Pagina1[BX+1], AL			;el BX+1 se refiere a el porque el mero BX es el tipo
copiarElProximo:
		DEC CX
		INC BX

		CMP AL, 0DH					;si es enter, terminar de copiar cadena
		JE SalirDeAqui

		CMP BX, 10
		JNE CopiarCaracter1
		
SalirDeAqui:
		;poner un $ despues de que termine la cadena
		MOV QueMatriz[BX], 24H 		
	
		POP AX
		POP DI
		POP CX
		POP BX
	ENDM	
	
	
	kmels_PedirFilaYColumna	MACRO
		PUSH DX
		EscribirMensaje	kmels_Msg_PedirFila
		LEA DX, ListaDe1CaracterTemp
		CALL	LeerCadena			
		CALL ImprimirEnter				
		; Pasarlo a FilaActual
		MOV DL, CaracterTempArreglo
		MOV	FilaActual, DL
		SUB	FilaActual, 30H
			
		EscribirMensaje kmels_Msg_PedirColumna
		LEA DX, ListaDe1CaracterTemp
		CALL	LeerCadena	
		CALL ImprimirEnter
								
		; Pasarlo a FilaActual
		
		MOV DL, CaracterTempArreglo
		MOV	ColumnaActual, DL
		SUB	ColumnaActual, 30H
		POP DX
	ENDM
	
	kmels_PedirFila_y_columns_inicial_y_final	MACRO
		PUSH DX
		
		EscribirMensaje	kmels_Msg_PedirFila
		LEA DX, ListaDe1CaracterTemp
		CALL	LeerCadena			
		CALL ImprimirEnter
		; Pasarlo a FilaActual
		MOV DL, CaracterTempArreglo
		MOV	FilaActual, DL
		SUB	FilaActual, 30H
		
		EscribirMensaje	kmels_Msg_PdrColumnI
		LEA DX, ListaDe1CaracterTemp
		CALL	LeerCadena			
		CALL ImprimirEnter
		; Pasarlo a FilaActual
		MOV DL, CaracterTempArreglo
		MOV	ColumnaInicial, DL
		SUB	ColumnaInicial, 30H
		
		EscribirMensaje	kmels_Msg_PdrColumnF
		LEA DX, ListaDe1CaracterTemp
		CALL	LeerCadena			
		CALL ImprimirEnter
		; Pasarlo a FilaActual
		MOV DL, CaracterTempArreglo
		MOV	ColumnaFinal, DL
		SUB	ColumnaFinal, 30H
		
		POP DX
	ENDM
	
	InicializarMatriz	MACRO	QueMatriz
		LOCAL InitCelda
		; inicializar matriz
		MOV BX, 11
		MOV DI, 0
InitCelda:
		MOV QueMatriz[BX], 24H
		MOV QueMatriz[DI], 0H
		ADD BX, 12
		ADD DI, 12
		CMP BX, 719
		JNE InitCelda
	ENDM
	
	;; Fin de Macros
	.model small
	.stack 64
	.data

	;; ----------------------------------------
	;; Definicion de algunos datos
	;; ----------------------------------------

	InstruccionesLabel	DB	'Ingresar combinacion de teclas','$'  ;Instrucciones para el usuario
	TeclaEnter 		DB	0DH,0AH,'$'
	
	ListaDe1CaracterTemp 			LABEL	BYTE		      	; Inicio de la lista de parametros
	CaraacterTempLongitudMaxima		DB	2		     						; Longitud maxima de la cadena
	CaracterTempLongitudDeLaCadena	DB	?		 				     		; Longitud real de la cadena
	CaracterTempArreglo				DB	2 DUP (' '),'$'	      				; Arreglo de caracteres
	
	
	ListaDe10CaracteresTemp 		LABEL	BYTE		      	; Inicio de la lista de parametros
	DiezCaracteresTempMaxLen		DB	11		     						; Longitud maxima de la cadena
	DiezCaracteresTempLenReal		DB	?		 				     		; Longitud real de la cadena
	DiezCaracteresTempArreglo		DB	11 DUP (' '),'$'	      				; Arreglo de caracteres
	NumeroTemporal					DW	?
	NumeroTemporalB					DB	?
	
	Numero				DB 	?
	PosicionDeMemoria	DW	?
	FilaActual			DB	?
	ColumnaActual		DB	?
	ColumnaInicial		DB	?
	ColumnaFinal		DB	?
	Resultado			DB	?

	MensajeDeAyuda		DB	' 			Panel de Ayuda			',0DH,0AH,'F1 (o ALT+C): Manejo de Celdas',0DH,0AH,'Ingresar/modificar dato texto',0DH,0AH,'		Ingresar/modificar dato numerico',0DH,0AH,'		Cambio de atributo de las celdas',0DH,0AH,0DH,0AH,'F2 (o ALT+F): Funciones',0DH,0AH,'		Sumar columnas de una fila',0DH,0AH,'		Promedio de columas de una fila',0DH,0AH,0DH,0AH,'F3 (o ALT+A): Archivo',0DH,0AH,'		Abrir archivo',0DH,0AH,'		Guardar archivo',0DH,0AH,'F4 (o ALT+Y):',0DH,0AH,'		Ayuda',0DH,0AH,0DH,0AH,'F5 (o ALT+R): Buscar y remplazar',0DH,0AH,0DH,0AH,'F6 (o ALT+S): Salir'
	
	ColumnaEnMemoria	DW	?			;para el calculo de getposicionenmemoria
	FilaEnMemoria		DW 	?			;para el calculo de getposicionenmemoria
	PaginaActual	DW	?
	Pagina1		DB 	720 DUP  (' ')
	Pagina2		DB 	720 DUP  (' ')
	Pagina3		DB 	720 DUP  (' ')
	TemporalWord	DW	?
	
	
	HayError			DB	?
	MensajeDeError		DB	79 DUP (' ')
	MsgError_MalosCaracteres	DB	'Caracteres no coinciden con el tipo que especifico$'
	MsgError_NoEsNumero	DB	'Alguna celda no es numero$'
	
	; kmels!

	Msg_IrAManejoDeCelda			DB 	'Manejo de celda','$'				; Manejo de celda
	Msg_IrAFunciones		DB	'Funciones $'
	Msg_IrAArchivo		DB	'Archivo $'
	Msg_IrAAyuda		DB 	'Ayuda $'
	Msg_IrAFindYReplace	DB	'Find y replace $'
	Msg_IrASalir		DB	'Salir $'
	
	Msg_ManejoDeCelda1	DB 	'Ingresar/Modificar Celda (String)$'
	Msg_ManejoDeCelda1_1	DB	'Ingresar el string de 10 letras pues$'
	Msg_ManejoDeCelda2	DB	'Ingresar/Modificar Celda (Numero)$'
	Msg_IngresarNumero	DB	'Ingrese numero pes$'
	Msg_ManejoDeCelda3	DB	'Cambio de atributo$'
	Msg_ManejoDeCelda4	DB	'Escribir/Mostrar Celda$'
	Msg_IngresarCadena	DB	'Ingrese cadena $'
	
	Msg_Funciones1		DB 	'Sumar$'
	Msg_Funciones2		DB 	'Promedio$'
		
	PresionoFuncion		DB	'Presiono Funcion','$'			
	NOPresionoFuncion	DB	'NO Presiono Funcion','$'			
	
	kmels_Msg_PedirFila		DB	'Fila: $'
	kmels_Msg_PedirColumna	DB	'Columna: $'
	kmels_Msg_PdrColumnI	DB	'Columna inicial ','$'
	kmels_Msg_PdrColumnF	DB	'Columna final ','$'
	
	kmels_aDondeSaltar		DW	?
	
	kmels_Msg_Noesnada		DB	'No es nada$'
	kmels_Msg_Numerico		DB 	'Numerico $'
	kmels_Msg_Cadena		DB 	'Cadena $'
	
	PresionoCombinacionIncorrecta	DB	'Presiono Combinacion Incorrecta','$'
	
	
	
	
	;; ----------------------------------------
	;; Inicio del codigo
	;; ----------------------------------------

	.CODE

	;; ----------------------------------------
	;; Procedimiento para leer la cadena
	;; ----------------------------------------
	LeerCadena PROC NEAR
		MOV AH,0AH
		INT 21H
		RET
	LeerCadena ENDP

	;; ----------------------------------------
	;; Procedimiento para desplegar
	;; ----------------------------------------
	Desplegar PROC NEAR
		MOV AH, 09H	; Peticion para desplegar
		INT 21H		; llama al DOS
		RET
	Desplegar ENDP

	;; ----------------------------------------
	;; Procedimiento para escribir un enter (caracter 13)
	;; ----------------------------------------

	ImprimirEnter	PROC NEAR
		LEA DX, TeclaEnter
		CALL Desplegar
		RET
	ImprimirEnter	ENDP


	PedirTeclaYSaltar	PROC	NEAR
	
PedirTecla:		
		EscribirMensaje InstruccionesLabel
		MOV AH,00H	; PeticiÃ³n entrada del teclado
		INT 16H		; Llama a DOS
		CMP	AL, 0	; Â¿Se presionÃ³ tecla de funciÃ³n?
		JNZ	IrASalir	; no, es un caracter ASCII
		
		CMP AH, 3BH 		  	; presiono f1 ?		
		;LEA DX, IrAManejoDeCelda
		;MOV kmels_aDondeSaltar, DX
		;JMP kmels_aDondeSaltar     ; si
		JE IrAManejoDeCelda
		
		CMP AH, 2EH				; Presiono Alt+C?
		JE IrAManejoDecelda		;si
		
		CMP	AH, 3CH				;Presiono F2?
		JE	IrAFunciones		; si		
		CMP	AH, 21H				;Presiono Alt+F
		JE	IrAFunciones		; si
		
		CMP	AH, 3DH				;Presiono F3?
		JE	IrAArchivo			; si		
		CMP	AH, 1EH				;Presiono Alt+A
		JE	IrAArchivo			; si
		
		CMP	AH, 3EH				;Presiono F4?
		JE	IrAAyuda			; si		
		CMP	AH, 15H				;Presiono Alt+F
		JE	IrAAyuda			; si
		
		CMP AH, 3FH				;Presiono F5?
		JE IrAFindYReplace		; si
		CMP	AH, 13H				; Presiono Alt+R?
		JE	IrAFindYReplace		; si
		
		CMP	AH, 40H				; Presiono F6 ?
		JE	IrASalir			; si		
		CMP AH, 1FH				; Presiono Alt+S?
		JE IrASalir				; si
		
		EscribirMensaje	PresionoCombinacionIncorrecta
		JMP PedirTecla
		
IrASalir:
		EscribirMensaje	Msg_IrASalir
		JMP Salir
		
IrAManejoDeCelda: 	
		EscribirMensaje	Msg_IrAManejoDeCelda
		JMP ManejoDeCelda

IrAFunciones:
		EscribirMensaje	Msg_IrAFunciones
		JMP Funciones
		
IrAArchivo:
		EscribirMensaje	Msg_IrAArchivo
		JMP PedirTecla
		
IrAAyuda:
		EscribirMensaje	Msg_IrAAyuda
		JMP PedirTecla

IrAFindYReplace:
		EscribirMensaje	Msg_IrAFindYReplace
		JMP PedirTecla
		
	PedirTeclaYSaltar ENDP
	;; ----------------------------------------
	;; Inicio
	;; ----------------------------------------

	Principal	PROC FAR
		MOV AX, @data	; Inicializar el segmento de datos
		MOV DS, AX
		MOV ES, AX
		
		InicializarMatriz Pagina1
		EscribirMensaje MensajeDeAyuda

		MOV Numero, 20
		ConvertirNumeroACadena	Numero, DiezCaracteresTempArreglo
		EscribirMensaje DiezCaracteresTempArreglo
		CALL ImprimirEnter
		MOV Numero, 120
		ConvertirNumeroACadena	Numero, DiezCaracteresTempArreglo
		EscribirMensaje DiezCaracteresTempArreglo
		CALL ImprimirEnter
		
		MOV Numero, 140
		ConvertirNumeroACadena	Numero, DiezCaracteresTempArreglo
		EscribirMensaje DiezCaracteresTempArreglo
		CALL ImprimirEnter
		
		MOV Numero, 211
		ConvertirNumeroACadena	Numero, DiezCaracteresTempArreglo
		EscribirMensaje DiezCaracteresTempArreglo
		CALL ImprimirEnter
		
		MOV Numero, 255
		ConvertirNumeroACadena	Numero, DiezCaracteresTempArreglo
		EscribirMensaje DiezCaracteresTempArreglo
		CALL ImprimirEnter
		
		


		CALL PedirTeclaYSaltar		
		
ManejoDeCelda: 			;(F1)
		CALL ImprimirEnter
		EscribirMensaje Msg_ManejoDeCelda1
		EscribirMensaje Msg_ManejoDeCelda2
		EscribirMensaje Msg_ManejoDeCelda3
		EscribirMensaje Msg_ManejoDeCelda4
		
		MOV AH, 00H			;Pedir Algo
		INT	16H
		CMP AL, 31H			;es uno
		JE	IrAModificarCeldaString
		CMP AL, 32H 		;es dos
		JE IrAModificarCeldaNumerica
		CMP AL, 34H		; es cuatro
		JE IrAEscribirCelda
		JMP PedirTecla

IrAModificarCeldaNumerica:
		JMP	ModificarCeldaNumerica
IrAEscribirCelda:
		JMP EscribirCelda		
IrAModificarCeldaString:
		JMP ModificarCeldaString
		
ModificarCeldaString:
		kmels_PedirFilaYColumna			;Pedir que fila
		getPosicionDeMemoria			FilaActual,ColumnaActual		
		EscribirMensaje					Msg_IngresarCadena
		LeerCadenayGuardarEn			ListaDe10CaracteresTemp
		CALL ImprimirEnter
		
		MOV HayError,0
		ModificarContenidoDeCelda_ConCadena FilaActual,ColumnaActual, DiezCaracteresTempArreglo, Pagina1
		
		CMP HayError, 0
		JNE EstaMal2

		JMP PedirTecla
EstaMal2:
		EscribirMensaje MensajeDeError
		JMP PedirTecla

		
ModificarCeldaNumerica:
		kmels_PedirFilaYColumna			;Pedir que fila
		getPosicionDeMemoria			FilaActual,ColumnaActual		
		EscribirMensaje					Msg_IngresarNumero
		LeerCadenayGuardarEn			ListaDe10CaracteresTemp
		CALL ImprimirEnter
		
		MOV HayError, 0
		
		ConvertirCadenaANumero			DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, Numero
		
		CMP HAYerror, 1
		JE EstaMal7
		
		EscribirMensaje DiezCaracteresTempArreglo
		ModificarContenidoDeCelda_ConNumero	FilaActual,ColumnaActual, Numero, Pagina1
		
		
		
		JMP PedirTecla	

EstaMal7:
		EscribirMensaje MensajeDeError
		JMP PedirTecla				
EscribirCelda:
		kmels_PedirFilaYColumna			;Pedir que fila
		getPosicionDeMemoria			FilaActual,ColumnaActual
		MOV DiezCaracteresTempArreglo, 0H
		
		
		getPosicionDeMemoria FilaActual,ColumnaActual
		
		MOV BX, PosiciondeMemoria
		MOV DL, Pagina1[BX]		;obtener tipo
		
		CMP DL, 0 					;es vacio?
		JE IrASalir1					;si ,salir
				
		CMP DL, 2					;esnumero?
		JE EsDatoNumerico			;si, es dato numercio
		
		CMP DL, 1
		JE esCadena
		
		JMP IrASalir1
esCadena:						;es cadena
		EscribirMensaje kmels_Msg_Cadena
		
		MOV BX, PosiciondeMemoria
		EscribirMensaje Pagina1[BX+1]
		
		;forma 2
		CopiarCadena_De_A Pagina1[BX+1], DiezCaracteresTempArreglo, 10
		EscribirMensaje DiezCaracteresTempArreglo
		
		JMP PedirTecla
IrASalir1:
		EscribirMensaje kmels_Msg_Noesnada		
		JMP PedirTecla
		
esDatoNumerico:
		EscribirMensaje kmels_Msg_Numerico
		MOV BX, PosicionDeMemoria
		
		guardarNumeroDeLaCelda_En	FilaActual, ColumnaActual, Numero, Pagina1
		ConvertirNumeroACadena	Numero, DiezCaracteresTempArreglo
		EscribirMensaje DiezCaracteresTempArreglo
		
		
		;EscribirContenidoDeCelda		FilaActual,ColumnaActual, Pagina1
		JMP PedirTecla

Funciones:
		EscribirMensaje Msg_Funciones1
		EscribirMensaje Msg_Funciones2
		
		MOV AH, 00H			;Pedir Algo
		INT	16H
		CMP AL, 31H			;es uno
		JE	IrASumar
		CMP AL, 32H 		;es dos
		JE IrAPromedio
		JMP PedirTecla
		
IrASumar:
		JMP Sumar
IrAPromedio:
		JMP Promedio		
		
Sumar:
		kmels_PedirFila_y_columns_inicial_y_final
		
		MOV HayError, 0 
		SumarCeldas	FilaActual, ColumnaInicial, ColumnaFinal, Pagina1
		
		CMP HayError, 0
		JE	Estabiensumado	
		
		EscribirMensaje MensajeDeError
		JMP PedirTecla
EstaBienSumado:
		ConvertirNumeroACadena	Resultado, DiezCaracteresTempArreglo
		EscribirMensaje			DiezCaracteresTempArreglo
		JMP PedirTecla
		
Promedio:

		
		kmels_PedirFila_y_columns_inicial_y_final
		
		MOV HayError, 0
		SumarCeldas	FilaActual, ColumnaInicial, ColumnaFinal, Pagina1

		CMP HayError,0 
		JE EstaBienSumado1
		
		EscribirMensaje MensajeDeError
		JMP PedirTecla
EstaBienSumado1:		
		; Dividir dentro del numero de celdas
		MOV AX, WORD PTR Resultado		;almacenar resultado de la suma
		MOV AH, 0
		MOV CL, ColumnaFinal
		ADD CL, 1
		SUB CL, ColumnaInicial		
		DIV	CL							;Op=byte: AL:=AX / Op, dividir!
		MOV Resultado, AL				;almacenarlo en resultado
		ConvertirNumeroACadena	Resultado, DiezCaracteresTempArreglo
		EscribirMensaje			DiezCaracteresTempArreglo
		JMP PedirTecla
				
Salir:
		MOV AH, 4CH		; Salida al DOS
		INT 21H

Principal	ENDP
	END Principal
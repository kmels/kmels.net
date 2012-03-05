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
		MOV ResultadoSuma, 0
		
SumarCelda:				
		guardarNumeroDeLaCelda_En	FilaActual, ColumnaActual, Numero, QueMatriz	
		MOV AL, Numero
		ADD ResultadoSuma, AL
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
		PUSH BX
		PUSH AX
		getPosicionDeMemoria	FilaActual, ColumnaActual
		MOV BX, PosicionDeMemoria
		MOV AL, QueMatriz[BX+1]
		MOV Numero, AL
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
		
		CALL ImprimirEnter
		CALL ImprimirEnter
		EscribirMensaje Cadena
		CALL ImprimirEnter
		CALL ImprimirEnter 
		
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
		LOCAL CopiarCaracter
		PUSH BX
		PUSH CX
		PUSH DI
		PUSH AX
		
		getPosicionDeMemoria Fila,Columna
		MOV BX, PosicionDeMemoria
		
		MOV QueMatriz[BX], 1			;especificar tipo cadena
		
		MOV CX, 10
CopiarCaracter:
		MOV DI, 10
		SUB DI, CX
		MOV AL, ArregloDeLaCadena[DI]		;Caracter
		MOV QueMatriz[BX+1], AL			;el BX+1 se refiere a el porque el mero BX es el tipo
		INC BX
		LOOP CopiarCaracter
	
		POP AX
		POP DI
		POP CX
		POP BX
	ENDM	
	
	EscribirContenidoDeCelda	MACRO	Fila,Columna, QueMatriz
		LOCAL Salir, Esdatonumerico,escadena,irasalir
		PUSH BX
		PUSH DX
		getPosicionDeMemoria Fila,Columna
		
		MOV BX, PosiciondeMemoria
		MOV DL, QueMatriz[BX]		;obtener tipo
		
		CMP DL, 0 					;es vacio?
		JE IrASalir					;si ,salir
				
		CMP DL, 2					;esnumero?
		JE EsDatoNumerico			;si, es dato numercio
esCadena:						;es cadena
		EscribirMensaje kmels_Msg_Cadena
		EscribirMensaje QueMatriz[BX+1]
IrASalir:		
		JMP Salir
		
esDatoNumerico:
		EscribirMensaje kmels_Msg_Numerico
		MOV BX, PosicionDeMemoria
		ConvertirNumeroACadena	QueMatriz[BX+1], DiezCaracteresTempArreglo
		EscribirMensaje DiezCaracteresTempArreglo
	
Salir:		
		POP DX
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
	
	
	Numero				DB 	?
	PosicionDeMemoria	DW	?
	FilaActual			DB	?
	ColumnaActual		DB	?
	ColumnaInicial		DB	?
	ColumnaFinal		DB	?
	ResultadoSuma		DB	?
	ResultadoPromedio	DB	?
	
	ColumnaEnMemoria	DW	?			;para el calculo de getposicionenmemoria
	FilaEnMemoria		DW 	?			;para el calculo de getposicionenmemoria
	PaginaActual	DW	?
	Pagina1		DB 	720 DUP  (' ')
	Pagina2		DB 	720 DUP  (' ')
	Pagina3		DB 	720 DUP  (' ')
	TemporalWord	DW	?
	
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


	;; ----------------------------------------
	;; Inicio
	;; ----------------------------------------

	Principal	PROC FAR
		MOV AX, @data	; Inicializar el segmento de datos
		MOV DS, AX
		MOV ES, AX
		
		
		InicializarMatriz Pagina1
		
		; init suma
		
		MOV Pagina1[1], 30
		MOV Pagina1[13], 60
		MOV Pagina1[25], 20
		MOV Pagina1[37], 5
		
		CALL ImprimirEnter
		CALL ImprimirEnter
		kmels_PedirFila_y_columns_inicial_y_final
		SumarCeldas	FilaActual, ColumnaInicial, ColumnaFinal, Pagina1
		; Dividir dentro del numero de celdas
		
		;Op=byte: AL:=AX / Op
		MOV AX, WORD PTR ResultadoSuma
		MOV AH, 0
		MOV CL, ColumnaFinal
		ADD CL, 1
		SUB CL, ColumnaInicial
		DIV	CL
		MOV ResultadoSuma, AL
		ConvertirNumeroACadena	ResultadoSuma, DiezCaracteresTempArreglo
		EscribirMensaje			DiezCaracteresTempArreglo
		
		
		; fin suma
;PeticiÃ³n de entrada
PedirTecla:		
		EscribirMensaje InstruccionesLabel
		MOV AH,00H	; PeticiÃ³n entrada del teclado
		INT 16H		; Llama a DOS
		CMP	AL, 0	; Â¿Se presionÃ³ tecla de funciÃ³n?
		JNZ	IrASalir	; no, es un caracter ASCII
		
		CMP AH, 3BH 		  	; presiono f1 ?
		JE IrAManejoDeCelda     ; si
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

ManejoDeCelda:
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
		kmels_PedirFilaYColumna			;Pedir que fila
		getPosicionDeMemoria			FilaActual,ColumnaActual		
		EscribirMensaje					Msg_IngresarCadena
		LeerCadenayGuardarEn			ListaDe10CaracteresTemp
		CALL ImprimirEnter
		ModificarContenidoDeCelda_ConCadena FilaActual,ColumnaActual, DiezCaracteresTempArreglo, Pagina1
		JMP PedirTecla
		
ModificarCeldaNumerica:
		kmels_PedirFilaYColumna			;Pedir que fila
		getPosicionDeMemoria			FilaActual,ColumnaActual		
		EscribirMensaje					Msg_IngresarNumero
		LeerCadenayGuardarEn			ListaDe10CaracteresTemp
		CALL ImprimirEnter
		ConvertirCadenaANumero			DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, Numero
		ModificarContenidoDeCelda_ConNumero	FilaActual,ColumnaActual, Numero, Pagina1
		JMP PedirTecla	
		
EscribirCelda:
		kmels_PedirFilaYColumna			;Pedir que fila
		getPosicionDeMemoria			FilaActual,ColumnaActual
		EscribirContenidoDeCelda		FilaActual,ColumnaActual, Pagina1
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
		SumarCeldas	FilaActual, ColumnaInicial, ColumnaFinal, Pagina1
		ConvertirNumeroACadena	ResultadoSuma, DiezCaracteresTempArreglo
		EscribirMensaje			DiezCaracteresTempArreglo
		JMP PedirTecla
		
Promedio:
		
		JMP PedirTecla
				
Salir:
		MOV AH, 4CH		; Salida al DOS
		INT 21H

Principal	ENDP
	END Principal
; Ubicación.....: Universidad del Valle de Guatemala
; Curso.........: CC3005 Programación en Assembler
; Sección.......: 10
; Creadores.....: Byron Orlando Morales Sequen (08414)
; ............... Carlos Lopez Camei (08...)
; Programa......: Proyecto 1
; Entrega.......: Lunes, 19 de octubre de 2009
; Archivo.......: PRO2.ASM
; Descripción...: Simulación de una hoja de cálculo.
;  ============================================================================
;       DEFINICION DE MACROS 
;  ============================================================================
; **********************************************************************************
; **********************************************************************************
; **********************************************************************************
; **********************************************************************************
    guardarNumeroDeLaCelda_En   MACRO   FilaActual, ColumnaActual, Numero, QueMatriz
        PUSH BX
        PUSH AX
        getPosicionDeMemoria    FilaActual, ColumnaActual
        MOV BX, PosicionDeMemoria
        MOV AL, QueMatriz[BX+1]
        MOV Numero, AL
        POP AX
        POP BX
    ENDM
; **********************************************************************************
    SumarCeldas MACRO   Fila, ColumnaInicial, ColumnaFinal, QueMatriz
        LOCAL ProcederASumar, IrASalir1, SumarCelda, Salirse
        PUSH CX
        PUSH AX
        PUSH BX
                
        MOV CL, ColumnaFinal
        CMP CL, ColumnaInicial
        JB IrASalir1            ;error
        JMP ProcederASumar
        
IrASalir1:
        JMP Salirse
        
ProcederASumar:             
        SUB CL, ColumnaInicial      ;cuantos
        
        MOV AL, ColumnaInicial
        MOV ColumnaActual, AL       
        MOV Resultado, 0
        
SumarCelda:             
        guardarNumeroDeLaCelda_En   FilaActual, ColumnaActual, Numero, QueMatriz    
        MOV AL, Numero
        ADD Resultado, AL
        MOV DL, ColumnaFinal
        ADD DL, 1
        INC ColumnaActual
        CMP ColumnaActual, DL
        JNE SumarCelda  
        
Salirse:
        POP BX
        POP AX
        POP CX  
    ENDM
; **********************************************************************************
    ConvertirCadenaANumero      MACRO   Cadena, Longitud, Numero
        Local Mult, Calcular1, Terminar, esCero, sumarle
        
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

        MOV TemporalWord, AX            ; almacenar 1*10 CX veces, en Temporalword      
        
        XOR BX, BX
        MOV BL, Longitud
        SUB BL, CL
        
        MOV AL, Cadena[BX-1]
        SUB AL, 30H
        MOV AH, 0                   ;para que multiplique       
        MUL TemporalWord            ;Op=byte: AX:=AL*Op
        
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
; **********************************************************************************
    LeerCadenaYGuardarEn MACRO Lista
        PUSH AX
        PUSH DX
                            
        LEA DX, Lista
        CALL LeerCadena
        
        POP DX
        POP AX
    ENDM
; **********************************************************************************
ModificarContenidoDeCelda_ConNumero	MACRO 	Fila, Columna, QueNumero, QueMatriz
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
	
; **********************************************************************************
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
	
; **********************************************************************************
CopiarCadena_De_A	MACRO	DesdeCual, EnCual, Tamano
		MOV CL, Tamano
		CLD		; de izquierda a derecha
		LEA SI, DesdeCual	; copiar de
		LEA DI, EnCual	; pegar en
		REP MOVSB	; copiar bytes Tamano veces
	ENDM
	
; **********************************************************************************
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
	
; **********************************************************************************
mostrarCeldaModificada MACRO fila, columna, QueMatriz
	LOCAL esVacio,EsCadena,EsNumero, SalirDeMostrarCelda, IrAEsNumero, CICLO_FILAS, CICLO_columnas, CopiarCaracter, CopiarCaracterV, CopiarCaracterN, salirdeaqui
	PUSHA
    
    getPosicionDeMemoria fila,columna
	MOV BX, posicionDeMemoria
	
	MOV DL, QueMatriz[BX]		;obtener tipo
		
	CMP DL, 0 					;es vacio?
	JE EsVacio					;si ,salir
	
	CMP DL, 2					;esnumero?
	JE IrAEsNumero			;si, es dato numercio
		
	CMP DL, 1
	JE esCadena
		
	JMP Salirdeaqui

EsVacio:

        ;calcular posicion en pantalla            
        CALCULAR_DESPLAZAMIENTO FILA, COLUMNA
        MOV BX, BP

        ; COPIAR CARACTERES
        MOV CX, 0
CopiarCaracterV:
        MOV PANTALLA[BX], ' '
        INC BX
        INC CX
        CMP CX, 10
        JNE CopiarCaracterV
        
        ; PINTAR CAMBIOS
        Cambiar_Celda ColorCeldaInverso
        JMP SALIRDEAQUI

IrAesNumero:
        ;calcular posicion en pantalla            
        CALCULAR_DESPLAZAMIENTO FILA, COLUMNA
        MOV BX, BP

        ;copiarla a diezcaracterestemparreglo
        PUSH    BX
        MOV BX, PosiciondeMemoria
        CopiarCadena_De_A QueMatriz[BX+1], NUMERO_ACT, 1
        ConvertirNumeroACadena NUMERO_ACT, DiezCaracteresTempArreglo
        POP     BX
        
        MOV AL, DiezCaracteresTempArreglo[0]
        MOV PANTALLA[BX+11], AL
        
        ; COPIAR CARACTERES
        MOV CX, 1
CopiarCaracterN:
        MOV PANTALLA[BX], ' '
        INC BX
        INC CX
        CMP CX, 10
        JNE CopiarCaracterN
        
        ; PINTAR CAMBIOS
        JMP SALIRDEAQUI

esCadena:	
        ;calcular posicion en pantalla            
        CALCULAR_DESPLAZAMIENTO FILA, COLUMNA
        MOV BX, BP
        
        ;copiarla a diezcaracterestemparreglo
        PUSH    BX
        MOV BX, PosiciondeMemoria
        CopiarCadena_De_A QueMatriz[BX+1], DiezCaracteresTempArreglo, 10
        POP     BX
        
        ; COPIAR CARACTERES
        MOV CX, 0
CopiarCaracter:
        PUSH    BX
        MOV BX, CX
        MOV AL, DiezCaracteresTempArreglo[BX]
        POP     BX
        MOV PANTALLA[BX], AL
        INC BX
        INC CX
        CMP CX, 10
        JNE CopiarCaracter
        
        ; PINTAR CAMBIOS
        JMP SALIRDEAQUI
        
SalirDeAqui:
        Cambiar_Celda ColorCeldaInverso
        POPA
ENDM

; **********************************************************************************
LeerCadenaYGuardarEn MACRO Lista
		PUSH AX
		PUSH DX
							
		LEA DX, Lista
		MOV AH,0AH
		INT 21H
		
		POP DX
		POP AX
	ENDM

; **********************************************************************************
ModificarContenidoDeCelda_ConCadena MACRO   Fila,Columna, ArregloDeLaCadena, QueMatriz
        LOCAL CopiarCaracter1, copiarElProximo, SalirDeAqui
        PUSH BX
        PUSH CX
        PUSH DI
        PUSH AX
        
        getPosicionDeMemoria Fila,Columna
        MOV BX, PosicionDeMemoria
        
        MOV QueMatriz[BX], 1            ;especificar tipo cadena
        
        MOV CX, 10
CopiarCaracter1:
        MOV DI, 10
        SUB DI, CX
        MOV AL, ArregloDeLaCadena[DI]       ;Caracter
        ;verificar que no sea enter (no copiarlo)       
        CMP AL, 0DH
        JE copiarElProximo      ;si es, no copiarlo..
        
        MOV Pagina1[BX+1], AL           ;el BX+1 se refiere a el porque el mero BX es el tipo
copiarElProximo:
        DEC CX
        INC BX

        CMP AL, 0DH                 ;si es enter, terminar de copiar cadena
        JE SalirDeAqui

        CMP BX, 10
        JNE CopiarCaracter1
        
SalirDeAqui:
        ;poner un $ despues de que termine la cadena
        MOV QueMatriz[BX], 00H
    
        POP AX
        POP DI
        POP CX
        POP BX
    ENDM    
    
; **********************************************************************************
CALCULAR_DESPLAZAMIENTO MACRO FILA, COLUMNA
        LOCAL CICLO_FILAS, CICLO_COLUMNAS
        MOV BP, 0
        
        XOR     CX, CX
        MOV     CL, Fila
        ADD     CX, 5
        XOR     BX, BX
        ADD     BL, Pantalla_Ancho_Fila 
CICLO_FILAS:
        ADD     BP, BX
        LOOP CICLO_FILAS
        
        XOR     CX, CX
        MOV     CL, Columna
        XOR     BX, BX
        ADD     BL, 11
CICLO_COLUMNAS:
        ADD     BP, BX
        LOOP CICLO_COLUMNAS
        
        ADD     BP, 4
        
        ENDM
; **********************************************************************************
IMPRIMIR_MENSAJE    MACRO   MESSAGE, DIGITOS
        PUSHA
        
        MOV     AX, 1301H               ; desplegar prompt
        MOV     BL, ColorFondo          ; Atribut
        MOV BH, 00H                     ; Pagina
        MOV DL, 0                       ; columna de pantalla
    ; LIMPIAR AREA DE MENSAJES
        LEA BP, MENSAJE                 ; linea de prompt
        MOV CX, 80                      ; longitud de linea
        MOV DH, 23                      ; fila y
        INT     10H                     

    ; IMPRIMIR MENSAJE
        LEA BP, MESSAGE                 ; linea de prompt
        XOR CX, CX
        MOV CL, DIGITOS                      ; longitud de linea
        MOV DH, 23                      ; fila y
        INT     10H                     
        
        POPA
        ENDM

; *****************

PROMT_LIMPIO    MACRO
        PUSHA
        
        MOV     AX, 1301H               ; desplegar prompt
        MOV     BL, ColorFondo          ; Atribut
        MOV BH, 00H                     ; Pagina
        MOV DL, 0                       ; columna de pantalla
    ; LIMPIAR AREA DE PROMPT
        LEA BP, MENSAJE                 ; linea de prompt
        MOV CX, 79                      ; longitud de linea
        MOV DH, 24                      ; fila y
        INT     10H                     

    ; IMPRIMIR PROMT
        LEA BP, PROMPT                 ; linea de prompt
        MOV CX, 14                      ; longitud de linea
        MOV DH, 24                      ; fila y
        INT     10H                     
        
        POPA
        ENDM

; **********************************************************************************
MOSTRAR_MENU    MACRO   TEXTO, FILA_INICIO, COLUMNA_INICIAL, ANCHO, FILAS, COLOR
        LOCAL SIGUIENTE_LINEA_SOMBRA
        
        PUSHA
    ; COPIAR VALORES DEL MENU
        LEA     BP, TEXTO
        MOV     MENU_DIRECCION, BP
        MOV     MENU_FILA_INICIO, FILA_INICIO
        MOV     MENU_COLUMNA_INICIO, COLUMNA_INICIAL 
        MOV     MENU_ANCHO, ANCHO
        MOV     MENU_FILAS, FILAS
        MOV     MENU_FILA_ACTUAL, 00H
        
    ; PINTAR SOMBRA 
        MOV     AL, FILA_INICIO
        MOV     AH, FILAS
        ADD     AH, AL
        ADD     AH, 1
        ADD     AL, 1
        MOV     BH, COLUMNA_INICIAL
        ADD     BH, 1
        
        MOV     DH, AL                  ; fila superior de sombra
        LEA     BP, SHADOW              ; caracteres sombreados
        MOV     DL, BH                  ; columna izq de sombra
        MOV     Bh, 00H                 ; pagina 
        MOV     BL, ColorSombra         ; atributo

SIGUIENTE_LINEA_SOMBRA:
        PUSH    AX
        
        MOV     AX, 1301H               ; dibujar caja sombreada
        MOV     CX, WORD PTR ANCHO      ; caracteres
        INT     10H
        INC     DH                      ; siguiente fila
        
        POP     AX
        CMP     DH, AH                  ; se desplegaron todas las columnas?
        JNE     SIGUIENTE_LINEA_SOMBRA  ; no, repetir
        
        
        
        MOSTRAR_CAJA TEXTO, FILA_INICIO, COLUMNA_INICIAL, ANCHO, ANCHO, FILAS, COLOR
        POPA
        ENDM

; **********************************************************************************
MOSTRAR_CAJA    MACRO   TEXTO, FILA_INICIO, COLUMNA_INICIAL, ANCHO, ANCHO_FILA, FILAS, COLOR
        PUSHA
        LEA     BP, TEXTO                       ; linea del menu
        MOSTRAR_CAJA_VERDADERO FILA_INICIO, COLUMNA_INICIAL, ANCHO, ANCHO_FILA, FILAS, COLOR
        POPA
        ENDM

; **********************************************************************************
MOSTRAR_CAJA_VERDADERO    MACRO   FILA_INICIO, COLUMNA_INICIAL, ANCHO, ANCHO_FILA, FILAS, COLOR
        LOCAL SIGUIENTE_LINEA
        
        PUSHA
        MOV     AH, FILAS
        ADD     AH, FILA_INICIO
        
        MOV     DH, FILA_INICIO                 ; fila
        MOV     BH, 00H                         ; pagina 
        MOV     BL, COLOR                       ; Atributo
        MOV     DL, COLUMNA_INICIAL             ; columna
        
SIGUIENTE_LINEA:
        PUSH    AX 
        MOV     AX, 1300H                       ; solicitar menu de despliegue
        XOR     CX, CX
        MOV     CL, ANCHO                       ; longitud de la linea
        PUSH    DX                              ; guarda el registro que contiene fila, columna
        INT     10H
        
        XOR     CX, CX
        ADD     CL, ANCHO_FILA
        ADD     BP, CX                          ; siguiente linea del menu
        POP     DX                              ; recupera registro con fila, columna
        INC     DH                              ; siguiente fila
        POP     AX
        CMP     DH, AH                          ; se mostraron todas las filas?
        JNE     SIGUIENTE_LINEA                 ; no, repetir
        
        POPA
        ENDM

; **********************************************************************************
QUITAR_MENU     MACRO   FILA_INICIAL, COLUMNA_INICIAL, ANCHO, FILAS
        PUSHA
        LEA     BP, PANTALLA
        XOR     BX, BX
        ADD     BL, Pantalla_Ancho_Fila 
        ADD     BL, Pantalla_Ancho_Fila 
        ADD     BL, COLUMNA_INICIAL 
        SUB     BL, Pantalla_Columna_Inicio 
        
        ADD     BP, BX
        
        MOV     AL, BYTE PTR ANCHO
        INC     AL
        MOV     ANCHO_TEMPORAL, AL
        MOV     BL, BYTE PTR FILAS
        INC     BL
        MOV     FILAS_TEMPORAL, BL
        
        MOSTRAR_CAJA_VERDADERO FILA_INICIAL, COLUMNA_INICIAL, ANCHO_TEMPORAL, Pantalla_Ancho_Fila, FILAS_TEMPORAL, ColorCelda
        
        MOV     MENU_FILA_INICIO, 00H
        MOV     MENU_COLUMNA_INICIO, 00H
        MOV     MENU_ANCHO, 00H
        MOV     MENU_FILAS, 00H
        MOV     MENU_FILA_ACTUAL, 00H
        
        POPA
        ENDM

; **********************************************************************************
CAMBIAR_CELDA     MACRO   COLOR
        LOCAL CICLO_FILAS, CICLO_COLUMNAS
    
    ; Calcular desplazamiento en la matriz de la pantalla
        PUSHA
        LEA     BP, PANTALLA
        
        XOR     CX, CX
        MOV     CL, FilaActual
        ADD     CX, 5
        XOR     BX, BX
        ADD     BL, Pantalla_Ancho_Fila 
CICLO_FILAS:
        ADD     BP, BX
        LOOP CICLO_FILAS
        
        XOR     CX, CX
        MOV     CL, ColumnaActual
        XOR     BX, BX
        ADD     BL, 11
CICLO_COLUMNAS:
        ADD     BP, BX
        LOOP CICLO_COLUMNAS
        
        XOR     BX, BX
        ADD     BP, 4
        ADD     BP, BX
        
        
        XOR     AX, AX
        MOV     AL, FilaActual
        ADD     AL, Pantalla_Fila_Inicio
        ADD     AL, 5
        MOV     FILA_INICIAL_TEMPORAL, AL
        MOV     AL, ColumnaActual
        
        MOV     BX, 11
        MUL     BX
        ADD     AL, Pantalla_Columna_Inicio
        ADD     AL, 4
        MOV     COLUMNA_INICIAL_TEMPORAL, al
        MOV     ANCHO_TEMPORAL, 10
        MOV     FILAS_TEMPORAL, 1
        
        MOSTRAR_CAJA_VERDADERO FILA_INICIAL_TEMPORAL, COLUMNA_INICIAL_TEMPORAL, ANCHO_TEMPORAL, Pantalla_Ancho_Fila, FILAS_TEMPORAL, COLOR
        POPA
        ENDM
        
; **********************************************************************************
CAMBIAR_FILA_MENU MACRO   COLOR
        LOCAL CICLO_FILAS, CICLO_COLUMNAS
    
    ; Calcular desplazamiento en la matriz de la pantalla
        PUSHA
        MOV     BP, MENU_DIRECCION
        
        XOR     CX, CX
        MOV     CL, MENU_FILA_ACTUAL
        ADD     CX, 1
        XOR     BX, BX
        ADD     BL, MENU_ANCHO
CICLO_FILAS:
        ADD     BP, BX
        LOOP CICLO_FILAS
        ADD     BP, 1
        
    ; Posicion Vertical
        MOV     AL, MENU_FILA_ACTUAL
        MOV     AH, MENU_FILA_INICIO
        ADD     AL, AH
        INC     AL
        MOV     FILA_INICIAL_TEMPORAL, AL
    ; Posicion horizontal
        MOV     AL, MENU_COLUMNA_INICIO
        ADD     AL, 1
        MOV     COLUMNA_INICIAL_TEMPORAL, al
    ; Ancho
        MOV     AL, MENU_ANCHO
        SUB     AL, 2
        MOV     ANCHO_TEMPORAL, AL
    ; Filas
        MOV     FILAS_TEMPORAL, 1
        
        MOSTRAR_CAJA_VERDADERO FILA_INICIAL_TEMPORAL, COLUMNA_INICIAL_TEMPORAL, ANCHO_TEMPORAL, Pantalla_Ancho_Fila, FILAS_TEMPORAL, COLOR
        POPA
        ENDM
; **********************************************************************************
MOV_APUN MACRO LUGAR, CHARACTERS
    MOV AH, 42H         ; Peticion para mover el apuntador
    MOV AL, LUGAR       ; DESDE INICIO DEL ARCHIVO
    MOV BX, MANEJ       ; MANEJADOR
    MOV CX, 00H         ;
    XOR DX, DX 
    MOV DL, CHARACTERS         ; DESPLAZAMIENTO DE 128 BYTES
    INT 21H
    ENDM
; **********************************************************************************
ABRIR_A MACRO NOM_ARCHIVO
    MOV AH, 3DH         ; peticion
    MOV AL, 010B         ; modo solo lectura
    LEA DX, NOM_ARCHIVO ; cadena ASCIIZ
    INT 21H
    MOV MANEJ, AX       ; guardar el manejador
    ENDM
; **********************************************************************************
CREAR_A MACRO NOM_ARCHIVO
    MOV AH, 3CH         ; PETICION
    MOV CX, 00          ; ATRIBUTO NORMAL
    LEA DX, NOM_ARCHIVO ; CADENA ASCIIZ
    INT 21H             ; LLAMA AL DOS
    MOV MANEJ, AX       ; GUARDA EL MANEJADOR
    ENDM
; **********************************************************************************
LEER_A  MACRO MANEJADOR, CHARACTERS
    MOV AH, 3FH         ; peticion
    MOV DX, BP          ; registro hacia donde se leen datos
    ADD DX, BX
    MOV BX, MANEJADOR   ; manejador
    MOV CX, CHARACTERS  ; longitud del registro
    INT 21H
    ENDM
; **********************************************************************************
ESCRIBIR_A  MACRO CHARACTERS
    MOV DX, BP          ; registro hacia donde se leen datos
    ADD DX, BX
    MOV AH, 40H         ; peticion para escribir
    MOV BX, MANEJ       ; manejador de archivo
    MOV CX, CHARACTERS  ; longitud del registro
    INT 21H             ; llama al DOS
    ENDM
; **********************************************************************************
CERRAR_A    MACRO MANEJADOR
    MOV AH, 3EH         ; PETICION
    MOV BX, MANEJADOR
    INT 21H
    ENDM

;  ============================================================================
;       DEFINICIONES GENERALES
;  ============================================================================
.MODEL SMALL                    ; Modelo pequeño de memoria
.STACK 64                       ; Segmento de la pila 
.DATA
;  ============================================================================
;       DEFINICIONES DE DATOS
;  ============================================================================

ASCII       DB  ?
SCANCODE    DB  ?                                               ; Guarda codigo de rastreo ingresado
SHADOW  DB  80  DUP(0DBH)                                       ; Caracteres de sombreado

MENU_DIRECCION      DW  ?
MENU_FILA_INICIO    DB  ?
MENU_COLUMNA_INICIO DB  ?
MENU_ANCHO          DB  ?
MENU_FILAS          DB  ?
MENU_FILA_ACTUAL    DB  ?

MENUF1  DB  0C9H, 16 DUP(0CDH), 0BBH                            ; Dibuja menu
        DB  0BAH, ' Ing/mod texto  ', 0BAH
        DB  0BAH, ' Ing/mod numero ', 0BAH
        DB  0BAH, ' Cam atributo   ', 0BAH
        DB  0C8H, 16 DUP(0CDH), 0BCH

MENUF2  DB  0C9H, 15 DUP(0CDH), 0BBH                            ; Dibuja menu
        DB  0BAH, ' Suma fila     ', 0BAH
        DB  0BAH, ' Promedio fila ', 0BAH
        DB  0C8H, 15 DUP(0CDH), 0BCH

MENUF3  DB  0C9H, 17 DUP(0CDH), 0BBH                            ; Dibuja menu
        DB  0BAH, ' Abrir archivo   ', 0BAH
        DB  0BAH, ' Guardar archivo ', 0BAH
        DB  0C8H, 17 DUP(0CDH), 0BCH

EJECUTAR_MENUF1 DW  INGRESO_DE_TEXTO, INGRESO_DE_NUMERO, CAMBIAR_ATRIBUTO
EJECUTAR_MENUF2 DW  SUMA, PROMEDIO
EJECUTAR_MENUF3 DW  abrirArchivo, guardarArchivo

MENSAJE DB  80 DUP(' ')
PROMPT  DB      "GasCulator >> "      

PosicionDeMemoria   DW  ?
FilaActual          DB  ?
ColumnaActual       DB  ?
Resultado           DB  ?
Portapapeles        DB  11 DUP(' ')
PaginaActual        DB  ?
HojaGuardada        DB  ?
NombreDelArchivo    DB  256 DUP(' '), 00H

ColorFondo          DB  1FH
ColorCelda          DB  2FH
ColorCeldaInverso   DB  0F2H
ColorSombra         DB  70H
ColorMenu           DB  05FH
ColorMenuInverso    DB  0F5H

FILA_INICIAL_TEMPORAL   DB  ?
COLUMNA_INICIAL_TEMPORAL    DB  ?
ANCHO_TEMPORAL      DB  ?
FILAS_TEMPORAL      DB  ?

Pagina1             DB  (12*10*6) DUP(00H)
Pagina2             DB  (12*10*6) DUP(00H)
Pagina3             DB  (12*10*6) DUP(00H)

Pantalla_Fila_Inicio    DB  4D
Pantalla_Columna_Inicio DB  5D
Pantalla_Ancho          DB  70D
Pantalla_Ancho_Fila     DB  70D
Pantalla_MAXFilas       DB  10
Pantalla_MAXColumnas    DB  6
Pantalla            DB  0C9H, 68 DUP(0CDH), 0BBH
                    DB  0BAH, ' (C)elda  (F)unciones  (A)rchivo  A(y)uda  (R)eemplazar  (S)alir', 4 DUP(' ') , 0BAH
                    DB  0CCH, 0CDH, 0CDH, 0CBH, 10 DUP(0CDH), 0CBH, 10 DUP(0CDH), 0CBH, 10 DUP(0CDH), 0CBH, 10 DUP(0CDH), 0CBH, 10 DUP(0CDH), 0CBH, 10 DUP(0CDH), 0B9H
                    DB  0BAH, '  ', 0BAH, '    A     ', 0BAH, '    B     ', 0BAH, '    C     ', 0BAH, '    D     ', 0BAH, '    E     ', 0BAH, '    F     ', 0BAH
                    DB  0CCH, 0CDH, 0CDH, 0CEH, 10 DUP(0CDH), 0CEH, 10 DUP(0CDH), 0CEH, 10 DUP(0CDH), 0CEH, 10 DUP(0CDH), 0CEH, 10 DUP(0CDH), 0CEH, 10 DUP(0CDH), 0B9H
                    DB  0BAH, ' 1', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 2', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 3', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 4', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 5', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 6', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 7', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 8', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, ' 9', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0BAH, '10', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH, '          ', 0BAH
                    DB  0C8H, 0CDH, 0CDH, 0CAH, 10 DUP(0CDH), 0CAH, 10 DUP(0CDH), 0CAH, 10 DUP(0CDH), 0CAH, 10 DUP(0CDH), 0CAH, 10 DUP(0CDH), 0CAH, 10 DUP(0CDH), 0BCH
                    
	ListaDe10CaracteresTemp 		LABEL	BYTE		      	; Inicio de la lista de parametros
	DiezCaracteresTempMaxLen		DB	11		     						; Longitud maxima de la cadena
	DiezCaracteresTempLenReal		DB	?		 				     		; Longitud real de la cadena
	DiezCaracteresTempArreglo		DB	11 DUP (' '),'$'	      				; Arreglo de caracteres
	NUMERO_act                      DB  ?
    ERROR                           DB  ?
    MENSAJE_ERROR                   DB  79 DUP('*')
    
	Msg_IngresarCadena	    DB	'Ingrese cadena: $'
	Msg_IngresarNumero	    DB	'Ingrese numero: $'
    MSG_INGRESARATRIBUTO    DB  'Ingrese atributo: $'
    MSG_INGRESARFILA        DB  'Ingrese fila: $'
    MSG_INGRESARCOL_INICIAL DB  'Ingrese columna inicial: $'
    MSG_INGRESARCOL_FINAL   DB  'Ingrese columna final: $'
	TemporalWord	DW	?
; ********************************************************************************************************************************************************************
; Para manejo de FUNCIONES
    Fila            DB  ?
    ColumnaInicial  DB  ?
    ColumnaFinal    DB  ?
    NUMERO          DB  ?
; ********************************************************************************************************************************************************************
; Para manejo de archivo
FILE_NAME   LABEL BYTE
MAXLEN      DB  54
ACTLEN      DB  ?
NOMBRE      DB  55 DUP (00H)  ;'DATOS.TXT',00h

MANEJ       DW  ?
ERROR_ABRIR DB  'No pudo abrirse el archivo$'
ERROR_CREAR DB  'No pudo crearse el archivo$'
ERROR_L1    DB  'No pudo leerse del archivo$'
ERROR_L2    DB  'No se encontro el codigo en el archivo$'
ERROR_E1    DB  'No pudo escribirse en el archivo$'
ERROR_E2    DB  'No se realizo la escritura completa en el archivo$'
ERROR_M     DB  'No se realizo el movimiento del apuntador.$'
; ********************************************************************************************************************************************************************
; Para manejo de ayuda
MensajeDeAyuda DB 'Panel de Ayuda',0DH,0AH,'F1 (o C): Manejo de Celdas',0DH,0AH,'   Ingresar/modificar dato texto',0DH,0AH,'   Ingresar/modificar dato numerico',0DH,0AH,'   Cambio de atributo de las celdas',0DH,0AH,'F2 (o F): Funciones',0DH,0AH,'   Sumar columnas de una fila',0DH,0AH,'   Promedio de columas de una fila',0DH,0AH,'F3 (o A): Archivo',0DH,0AH,'   Abrir archivo',0DH,0AH,'   Guardar archivo',0DH,0AH,'F4 (o Y): Ayuda',0DH,0AH,'F5 (o R): Buscar y reemplazar en todas las celdas',0DH,0AH,'F6 (o S): Salir',0DH,0AH,0DH,0AH,'Hecho por Byron Morales Sequen (08414) y Carlos Lopez Camei (08___).', 0DH,0AH, 'Universidad del Valle de Guatemala (2009), Facultad de Ingenieria - Departamento de Computacion.', 0DH,0AH, 0DH,0AH, 'Este trabajo esta licenciado bajo la licencia GNU LGPL 1.',0DH,0AH, '(http://creativecommons.org/licenses/LGPL/)', 0DH,0AH, '$'

.386                                                            ; directiva que permite uso de instrucciones como PUSHA,POPA,MOVZX
.CODE
;  ============================================================================
;       PROCEDIMTIENTO PRINCIPAL
;  ============================================================================
MAIN    PROC    FAR
        MOV     AX, @data               ; inicializar segmento de datos
        MOV     DS, AX
        MOV     ES, AX
        
        CALL    LIMPIAR_PANTALLA        ; Limpiar pantalla
        CALL    CUADRICULA
        MOV     FilaActual, 0
        MOV     ColumnaActual, 0
        CAMBIAR_CELDA ColorCeldaInverso
        CALL    ESPERAR_MODO_EDICION

        CALL    salirDelPrograma
MAIN    ENDP
;  ============================================================================
;       Despliega IMPRIME LA REGILLA
;  ============================================================================
CUADRICULA  PROC NEAR
        PUSHA                           ; guardar todos los registros
        ; Pintar Pantalla
        MOSTRAR_CAJA PANTALLA, 4, 5, 70, 70, 16, ColorCelda
        POPA                            ; recuperar registros
        RET
CUADRICULA ENDP
;  ============================================================================
;       Limpiar pantalla
;  ============================================================================
LIMPIAR_PANTALLA PROC   NEAR
        PUSHA                           ; guardar registros
        MOV     AX, 0600H
        MOV     BH, ColorFondo          ; azul sobre cafe
        MOV     CX, 0000H               ; pantalla completa
        MOV     DX, 184FH               ; fila 24, col 79
        INT     10H
        POPA                            ; recuperar registros
        RET
LIMPIAR_PANTALLA ENDP
;  ============================================================================
;       Espera del modo edición
;  ============================================================================
ESPERAR_MODO_EDICION     PROC     NEAR

        PUSHA
;         MOV     AX, 1301H               ; desplegar prompt
;         MOV     BL, ColorFondo          ; Atributo
;         MOV BH, 00H                     ; Pagina
;         MOV DL, 0                       ; columna de pantalla
;     ; PROMPT
;         LEA BP, PROMPT                  ; linea de prompt
;         MOV CX, 14                      ; longitud de linea
;         MOV DH, 24                      ; fila y
;         INT     10H                     
    
ESPERAR_TECLA:    
        PROMT_LIMPIO
        MOV    BH, 00                   ; Espera que la tecla presionada sea F1 para desplegar
        MOV    AH, 0CH                  ; el menu, en caso contrario no hace nada
        INT    16H
        MOV    AH, 10H
        INT    16H
        MOV    ASCII, AL
        MOV    SCANCODE, AH
        
        CMP     AH, 50H                 ; cod rastreo flecha ABAJO?
        JE      FLECHA_ABAJO
        CMP     AH, 48H                 ; cod rastreo flecha ARRIBA?
        JE      FLECHA_ARRIBA
        CMP     AH, 4BH                 ; flecha izquierda?
        JE      FLECHA_IZQUIERDA
        CMP     AH, 4DH                 ; flecha derecha?
        JE      FLECHA_DERECHA
        CMP     AH, 0FH                 ; TAB?
        JE      FLECHA_DERECHA
        CMP     AL, 0DH                 ; ascii enter?
        JE      TECLA_ENTER
        CMP     AH, 47H                 ; TECLA INICIO
        JE      TECLA_INICIO
        CMP     AH, 4FH                 ; TECLA FIN
        JE      TECLA_FIN
        CMP     AL, 03H                 ; Control C
        JE      COPIAR_CELDA
        CMP     AL, 16H                 ; Control V
        JE      PEGAR_CELDA


        CMP    AH, 3BH                   ; F1?
        JE     MANEJO_DE_CELDAS
        CMP    AL, 63H                   ; ASCII C?
        JE     MANEJO_DE_CELDAS
        CMP    AH, 3CH                   ; F2?
        JE     FUNCIONES
        CMP    AL, 66H                   ; ASCII F?
        JE     FUNCIONES
        CMP    AH, 3DH                   ; F3?
        JE     ARCHIVO
        CMP    AL, 61H                   ; ASCII A?
        JE     ARCHIVO
        CMP    AH, 3EH                   ; F4?
        JE     AYUDA
        CMP    AL, 79H                   ; ASCII Y?
        JE     AYUDA
        CMP    AH, 3FH                   ; F5?
        JE     REEMPLAZAR
        CMP    AL, 72H                   ; ASCII R?
        JE     REEMPLAZAR
        CMP    AH, 40H                   ; F6?
        JE     LLAMAR_SALIDA
        CMP    AL, 73H                   ; ASCII S?
        JE     LLAMAR_SALIDA
        


        JMP ESPERAR_TECLA

FLECHA_ARRIBA:    
        CAMBIAR_CELDA ColorCelda        ; regresar linea ant a video normal
        DEC FilaActual                  ; fila anterior
        CMP FilaActual, 0               ; se paso de la primera fila?
        JGE SELECCIONAR_CELDA            ; no, ok
        MOV FilaActual, 9               ; si, iniciar fila
        JMP SELECCIONAR_CELDA            

FLECHA_ABAJO:    
        CAMBIAR_CELDA ColorCelda        ; regresar linea ant a video normal
        INC FilaActual                  ; fila siguiente
        MOV BL, Pantalla_MAXFilas
        CMP FilaActual, BL              ; se paso de la ultima fila?
        JB SELECCIONAR_CELDA            ; no, ok
        MOV FilaActual, 0               ; si, iniciar fila
        JMP SELECCIONAR_CELDA
        
FLECHA_IZQUIERDA:    
        CAMBIAR_CELDA ColorCelda        ; regresar linea ant a video normal
        DEC ColumnaActual               ; fila anterior
        CMP ColumnaActual, 0            ; se paso de la primera fila?
        JGE SELECCIONAR_CELDA            ; no, ok
        MOV ColumnaActual, 5            ; si, iniciar fila
        JMP SELECCIONAR_CELDA            

FLECHA_DERECHA:    
        CAMBIAR_CELDA ColorCelda        ; regresar linea ant a video normal
        INC ColumnaActual               ; fila siguiente
        MOV BL, Pantalla_MAXColumnas
        CMP ColumnaActual, BL           ; se paso de la ultima fila?
        JB SELECCIONAR_CELDA            ; no, ok
        MOV ColumnaActual, 0            ; si, iniciar fila
        JMP SELECCIONAR_CELDA

TECLA_ENTER:    
        CAMBIAR_CELDA ColorCelda        ; regresar linea ant a video normal
        INC FilaActual                  ; fila siguiente
        MOV ColumnaActual, 0            ; si, iniciar fila
        MOV BL, Pantalla_MAXFilas
        CMP FilaActual, BL              ; se paso de la ultima fila?
        JB SELECCIONAR_CELDA            ; no, ok
        MOV FilaActual, 0               ; si, iniciar fila
        JMP SELECCIONAR_CELDA

TECLA_INICIO:    
        CAMBIAR_CELDA ColorCelda        ; regresar linea ant a video normal
        MOV FilaActual, 0               ; si, iniciar fila
        MOV ColumnaActual, 0            ; si, iniciar fila
        JMP SELECCIONAR_CELDA

TECLA_FIN:    
        CAMBIAR_CELDA ColorCelda        ; regresar linea ant a video normal
        MOV FilaActual, 9               ; si, iniciar fila
        MOV ColumnaActual, 5            ; si, iniciar fila
        JMP SELECCIONAR_CELDA

COPIAR_CELDA:
        CALL copiarCelda                ; copia la celda actual
        JMP ESPERAR_TECLA
        
PEGAR_CELDA:
        CALL pegarCelda                 ; copia la celda actual
        JMP ESPERAR_TECLA
        
SELECCIONAR_CELDA:
        CAMBIAR_CELDA ColorCeldaInverso ; regresar linea ant a video SELECCIONADO
        JMP ESPERAR_TECLA
        
MANEJO_DE_CELDAS:
        CALL MOSTRAR_MENUF1
        JMP ESPERAR_TECLA;
FUNCIONES:
        CALL MOSTRAR_MENUF2
        JMP ESPERAR_TECLA;
ARCHIVO:
        CALL MOSTRAR_MENUF3
        JMP ESPERAR_TECLA;
AYUDA:
        CALL alternarPantallaDeAyuda
        JMP ESPERAR_TECLA;
REEMPLAZAR:
        CALL buscarYReemplazarTodasLasCeldas
        JMP ESPERAR_TECLA;

LLAMAR_SALIDA:   
        CALL    salirDelPrograma

SALIR_DE_LA_ESPERA:  
        POPA
        RET

ESPERAR_MODO_EDICION    ENDP
;  ============================================================================
;       Imprimir Y MANEJAR MENU DE CELDAS
;  ============================================================================
MOSTRAR_MENUF1  PROC    NEAR
        MOSTRAR_MENU MENUF1, 6, 6, 18, 5, ColorMenu
        CAMBIAR_FILA_MENU ColorMenuInverso
        
ESPERAR_MANEJADORF1:
        MOV     AH, 10H                 ; leer caracter de teclado
        INT     16H
        
        CMP     AL, 1BH                 ; ascii esc?
        JE      SALIR_DEL_MENUF1
        CMP     AL, 0DH                 ; ascii enter?
        JE      F1_TECLA_ENTER
        CMP     AH, 50H                 ; cod rastreo flecha ABAJO?
        JE      F1_FLECHA_ABAJO
        CMP     AH, 48H                 ; cod rastreo flecha ARRIBA?
        JE      F1_FLECHA_ARRIBA
        CMP     AH, 4BH                 ; flecha izquierda?
        JE      F1_FLECHA_IZQUIERDA
        CMP     AH, 4DH                 ; flecha derecha?
        JE      F1_FLECHA_DERECHA
        
        JMP ESPERAR_MANEJADORF1
        
F1_FLECHA_ARRIBA:
        CAMBIAR_FILA_MENU ColorMenu     ; regresar linea ant a video normal
        DEC MENU_FILA_ACTUAL            ; fila anteriSor
        CMP MENU_FILA_ACTUAL, 0         ; se paso de la primera fila?
        JGE F1_PINTAR_FILA_SELECCIONADA ; no, ok
        MOV AL, MENU_FILAS
        SUB AL, 3
        MOV MENU_FILA_ACTUAL, AL         ; si, iniciar fila
        JMP F1_PINTAR_FILA_SELECCIONADA

F1_FLECHA_ABAJO:
        CAMBIAR_FILA_MENU ColorMenu     ; regresar linea ant a video normal
        INC MENU_FILA_ACTUAL            ; fila siguiente
        MOV AL, MENU_FILAS
        SUB AL, 2
        CMP MENU_FILA_ACTUAL, AL        ; se paso de la ultima fila?
        JB F1_PINTAR_FILA_SELECCIONADA  ; no, ok
        MOV MENU_FILA_ACTUAL, 0         ; si, iniciar fila
        JMP F1_PINTAR_FILA_SELECCIONADA

F1_FLECHA_DERECHA:
        QUITAR_MENU 6, 6, 18, 5
        CAMBIAR_CELDA ColorCeldaInverso
        CALL MOSTRAR_MENUF2
        JMP SALIR_DEL_MENUF1
        
F1_FLECHA_IZQUIERDA:
        QUITAR_MENU 6, 6, 18, 5
        CAMBIAR_CELDA ColorCeldaInverso
        CALL MOSTRAR_MENUF3
        JMP SALIR_DEL_MENUF1

F1_TECLA_ENTER:
        XOR BX, BX
        MOV BL, MENU_FILA_ACTUAL
        SHL BX, 1
        PUSH BX
        QUITAR_MENU 6, 6, 18, 5
        POP BX
        JMP EJECUTAR_MENUF1[BX] 
        
F1_PINTAR_FILA_SELECCIONADA:
        CAMBIAR_FILA_MENU ColorMenuInverso
        JMP ESPERAR_MANEJADORF1

SALIR_DEL_MENUF1:
        QUITAR_MENU 6, 6, 18, 5
        RET
        ENDP
;  ============================================================================
;       Imprimir Y MANEJAR MENU DE FUNCIONES
;  ============================================================================
MOSTRAR_MENUF2  PROC    NEAR
        MOSTRAR_MENU MENUF2, 6, 15, 17, 4, ColorMenu
        CAMBIAR_FILA_MENU ColorMenuInverso
        
ESPERAR_MANEJADORF2:
        MOV     AH, 10H                 ; leer caracter de teclado
        INT     16H
        
        CMP     AL, 1BH                 ; ascii esc?
        JE      SALIR_DEL_MENUF2
        CMP     AL, 0DH                 ; ascii enter?
        JE      F2_TECLA_ENTER
        CMP     AH, 50H                 ; cod rastreo flecha ABAJO?
        JE      F2_FLECHA_ABAJO
        CMP     AH, 48H                 ; cod rastreo flecha ARRIBA?
        JE      F2_FLECHA_ARRIBA
        CMP     AH, 4BH                 ; flecha izquierda?
        JE      F2_FLECHA_IZQUIERDA
        CMP     AH, 4DH                 ; flecha derecha?
        JE      F2_FLECHA_DERECHA
        
        JMP ESPERAR_MANEJADORF2
        
F2_FLECHA_ARRIBA:
        CAMBIAR_FILA_MENU ColorMenu     ; regresar linea ant a video normal
        DEC MENU_FILA_ACTUAL            ; fila anteriSor
        CMP MENU_FILA_ACTUAL, 0         ; se paso de la primera fila?
        JGE F2_PINTAR_FILA_SELECCIONADA ; no, ok
        MOV AL, MENU_FILAS
        SUB AL, 3
        MOV MENU_FILA_ACTUAL, AL         ; si, iniciar fila
        JMP F2_PINTAR_FILA_SELECCIONADA

F2_FLECHA_ABAJO:
        CAMBIAR_FILA_MENU ColorMenu     ; regresar linea ant a video normal
        INC MENU_FILA_ACTUAL            ; fila siguiente
        MOV AL, MENU_FILAS
        SUB AL, 2
        CMP MENU_FILA_ACTUAL, AL        ; se paso de la ultima fila?
        JB F2_PINTAR_FILA_SELECCIONADA  ; no, ok
        MOV MENU_FILA_ACTUAL, 0         ; si, iniciar fila
        JMP F2_PINTAR_FILA_SELECCIONADA

F2_FLECHA_DERECHA:
        QUITAR_MENU 6, 15, 17, 4
        CAMBIAR_CELDA ColorCeldaInverso
        CALL MOSTRAR_MENUF3
        JMP SALIR_DEL_MENUF2
        
F2_FLECHA_IZQUIERDA:
        QUITAR_MENU 6, 15, 17, 4
        CAMBIAR_CELDA ColorCeldaInverso
        CALL MOSTRAR_MENUF1
        JMP SALIR_DEL_MENUF2

F2_TECLA_ENTER:
        XOR BX, BX
        MOV BL, MENU_FILA_ACTUAL
        SHL BX, 1
        PUSH BX
        QUITAR_MENU 6, 15, 17, 4
        POP BX
        JMP EJECUTAR_MENUF2[BX] 
        
F2_PINTAR_FILA_SELECCIONADA:
        CAMBIAR_FILA_MENU ColorMenuInverso
        JMP ESPERAR_MANEJADORF2

SALIR_DEL_MENUF2:
        QUITAR_MENU 6, 15, 17, 4
        RET
        ENDP
;  ============================================================================
;       Imprimir Y MANEJAR MENU DE ARCHIVO
;  ============================================================================
MOSTRAR_MENUF3  PROC    NEAR
        MOSTRAR_MENU MENUF3, 6, 28, 19, 4, ColorMenu
        CAMBIAR_FILA_MENU ColorMenuInverso
        
ESPERAR_MANEJADORF3:
        MOV     AH, 10H                 ; leer caracter de teclado
        INT     16H
        
        CMP     AL, 1BH                 ; ascii esc?
        JE      SALIR_DEL_MENUF3
        CMP     AL, 0DH                 ; ascii enter?
        JE      F3_TECLA_ENTER
        CMP     AH, 50H                 ; cod rastreo flecha ABAJO?
        JE      F3_FLECHA_ABAJO
        CMP     AH, 48H                 ; cod rastreo flecha ARRIBA?
        JE      F3_FLECHA_ARRIBA
        CMP     AH, 4BH                 ; flecha izquierda?
        JE      F3_FLECHA_IZQUIERDA
        CMP     AH, 4DH                 ; flecha derecha?
        JE      F3_FLECHA_DERECHA
        
        JMP ESPERAR_MANEJADORF3
        
F3_FLECHA_ARRIBA:
        CAMBIAR_FILA_MENU ColorMenu     ; regresar linea ant a video normal
        DEC MENU_FILA_ACTUAL            ; fila anteriSor
        CMP MENU_FILA_ACTUAL, 0         ; se paso de la primera fila?
        JGE F3_PINTAR_FILA_SELECCIONADA ; no, ok
        MOV AL, MENU_FILAS
        SUB AL, 3
        MOV MENU_FILA_ACTUAL, AL         ; si, iniciar fila
        JMP F3_PINTAR_FILA_SELECCIONADA

F3_FLECHA_ABAJO:
        CAMBIAR_FILA_MENU ColorMenu     ; regresar linea ant a video normal
        INC MENU_FILA_ACTUAL            ; fila siguiente
        MOV AL, MENU_FILAS
        SUB AL, 2
        CMP MENU_FILA_ACTUAL, AL        ; se paso de la ultima fila?
        JB F3_PINTAR_FILA_SELECCIONADA  ; no, ok
        MOV MENU_FILA_ACTUAL, 0         ; si, iniciar fila
        JMP F3_PINTAR_FILA_SELECCIONADA

F3_FLECHA_DERECHA:
        QUITAR_MENU 6, 28, 19, 4
        CAMBIAR_CELDA ColorCeldaInverso
        CALL MOSTRAR_MENUF1
        JMP SALIR_DEL_MENUF3
        
F3_FLECHA_IZQUIERDA:
        QUITAR_MENU 6, 28, 19, 4
        CAMBIAR_CELDA ColorCeldaInverso
        CALL MOSTRAR_MENUF2
        JMP SALIR_DEL_MENUF3

F3_TECLA_ENTER:
        XOR BX, BX
        MOV BL, MENU_FILA_ACTUAL
        SHL BX, 1
        PUSH BX
        QUITAR_MENU 6, 28, 19, 4
        POP BX
        JMP EJECUTAR_MENUF3[BX] 
        
F3_PINTAR_FILA_SELECCIONADA:
        CAMBIAR_FILA_MENU ColorMenuInverso
        JMP ESPERAR_MANEJADORF3

SALIR_DEL_MENUF3:
        QUITAR_MENU 6, 28, 19, 4
        RET
        ENDP
;  ============================================================================
;       Salir al DOS
;  ============================================================================
salirDelPrograma PROC NEAR
    ; VERIFICAR SI SE GUARDO DECUMENTO
        CALL verificarSiHojaEstaGuardada
    ; REGRESAR AL MODO DE TEXTO NORMAL
        MOV AX, 0600H                   ; si, terminar
        MOV    AX, 0600H                ; Peticion de recorrido de pantalla
        MOV    BH, 07H                  ; Fondo negro y letras grises
        MOV    CX, 0000                 ; Inicia en 00,00
        MOV    DX, 184FH                ; Termina en 24, 79
        INT    10H
    ; Salir al DOS
        MOV AX, 4C00H                   ; salir a DOS
        INT 21H
        ENDP
;  ============================================================================
;       ABRIR ARCHIVO
;  ============================================================================
abrirArchivo PROC NEAR
        ; VACIAR NOMBRE DEL ARCHIVO
        LEA BX, NOMBRE
        XOR CX, CX
        MOV CL, ACTLEN
        INC CX
VACIAR_NOMBRE_ARCHIVO:
        MOV [BX], 00H
        INC BX
        LOOP VACIAR_NOMBRE_ARCHIVO
        
        ; PEDIR NOMBRE DEL ARCHIVO
        PROMT_LIMPIO
        LEA DX, FILE_NAME              ; LEER CADENA
        MOV AH,0AH
        INT 21H
        
        ; QUITAR CARACTER DEL FINAL
        XOR AX, AX
        MOV AL, ACTLEN
        LEA BX, NOMBRE
        ADD BX, AX
        MOV [BX], 00H

        ; ABRIR EL ARCHIVO
        ABRIR_A NOMBRE
        JC FALLO_ABRIR                          ; SI HAY ERROR, SALE
        
        ; CAMBIAR EL MANEJADOR AL INICIO
        MOV_APUN 0, 0
        JC FALLO_APUNTADOR                      ; SI HAY ERROR, SALE

        ; CARGAR ARCHIVO AL AREA DE DATOS DE ESTE PROGRAMA
        ; LEER DESDE EL ARCHIVO
        MOV CX, 3; (10*12*6)
        MOV BX, 0
        LEA BP, PAGINA1
ABRIR:
        PUSH    BX
        PUSH    CX
        LEER_A MANEJ, 720
        JC ERROR_LECTURA1                       ; prueba por error
        CMP AX, 720                             ; en AX retorna el numero de bytes leidos
        JNE ERROR_LECTURA2
        POP     CX
        POP     BX
        ADD     BX, 720
        LOOP    ABRIR
        
        ; Mover datos al area de despliegue
        MOV AL, FilaActual
        MOV AH, ColumnaActual
        PUSH AX
        
        XOR CX, CX
        XOR BX, BX
        MOV CL, 0
ABRIR_FILAS:
        MOV FilaActual, CL
        MOV BL, 0
;         PUSH    CX
ABRIR_COLUMNAS:
        MOV ColumnaActual, BL
        mostrarCeldaModificada          FilaActual, ColumnaActual, Pagina1        
;         Cambiar_Celda ColorCelda
        INC BL
        CMP BL, 6
        JNE ABRIR_COLUMNAS
;         POP     CX
        INC CL
        CMP CL, 10
        JNE ABRIR_FILAS
        
        POP AX
        MOV FilaActual, AL
        MOV ColumnaActual, AH
;         Cambiar_Celda ColorCeldaInverso        
        
        ; REPINTAR MATRIZ DE LA PANTALLA
        CALL CUADRICULA
        Cambiar_Celda ColorCeldaInverso        
        
        JMP SALIR_ABRIR;
FALLO_ABRIR:
        IMPRIMIR_MENSAJE ERROR_ABRIR, 26
        JMP SALIR_ABRIR
FALLO_APUNTADOR:
        IMPRIMIR_MENSAJE ERROR_M, 42
        JMP SALIR_ABRIR
ERROR_LECTURA1:
        IMPRIMIR_MENSAJE ERROR_L1, 26
        JMP SALIR_ABRIR
ERROR_LECTURA2:
        IMPRIMIR_MENSAJE ERROR_L2, 38
        JMP SALIR_ABRIR
SALIR_ABRIR:
        RET
        ENDP
;  ============================================================================
;       Guardar Archivos en Disco
;  ============================================================================
guardarArchivo PROC NEAR
        ; VACIAR NOMBRE DEL ARCHIVO
        LEA BX, NOMBRE
        CMP [BX], 00H
        JNE GUARDAR_ARCHIVO_CON_NOMBRE
        
        ; PEDIR NOMBRE DEL ARCHIVO
        PROMT_LIMPIO
        LEA DX, FILE_NAME              ; LEER CADENA
        MOV AH,0AH
        INT 21H
        
        ; QUITAR CARACTER DEL FINAL
        XOR AX, AX
        MOV AL, ACTLEN
        LEA BX, NOMBRE
        ADD BX, AX
        MOV [BX], 00H

GUARDAR_ARCHIVO_CON_NOMBRE:
        ; CREAR EL ARCHIVO
        CREAR_A NOMBRE
        JC  FALLO_CREAR                         ; SI HAY ERROR, SALE
        
        ; CAMBIAR EL MANEJADOR AL INICIO
        MOV_APUN 0, 0
        JC FALLO_APUNTADOR_CREAR                ; SI HAY ERROR, SALE

        ; CARGAR EN EL ARCHIVO EL AREA DE DATOS DE ESTE PROGRAMA
        ; ESCRIBIR EN EL ARCHIVO
        MOV CX, 3; (10*12*6)
        MOV BX, 0
        LEA BP, PAGINA1
CREAR:
        PUSH    BX
        PUSH    CX
        ESCRIBIR_A 720
        JC ERROR_ESCRITURA1                       ; prueba por error
        CMP AX, 720                               ; en AX retorna el numero de bytes leidos
        JNE ERROR_ESCRITURA2
        POP     CX
        POP     BX
        ADD     BX, 720
        LOOP    CREAR
        
    ; Cerrar archivo
        CERRAR_A MANEJ  ; CERRAR ARCHIVO ANTES DE SALIR
        
        JMP SALIR_CREAR;
        
FALLO_CREAR:
        IMPRIMIR_MENSAJE ERROR_CREAR, 26
        JMP SALIR_CREAR
FALLO_APUNTADOR_CREAR:
        IMPRIMIR_MENSAJE ERROR_M, 42
        JMP SALIR_ABRIR
ERROR_ESCRITURA1:
        IMPRIMIR_MENSAJE ERROR_E1, 32
        JMP SALIR_ABRIR
ERROR_ESCRITURA2:
        IMPRIMIR_MENSAJE ERROR_E2, 61
        JMP SALIR_ABRIR
SALIR_CREAR:
        RET
        ENDP
;  ============================================================================
;       procedimientosVacios
;  ============================================================================
verificarSiHojaEstaGuardada PROC NEAR

        RET
        ENDP

;  ============================================================================
;       COPIAR CELDA ACTUAL
;  ============================================================================
copiarCelda PROC NEAR
        GetPosicionDeMemoria FilaActual, ColumnaActual
        MOV BX, POSICIONDEMEMORIA
        CopiarCadena_De_A Pagina1[BX], PORTAPAPELES, 12
        
        IMPRIMIR_mensaje mensajedeayuda, 12
        
        CMP ERROR, 0
        JNE MOSTRAR_ERROR_COP
        JMP SALIR_COP
MOSTRAR_ERROR_COP:
        IMPRIMIR_MENSAJE MENSAJE_ERROR, 79
SALIR_COP:
        RET
        ENDP
;  ============================================================================
;       PEGAR EN CELDA ACTUAL
;  ============================================================================
pegarCelda PROC NEAR
        GetPosicionDeMemoria FilaActual, ColumnaActual
        MOV BX, POSICIONDEMEMORIA
        CopiarCadena_De_A PORTAPAPELES, Pagina1[BX], 12
        mostrarCeldaModificada      FilaActual, columnaActual, Pagina1
        
        CMP ERROR, 0
        JNE MOSTRAR_ERROR_PEG
        JMP SALIR_PEG
MOSTRAR_ERROR_PEG:
        IMPRIMIR_MENSAJE MENSAJE_ERROR, 79
SALIR_PEG:
        RET
        ENDP
;  ============================================================================
;       MOSTRAR AYUDA
;  ============================================================================
alternarPantallaDeAyuda PROC NEAR
    ;limpiar pantalla
        CALL    LIMPIAR_PANTALLA        ; Limpiar pantalla
    ; mover puntero de la pantalla
        MOV     AX, 1301H               ; desplegar prompt
        MOV     BL, ColorFondo          ; Atribut
        MOV BH, 00H                     ; Pagina
        MOV DL, 0                       ; columna de pantalla
        LEA BP, MENSAJE                 ; linea de prompt
        MOV CX, 33                      ; longitud de linea
        MOV DH, 1                       ; fila y
        INT     10H                     

        MOV     AH, 09h
        LEA     DX, MENSAJEDEAYUDA
        int     21h
        
        MOV     AH, 10H                 ; leer caracter de teclado
        INT     16H
        
        CALL    LIMPIAR_PANTALLA        ; Limpiar pantalla
        CALL    CUADRICULA
        CAMBIAR_CELDA ColorCeldaInverso

        RET
        ENDP
;  ============================================================================
;       BUSCAR Y REEMPLAZAR
;  ============================================================================
buscarYReemplazarTodasLasCeldas PROC NEAR
        IMPRIMIR_MENSAJE MENUF1, 5 
        
        RET
        ENDP
;  ============================================================================
;       INGRESO DE CADENA DE TEXTO
;  ============================================================================
INGRESO_DE_TEXTO PROC NEAR
        Imprimir_Mensaje				Msg_IngresarCadena, 16
        LeerCadenayGuardarEn			ListaDe10CaracteresTemp
        ModificarContenidoDeCelda_ConCadena FilaActual, ColumnaActual, DiezCaracteresTempArreglo, Pagina1
        mostrarCeldaModificada 		FilaActual, columnaActual, Pagina1

        CMP ERROR, 0
        JNE MOSTRAR_ERROR_TEX
        JMP SALIR_TEX
MOSTRAR_ERROR_TEX:
        IMPRIMIR_MENSAJE MENSAJE_ERROR, 79
SALIR_TEX:
        RET
        ENDP
;  ============================================================================
;       INGRESO DE UN NUMERO
;  ============================================================================
INGRESO_DE_NUMERO PROC NEAR
        IMPRIMIR_MENSAJE                Msg_IngresarNumero, 16
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, Numero_ACT
        ModificarContenidoDeCelda_ConNumero FilaActual,ColumnaActual, Numero_ACT, Pagina1
        mostrarCeldaModificada          FilaActual, columnaActual, Pagina1

        CMP ERROR, 0
        JNE MOSTRAR_ERROR_NUM
        JMP SALIR_NUM
MOSTRAR_ERROR_NUM:
        IMPRIMIR_MENSAJE MENSAJE_ERROR, 79
SALIR_NUM:
        RET
        ENDP
;  ============================================================================
;       CAMBIAR ATRIBUTO
;  ============================================================================
CAMBIAR_ATRIBUTO PROC NEAR
        IMPRIMIR_MENSAJE                Msg_IngresarAtributo, 18
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, ColorCelda
        CMP ERROR, 0
        JNE MOSTRAR_ERROR_AT
        
    ; encontrar color inverso
        mov al, colorCelda
        mov ah, colorCelda
        and al, 00001111B
        and ah, 11110000B
        shl al, 4
        shr ah, 4
        ADD AL, AH
        MOV ColorCeldaInverso, AL
    ; repintar
        call cuadricula
        CAMBIAR_CELDA ColorCeldaInverso
        
        JMP SALIR_AT
MOSTRAR_ERROR_AT:
        IMPRIMIR_MENSAJE MENSAJE_ERROR, 79
SALIR_AT:
        RET
        ENDP
;  ============================================================================
;       SUMA
;  ============================================================================
SUMA PROC NEAR
        IMPRIMIR_MENSAJE                Msg_IngresarFILA, 14
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, FILA
        IMPRIMIR_MENSAJE                Msg_IngresarCOL_INICIAL, 25
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, COLUMNAINICIAL
        IMPRIMIR_MENSAJE                Msg_IngresarCOL_FINAL, 23
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, COLUMNAFINAL
        
        CMP ERROR, 0
        JNE MOSTRAR_ERROR_S
        
        SumarCeldas Fila, ColumnaInicial, ColumnaFinal, Pagina1
        INC COLUMNAFINAL
        ModificarContenidoDeCelda_ConNumero Fila,ColumnaFINAL, RESULTADO, Pagina1
        MOV AL, FilaActual
        MOV AH, ColumnaActual
        PUSH AX
        MOV AL, FILA 
        MOV FilaActual, AL
        MOV AL, COLUMNAFINAL
        MOV ColumnaActual, AL
        mostrarCeldaModificada          FilaActual, ColumnaActual, Pagina1        
        Cambiar_Celda ColorCelda
        POP AX
        MOV FilaActual, AL
        MOV ColumnaActual, AH
        Cambiar_Celda ColorCeldaInverso
        
        CMP ERROR, 0
        JNE MOSTRAR_ERROR_S
        
        JMP SALIR_SUMA
MOSTRAR_ERROR_S:
        IMPRIMIR_MENSAJE MENSAJE_ERROR, 79
SALIR_SUMA:
        RET
        ENDP
;  ============================================================================
;       PROMEDIO
;  ============================================================================
PROMEDIO PROC NEAR
        IMPRIMIR_MENSAJE                Msg_IngresarFILA, 14
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, FILA
        IMPRIMIR_MENSAJE                Msg_IngresarCOL_INICIAL, 25
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, COLUMNAINICIAL
        IMPRIMIR_MENSAJE                Msg_IngresarCOL_FINAL, 23
        LeerCadenayGuardarEn            ListaDe10CaracteresTemp
        ConvertirCadenaANumero          DiezCaracteresTempArreglo, DiezCaracteresTempLenReal, COLUMNAFINAL
        
        CMP ERROR, 0
        JNE MOSTRAR_ERROR_S
        
        SumarCeldas Fila, ColumnaInicial, ColumnaFinal, Pagina1
        
        ; Dividir dentro del numero de celdas
        MOV AX, WORD PTR Resultado      ;almacenar resultado de la suma
        MOV AH, 0
        MOV CL, ColumnaFinal
        ADD CL, 1
        SUB CL, ColumnaInicial      
        DIV CL                          ;Op=byte: AL:=AX / Op, dividir!
        MOV Resultado, AL               ;almacenarlo en resultado

        
        INC COLUMNAFINAL
        ModificarContenidoDeCelda_ConNumero Fila,ColumnaFINAL, RESULTADO, Pagina1
        MOV AL, FilaActual
        MOV AH, ColumnaActual
        PUSH AX
        MOV AL, FILA 
        MOV FilaActual, AL
        MOV AL, COLUMNAFINAL
        MOV ColumnaActual, AL
        mostrarCeldaModificada          FilaActual, ColumnaActual, Pagina1        
        Cambiar_Celda ColorCelda
        POP AX
        MOV FilaActual, AL
        MOV ColumnaActual, AH
        Cambiar_Celda ColorCeldaInverso
        
        CMP ERROR, 0
        JNE MOSTRAR_ERROR_P
        
        JMP SALIR_PROMEDIO

MOSTRAR_ERROR_P:
        IMPRIMIR_MENSAJE MENSAJE_ERROR, 79
SALIR_PROMEDIO:
        
        RET
        ENDP
        
;  ============================================================================
;       LLAMAR AL PLOCEDIMIENTE PRINCIPAL
;  ============================================================================
END     MAIN


;  ============================================================================
;      
;  ============================================================================

;UNIVERSIDAD DEL VALLE DE GUATEMALA
;PROGRAMACION EN ASSEMBLER
;PROYECTO FINAL---MULTITASKING
;VERSION 1.2
;ALHVI BALCARCEL              03100
;MARTA ESTRADA                03115

.MODEL LARGE
.STACK 5000H
.DATA
;--------------------------------------VARIABLES------------------
RELOJVIEJO	DD	?  	     ;CONTIENE EL RELOJVIEJO PARA LA LLAMADA
TECLADOVIEJO	DD	?	     ;CONTIENE EL TECLADOVIEJO PARA LA LLAMDA
VECTORBP	DW	4 DUP(1000H) ;BUFER (VECTOR) CIRCULAR DEL BP
VECTORSP	DW	4 DUP(1000H) ;BUFER (VECTOR) CIRCUALR DEL SP
CONTPROC	DW	0   	     ;CONTADOR DEL PROCEDIMIENTO ACTUAL
TECLAZO		DB 	?	     ;BANDERA DE TECLADO
COLUMNA		DW	79	     ;CONTADOR DE COLUMNAS (PARA ESPRIALES)
FILA		DW	7	     ;CONTADOR DE FILAS (PARA ESPRIALES)
DOS		DB	2	     ;MULTIPLICADORES
ONESIXTY	DB 	160
AUXILIAR1 	DW	0 	     ;AUXILIAR (MUCHOS USOS)
ATRIBUTO	DB	2	     ;CONTIENE EL COLOR DEL CARATER
ESPIRAL1	DW	0	     ;POSICION DONDE EMPIEZA LA ESPIRAL1
                                     ;EN LA PANTALLA
ESPIRAL2	DW	1440	     ;POSICION DONDE EMPIEZA LA ESPIRAL2
			             ;EN LA PATNALLA
ESPIRAL3	DW	2880	     ;POSICION DONDE EMPIEZA LA ESPRIAL3
				     ;EN LA PANTALLA
LAQUESESPIRAL	DW	?	     ;PARAMETRO QUE RECIBE LA POSICION DE
				     ;LA ESPRIAL
CONTADOR	DB	8
CONT 		DW  	0

OTRATEMP	DW	0	      ;OTRA VARIABLE TEMPORAL
FREQ		DW	104	      ;DO ESCALA 4
TKS		DW	2	      ;1/2 SEGUNDO
FNLOW           DB      ?
FNHIGH          DB      ?
;CONT		DB	?
GETREADY	DB	10110110B     ;ALISTA LA BOCINA
;-------NOTAS MUSICALES--------------------
SOL2	EQU 98
SOLS2	EQU 104
LA2	EQU 110
LAS2	EQU 116
SI2	EQU 123
DO3	EQU 131
DOS3	EQU 139
RE3	EQU 147
RES3	EQU 155
MI3	EQU 165
FA3	EQU 175
FAS3	EQU 185
SOL3	EQU 196
SOLS3	EQU 208
LA3	EQU 220
LAS3	EQU 233
SI3	EQU 245
DO4	EQU 262
DOS4	EQU 277
RE4  	EQU 294
RES4	EQU 311
MI4	EQU 330
FA4	EQU 349
FAS4	EQU 370
SOL4	EQU 392
SOLS4	EQU 415
LA4	EQU 440
LAS4	EQU 466
SI4	EQU 494
DO5	EQU 523
DOS5	EQU 554
RE5	EQU 587
RES5	EQU 622
MI5	EQU 659
FA5	EQU 698
FAS5	EQU 740
SOL5	EQU 784
SOLS5	EQU 831
LA5	EQU 880
LAS5	EQU 932
SI5	EQU 988
DO6	EQU 1046
;------------------------------------------------------------------
.CODE
;------------------------------------------------------------------
;MACRO QUE HACE PUSH DE TODOS LOS PARAMETROS QUE UTILIZARAN LAS FUNCIONES
HACERPUSH MACRO
       PUSH COLUMNA
       PUSH FILA
       PUSH DI
       PUSH WORD PTR CONTADOR
       PUSH LAQUESESPIRAL
       PUSH WORD PTR ATRIBUTO
       PUSH TKS
       PUSH FREQ
       PUSH WORD PTR FNLOW
       PUSH WORD PTR FNHIGH
       PUSH DS
       PUSH ES
       PUSH SI
       PUSH OTRATEMP
       PUSH CX
ENDM
;-----------------------------------------------------------------------------
;MACRO QUE HACE POP DE TODOS LOS PARAMETROS QUE UTILIZARON LOS PROCEDIMIENTOS
HACERPOP MACRO
       POP CX
       POP OTRATEMP
       POP SI
       POP ES
       POP DS
       POP WORD PTR FNHIGH
       POP WORD PTR FNLOW
       POP FREQ
       POP TKS
       POP WORD PTR ATRIBUTO
       POP LAQUESESPIRAL
       POP WORD PTR CONTADOR
       POP DI
       POP FILA
       POP COLUMNA
ENDM
;-------------------------------------------------------------------------------
;PROGRAMA PRINCIPAL
MAIN PROC FAR

       MOV AX, @DATA       		;INICIALIZAR AREA DE DATOS
       MOV DS, AX
       MOV AX, 0300H		        ;INICIALIZAR MEMORIA DE VIDEO
       INT 10H

       MOV AX, 0B800H		        ;COLOCARSE EN PAGINA 0
       MOV ES, AX
       MOV AX, 0500H 		        ;SELECCIONA PAGINA ACTIVA
       INT 10H

       CALL INICIALIZAR		        ;PROCEDIMIENTO QUE INICIALIZA EL STACK
       CALL REPROGRAMCLK		;REPROGRAMACION DEL RELOJ(08H)
       CALL REPROGRAMKB		        ;REPROGRAMACION DEL TECLADO(09H)
       CALL UNIVERSALMIND		;PRIMER PROCEDIMIENTO (MUSICA)
       CALL SALIR			;SALE AL DOS

MAIN ENDP
;------------------------------------------------------------------------------------------
;-------------------DEFINICION DE STACKS---------------------------------------------------
;------------------------------------------------------------------------------------------
DEFINICION_STACKS PROC NEAR

       MOV BX, 0     			;CONTADOR DEL BUFER
       MOV WORD PTR [VECTORBP+BX], BP	;SE MUEVEN LOS BP Y SP ACTUALES AL VECTOR CIRCULAR
       MOV WORD PTR [VECTORSP+BX], SP
       MOV CX, 3
STK:   MOV AX, VECTORBP[BX]		;CREA LOS NUEVOS STACKS
       ADD BX, 2
       ADD AX, 1000H
       MOV VECTORBP[BX], AX
       MOV VECTORSP[BX], AX
       LOOP STK
       RET

DEFINICION_STACKS ENDP
;------------------------------------------------------------------
INICIALIZAR PROC NEAR

        CALL DEFINICION_STACKS              ;CREA STACKS ARTIFICALES
        MOV [WORD PTR VECTORSP], SP 	    ;GUARDA SP ACTUAL
        MOV CX, 3
        MOV BX, 2

PUSHEAR:MOV BP, WORD PTR VECTORBP[BX]       ;SE MUEVE A LA STACK QUE LE TOCA
        MOV SP, WORD PTR VECTORSP[BX]
        PUSHF                               ;HACE PUSH DE LAS BANDERAS
        PUSH SEG ESPIRAL                    ;Y DE LAS DIRECCIONES INICIALES
	PUSH OFFSET ESPIRAL                 ;SWITCH DE QUE ESPIRAL ES
        CMP BX, 2
        JE ESP1
        CMP BX, 4
        JE ESP2
        CMP BX, 6
        JE ESP3 
ESP1:	MOV DX, ESPIRAL1                    ;LE PASA LOS PARAMETROS DISTINTOS A CADA ESPIRAL
	JMP POOSH
ESP2:	MOV DX, ESPIRAL2
	MOV ATRIBUTO, 5
	JMP POOSH
ESP3:	MOV DX, ESPIRAL3
	MOV ATRIBUTO, 14
POOSH:	MOV LAQUESESPIRAL, DX
	HACERPUSH                           ;HACE PUSH DE LOS PARAMETROS
        MOV [WORD PTR VECTORSP+BX], SP      ;ACTUALIZA EL SP
        ADD BX, 2                           ;LO HACE 3 VECES PARA LAS ULTIMAS TRES STACKS
        LOOP PUSHEAR
	XOR BX, BX
	MOV SP, [WORD PTR VECTORSP+BX]      ;REGRESA A LA STACK ORIGINAL
	MOV BP, [WORD PTR VECTORBP+BX]
        RET

INICIALIZAR ENDP
;----------------------------------------------------------------------------
;VERIFICA EL PROCEDIMIENTO DONDE VA, SI YA ES EL ULTIMO, SE MUEVE A 0
;QUE ES EL ORGIINAL
REFRESH PROC NEAR

       CMP CONTPROC, 6
       JE VUELTA
       ADD CONTPROC, 2
       JMP YAREF
VUELTA:MOV CONTPROC, 0
YAREF:
       RET

REFRESH ENDP
;------------------------------------------------------------------------------------------
;-------------------REPROGRAMACION DE INTERRUPCIONES---------------------------------------
;------------------------------------------------------------------------------------------
;REPROGRAMACION DEL RELOJ
RELOJNUEVO PROC NEAR

       CLI			         ;PREVIENE INTERRUPCIONES POSTERIORE
       PUSHF       		         ;PUSH DEL REGISTRO DE BANDERAS
       CALL DWORD PTR RELOJVIEJO         ;LLAMADA AL RELOJ VIEJO
       HACERPUSH		         ;PUSH DE TODOS LOS REGISTROS Y PARAMETROS
       MOV BX, CONTPROC	                 ;DEL STACK ACTUAL
       MOV [OFFSET VECTORSP+BX], SP
       CALL REFRESH		         ;CAMBIEAR DE STACK
       MOV BX, CONTPROC    	         ;MOV BP, [OFFSET VECTORBP+BX]
       MOV SP, [OFFSET VECTORSP+BX]
       HACERPOP		                 ;Y HACER POP DE TODOS LOS REGISTROS
FINPROC:
       STI
       IRET

RELOJNUEVO ENDP
;-----------------------------------------------------------------------------
;NUEVA DIRECCION DEL RELOJ
REPROGRAMCLK PROC NEAR

       STD
       MOV AH, 35H			   	
       MOV AL, 08H
       INT 21H                             ;OBTENER LA INTERRUPCION
       MOV [WORD PTR RELOJVIEJO+2], ES     ;SEGMENTO
       MOV [WORD PTR RELOJVIEJO], BX       ;DESPLAZAMIENTO
       PUSH DS				   ;GUARDA DS, PUES SE VA A MODIFICAR
       MOV AX, SEG RELOJNUEVO		   ;OBTIENE LA DIRECCION DEL RELOJ NUEVO (AX:BX)
       MOV DS, AX
       MOV DX, OFFSET RELOJNUEVO
       MOV AH, 25H
       MOV AL, 08H
       INT 21H                             ;FIJAR LA INTERRUPCION
       POP DS
       CLD
       RET

REPROGRAMCLK ENDP
;----------------------------------------------------------------------------
;PROCEDIMIENTO SIMILAR AL DE REPROGRAMAR LA INTERRUPCION DE RELOJ
TECLADONUEVO PROC NEAR

	CLI
	PUSHF
	CALL DWORD PTR TECLADOVIEJO         ;LLAMA TECLADO VIEJO
	MOV TECLAZO, 1    	            ;SI ENCONTRO TECLAZO, CAMBIA LA BANDERA
	STI
	IRET

TECLADONUEVO ENDP
;-----------------------------------------------------------------------------
REPROGRAMKB PROC NEAR

	STD
	MOV AH, 35H
        MOV AL, 09H
        INT 21H                             ;OBTENER LA INTERRUPCION
        MOV [WORD PTR TECLADOVIEJO+2], ES   ;SEGMENTO
        MOV [WORD PTR TECLADOVIEJO], BX     ;DESPLAZAMIENTO
        PUSH DS
        MOV AX, SEG TECLADONUEVO
        MOV DS, AX
        MOV DX, OFFSET TECLADONUEVO
        MOV AH, 25H
        MOV AL, 09H
        INT 21H                             ;FIJAR LA INTERRUPCION
        POP DS
	CLD
	RET

REPROGRAMKB ENDP
;------------------------------------------------------------------------------------------
;-------------------FINAL DEL PROGRAMA-----------------------------------------------------
;------------------------------------------------------------------------------------------
;MIRA SI SIGUE EJECUTANDO LOS PROCESOS O SALE
COMPARAR PROC NEAR

        CMP TECLAZO, 1                 ;SI EL TECLAZO ES UNO SALE
        JNE SIGUET
        CALL SALIR
SIGUET:
        RET

COMPARAR ENDP
;------------------------------------------------------------------------------
;REGRESA LOS VALORES INICIALES DE LAS INTERRUPCIONES MODIFICADAS
RESTORE PROC NEAR
       CLI
       PUSH DS
       MOV AX, [WORD PTR RELOJVIEJO+2]	        ;REGRESA LA INTERRUPCION DEL RELOJ
       MOV DS, AX
       MOV DX, [WORD PTR RELOJVIEJO]
       MOV AH, 25H
       MOV AL, 08H
       INT 21H
   
       MOV AX, [WORD PTR TECLADOVIEJO+2] 	;REGRESA LA INTERRUPCION DEL TECLADO
       MOV DS, AX
       MOV DX, [WORD PTR TECLADOVIEJO]
       MOV AH, 25H
       MOV AL, 09H
       INT 21H
   
       POP DS
   
       IN AL, 61H
       AND AL, 11111100B			;CIERRA LA BOCINA POR SI SE QUEDO ABIERTA
       OUT 61H, AL
  
       STI
       RET
RESTORE ENDP
;------------------------------------------------------------------------------
;SALIR AL DOS
SALIR PROC NEAR
       CALL RESTORE
       MOV AX, 4C00H
       INT 21H
SALIR ENDP
;------------------------------------------------------------------------------
;-------------------ESPIRALES--------------------------------------------------
;------------------------------------------------------------------------------
;PROCESO QUE ARMA LAS ESPIRALES
;DIBUJA LA ESPRIAL EN LA POSICION DE DI QUE SE INDIQUE EN LAQUESESPIRAL
ESPIRAL PROC NEAR

START:
       CMP TECLAZO, 1
       JE PUROMEROFIN
       MOV DI, LAQUESESPIRAL
HACERESPIRAL:
       CMP FILA,0                           ;SI LA FILA ES 0 COMIENZA UNA NUEVA ESPIRAL
       JE FINESPIRAL
       CALL HORIZONTALR                     ;DIBUJA LA LINEA HORIZONTAL HACIA LA DERECHA
       DEC COLUMNA
       CALL VERTICALD                       ;DIBUJA LA LINEA VERTICAL HACIA ABAJO
       DEC FILA
       CMP FILA, 0
       JE FINESPIRAL
       CALL HORIZONTALL                     ;DIBUJA LA LINEA HORIZONTAL HACIA LA IZQUIERDA
       DEC COLUMNA
       CALL VERTICALU                       ;DIBUJA LA LINEA VERTICAL HACIA ARRIBA
       DEC FILA
       JMP HACERESPIRAL                     ;SE ENLOOPA
FINESPIRAL:
       INC ATRIBUTO                         ;PARA SEGUIR INCREMENTA EL ATRIBUTO
       MOV COLUMNA, 79
       MOV FILA, 7
       JMP START
PUROMEROFIN:
       RET

ESPIRAL ENDP
;----------------------------------------------------------------------------
;DIBUJA LA LINEA HORIZONTAL HACIA LA DERECHA
HORIZONTALR PROC NEAR

        MOV CX, COLUMNA
ESCRIBA:
        CMP TECLAZO, 1                      ;SI EL TECLAZO ES UNO YA NO SIGUE
        JE FINHR
        MOV AH,ATRIBUTO
        MOV AL, 16                          ;FLECHA
        STOSW
        CALL DELAY
        CALL COMPARAR                       ;LLAMA A COMPARAR PARA VER SI HAY UN TECLAZO
        LOOP ESCRIBA                        ;LO HACE LAS VECES ESPECIFICADAS EN COLUMNA
FINHR:   			            ;PARA QUE QUEDE EN LA DE ABAJO -2+160
        RET

HORIZONTALR ENDP
;------------------------------------------------------------------
;DIBUJA LA LINEA HORIZONTAL HACIA LA IZQUIERDA
HORIZONTALL PROC NEAR

       CMP TECLAZO, 1
       JE FINHL
       MOV CX, COLUMNA
ESCRIBAL:
       MOV AH,ATRIBUTO
       MOV AL, 17
       CMP TECLAZO, 1
       JE FINHL
       STOSW
       SUB DI, 4
       CALL DELAY
       CALL COMPARAR
       LOOP ESCRIBAL
FINHL:
       RET

HORIZONTALL ENDP
;--------------------------------------------------------------------
;DIBUJA LA LINEA VERTICAL HACIA ABAJO
VERTICALD PROC NEAR

       MOV CX, FILA
ESCRIBAD:
       CMP TECLAZO, 1
       JE FINVD
       MOV AH, ATRIBUTO
       MOV AL, 31
       STOSW
       ADD DI, 158
       CALL DELAY
       CALL COMPARAR
       LOOP ESCRIBAD
       SUB DI, 162                          ;PARA QUE QUEDE DONDE TIENE QUE EMPEZAR HORIZONTALL
FINVD:
       RET

VERTICALD ENDP
;------------------------------------------------------------------------
;DIBUJA LA LINEA VERTICAL HACIA ARRIBA
VERTICALU PROC NEAR

       MOV CX, FILA
ESCRIBAU:
       CMP TECLAZO, 1
       JE FINVU
       MOV AH, ATRIBUTO
       MOV AL, 30
       STOSW
       SUB DI, 162
       CALL DELAY
       CALL COMPARAR		             ;PARA VER SI YA HAY TECLAZO
       LOOP ESCRIBAU
       ADD DI, 162                           ;PARA QUE QUEDE DONDE TIENE QUE EMPEZAR EL HORIZONTALL
FINVU:
       RET

VERTICALU ENDP
;-------------------------------------------------------------------------

;RETRASA EL DIBUJADO DE LA ESPIRAL, HACE MUCHOS CICLOS QUE NO HACEN NADA :P
DELAY PROC NEAR
INICIACX:
       MOV OTRATEMP, 0FFFFH
ENLOOPAO:
       DEC OTRATEMP
       CMP OTRATEMP, 0
       JNE ENLOOPAO
       DEC CONTADOR
       CMP CONTADOR, 0
       JA INICIACX
       JMP FINDELAY
FINDELAY:
       RET

DELAY ENDP
;------------------------------------------------------------------------------
;-------------------MUSICAS----------------------------------------------------
;------------------------------------------------------------------------------
;PROCESO QUE HACE LA MUSICA, LLAMA A TODAS LAS FUNCIONES QUE LA REALIZAN
UNIVERSALMIND PROC NEAR

	CMP TECLAZO, 1
        JE FINUNVM
INICIOUNVM:
	CALL PARTE1
	CALL PARTE1
	CALL PARTE2
	CALL PARTE2		;32
	CALL PARTE3
	JMP INICIOUNVM
FINUNVM:
	RET

UNIVERSALMIND ENDP
;------------------------------------------------------------------------------
;HACE UN BEEP CON UNA FRECUENCIA QUE SE LE PASA
;FUENTE http://www.riverland.net.au/~mdunn/
BEEP PROC NEAR

	CMP TECLAZO, 1
	JE FINBEEP

	MOV AX, 34DCH           ;CONVERTIR FRECUENCIA A FN(NUMERO QUE RECONOCE EL PUERTO)
	MOV DX, 12H		;1234DC ES 1193180 QUE ES LO QUE SE DIVIDE
	MOV BX, FREQ		;ENTRE LA FRECUENCIA PARA ENCONTRAR NUMERO QUE LE CORRESPONDE
	DIV BX
	MOV FNLOW, AL		;SE GUARDA EL RESULTADO EN FNLOW
	MOV FNHIGH, AH		;Y FN HIGH

	;DECIRLE AL PUERTO 43H QUE VAMOS A SACAR UN SONIDO
	MOV AL, GETREADY
	OUT 43H, AL		;SE LE PASA EL 	10110110B

	;PASARLE EL FN AL PUERTO 42H (SPEAKER)
	MOV AL, FNLOW
	OUT 42H, AL		;SE LE PASA PRIMERO EL LOW DEL FN
	MOV AL, FNHIGH
	OUT 42H, AL		;SE LE PASA EL HIGH DEL FN

	;ENCENDER EL SPEAKER
	IN AL, 61H		;SE HACE UN GET DEL ESTADO DEL SPEAKER (PUERTO 61H)
	OR AL, 00000011B	;SE PRENDE EL SPEAKER PONIENDO EN 1 LOS BYTES 0 Y 1
	OUT 61H, AL		;SE SETEA EL PUERTO 61H

	;MANTENER ENCENDIDO EL SPEAKER EL TIEMPO QUE SE REQUIERA
        CALL DELAYM

	;DESPUES DE TRANSCURRIDO EL TIEMPO APAGAR EL SPEAKER

	IN AL, 61H		;OTRA VEZ SE HACE UN GET DEL ESTADO DEL SPEAKER
	AND AL, 11111100B	;SE PONEN EN 0 LOS BYTES 0 Y 1 PARA APAGARLO
	OUT 61H, AL		;SE SETEA EL PUERTO
FINBEEP:
	RET			;YA
BEEP ENDP
;---------------------------------------------------------------------------
;DELAY TOMANDO EN CUENTA LOS TICKS PARA MEJOR CONTROL DE LOS TIEMPOS DE LAS NOTAS MUSICALES
DELAYM PROC NEAR

      	STI
        MOV CX,TKS		;PONE EN EL CONTADOR EL NUMERO DE TICKS
        SHR CX, 1
        MOV AX,040H
        PUSH ES
        MOV ES,AX		;APUNTA EL ES AL BIOS
        MOV SI,06CH
WAIT1:  MOV AX,[ES:SI]          ;OBTIENE EL NUMERO DE TICKS ACTUALES
WAIT2:  CMP AX,[ES:SI]
        JE WAIT2		;SE ENLOOPA HASTA QUE SEA UN TICK DIFERENTE
        LOOP WAIT1		;LO HACE CX VECES
        POP ES
        RET

DELAYM ENDP
;-----------------------------------------------------------------------------
;MACRO QUE PASA LA FRECUENCIA Y LLAMA A LA FUNCION QUE TOCA LA NOTA.. TAMBIEN LLAMA A
;COMPARAR DONDE SE MIRA SI SIGUIE TOCANDO O SE SALE DEL PROGRAMA
PLAY MACRO F
  	MOV FREQ, F
  	CALL BEEP
  	CALL COMPARAR
ENDM
;-----------------------------------------------------------------------------
;COMPAS # 1 DE LA CANCION
CMP1 PROC NEAR

        MOV TKS, 2
	PLAY LA5
	PLAY FA5
	PLAY LAS4
	PLAY LA4
	PLAY LAS4
	PLAY FA5
	PLAY LA5
	PLAY FA5
	PLAY LAS4
	PLAY LA4
	PLAY FA4
	PLAY MI4
	PLAY FA4
	PLAY LA4
	PLAY LAS4
	PLAY FA5
	RET

CMP1 ENDP
;------------------------------------------------------------------------------
;COMOPAS # 4
CMP4 PROC NEAR

	PLAY DO6
	PLAY SOL5
	PLAY DO5
	PLAY LAS4
	PLAY DO5
	PLAY SOL5
	PLAY DO6
	PLAY SOL5
	PLAY DO5
	PLAY LAS4
	PLAY DO5
	PLAY SOL5
	PLAY DO6
	PLAY SOL5
	PLAY DO5
	PLAY LAS4
	RET

CMP4 ENDP
;------------------------------------------------------------------------------
;COMPAS # 8
CMP8 PROC NEAR

	PLAY DO6
	PLAY FA5
	PLAY DO5
	PLAY FA5
	PLAY LAS5
	PLAY FA5
	PLAY DO5
	PLAY FA5
	PLAY LA5
	PLAY FA5
	PLAY DO5
	PLAY FA5
	PLAY SOL5
	PLAY FA5
	PLAY DO5
	PLAY FA5
	RET

CMP8 ENDP
;------------------------------------------------------------------------------
;TOCA LA PRIMERA PARTE DE LA CANCION
PARTE1 PROC NEAR

	MOV TKS, 2		;TIEMPO 2 TICKS
	CALL CMP1
	CALL CMP1
	CALL CMP1
	CALL CMP4
	CALL CMP1
	CALL CMP1
	CALL CMP1
	CALL CMP8
	RET

PARTE1 ENDP
;------------------------------------------------------------------------------
;COMPAS # 17
CMP17 PROC NEAR

	MOV TKS, 4		;CORCHEA
	PLAY RE4
	MOV TKS, 16		;BLANCA
	PLAY RE3
	MOV TKS, 4		;CORCHEA
	PLAY MI3
	CALL DELAYM		;SILENCIO DE CORCHEA
CMP18:	MOV TKS, 8		;DOS CORCHEAS
	PLAY FA3
	MOV TKS, 4		;CORCHEA
	PLAY SOL3
	PLAY LA3
	MOV TKS, 12		;NEGRA CON PUNTO
	PLAY DO4
	MOV TKS, 4		;CORCHEA
	PLAY MI4
	PLAY DO4
	RET

CMP17 ENDP
;------------------------------------------------------------------------------
;COMPAS # 19
CMP19 PROC NEAR

	MOV TKS, 4		;CORCHEA
	PLAY RE4
	MOV TKS, 8		;NEGRA
	PLAY RE3
	MOV TKS, 4		;CORCHEA
	PLAY MI3
	PLAY FA3
	PLAY SOL3
	PLAY LA3
CMP20:	MOV TKS, 8		;DOS CORCHEAS
	PLAY DO4
	MOV TKS, 4		;CORCHEA
	PLAY MI4
	MOV TKS, 16
	PLAY SOL3
	MOV TKS, 2		;SEMI CORCHEA
	PLAY SOL3
	PLAY LA3
	MOV TKS, 4		;CORCHEA
	PLAY DO4
	RET

CMP19 ENDP
;------------------------------------------------------------------------------
;COMPAS # 23
CMP23  PROC NEAR

	MOV TKS, 4		;CORCHEA
	PLAY RE4
	MOV TKS, 8		;NEGRA
	PLAY RE3
	MOV TKS, 4		;CORCHEA
	PLAY MI3
	PLAY FA3
	PLAY SOL3
	PLAY LA3
CMP24:	MOV TKS, 36		;CORCHEA CON REDONDA
	PLAY DO4		;ES DO Y SOL???
	RET

CMP23 ENDP
;------------------------------------------------------------------------------
;TOCA LA PARTE 2
PARTE2 PROC NEAR

	CALL CMP17
	CALL CMP19
	CALL CMP17
	CALL CMP23
	RET

PARTE2 ENDP
;------------------------------------------------------------------------------
;COMPAS # 33
CMP33 PROC NEAR
	MOV TKS, 4		;CORCHEA
	PLAY SOL3
	MOV TKS, 16		;BLANCA
	PLAY SOL2
	MOV TKS, 4		;CORCHEA
	PLAY LA2
	CALL DELAYM		;SILENCIO DE CORCHEA

CMP34:	MOV TKS, 8		;DOS CORCHEAS
	PLAY LAS2
	MOV TKS, 4		;CORCHEA
	PLAY DO3
	PLAY RE3
	MOV TKS, 12		;NEGRA CON PUNTILLO
	PLAY FA3
	MOV TKS, 4		;CORCHEA
	PLAY LA3
	PLAY FA3
	RET
CMP33 ENDP
;------------------------------------------------------------------------------
;COMPAS # 35
CMP35 PROC NEAR

	MOV TKS, 4		;CORCHEA
	PLAY SOL3
	MOV TKS, 8		;NEGRA
	PLAY SOL2
	MOV TKS, 4		;CORCHEA
	PLAY LA2
	PLAY LAS2
	PLAY DO3
	PLAY RE3

CMP36:	MOV TKS, 8		;DOS CORCHEAS
	PLAY FA3
	MOV TKS, 4		;CORCHEA
	PLAY LA3
	MOV TKS, 16		;BLANCA
	PLAY DO3
	MOV TKS, 2		;SEMICORCHEA
	PLAY DO3
	PLAY RE3
	MOV TKS, 4		;CORCHEA
	PLAY FA3
	RET

CMP35 ENDP
;------------------------------------------------------------------------------
;COMPAS # 39
CMP39 PROC NEAR

	MOV TKS, 4		;CORCHEA
	PLAY SOL3
	MOV TKS, 8		;NEGRA
	PLAY SOL2
	MOV TKS, 4		;CORCHEA
	PLAY LA2
	PLAY LAS2
	PLAY DO3
	PLAY RE3
CMP40:	MOV TKS, 36		;REDONDA CON CORCHEA
	PLAY FA3
	RET

CMP39 ENDP
;------------------------------------------------------------------------------
;TOCA LA TERCERA PARTE DE LA CANCION
PARTE3 PROC NEAR

	CALL CMP33
	CALL CMP35
	CALL CMP33
	CALL CMP39
	RET

PARTE3 ENDP
;------------------------------------------------------------------------------
END MAIN


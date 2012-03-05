TITLE P09DOSAS (COM) Exhibe los caracteres ASCII 00H-FFh
	.MODEL SMALL
	.STACK 64
	.DATA
CHAR	DB 00,'$'
;
;	Procedimiento principal
;	-----------------------
	.CODE
MAIN	PROC NEAR
	MOV AX,@data	; Iniciar registros de segmento
	MOV DS, AX
	MOV ES, AX
	CALL CURSOR		; Fijar cursor
	CALL VENTANA	; Hacer ventana de 5 lineas
	CALL DESPLIEGUE	; Exhibir caracteres
	MOV AX,4C00H		; Salir a DOS
	INT 21H
MAIN	ENDP
;
;	Despejar pantalla
;	----------------
VENTANA	PROC NEAR
	MOV AX,0605H	; 5 líneas
	MOV BH,61H		; Atributo: 
	MOV CX,0000		; Posicion izquierda superior
	MOV DX,054FH	; Posicion derecha inferior
	INT 10H			
	RET
VENTANA	ENDP
;
;	Fijar cursor en 00,00
;	---------------------
CURSOR	PROC NEAR
	MOV AX,02H		; Peticion de fijar cursor
	MOV BH,00		; Pagina 0
	MOV DX,0000		; Fila 0, columna 0
	INT 10H
	RET
CURSOR	ENDP
;
;	Exhibir caracteres ASCII
;	------------------------
DESPLIEGUE	PROC
	MOV CX,256		; Iniciar 256 repeticiones
	LEA DX, CHAR	; Iniciar direccion de caracter
D20:
	MOV AH, 09H		; Exhibir caracter ASCII
	INT 21H
	INC CHAR		; Incrementar para el siguiente caracter
	LOOP D20		; Decrementar CX, ciclo <> 0
	RET
DESPLIEGUE	ENDP
	END MAIN

TITLE	CICLOS 	Ejemplos de ciclos
;-------------------------------------------------
	.MODEL SMALL
	.STACK 64
	.DATA
; Definicion de datos
CONTA	DB	00, 0DH, 0AH,'$'
CHAR	DB	00, 0DH, 0AH,'$'
;-------------------------------------------------
; Inicio del codigo
	.CODE

DESPLIEGUE	PROC NEAR

	MOV CX, 256		; Iniciar 256 repeticiones
	LEA DX, CHAR    ; Iniciar direccion de caracter
D20:
	MOV AH, 09H		; Desplegar caracter ASCII apuntado por DX
	INT 21H
    INC CHAR        ; Incrementar para el siguiente caracter
    LOOP D20        ; Decrementar CX, ciclo < > 0
	RET

DESPLIEGUE	ENDP


BEGIN	PROC FAR
    MOV AX,@data	        ;inicializa segmento de datos
	MOV DS,AX

	MOV AX, 01		; iniciar AX, BX, DX con 1
	MOV BX, 01
	MOV DX, 01
	MOV CX, 256		; iniciar CX con 256 iteraciones

CICLO:
	INC AX			; sumar 1 a AX
	ADD BX, AX		; sumar AX a BX
	SHL DX, 1		; multiplicar DX por dos

	CALL DESPLIEGUE
    MOV AH, 4CH   ; salida al DOS
	INT 21H

BEGIN	ENDP
END BEGIN

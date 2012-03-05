TITLE	Uso de tablas de saltos
;-------------------------------------------------
.MODEL SMALL
.STACK 64
.DATA
; Definicion de datos
MENSAJE0	DB "Rutina 1$"
MENSAJE1	DB "Rutina 2$"
MENSAJE2	DB "Rutina 3$"
TABLA		DW	COD0	; tabla de direcciones
			DW	COD1
			DW	COD2
CODIGO		DB	2

;-------------------------------------------------
; Inicio del codigo
	.CODE
;-------------------------------------------------
; Funcion de despliegue
COD0   PROC NEAR
	   LEA DX, MENSAJE0
       MOV AH, 09H   ; peticion para desplegar
       INT 21H       ; llama al DOS
       RET
COD0   ENDP
;-------------------------------------------------
; Funcion de despliegue
COD1   PROC NEAR
	   LEA DX, MENSAJE1
       MOV AH, 09H   ; peticion para desplegar
       INT 21H       ; llama al DOS
       RET
COD1   ENDP
;-------------------------------------------------
; Funcion de despliegue
COD2   PROC NEAR
	   LEA DX, MENSAJE2
       MOV AH, 09H   ; peticion para desplegar
       INT 21H       ; llama al DOS
       RET
COD2   ENDP
;-------------------------------------------------
SALTOS	PROC 	NEAR
		XOR	BX, BX	  	; pone a 0 registro BX
		MOV BL, CODIGO 	; obtener el codigo
		SHL	BX, 01	  	; mult. Por 2
		JMP	[TABLA+BX] 	; salta a la tabla
SALTOS	ENDP

;-------------------------------------------------
;Programa principal
BEGIN	PROC FAR
        MOV AX,@data	;inicializa segmento de datos
		MOV DS,AX
		MOV ES,AX		;debe inicializarse tambien ES
		
		CALL SALTOS
        
        MOV AH, 4CH		;salida al DOS
		INT 21H

BEGIN	ENDP
END BEGIN

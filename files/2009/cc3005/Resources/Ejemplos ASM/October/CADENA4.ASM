; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 28 de septiembre del 2009
; Fecha de ultima modificacion: 
; CC-3005 Programacion en Assembler
; Cadena4.asm: comparacion de cadenas
; **********************************************************************************
.model small
.stack 64
.data
;----------------------------------------------------
MENSAJE		DB	'Cadena 1 y cadena 2 son iguales   ',0DH,0AH,'$'
			DB	'Cadena 1 y cadena 2 no son iguales',0DH,0AH,'$'
			DB	'Cadena 2 y cadena 3 son iguales   ',0DH,0AH,'$'
			DB	'Cadena 2 y cadena 3 no son iguales',0DH,0AH,'$'
LONGITUD	EQU	10
CADENA1		DB	'Ensamblado'
CADENA2		DB	'ENSAMBLADO'
CADENA3		DB	'ENSAMBLADO'
;-----------------------------------------------------
.code
DESP	PROC NEAR
		LEA DX, MENSAJE+BX
		MOV AH, 09h     		;muestra cadena destino
		INT 21H
		RET
DESP	ENDP

MAIN	PROC FAR

   	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	MOV ES, AX
	
	; comparacion de cadena 1 y cadena 2
	XOR BX, BX				; se limpia BX
	CLD						; izq a der
	MOV	CX, LONGITUD		; 10 bytes
	LEA	DI, CADENA1
	LEA	SI, CADENA2
	REPE CMPSB				; compare CADENA1 y CADENA2
	JNE	CONTINUAR			; no es igual, terminar comparación
	MOV	BX, 0				; si es igual, offset de mensaje en BX
	CALL DESP
	JMP NEXT
	
	; comparacion de cadena 2 y cadena 3
CONTINUAR:
	MOV BX, 37
	CALL DESP
NEXT:
	MOV	CX, LONGITUD
	LEA	DI, CADENA2
	LEA	SI, CADENA3
	REPE	CMPSB			; compare CADENA2 y CADENA3
	JNE SALIR				; NO es igual, terminar comparacion
	MOV	BX, 74				; SI es igual, offset de mensaje en BX
	CALL DESP
	JMP FIN
SALIR:
	MOV BX, 111				; offset del mensaje en BX
	CALL DESP
FIN:
	MOV AH, 4CH   			;salida al DOS
	INT 21H

MAIN	ENDP
END	MAIN
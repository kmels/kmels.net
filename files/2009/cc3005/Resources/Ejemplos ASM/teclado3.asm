; Manejo de teclado
; Teclado3.asm
; Verifica si se presiono tecla de funcion F1
.MODEL SMALL
.STACK 64
.DATA
;--------------------------------------------------------------
ASC		DB		'Presiono otra tecla$'
CAD    	DB      'Presiono F1$'
;--------------------------------------------------------------
.CODE
;----------------- Procedimiento de teclado -------------------
TECLADO PROC
		MOV AH, 00H	; Petición entrada del teclado al BIOS
		INT 16H		; Llama al BIOS
		CMP	AL, 0	; ¿Se presiono tecla de función?
		JNE SALIR	; no, ir a la salida
		CMP AH, 3BH	; presiono F1
		JNE SALIR	; no fue F1, ir a salida
		LEA DX,CAD  ; desplegar mensaje
		MOV AH,09H
		INT 21H
		JMP FIN
SALIR:  LEA DX,ASC  ; desplegar mensaje
		MOV AH,09H
		INT 21H
FIN:	RET
TECLADO ENDP
;----------------- Programa principal -------------------------
MAIN PROC NEAR
	MOV AX,@DATA ; inicializar area de datos
	MOV DS,AX
	CALL TECLADO
	MOV AX,4C00H
	INT 21H
MAIN ENDP
; -------------------------------------------------------------
END MAIN

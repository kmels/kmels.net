; Manejo de teclado
; Teclado1.asm
; Verifica si se presiono tecla de funcion
.MODEL SMALL
.STACK 64
.DATA
;--------------------------------------------------------------
ASC		DB		'Presiono tecla normal$'
CAD    	DB      'Presiono F1$'
;--------------------------------------------------------------
.CODE
;----------------- Procedimiento de teclado -------------------
TECLADO PROC
		MOV AH,01H	; Petición entrada del teclado
		INT 21H		; Llama a DOS
		CMP	AL, 0	; ¿Se presionó tecla de función?
		JNZ	ASCII	; no, es un carácter ASCII
		INT	21H		; si, repite operación para código de rastreo
		CMP AL, 3BH ; presiono f1 ?
		JE F1       ; si
		JMP SALIR
ASCII: 	LEA DX,ASC
		MOV AH,09H
		INT 21H
		JMP SALIR
F1: 	LEA DX,CAD  ; desplegar una cadena
		MOV AH,09H
		INT 21H
SALIR: 	RET
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

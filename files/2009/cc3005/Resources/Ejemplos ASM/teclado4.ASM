; Manejo de teclado
; Teclado4.asm
; Verifica si hay un caracter presente en el teclado
.model small
.stack 64
.data
;--------------------------------------------------------------
MEN		DB		'No ha ingresado caracter', 0DH, 0AH, '$'
;--------------------------------------------------------------
.code
;----------------- Procedimiento de teclado -------------------
TECLADO PROC
		MOV CX, 10000		; repeticiones para esperar el caracter
CICLO:	MOV	AH, 01H			; Petición 
		INT	16H
		JZ	MENSAJE			; Enviar mensaje si buffer esta vacío
							; Leer caracter con funcion 00H
		MOV AH, 00H			; Petición entrada del teclado al BIOS
		INT 16H				; Llama al BIOS
		CMP	AL, 0			; es tecla de funcion?
		JE SALIR			; si es tecla de funcion, salir
		MOV DL, AL			; pasar caracter ASCII al DL
		MOV AH, 02H
		INT 21H
		JMP SALIR
MENSAJE:LEA DX,MEN  ; desplegar una cadena
		MOV AH,09H
		INT 21H
		LOOP CICLO
SALIR:	RET
TECLADO ENDP
;----------------- Programa principal -------------------------
MAIN PROC NEAR
		MOV AX,@DATA ; inicializar area de datos
		MOV DS,AX
		CALL TECLADO
		MOV AX,4C00H
		INT 21H
MAIN ENDP
;--------------------------------------------------------------
END MAIN

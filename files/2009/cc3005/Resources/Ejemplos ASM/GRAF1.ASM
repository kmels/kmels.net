; Autor: Martha L. Naranjo
; Ideas tomadas del libro Lenguaje ensamblador y programacion
; para PC IBM y compatibles
; Cambia el fondo azul
; dibuja un pixel color amarillo
; si presiona una tecla diferente a ESC dibuja en la pantalla
.MODEL SMALL
.STACK
.DATA
COLOR			DB	1	; color paleta
X				DW	320 ; coordenada centro
Y				DW	240	; coordenada centro
.CODE
; ------------------- Programa principal --------------------
MAIN PROC
	.STARTUP
			
			CALL MODO_GRAFICO
			MOV CX,x						; coordenada centro
			MOV DX,y						; inicial para x,y
REPETIR:	CALL PIXEL
			CALL TECLA
			CMP AL,27		; Tecla ESC
			JNE REPETIR
			CALL RESTAURAR_MODO_ORIGINAL
			MOV AX,4C00H					; salida a DOS
			INT 21H		    
MAIN ENDP	
; ------------------- Designa modo grafico --------------------
MODO_GRAFICO PROC
	MOV AH,00H					; modo grafico 640*480
    MOV AL,12H
    INT 10H
	
	MOV AH,0BH					; paleta
	MOV BH,00H					; color de fondo
	MOV BL,color				; color azul
	INT 10H
	RET
MODO_GRAFICO ENDP
; ------------------- Escribe un pixel punto --------------------
PIXEL PROC	
		MOV AH,0CH
		MOV AL,0EH				    ;7=gris claro, E=amarillo
		MOV BH,0        
		INC CX						; simula el movimiento del punto
		INC DX						; mientras no se presiona ESC
		CMP CX,640					; si llego al extremo del eje x
		JE CAMBIOX					; cambiar la direccion
		CMP DX,480					; si llego al extremo del eje y
		JE CAMBIOY
		JMP SEGUIR
CAMBIOX:MOV CX, 0
CAMBIOY:MOV DX, 0
SEGUIR: INT 10H
		RET
PIXEL ENDP
; ------------------- Obtiene respuesta del teclado --------------------
TECLA PROC
	MOV AH,07H					; leer tecla sin eco
    INT 21H						
	RET
TECLA ENDP
; ------------------- Restaurar modo original de pantalla --------------------
RESTAURAR_MODO_ORIGINAL PROC
	MOV AL,03H				; modo texto 03h
	MOV AH,00H
	INT 10H
	RET
RESTAURAR_MODO_ORIGINAL ENDP

END MAIN
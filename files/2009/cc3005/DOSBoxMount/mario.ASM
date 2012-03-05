; ************************** MACRO PARA DARLE UN PLAY A UNA NOTA ***************************
PLAY	MACRO	FRECUENCIA, TIEMPO
	MOV	FREQ, FRECUENCIA
	MOV	TKS, TIEMPO
	CALL	BEEP
ENDM
; ******************************************************************************************

.MODEL SMALL
.STACK 64
.DATA

FREQ		DW	?	; frecuencia de la nota a sonar
TKS		DW	?	; duracion de la nota
fnlow		db	?
fnhigh		db	?
cont		db	?
getready	db	10110110b

.CODE

; ******************************************************************************************
BEEP	PROC	NEAR

	; convertir frecuencia a fn(numero que reconoce el puerto)

	MOV	AX, 34DCH
	MOV	DX, 12H		;1234DC es 1193180 que es lo que se divide
	MOV	BX, FREQ	;entre la frecuencia para encontrar numero que corresponde
	DIV	BX
	MOV	fnlow, AL	;se guarda el resultado en fnlow
	MOV	fnhigh, AH	; y fn high

	; decirle al puerto 43H que vamos a sacar un sonido
	mov al, getready
	out 43h, al		;se le pasa el 	10110110b

	;pasarle el fn al puerto 42h (speaker)
	MOV	AL, fnlow
	OUT	42H, AL		; se le pasa primero el low del fn
	MOV	AL, fnhigh
	OUT	42H, AL		; se le pasa el high del fn

	; encender el speaker
	IN AL, 61h		;se hace un get del estado del speaker (puerto 61h)
	OR AL, 00000011b	;se prende el speaker poniendo en 1 los bytes 0 y 1
	OUT 61h, AL		;se setea el puerto 61h

	;mantener encendido el speaker el tiempo que se requiera
	CALL	DELAY_SONIDO

	;despues de transcurrido el tiempo apagar el speaker
	IN AL, 61h		;otra vez se hace un get del estado del speaker
	AND AL, 11111100b	;se ponen en 0 los bytes 0 y 1 para apagarlo
	OUT 61h, AL		;se setea el puerto

	RET
BEEP	ENDP
; ******************************************************************************************
; ******************************************************************************************
DELAY_SONIDO	PROC	NEAR
	STI
	mov cx,tks		;pone en el contador el numero de ticks
	 mov ax,040h
	mov es,ax		;apunta el es al bios
	mov si,06ch
	push ds
	mov ds,ax		;y tambien el ds
wait1:  mov ax,[es:si]         ;obtiene el numero de ticks actuales
wait2:  cmp ax,[es:si]
	je wait2		;se enloopa hasta que sea un tick diferente
	loop wait1		;lo hace cx veces
	POP	DS

	RET
DELAY_SONIDO	ENDP
; ******************************************************************************************
; ******************************************************************************************
MAIN	PROC	NEAR
	MOV	AX, @DATA
	MOV	DS, AX

	CALL	mariobros	; hacer sonar la melodia

	MOV	AX, 4C00H
	INT	21H	; salir al DOS
MAIN	ENDP
; ******************************************************************************************

; ******************************************************************************************
mariobros	PROC	NEAR
	; procedimiento que tiene la melodia

	PLAY 130, 8	; sonar un C3-2
	PLAY 784, 4	; sonar un G5-1
	PLAY 740, 4	; sonar un F#5-1
	PLAY 698, 4	; sonar un F5-1
	PLAY 622, 4	; sonar un Eb5-1
	PLAY 164, 4	; sonar un E3-1
	PLAY 659, 4	; sonar un E5-1
	PLAY 146, 8	; sonar un D3-2
	PLAY 415, 4	; sonar un Ab4-1
	PLAY 440, 4	; sonar un A4-1
	PLAY 523, 4	; sonar un C5-1
	PLAY 174, 8	; sonar un F3-2
	PLAY 440, 8	; sonar un A4-2
	PLAY 523, 4	; sonar un C5-1
	PLAY 587, 4	; sonar un D5-1
	PLAY 164, 8	; sonar un E3-2
	PLAY 784, 4	; sonar un G5-1
	PLAY 740, 4	; sonar un F#5-1
	PLAY 698, 4	; sonar un F5-1
	PLAY 622, 4	; sonar un Eb5-1
	PLAY 261, 4	; sonar un C4-1
	PLAY 659, 4	; sonar un E5-1
	PLAY 174, 4	; sonar un F3-1
	PLAY 1046, 4	; sonar un C6-1
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	PLAY 1046, 4	; sonar un C6-1
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	PLAY 1046, 4	; sonar un C6-1
	PLAY 261, 8	; sonar un C4-2
	PLAY 130, 8	; sonar un C3-2
	PLAY 784, 4	; sonar un G5-1
	PLAY 740, 4	; sonar un F#5-1
	PLAY 698, 4	; sonar un F5-1
	PLAY 622, 4	; sonar un Eb5-1
	PLAY 164, 4	; sonar un E3-1
	PLAY 659, 4	; sonar un E5-1
	PLAY 146, 8	; sonar un D3-2
	PLAY 415, 4	; sonar un Ab4-1
	PLAY 440, 4	; sonar un A4-1
	PLAY 523, 4	; sonar un C5-1
	PLAY 174, 8	; sonar un F3-2
	PLAY 440, 8	; sonar un A4-2
	PLAY 523, 4	; sonar un C5-1
	PLAY 587, 4	; sonar un D5-1
	PLAY 130, 8	; sonar un C3-2
	PLAY 622, 8	; sonar un Eb5-2
	PLAY 130, 4	; sonar un C3-1
	PLAY 587, 8	; sonar un D5-2
	PLAY 130, 4	; sonar un C3-1
	PLAY 523, 8	; sonar un C5-2
	PLAY 523, 8	; sonar un C5-2
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	PLAY 523, 4	; sonar un C5-1
	PLAY 523, 4	; sonar un C5-1
	PLAY 130, 4	; sonar un C3-1
	PLAY 523, 8	; sonar un C5-2
	PLAY 523, 4	; sonar un C5-1
	PLAY 587, 8	; sonar un D5-2
	PLAY 659, 4	; sonar un E5-1
	PLAY 523, 8	; sonar un C5-2
	PLAY 440, 4	; sonar un A4-1
	PLAY 392, 8	; sonar un G4-2
	PLAY 392, 8	; sonar un G4-2
	PLAY 523, 4	; sonar un C5-1
	PLAY 523, 4	; sonar un C5-1
	PLAY 130, 4	; sonar un C3-1
	PLAY 523, 8	; sonar un C5-2
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	PLAY 523, 4	; sonar un C5-1
	PLAY 587, 4	; sonar un D5-1
	PLAY 659, 4	; sonar un E5-1
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	MOV	TKS, 4
	CALL	DELAY_SONIDO	; silencio de negra
	PLAY 196, 8	; sonar un G3-2
	PLAY 220, 8	; sonar un A3-2
	PLAY 246, 8	; sonar un B3-2
	PLAY 523, 4	; sonar un C5-1
	PLAY 523, 4	; sonar un C5-1
	PLAY 130, 4	; sonar un C3-1
	PLAY 523, 8	; sonar un C5-2
	PLAY 523, 4	; sonar un C5-1
	PLAY 587, 8	; sonar un D5-2
	PLAY 659, 4	; sonar un E5-1
	PLAY 523, 8	; sonar un C5-2
	PLAY 440, 4	; sonar un A4-1
	PLAY 392, 8	; sonar un G4-2
	PLAY 392, 8	; sonar un G4-2
	PLAY 659, 4	; sonar un E5-1
	PLAY 659, 4	; sonar un E5-1
	PLAY 392, 4	; sonar un G4-1
	PLAY 659, 8	; sonar un E5-2
	PLAY 523, 4	; sonar un C5-1
	PLAY 659, 8	; sonar un E5-2
	PLAY 784, 8	; sonar un G5-2
	PLAY 784, 8	; sonar un G5-2
	PLAY 196, 8	; sonar un G3-2
	PLAY 196, 8	; sonar un G3-2

	RET
mariobros	ENDP
; ******************************************************************************************
END	MAIN
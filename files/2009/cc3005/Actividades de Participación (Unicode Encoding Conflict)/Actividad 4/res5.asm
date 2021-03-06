; **********************************************************************************
; Autor: Abel, P. 
; Fecha de creacion: 
; CC-3005 Programacion en Assembler
; res5.asm: con alt F10 se activa la bocina
; **********************************************************************************
CODESG		SEGMENT PARA
			ASSUME 	CS:CODESG
			ORG 	100H
MAIN:		JMP 	SHORT LOAD		; SALTA AL INICIO
OLDINT9		DD		?			; DIRECCION DE LA INT 09H DEL TECLADO
;-----------ESTA PARTE SE MANTIENE RESIDENTE
NEWINT9		PROC
			PUSH AX
			MOV AH,2			; OBTIENE ESTADO DEL TECLADO
			INT 16H
			TEST AL, 00001000B	; CHEQUEA EL ALT
			JZ OVER				; NO HAY ALT, SALE
			IN AL, 60H			; OBTIENE CODIGO DE RASTREO
			CMP AL, 44H			; VE SI ES TECLA F10
			JNE OVER			; NO ES F10, SALE
			MOV AH, 0EH			; SI ES F10, SUENA LA BOCINA
			MOV AL, 07			; USANDO EL BIOS
			INT 10H
							
OVER:		POP AX
			JMP CS:OLDINT9
NEWINT9		ENDP
; ----------ESTA PORCION SE EJECUTA SOLO UNA VEZ DURANTE LA INICIALIZACION
			ASSUME 	CS:CODESG, DS:CODESG
LOAD		PROC NEAR
			MOV AH, 35H			; OBTENER VALORES DEL VECTOR PARA INT 09H
			MOV AL, 09H
			INT 21H
			MOV	WORD PTR OLDINT9, BX
			MOV	WORD PTR OLDINT9+2, ES
			MOV AH, 25H
			MOV	AL, 09H		; FIJAR NUEVA DIRECCION PARA INT 09H
			MOV	DX, OFFSET NEWINT9
			INT 21H
			MOV DX, (OFFSET LOAD - OFFSET CODESG); ENCUENTRA CUANTOS BYTES OCUPA EL RESIDENTE
			ADD DX,15								; MULTIPLICA POR 16
			MOV CL, 4
			SHR DX, CL
			MOV AH, 31H
			INT 21H
LOAD		ENDP
CODESG		ENDS
			END MAIN


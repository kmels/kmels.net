; **********************************************************************************
; Autor:  EL UNIVERSO DIGITAL  	DEL IBM PC, AT Y PS/2
; Edición 4.0 (4ª) 	Ciriaco García de Celis
; Fecha de creacion: 
; CC-3005 Programacion en Assembler
; res6.asm: Escribe caracteres en pantalla 18.2 veces por seg
; **********************************************************************************
demores        SEGMENT
               ASSUME CS:demores, DS:demores

               ORG   100h
inicio:
               JMP   main

controla_int08 PROC
               PUSHF
               CALL  CS:ant_int08   ; llamar al gestor normal de INT 8
               STI
               CMP   CS:in10,0
               JNE   fin_int08      ; estamos dentro de INT 10h

               ;
               ; Colocar aquí el proceso a ejecutar 18,2 veces/seg.
               ; que puede invocar funciones de INT 10h
			   ; Instrucciones que dibujan cinco corazones
			
				CMP YaSalio, 1
				JE fin_int08
				
				;Revisar si presiono Alt+F10
				MOV AH,2			; OBTIENE ESTADO DEL TECLADO
				INT 16H
				TEST AL, 00001000B	; CHEQUEA EL ALT
				JZ Pintar				; NO HAY ALT, SALE
				IN AL, 60H			; OBTIENE CODIGO DE RASTREO
				CMP AL, 44H			; VE SI ES TECLA F10
				JNE Pintar			; NO ES F10, SALE
				
				;limpiar pantalla
				MOV AX, 0600H 
				MOV BH, 07H
				MOV CX, 0000H
				MOV DX, 184FH
				INT 10H
				
				MOV YaSalio, 1
				
				LEA AX,ant_int08_seg
				MOV DS, AX
				LEA BX,ant_int08_off
				MOV AX, 2508H
				INT 21H 
				
				;termina el residente
				JMP fin_int08
Pintar:	
				MOV AX,0605H
				MOV BH,7DH
				MOV CL,C1
				MOV CH,0

				MOV DL,C2                         ;columna  
				MOV DH,15                         ;fila baja la figura
				INT 10h 	   

				CMP C1, 78
				JG fin_int08
				
				ADD C1,10
				ADD C2,10

				MOV AH,02H
				MOV BH,00H
				MOV DH,C1
				MOV DL,C2
				INT 10H
fin_int08:
               IRET
controla_int08 ENDP

controla_int10 PROC
               INC   CS:in10        ; indicar entrada en INT 10h
               PUSHF
               CALL  CS:ant_int10
               DEC   CS:in10        ; fin de la INT 10h
               IRET
controla_int10 ENDP

in10           DB    0              ; mayor de 0 si hay INT 10h
ant_int08      LABEL DWORD
ant_int08_off  DW    ?
ant_int08_seg  DW    ?
ant_int10      LABEL DWORD
ant_int10_off  DW    ?
ant_int10_seg  DW    ?
yasalio			DB	?
C1 			db	10
C2			Db 30

               ; Dejar residente hasta aquí.

main:          PUSH  ES
               MOV   AX,3508h
               INT   21h               ; obtener vector de INT 8
               MOV   ant_int08_seg,ES
               MOV   ant_int08_off,BX
               MOV   AX,3510h
               INT   21h               ; obtener vector de INT 10h
               MOV   ant_int10_seg,ES
               MOV   ant_int10_off,BX
               POP   ES

			   
               LEA   DX,controla_int08
               MOV   AX,2508h
               INT   21h               ; nueva rutina de INT 8

               LEA   DX,controla_int10
               MOV   AX,2510h
               INT   21h               ; nueva rutina de INT 10h

               PUSH  ES
               MOV   ES,DS:[2Ch]       ; dirección del entorno
               MOV   AH,49h
               INT   21h               ; liberar espacio de entorno
               POP   ES

               LEA   DX,main           ; fin del código residente
               ADD   DX,15             ; redondeo a párrafo
               MOV   CL,4
               SHR   DX,CL             ; bytes -> párrafos
               MOV   AX,3100h          ; terminar residente
               INT   21h

demores        ENDS
               END   inicio

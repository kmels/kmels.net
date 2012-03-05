; **********************************************************************************
; Autor:  EL UNIVERSO DIGITAL  	DEL IBM PC, AT Y PS/2
; Edición 4.0 (4ª) 	Ciriaco García de Celis
; Fecha de creacion: 
; CC-3005 Programacion en Assembler
; res6.asm: Escribe caracteres en pantalla 18.2 veces por seg
; **********************************************************************************


; **********************************************************************************
DESP	MACRO CADENA,VECES
	mov ah,09h
	mov al,CADENA		; codigo ascii del caracter
	mov bh,00		; pagina 0
	mov bl,0f4h		; atributo
	mov cx,VECES		; veces
	int 10h
	
ENDM
; ***********************************************************************************

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
				

			   
	       MOV  CADE,01H
	       MOV  VEZ,5
	       DESP CADE,VEZ

	       MOV  CADE,17H
	       MOV  VEZ,1
	       DESP CADE,VEZ
	
	       MOV  CADE,01H
	       MOV  VEZ,4
	       DESP CADE,VEZ

	       MOV  CADE,17H
	       MOV  VEZ,1
	       DESP CADE,VEZ
	
	       MOV  CADE,01H
	       MOV  VEZ,3
	       DESP CADE,VEZ

	       MOV  CADE,17H
	       MOV  VEZ,1
	       DESP CADE,VEZ
	
	       MOV  CADE,01H
	       MOV  VEZ,2
	       DESP CADE,VEZ

	       MOV  CADE,17H
	       MOV  VEZ,1
	       DESP CADE,VEZ
	
	       MOV  CADE,01H
	       MOV  VEZ,1
	       DESP CADE,VEZ


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
CADE	       DB    ?
VEZ            DB    ?


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

TITLE	MINMAY Conversion de minusculas a mayusculas
;-------------------------------------------------
; las letras de la A a la Z son desde 41H a 5AH
; las letras de la a a la z son desde 61H a 7AH
; la diferencia se encuentra en el bit 5: mayusc 0, minusc 1

	.MODEL SMALL
	.STACK 64
	.DATA
; Definicion de datos

NOMBRE DB 'Ingrese cadena a cambiar', '$' ; cadena de despliegue
LISTA  LABEL BYTE                    ; inicio de la lista de parametros
MAXLEN DB    10                       ; numero maximo de caracteres de entrada
ACTLEN DB    ?                       ; numero real de caracteres de entrada
CAMPO  DB    10 DUP (' ')             ; caracteres introducidos del teclado
FIN    DB    '$'
ENTRAR  DB 0DH, 0AH, '$'

;-------------------------------------------------
; Inicio del codigo
	.CODE
;-------------------------------------------------
; Funcion de entrada
CIN	PROC NEAR

       MOV AH, 0AH    ; peticion de la funcion de entrada
       LEA DX, LISTA  ; carga la direccion de la lista de parametros
       INT 21H        ; llama al DOS
       RET

CIN	ENDP
;-------------------------------------------------
; Funcion de despliegue
COUT   PROC NEAR

       MOV AH, 09H   ; peticion para desplegar
       INT 21H       ; llama al DOS
       RET

COUT   ENDP
;-------------------------------------------------
; funcion de cambio de mayuscula a minuscula
MAYUS  PROC NEAR

       LEA BX, CAMPO 	; primer caracter a cambiar
       MOV CX, 30      ; numero de campos a cambiar
CICL1:
       MOV AH, [BX]    ; caracter de CAMPO
       CMP AH, 61H     ; Es letra minuscula ?
       JB  CICL2       ; NO. (salte si es menor)
       CMP AH, 7AH     ;
       JA  CICL2       ; NO. (salte si es mayor)
       AND AH, 11011111B ; SI. convertir a mayusculas
       MOV [BX], AH      ; copiar el caracter en mayusculas

CICL2:
       INC BX            ; siguiente caracter
       LOOP CICL1        ; repetir 30 veces

       RET

MAYUS  ENDP
;-------------------------------------------------
BEGIN	PROC FAR

        MOV AX,@data	        ;inicializa segmento de datos
		MOV DS,AX

        LEA DX, NOMBRE         ; carga la direccion de la cadena
        CALL COUT
        CALL CIN

        ; para desplegar los caracteres que se leyeron

        LEA DX, CAMPO          ; carga la direccion de la cadena a desplegar
        CALL COUT

        ; realizar las conversiones necesarias para hacer el cálculo con el número

        CALL MAYUS

        CALL COUT

        MOV AH, 4CH   ; salida al DOS
	INT 21H

BEGIN	ENDP
	END BEGIN

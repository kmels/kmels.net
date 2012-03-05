; Modos de video
.model small 
.stack 64
.data
;--------------------------------------------------------------
MENSAJE	db	'Esta es una prueba Esta es una prueba Esta es una prueba Esta es una prueba Esta es una prueba '
;--------------------------------------------------------------
.code
    MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	MOV ES, AX

	MOV AH, 00H ;Designación de modo
	MOV AL, 00H ;Texto a color, 80x40
	INT 10H	  ;Llama al BIOS
    
	MOV AH, 13H ; Petición
	MOV AL, 00H ; Subfuncion: despliega atributo y cadena
	MOV BH, 0 	; Pagina: 0, 1, 2, 3
	MOV BL, 0A8H ; atributos de pantalla
	MOV BP, OFFSET MENSAJE ; dirección de la cadena en ES:BP
	MOV CX, 100 	; longitud de la cadena de caracteres
	MOV DX, 900; posición relativa de inicio en la pantalla
	INT 10H

    MOV AX,4C00H            ; salir a DOS
	INT 21H
end

.model small
.stack 64
;-----------------------------------------------------------------------------
.data
mensaje	DB 'Prueba de despliegue directo en video','$'
;-----------------------------------------------------------------------------
.code
MAIN PROC FAR
    mov ax, @DATA          ; inicializar area de datos
	mov ds, ax

	mov ax,0B800h ; dirección de inicio de memoria de video 
			      ; pagina 0
    mov es,ax     ; se carga al registro ES la direcc mem ¡MUY IMPORTANTE ¡
	mov di,0	  ; desplazamiento. Memoria formada por ES:DI

    mov cx,2000    ; numero de veces que se repite la impresion
    mov al,01h     ; se carga el caracter que va a imprimirse
    mov ah,0Dh    ; atributo
    rep stosw      ; almacena el contenido del acumulador en
					; la memoria. El prefijo REP junto con CX
					; hace que se repita la operacion CX veces
					; El par ES:DI hace referencia al area de
					; memoria donde sera almacenado

	mov ax,4C00H
	int 21h
MAIN ENDP
END MAIN
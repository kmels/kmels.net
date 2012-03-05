.model small
.stack 64
.data
;--------------------------------------------------------------
atr1	db		05h
atr2	db		0a8h
atr3	db		30h
atr		db		?
dirpag0	dw		0b800h
dirpag1	dw		0b900h
dirpag2	dw		0ba00h
pagina0 db      'Pagina 0'
pagina1 db      'Pagina 1'
pagina2 db      'Pagina 2'
cont    dw      0
;--------------------------------------------------------------
.code
;------------------- Programa principal -----------------------
main proc far
        mov ax, @DATA           ; inicializar area de datos
		mov ds, ax
		
		mov dx, dirpag0			; Cargar página 0
		mov bl, atr1			; carga atributo
		mov atr, bl
		mov bx, offset pagina0  ; mensaje que se va a imprimir
		call pagina
		
		mov dx, dirpag1			; Cargar página 1
		mov bl, atr2			; carga atributo
		mov atr, bl
		mov bx, offset pagina1  ; mensaje que se va a imprimir
		call pagina
		
		mov dx, dirpag2			; Cargar página 1
		mov bl, atr3			; carga atributo
		mov atr, bl
		mov bx, offset pagina2  ; mensaje que se va a imprimir
		call pagina
		
		mov ah, 05h             ; pasarse a la pagina 2
        mov al, 02
        int 10h

        mov ah, 10h             ; peticion de un caracter del teclado
        int 16h                 ; llama al BIOS
        
		mov ah, 05h             ; pasarse a la pagina 1
        mov al, 01
        int 10h

        mov ah, 10h             ; peticion de un caracter del teclado
        int 16h                 ; llama al BIOS
        
		mov ah, 05h             ; pasarse a la pagina 0
        mov al, 00
        int 10h

        mov ax,4C00H            ; salir a DOS
		int 21h
main endp
;------------------- Imprimir en pagina -----------------------
pagina proc
        mov ax,dx           	; dx contiene direccion de inicio de memoria de video
        mov es,ax               ; se carga al registro ES la dir direcc mem
		mov di,0
        mov cont, 0             ; inicializa contador a cero
ciclo:  mov al, [bx]            ; se carga el caracter que va a imprimirse "
        mov ah, atr			    ; atributo
        stosw                   ; almacena el contenido del acumulador en
                                ; la memoria. El prefijo REP junto con CX
                                ; hace que se repita la operacion CX veces
                                ; El par ES:DI hace referencia al area de
                                ; memoria donde sera almacenado
        inc bx                  ; incrementa puntero de la cadena
        inc cont                ; incrementa contador
        cmp cont, 2000          ; hasta llegar al tamanno de la cadena
        jne ciclo
		ret
pagina endp
    
end main

.model small
.stack 64
.data
;--------------------------------------------------------------
mensaje db      '                                 MENSAJE SECRETO MENSAJE SECRETO MENSAJE SECRETO MENSAJE SECRETO MENSAJE SECRETO'
cont    db      0
;--------------------------------------------------------------
.code
begin proc far
        mov ax, @DATA           ; inicializar area de datos
		mov ds, ax

        mov ax,0B800h           ; direccion de inicio de memoria de video
        mov es,ax               ; se carga al registro ES la dir direcc mem
		mov di,100
        mov cont, 0             ; inicializa contador a cero
        mov bx, offset mensaje  ; mensaje se carga en bx
ciclo:  mov al, [bx]            ; se carga el caracter que va a imprimirse "
        mov ah,0fh                ; atributo
        stosw                   ; almacena el contenido del acumulador en
                                ; la memoria.
                                ; El par ES:DI hace referencia al area de
                                ; memoria donde sera almacenado
        inc bx                  ; incrementa puntero de la cadena
        inc cont               ; incrementa contador
        cmp cont, 255          ; hasta llegar al tamanno de la cadena
        jne ciclo

        mov ax,4C00H            ; salir a DOS
		int 21h
begin endp
end begin


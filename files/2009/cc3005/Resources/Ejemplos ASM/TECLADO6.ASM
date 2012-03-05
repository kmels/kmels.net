; Manejo teclas duplicadas
; Revisa si presiono enter de panel numérico o panel extendido
.model small
.stack 64
.data
;--------------------------------------------------------------
enter1  db 'Presiono Enter Panel central', '$'
enter2	db 'Presiono Enter Panel numerico-extendido', '$'
vacio		db	'$'
;--------------------------------------------------------------
.code
;----------- Procedimiento shift de teclado -------------------
enter0 proc				; revisar el estado del shift de teclado
        mov ah, 0ch     ; limpiar buffer de teclado
        int 21h
		mov ah, 10h		; entrada desde el teclado
		int 16h
		cmp ah, 1ch		; es enter panel central?
		je e1
		cmp ah, 0e0h	; es enter panel extendido?
		je e2
		lea dx, vacio
		jmp salir
e1:		lea dx, enter1     ; desplegar una cadena
        jmp salir
e2:		lea dx, enter2    ; desplegar una cadena
salir:  mov ah, 09h
        int 21h
		ret
enter0 endp
;----------------- Programa principal -------------------------
main    proc far
        mov ax, @DATA           ; inicializar area de datos
		mov ds, ax
		call enter0
		mov ax, 4C00H
        int 21h
 main    endp
;---------------------------------------------------------------------------
end main
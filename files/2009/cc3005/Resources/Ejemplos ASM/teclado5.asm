; teclado5.asm
; Manejo del shift del teclado
; Revisa si presiono las teclas: NumLock, CapLock ScrollLock
; solo indica la última tecla presionada
.model small
.stack 64
.data
;--------------------------------------------------------------
s1     db      'Presiono CapsLock', '$'
s2     db      'Presiono NumLock', '$'
s3     db      'Presiono ScrollLock', '$'

;--------------------------------------------------------------
.code
;----------- Procedimiento shift de teclado -------------------
SHIFT PROC			 ; revisar el estado del shift de teclado
        mov ah, 0ch  ; limpiar buffer de teclado
        int 21h
		mov ah, 10h	; entrada desde el teclado sin eco
		int 16h		; para teclado extendido
		mov ah, 02h	; regresa el estado actual del shift del teclado
        int 16h
        cmp al,40h	; caps lock presionado ? 
        je caps_lock; si, desplegar cadena    
		cmp al,20h	; num lock presionado ? 
        je num_lock ; si, desplegar cadena
        cmp al,10h	; scroll lock presionado ? 
        je scroll_lock 	; si, desplegar cadena
num_lock: 
		lea dx, s2     ; desplegar una cadena
        mov ah, 09h
        int 21h
        jmp salir
scroll_lock: 
		lea dx, s3     ; desplegar una cadena
        mov ah, 09h
        int 21h
        jmp salir
caps_lock: 
		lea dx, s1     ; desplegar una cadena
        mov ah, 09h
        int 21h
        jmp salir
salir:  ret
SHIFT ENDP
;----------------- Programa principal -------------------------
main    proc far
        mov ax, @DATA; inicializar area de datos
		mov ds, ax
		call shift
        mov ax, 4C00H
        int 21h
 main    endp
;---------------------------------------------------------------
end main

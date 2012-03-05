.model small
.stack 64
.data

freq	dw	?	;do escala 4
tiempo		dw	3	;1/6 de segundo
freclow           db      ?
frecalta          db      ?

;notas musicales
do			equ	262
si_			equ	494

.code

;-----------------------------------------------------------------------------
main proc far
	mov ax, @data
	mov ds, ax		;inicializa el segmento de datos

Musiquita:
	
	;decirle al puerto 43h que vamos a hacer sonar la bocina
	mov al, 10110110b	; alistarse
	out 43h, al		;se le pasa el 	10110110b

	;pasarle el fn al puerto 42h (speaker)
	mov al, 40
	out 42h, al			;se le pasa primero el low del fn
	mov al, 20
	out 42h, al			;se le pasa el high del fn

	;encender el speaker
	in al, 61h			;obtener el estado del puerto 61h (el del speaker)
	or al, 00000011b	;se va a prender el speaker prendiendo los bits (en 1) 0 y 1
	out 61h, al			;mandarselo al puerto
	
	;mantener encendido el speaker el tiempo que se requiera
    ; ***
	; Delay
	; ***
	sti                     
    mov cx,5			;pone en el contador el numero de ticks                
    mov ax,040h  		          
    mov es,ax				;apunta el es al bios
    mov si,06ch
    push ds
    mov ds,ax				;y tambien el ds
esperar3:  mov ax,[es:si]       ;obtiene el numero de ticks actuales    
esperar4:  cmp ax,[es:si]              
    je esperar4				;se enloopa hasta que sea un tick diferente
    loop esperar3			;lo hace cx veces                 
	pop ds
	
	; despues de transcurrido el tiempo apagar el speaker
	in al, 61h			;de nuevo, se obtiene el estado del puerto del speaker
	and al, 11111100b	;se va a apagar el speaker, poniendo los bits (en 0) 0 y 1	
	out 61h, al			;mandarselo al puerto
	

    
    
    

	
	;decirle al puerto 43h que vamos a hacer sonar la bocina
	mov al, 10110110b	; alistarse
	out 43h, al		;se le pasa el 	10110110b

	;pasarle el fn al puerto 42h (speaker)
	mov al, 70
	out 42h, al			;se le pasa primero el low del fn
	mov al, 30
	out 42h, al			;se le pasa el high del fn

	;encender el speaker
	in al, 61h			;obtener el estado del puerto 61h (el del speaker)
	or al, 00000011b	;se va a prender el speaker prendiendo los bits (en 1) 0 y 1
	out 61h, al			;mandarselo al puerto
	
	;mantener encendido el speaker el tiempo que se requiera
    ; ***
	; DELAy
	; ***
	sti                     
    mov cx,5			;pone en el contador el numero de ticks                
    mov ax,040h  		          
    mov es,ax				;apunta el es al bios
    mov si,06ch
    push ds
    mov ds,ax				;y tambien el ds
esperar5:  mov ax,[es:si]       ;obtiene el numero de ticks actuales    
esperar6:  cmp ax,[es:si]              
    je esperar6			;se enloopa hasta que sea un tick diferente
    loop esperar5			;lo hace cx veces                 
	pop ds
	
	; despues de transcurrido el tiempo apagar el speaker
	in al, 61h			;de nuevo, se obtiene el estado del puerto del speaker
	and al, 11111100b	;se va a apagar el speaker, poniendo los bits (en 0) 0 y 1	
	out 61h, al			;mandarselo al puerto
 	
 	JMP Musiquita
 	
 	
Salir:
	mov ax, 4c00h
	int 21h			;salir al dos
main endp
end main

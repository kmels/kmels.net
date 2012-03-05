;Beep by 414C485649

;Saca un sonido de la frecuencia especificada en freq el tiempo que se ponga en
;la variable tks (el tiempo se da en ticks, 18.2 ticks = 1 seg)
;fuente http://www.riverland.net.au/~mdunn/

.model small
.stack 64
.data

freq		dw	104	;do escala 4
tks		dw	18	;1/2 segundo
fnlow           db      ?
fnhigh          db      ?
temp		db	?
getready	db	10110110b

.code
;---------------------------------------------------------------------------
beep proc near
	;cli
	;convertir frecuencia a fn(numero que reconoce el puerto)

	mov ax, 34dch
	mov dx, 12h		;1234dc es 1193180 que es lo que se divide
	mov bx, freq		;entre la frecuencia para encontrar numero que le corresponde
	div bx
	mov fnlow, al		;se guarda el resultado en fnlow
	mov fnhigh, ah		;y fn high para despues mandarselo al puerto

	;decirle al puerto 43h que vamos a sacar un sonido
	mov al, getready
	out 43h, al		;se le pasa el 	10110110b

	;pasarle el fn al puerto 42h (speaker)
	mov al, fnlow
	out 42h, al		;se le pasa primero el low del fn
	mov al, fnhigh
	out 42h, al		;se le pasa el high del fn

	;encender el speaker
	in al, 61h		;se hace un get del estado del speaker (puerto 61h)
	or al, 00000011b	;se prende el speaker poniendo en 1 los bytes 0 y 1
	out 61h, al		;se setea el puerto 61h

	;mantener encendido el speaker el tiempo que se requiera
	
    call delay

	;despues de transcurrido el tiempo apagar el speaker

	in al, 61h		;otra vez se hace un get del estado del speaker
	and al, 11111100b	;se ponen en 0 los bytes 0 y 1 para apagarlo
	out 61h, al		;se setea el puerto

	ret			;ya
beep endp
;---------------------------------------------------------------------------
delay proc near
     
      	sti                     
        mov cx,tks		;pone en el contador el numero de ticks
        mov ax,040h  		          
        mov es,ax		;apunta el es al bios
        mov si,06ch
        push ds
        mov ds,ax		;y tambien el ds
wait1:  mov ax,[es:si]          ;obtiene el numero de ticks actuales    
wait2:  cmp ax,[es:si]              
        je wait2		;se enloopa hasta que sea un tick diferente
        loop wait1		;lo hace cx veces                 
        pop ds
        ret
delay endp
;-----------------------------------------------------------------------------
main proc far

	mov ax, @data
	mov ds, ax		;inicializa el segmento de datos
	
	call beep		;llama a la funcion beep
	
	mov ax, 4c00h
	int 21h			;salir al dos
main endp
end main

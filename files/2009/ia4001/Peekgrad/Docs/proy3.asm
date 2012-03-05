; **********************************************************************************
; Macros
; **********************************************************************************
ConvertirFrecuencia_A_Fn MACRO Frecuencia
	;convertir frecuencia a fn(numero que reconoce el puerto)
	mov ax, 34dch
	mov dx, 12h			;1234dc es 1193180 que es lo que se divide
	mov bx, frecuencia	;entre la frecuencia para encontrar numero que le corresponde
	div bx
	mov fnlow, al		;se guarda el resultado en fnlow 
	mov fnhigh, ah		;y fn high
ENDM

SonarFrecuencia 	MACRO	Frecuencia		; define macro
	ConvertirFrecuencia_A_Fn Frecuencia
	call sonar
	
	
ENDM			; fin macro


;En el tren by 414C485649

;Toca la cancion en el tren.. :D 
;fuente http://www.riverland.net.au/~mdunn/

.model small
.stack 64
.data

freq	dw	?	;do escala 4
tks		dw	3	;1/6 de segundo
fnlow           db      ?
fnhigh          db      ?
cont		db	?


do			equ	262
do_s		equ	277
re			equ	294
re_s		equ	311
mi			equ	330
fa			equ	349
fa_s		equ	370
sol			equ	392
sol_s		equ	415
la			equ	440
las			equ	466
si_			equ	494
do8			equ	523
re8			equ	587

.code
;---------------------------------------------------------------------------
sonar proc near
	;decirle al puerto 43h que vamos a hacer sonar la bocina
	mov al, 10110110b	; alistarse
	out 43h, al		;se le pasa el 	10110110b

	;pasarle el fn al puerto 42h (speaker)
	mov al, fnlow
	out 42h, al			;se le pasa primero el low del fn
	mov al, fnhigh
	out 42h, al			;se le pasa el high del fn

	;encender el speaker
	in al, 61h			;obtener el estado del puerto 61h (el del speaker)
	or al, 00000011b	;se va a prender el speaker prendiendo los bits (en 1) 0 y 1
	out 61h, al			;mandarselo al puerto
	
	;mantener encendido el speaker el tiempo que se requiera
    call delay

	; despues de transcurrido el tiempo apagar el speaker
	in al, 61h			;de nuevo, se obtiene el estado del puerto del speaker
	and al, 11111100b	;se va a apagar el speaker, poniendo los bits (en 0) 0 y 1	
	out 61h, al			;mandarselo al puerto
	
	ret	
sonar endp
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

	MOV CX, 4
Musiquita:
	SonarFrecuencia si_ 
 	SonarFrecuencia do_s
 	call delay
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_ 
 	SonarFrecuencia si_ 
 	SonarFrecuencia do_s
 	call delay
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_ 
 	
 	SonarFrecuencia mi 
 	SonarFrecuencia fa
 	call delay
 	SonarFrecuencia fa 
 	SonarFrecuencia mi
 	
 	SonarFrecuencia si_ 
 	SonarFrecuencia do_s
 	call delay
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_ 
 	
 	SonarFrecuencia si_ 
 	SonarFrecuencia do_s
 	call delay
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_  
 	
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_ 
 	SonarFrecuencia si_ 
 	SonarFrecuencia do_s
 	call delay
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_
 	
 	SonarFrecuencia la 
 	SonarFrecuencia si_
 	call delay
 	SonarFrecuencia do8 
 	SonarFrecuencia do8
 	SonarFrecuencia do8 
 	SonarFrecuencia do8
 	
 	SonarFrecuencia re8 
 	SonarFrecuencia re8
 	la			equ	440
 	SonarFrecuencia si_ 
 	call delay
 	
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_ 
 	
 	SonarFrecuencia mi 
 	SonarFrecuencia fa
 	call delay
 	SonarFrecuencia fa 
 	SonarFrecuencia mi
 	
 	SonarFrecuencia si_ 
 	SonarFrecuencia do_s
 	call delay
 	SonarFrecuencia re_s 
 	SonarFrecuencia si_ 
 	JMP Musiquita
 	
 	
Salir:
	mov ax, 4c00h
	int 21h			;salir al dos
main endp
end main

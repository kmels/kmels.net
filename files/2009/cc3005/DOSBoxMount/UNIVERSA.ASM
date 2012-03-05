;Universal mind by 414C485649

;Toca Universal Mind de Liquid Tension Experiment hasta que termine o
;se presione cualquier tecla
;fuente http://www.riverland.net.au/~mdunn/ de como hacer un beep

.model small
.stack 64
.data

freq		dw	104	;do escala 4
tks		dw	2	;1/2 segundo
fnlow           db      ?
fnhigh          db      ?
cont		db	?
getready	db	10110110b
teclazo         db      0
sol2	equ 98
sols2	equ 104
la2	equ 110
las2	equ 116
si2	equ 123
do3	equ 131
dos3	equ 139
re3	equ 147
res3	equ 155
mi3	equ 165
fa3	equ 175
fas3	equ 185
sol3	equ 196
sols3	equ 208
la3	equ 220
las3	equ 233
si3	equ 245
do4	equ 262
dos4	equ 277
re4  	equ 294
res4	equ 311
mi4	equ 330
fa4	equ 349
fas4	equ 370
sol4	equ 392
sols4	equ 415
la4	equ 440
las4	equ 466
si4	equ 494
do5	equ 523
dos5	equ 554
re5	equ 587
res5	equ 622
mi5	equ 659
fa5	equ 698
fas5	equ 740
sol5	equ 784
sols5	equ 831
la5	equ 880
las5	equ 932
si5	equ 988
do6	equ 1046

.code
;---------------------------------------------------------------------------
beep proc near
	cli
	;convertir frecuencia a fn(numero que reconoce el puerto)

	mov ax, 34dch
	mov dx, 12h		;1234dc es 1193180 que es lo que se divide
	mov bx, freq		;entre la frecuencia para encontrar numero que le corresponde
	div bx
	mov fnlow, al		;se guarda el resultado en fnlow
	mov fnhigh, ah		;y fn high

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
play macro f
  	mov freq, f
  	call beep
  	call readkey
  	call comparar
endm
;-----------------------------------------------------------------------------

cmp1 proc near
        mov tks, 2
	play la5
	play fa5
	play las4
	play la4
	play las4
	play fa5
	play la5
	play fa5
	play las4
	play la4
	play fa4
	play mi4
	play fa4
	play la4
	play las4
	play fa5
	ret
cmp1 endp
;------------------------------------------------------------------------------
cmp4 proc near
	play do6
	play sol5
	play do5
	play las4
	play do5
	play sol5
	play do6
	play sol5
	play do5
	play las4
	play do5
	play sol5
	play do6
	play sol5
	play do5
	play las4
	ret
cmp4 endp
;------------------------------------------------------------------------------
cmp8 proc near
	play do6
	play fa5
	play do5
	play fa5
	play las5
	play fa5
	play do5
	play fa5
	play la5
	play fa5
	play do5
	play fa5
	play sol5
	play fa5
	play do5
	play fa5
	ret
cmp8 endp
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
parte1 proc near
	mov tks, 2		;tiempo 2 ticks
	call cmp1
	call cmp1
	call cmp1
	call cmp4
	call cmp1
	call cmp1
	call cmp1
	call cmp8
	ret
parte1 endp
;------------------------------------------------------------------------------
cmp17 proc near
	mov tks, 4		;corchea
	play re4
	mov tks, 16		;blanca
	play re3
	mov tks, 4		;corchea
	play mi3
	call delay		;silencio de corchea
cmp18:	mov tks, 8		;dos corcheas
	play fa3
	mov tks, 4		;corchea
	play sol3
	play la3
	mov tks, 12		;negra con punto
	play do4
	mov tks, 4		;corchea
	play mi4
	play do4
	ret
cmp17 endp
;------------------------------------------------------------------------------
cmp19 proc near
	mov tks, 4		;corchea
	play re4
	mov tks, 8		;negra
	play re3
	mov tks, 4		;corchea
	play mi3
	play fa3
	play sol3
	play la3
cmp20:	mov tks, 8		;dos corcheas
	play do4
	mov tks, 4		;corchea
	play mi4
	mov tks, 16
	play sol3
	mov tks, 2		;semi corchea
	play sol3
	play la3
	mov tks, 4		;corchea
	play do4
	ret
cmp19 endp
;------------------------------------------------------------------------------
cmp23  proc near
	mov tks, 4		;corchea
	play re4
	mov tks, 8		;negra
	play re3
	mov tks, 4		;corchea
	play mi3
	play fa3
	play sol3
	play la3
cmp24:	mov tks, 36		;corchea con redonda
	play do4		;es do y sol???
	ret
cmp23 endp
;------------------------------------------------------------------------------
parte2 proc near
	call cmp17
	call cmp19
	call cmp17
	call cmp23
	ret
parte2 endp
;------------------------------------------------------------------------------
cmp33 proc near
	mov tks, 4		;corchea
	play sol3
	mov tks, 16		;blanca
	play sol2
	mov tks, 4		;corchea
	play la2
	call delay		;silencio de corchea
cmp34:	mov tks, 8		;dos corcheas
	play las2
	mov tks, 4		;corchea
	play do3
	play re3
	mov tks, 12		;negra con puntillo
	play fa3
	mov tks, 4		;corchea
	play la3
	play fa3
	ret
cmp33 endp
;------------------------------------------------------------------------------
cmp35 proc near
	mov tks, 4		;corchea
	play sol3
	mov tks, 8		;negra
	play sol2
	mov tks, 4		;corchea
	play la2
	play las2
	play do3
	play re3
cmp36:	mov tks, 8		;dos corcheas
	play fa3
	mov tks, 4		;corchea
	play la3
	mov tks, 16		;blanca
	play do3
	mov tks, 2		;semicorchea
	play do3
	play re3
	mov tks, 4		;corchea
	play fa3
	ret
cmp35 endp
;------------------------------------------------------------------------------
cmp39 proc near
	mov tks, 4		;corchea
	play sol3
	mov tks, 8		;negra
	play sol2
	mov tks, 4		;corchea
	play la2
	play las2
	play do3
	play re3
cmp40:	mov tks, 36		;redonda con corchea
	play fa3
	ret
cmp39 endp
;------------------------------------------------------------------------------
parte3 proc near
	call cmp33
	call cmp35
	call cmp33
	call cmp39
	ret
parte3 endp
;------------------------------------------------------------------------------
universalmind proc near
	call parte1
	call parte1
	call parte2
	call parte2		;32
	call parte3
	ret
universalmind endp
;------------------------------------------------------------------------------
READKEY PROC NEAR
   PUSH AX

   MOV AH, 06H
   MOV DL, 0FFH
   INT 21H

   JZ ENDREADING
TECLAZOS:
   MOV TECLAZO, 1

ENDREADING:
   POP AX
   RET
READKEY ENDP
;------------------------------------------------------------------------------
comparar proc near
        cmp teclazo, 1
        jne siguet
        call salir
siguet:
        ret
comparar endp
;------------------------------------------------------------------------------
salir proc near
        mov ax, 4c00h
	int 21h			;salir al dos
	ret
salir endp
;------------------------------------------------------------------------------
main proc far

	mov ax, @data
	mov ds, ax		;inicializa el segmento de datos

 	
	call universalmind	
        call salir
main endp
end main

; Ubicación.....: Universidad del Valle de Guatemala
; Curso.........: CC3005 Programación en Assembler
; Sección.......: 10
; Creadores.....: Byron Orlando Morales Sequen (08414)
; ............... Carlos Lopez Camei (08...)
; Programa......: Proyecto 3
; Prentrega.....: Lunes, 16 de noviembre de 2009
; Entrega.......: Miercoles, 25 de noviembre de 2009
; Archivo.......: PRO3.ASM
; Descripción...: 
;  ============================================================================
;
;  ============================================================================
.MODEL MEDIUM                   ; Modelo pequeño de memoria
.STACK 5000                     ; Segmento de la pila 
.DATA
;  ============================================================================
;       Definición de datos
;  ============================================================================
COLOR_FONDO EQU     12
PT          EQU     23
META1       EQU     54
META2       EQU     40
TAMANO      EQU     30

V_SEG       SEGMENT AT 0A000H
V_AREA      DB      1000 DUP (?)
V_SEG       ENDS

; 30x30
VEHICULO1   DB      PT, PT, PT, PT, PT, PT, PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT, PT, PT, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, 56, PT, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,118,118, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,118,118,118, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,118,118,118, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT, PT, 64, PT, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,191,191,191, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,191,191,191, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,191,191,191, 64, PT, 16, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,191,191,191, PT, 16, 16, 16, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,191,191,191, PT, PT, 16, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 56, 56, PT, PT, PT, PT, PT, PT, PT, 56, PT,191,191,191, PT, PT, PT, PT, 56, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT, PT, PT, PT
            DB      PT, PT, PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT, PT, PT
            DB      PT, PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT, PT
            DB      PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT
            DB      56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56
            DB      56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56
            DB      04, 04, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 15, 15, 56
            DB      14, 14, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 15, 15, 56
            DB      56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 15, 15, 56
            DB      56, 56, 56, 56, 56, 56, PT, PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT, PT, 56, 56, 56, 56, 56, 56, 56
            DB      56, 56, 56, 56, 56, PT, 16, 16, PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT, 16, 16, PT, 56, 56, 56, 56, 56, PT
            DB      56, 56, 56, 56, PT, 16, 16, 16, 16, PT, 56, 56, 56, 56, 56, 56, 56, 56, 56, PT, 16, 16, 16, 16, PT, 56, 56, 56, PT, PT
            DB      PT, 56, 56, PT, 16, 16, 15, 15, 16, 16, PT, 56, 56, 56, 56, 56, 56, 56, PT, 16, 16, 15, 15, 16, 16, PT, 56, PT, PT, PT
            DB      PT, PT, PT, PT, 16, 16, 15, 15, 16, 16, 16, 16, 16, PT, PT, PT, PT, PT, PT, 16, 16, 15, 15, 16, 16, 16, 16, 16, PT, PT
            DB      PT, PT, PT, PT, PT, 16, 16, 16, 16, PT, 16, 16, PT, PT, PT, PT, PT, PT, PT, PT, 16, 16, 16, 16, PT, 16, 16, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 16, 16, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, 16, 16, PT, PT, PT, PT, PT, PT, PT
VEHICULO2   DB      PT, PT, PT, PT, PT, PT, PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT, PT, PT, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, 72, PT, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT, 53, 53, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT, 53, 53, 53, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT, 53, 53, 53, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT, PT, 64, PT, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT,127,127,127, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT,127,127,127, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT,127,127,127, 64, PT, 16, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT,127,127,127, PT, 16, 16, 16, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT,127,127,127, PT, PT, 16, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 72, 72, PT, PT, PT, PT, PT, PT, PT, 72, PT,127,127,127, PT, PT, PT, PT, 72, PT, PT, PT, PT, PT
            DB      PT, PT, PT, PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT, PT, PT, PT
            DB      PT, PT, PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT, PT, PT
            DB      PT, PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT, PT
            DB      PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT
            DB      72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72
            DB      72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72
            DB      04, 04, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 15, 15, 72
            DB      14, 14, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 15, 15, 72
            DB      72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 15, 15, 72
            DB      72, 72, 72, 72, 72, 72, PT, PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT, PT, 72, 72, 72, 72, 72, 72, 72
            DB      72, 72, 72, 72, 72, PT, 16, 16, PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT, 16, 16, PT, 72, 72, 72, 72, 72, PT
            DB      72, 72, 72, 72, PT, 16, 16, 16, 16, PT, 72, 72, 72, 72, 72, 72, 72, 72, 72, PT, 16, 16, 16, 16, PT, 72, 72, 72, PT, PT
            DB      PT, 72, 72, PT, 16, 16, 15, 15, 16, 16, PT, 72, 72, 72, 72, 72, 72, 72, PT, 16, 16, 15, 15, 16, 16, PT, 72, PT, PT, PT
            DB      PT, PT, PT, PT, 16, 16, 15, 15, 16, 16, 16, 16, 16, PT, PT, PT, PT, PT, PT, 16, 16, 15, 15, 16, 16, 16, 16, 16, PT, PT
            DB      PT, PT, PT, PT, PT, 16, 16, 16, 16, PT, 16, 16, PT, PT, PT, PT, PT, PT, PT, PT, 16, 16, 16, 16, PT, 16, 16, PT, PT, PT
            DB      PT, PT, PT, PT, PT, PT, 16, 16, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, PT, 16, 16, PT, PT, PT, PT, PT, PT, PT
POS1        DW      ?                   ; Posicion del personaje 1 (HORIZONTAL)
POS2        DW      ?                   ; Posicion del personaje 2 (HORIZONTAL)
ESTADO      DB      1                   ; Determina si el personaje avanza
; 0 || 1 = Avanza, 2=ABANDONO, 3=GANO 1, 4=GANO 2

ABANDONADO  DB      "EL JUEGO HA SIDO ABANDONADO.", "$"
GANO1       DB      "FELICIDADES JUGADOR 1, HA GANADO EL JUEGO.", "$"
GANO2       DB      "FELICIDADES JUGADOR 2, HA GANADO EL JUEGO.", "$"

; PARTE MUSICAL
freq                dw  ?   ;do escala 4
tiempo              dw  3   ;1/6 de segundo
freclow             db      ?
frecalta            db      ?

;notas musicales
do          equ 262
si_         equ 494

; Parte de concurrencia
RelojViejo      dd  ?           ; guarda direcciones antiguas para ser restauradas
TecladoViejo    dd  ?           ; guarda direcciones antiguas para ser restauradas
VectorBP        DW  3 DUP(?)    ; una posicion por proceso (3)
VectorSP        DW  3 DUP(?)    ; nos vectores de control circulares
Contador        DW  0           ; contador de procesos
Tecla           DB  ?           ; bandera para terminar
Hubo_tecla      DB  ?           ; bandera para revisar tecla

BP_TEMP         DW  ?
SP_TEMP         DW  ?

.386
.CODE
;  ============================================================================
;       Procedimiento principal del juego (parte grafica)
;  ============================================================================
JUEGO PROC  NEAR
    ;inicializa segmento de datos
        MOV AX, @data
        MOV DS, AX
        MOV ES, AX
    ; Configurar pantalla
        MOV     AH, 0FH                 ; Petición de modo de video actual
        INT     10H
        PUSH    AX              
        PUSH    BX              
        MOV     AH, 00H                 ; Designación de modo
        MOV     AL, 13H                    
        INT     10H
    ; CONFIGURAR JUEGO
        CALL CONFIGURAR_JUEGO
    ; Configurar stacks
        CALL PILAS
    ; Obtener direcciones de memoria de las interrupciones
    ; y programar nuevas direcciones de memoria
        CALL CAMBIAR_INTERRUPCIONES
    ; Llamar a procedimiento uno (entrar a la simulacion)
        CALL CARRO1
    ; Regresar a las interrupciones normales
        CALL REGRESO_INTERRUPCIONES
    ; Regresar configuracion de pantalla
        POP     BX                      ;
        MOV     AL, BH                  ; 
        MOV     AH, 05H                 ; Cambio de pagina
        INT     10H
        POP     AX              
        MOV     AH, 00H
        INT     10H
    ; LIMPIAR BUFFER
        MOV     AH, 0CH                 ; limpiar buffer de teclado
        INT     21H
    ; despues de transcurrido el tiempo apagar el speaker
        in al, 61h          ;de nuevo, se obtiene el estado del puerto del speaker
        and al, 11111100b   ;se va a apagar el speaker, poniendo los bits (en 0) 0 y 1  
        out 61h, al         ;mandarselo al puerto
    ; Mostar mensaje de resultado del juego
        CALL    RESULTADO_JUEGO
    ; Salida al DOS
        MOV     AX, 4C00H                               ; salir a DOS
        INT     21H
JUEGO ENDP
;  ============================================================================
;       Metodo para mostrar el resultado del juego
;  ============================================================================
RESULTADO_JUEGO PROC   NEAR
; REVISAR EL ESTADO DEL JUEGO
        CMP     ESTADO, 2
        JE      RESULTADO_JUEGO20
        CMP     ESTADO, 3
        JE      RESULTADO_JUEGO30
        CMP     ESTADO, 4
        JE      RESULTADO_JUEGO40
        
        JMP     RESULTADO_JUEGO100;
RESULTADO_JUEGO20:
        LEA     DX, ABANDONADO
        JMP     RESULTADO_JUEGO100;
RESULTADO_JUEGO30:
        LEA     DX, GANO1
        JMP     RESULTADO_JUEGO100;
RESULTADO_JUEGO40:
        LEA     DX, GANO2
RESULTADO_JUEGO100:        
        CALL    COUT
        RET
RESULTADO_JUEGO ENDP
;  ============================================================================
;       Mostrar texto
;  ============================================================================
COUT    PROC NEAR
        MOV AH, 09H             ; peticion para desplegar
        INT 21H                 ; llama al DOS
        RET
COUT    ENDP
;  ============================================================================
;       Metodo para configurar pantalla de juego 
;  ============================================================================
CONFIGURAR_JUEGO    PROC    NEAR
    ; Configuracion de las posiciones
        MOV     POS1, 15
        MOV     POS2, 15

        ;FONDO
        MOV     AX, 320                     ; COLS
        PUSH    AX
        MOV     AX, 200                     ; ROWS
        PUSH    AX
        MOV     AX, 0000H                   ; INICIO
        PUSH    AX
        MOV     AX, COLOR_FONDO             ; COLOR
        PUSH    AX
        CALL    PINTAR
        ; CARRIL 1
        MOV     AX, 300                     ; COLS
        PUSH    AX
        MOV     AX, 50                      ; ROWS
        PUSH    AX
        MOV     AX, 320*40+10               ; INICIO
        PUSH    AX
        MOV     AX, PT                      ; COLOR
        PUSH    AX
        CALL    PINTAR
        ; CARRIL 2
        MOV     AX, 300                     ; COLS
        PUSH    AX
        MOV     AX, 50                      ; ROWS
        PUSH    AX
        MOV     AX, 320*110+10              ; INICIO
        PUSH    AX
        MOV     AX, PT                      ; COLOR
        PUSH    AX
        CALL    PINTAR
        ; CARROS
        CALL    PINTAR_CARRO1
        CALL    PINTAR_CARRO2

        RET
CONFIGURAR_JUEGO    ENDP
;  ============================================================================
;       Metodo para crear pilas artificiales (algoritmos tomados del pdf de Multitarea)
;  ============================================================================
PILAS   PROC    NEAR
    ; Backup
        MOV BP_TEMP, BP
        MOV SP_TEMP, SP
        
    ; PROCESO1
        MOV [VectorBP], BP
        MOV [VectorSP], SP
        
    ; PROCESO2
        MOV [VectorBP + 02], 1000h      ; Asignación del espacio en el stack
        MOV [VectorSP + 02], 1000h
        
        MOV BP, [VectorBP + 02]         ; Valor de pila actual
        MOV SP, [VectorSP + 02]         
        
        PUSHF                           ; REGISTRO DE BANDERAS
        PUSH SEG CARRO2                 ; SEGMENTO DEL PROGRAMA 2
        PUSH OFFSET CARRO2              ; OFFSET DEL PRAGRAMA 2
        PUSHA                           ; TODOS
        PUSH    ES
        
        MOV [VectorBP + 02], BP         ; VALOR DE LAS NUEVAS PILAS
        MOV [VectorSP + 02], SP 
        
    ; PROCESO3
        MOV [VectorBP + 04], 2000h
        MOV [VectorSP + 04], 2000h

        MOV BP, [VectorBP + 04]         ; Valor de pila actual
        MOV SP, [VectorSP + 04]         
        
        PUSHF                           ; REGISTRO DE BANDERAS
        PUSH SEG SONIDO                 ; SEGMENTO DEL PROGRAMA 3
        PUSH OFFSET SONIDO              ; OFFSET DEL PRAGRAMA 3
        PUSHA                           ; TODOS
        PUSH ES                         ; ES
        
        MOV [VectorBP + 04], BP         ; VALOR DE LAS NUEVAS PILGAS
        MOV [VectorSP + 04], SP 

    ; REGRESAR
        MOV BP, BP_TEMP                 ; REGRESAR REGISTROS MODIFICADOS
        MOV SP, SP_TEMP
        RET
PILAS   ENDP    
;  ============================================================================
;       Metodo para cambiar interrupción de teclado y de cronometro
;  ============================================================================
CAMBIAR_INTERRUPCIONES  PROC    NEAR
    ; PARA EL CRONOMETRO
        MOV AH, 35H             ; OBTENER DIRECCIÓN DE LA INTERRUPCION
        MOV AL, 08H
        INT 21H
        
        MOV [WORD PTR RelojViejo + 2], ES     ; GUARDAR DIRECCIÓN OBTENIDA (ES:BX)
        MOV [WORD PTR RelojViejo], BX
        
        PUSH DS                             ; COLOCAR LA NUEVA INTERRUPCIÓN EN DS:DX
        MOV AX, SEG RELOJ_MODIFICADO
        MOV DS, AX
        MOV DX, OFFSET RELOJ_MODIFICADO
        
        MOV AH, 25H                         ; ESTABLECER LA NUEVA DIRECCIÓN DE LA INTERRUPCIÓN
        MOV AL, 08H
        INT 21H
        POP DS
        
    ; PARA EL TECLADO
        MOV AH, 35H             ; OBTENER DIRECCIÓN DE LA INTERRUPCION
        MOV AL, 09H
        INT 21H
        
        MOV [WORD PTR TecladoViejo+2], ES     ; GUARDAR DIRECCIÓN OBTENIDA
        MOV [WORD PTR TecladoViejo], BX
        
        PUSH DS                             ; COLOCAR LA NUEVA INTERRUPCIÓN EN DX:DS
        MOV AX, SEG TECLADO_MODIFICADO
        MOV DS, AX
        MOV DX, OFFSET TECLADO_MODIFICADO
        
        MOV AH, 25H                         ; ESTABLECER LA NUEVA DIRECCIÓN DE LA INTERRUPCIÓN
        MOV AL, 09H
        INT 21H
        POP DS

    ; Regresar
        RET
CAMBIAR_INTERRUPCIONES  ENDP
;  ============================================================================
;       NUEVO RELOJ
;  ============================================================================
RELOJ_MODIFICADO    PROC    NEAR
        CLI                             ; DESHABILITA INTERRUPCIONES EXTERNAS ENMASCARABLES
    ; VERIFICAR SI SE HA PRESIONADO TECLA LLAMAR A PROGRAMA 1
;         CMP HUBO_Tecla, 1
;         JNE  RELOJ_MODIFICADO_CAMBIAR_PROCESO
;         MOV CONTADOR, 0
        
    ; CONTROL DE CAMBIO DE PROCESO
RELOJ_MODIFICADO_CAMBIAR_PROCESO:
        PUSHF                           ; REGISTRO DE BANDERAS
        CALL DWORD PTR RelojViejo       ; Acciones de reloj viejo
        PUSHA                           ; Para todos los registros generales
        PUSH    ES                      ; Para ES
        
        MOV SI, CONTADOR                ; traer contador

        MOV [VectorSP + SI], SP         ; guardar sp actual
        MOV [VectorBP + SI], BP         ; guardar bp actual
        ADD CONTADOR, 2                 ; incrementar contador (para word)
        CMP CONTADOR, 6
        JNE RELOJ_MODIFICADO_TRAER_NUEVOS
        MOV CONTADOR, 0
RELOJ_MODIFICADO_TRAER_NUEVOS:        
        MOV SI, CONTADOR                ; traer nu2evo contador
        MOV SP, [VectorSP + SI]         ; traer nueno sp
        MOV BP, [VectorBP + SI]         ; traer nuevo bp
        POP ES                          ; traer ES
        POPA                            ; pop de todos los registros
        ;POPF
        ;PUSHF
        
RELOJ_MODIFICADO_SALIR:
    ; REGRESAR
        STI                 ; HABILITA INTERRUPCIONES EXTERNAS ENMASCARABLES
        IRET
RELOJ_MODIFICADO    ENDP
;  ============================================================================
;       NUEVO TECLADO
;  ============================================================================
TECLADO_MODIFICADO  PROC    NEAR
        CLI                             ; DESHABILITA INTERRUPCIONES EXTERNAS ENMASCARABLES
        
        PUSHF
        CALL DWORD PTR TecladoViejo     ; Llamar a la interrucion de teclado original
        
        IN  AL, 60H
        MOV TECLA, AL               ; SCAN CODE
;         MOV HUBO_TECLA, 1
        
        CMP TECLA, 1CH              ; ENTER?
        JE  TECLADO_MODIFICADO_CARRO1
        
        JMP TECLADO_MODIFICADO_SALIR
        
TECLADO_MODIFICADO_CARRO1:
        ADD     POS1, 4
        CMP     POS1, 270
        JB      TECLADO_MODIFICADO_SALIR
        MOV     ESTADO, 3
        
TECLADO_MODIFICADO_SALIR:
    ; REGRESAR
        STI                 ; HABILITA INTERRUPCIONES EXTERNAS ENMASCARABLES
        IRET
TECLADO_MODIFICADO  ENDP
;  ============================================================================
;       Metodo para cambiar interrupción de teclado y de cronometro
;  ============================================================================
REGRESO_INTERRUPCIONES  PROC    NEAR
        CLI
    ; PARA EL CRONOMETRO
        PUSH DS                             ; COLOCAR LA NUEVA INTERRUPCIÓN EN DX:DS
        MOV AX, [WORD PTR RelojViejo + 2]
        MOV DS, AX
        MOV DX, [WORD PTR RelojViejo]
        
        MOV AH, 25H                         ; ESTABLECER LA NUEVA DIRECCIÓN DE LA INTERRUPCIÓN
        MOV AL, 08H
        INT 21H
        
    ; PARA EL TECLADO
        MOV AX, [WORD PTR TecladoViejo + 2]
        MOV DS, AX
        MOV DX, [WORD PTR TecladoViejo]
        
        MOV AH, 25H                         ; ESTABLECER LA NUEVA DIRECCIÓN DE LA INTERRUPCIÓN
        MOV AL, 09H
        INT 21H

    ; Regresar
        POP DS
        STI
        RET
REGRESO_INTERRUPCIONES  ENDP
;  ============================================================================
;       Metodo para pintar CARRO1
;  ============================================================================
PINTAR_CARRO1   PROC    NEAR
    ; PINTAR CARRIL DONDE HA PASADO EL CARRO
        MOV     AX, 5                       ; COLS
        PUSH    AX
        MOV     AX, 30                      ; ROWS
        PUSH    AX
        MOV     AX, 320*50                  ; INICIO
        ADD     AX, POS1
        SUB     AX, 5
        PUSH    AX
        MOV     AX, PT                      ; COLOR
        PUSH    AX
        CALL    PINTAR
    ; PINTAR CARRO UNO
        MOV     AX, 320*50                       ; INICIO
        ADD     AX, POS1
        PUSH    AX
        LEA     AX, VEHICULO1                    ; CARRO
        PUSH    AX
        CALL    PINTAR_CARRO
        
        RET
PINTAR_CARRO1   ENDP
;  ============================================================================
;       Metodo para pintar CARRO2
;  ============================================================================
PINTAR_CARRO2   PROC    NEAR
    ; PINTAR CARRIL
        MOV     AX, 5                       ; COLS
        PUSH    AX
        MOV     AX, 30                      ; ROWS
        PUSH    AX
        MOV     AX, 320*120                 ; INICIO
        ADD     AX, POS2
        SUB     AX, 5
        PUSH    AX
        MOV     AX, PT                      ; COLOR
        PUSH    AX
        CALL    PINTAR
    ; PINTAR CARRO DOS
        MOV     AX, 320*120                      ; INICIO
        ADD     AX, POS2
        PUSH    AX
        LEA     AX, VEHICULO2                    ; CARRO
        PUSH    AX
        CALL    PINTAR_CARRO
        RET
PINTAR_CARRO2   ENDP
;  ============================================================================
;       Metodo para pintar un rectangulo lleno de ROWS filas y COLS columnas
;  ============================================================================
;  Parametro en orden: AX (AL = COLOR), DI (POSICIÓN RELATIVA), COLS, ROWS
PINTAR  PROC    NEAR
    ; CONFIGURAR SEGMENTOS DE MEMORIA
        MOV     AX, V_SEG
        MOV     ES, AX
        ;ASSUME  ES:V_SEG

        POP     BX          ; OFFSET RETORNO
        POP     AX                      ; Colores del pixel
        POP     DI                      ; Posición inicial
        POP     DX                      ; ROWS
        POP     CX                      ; COLS
        PUSH    BX                      ; DIRECCION DE RETORNO
        PUSH    CX
PINTAR_FILAS:
        POP     CX
        PUSH    CX

PINTAR_COLS:
        MOV     ES:BYTE PTR[DI], AL     ; Pintar 1 pixel
        INC     DI
        LOOP    PINTAR_COLS             ; Terminador de columnas
        
        POP     CX
        PUSH    CX
        ADD     DI, 320D
        SUB     DI, CX
        DEC     DX
        CMP     DX, 0
        JA      PINTAR_FILAS            ; Terminador de filas
        
    ; CONFIGURAR SEGMENTOS DE MEMORIA ANTERIORES
        POP     CX
        MOV     AX, @data
        MOV     ES, AX
    
        RET
PINTAR  ENDP
;  ============================================================================
;       Metodo para pintar un CARRO
;  ============================================================================
;  Parametro: AX (AL = COLOR), DI (POSICIÓN RELATIVA), COLS, ROWS
PINTAR_CARRO  PROC    NEAR
    ; CONFIGURAR SEGMENTOS DE MEMORIA
        MOV     AX, V_SEG
        MOV     ES, AX
        
        POP     AX                      ; OFFSET RETORNO
        POP     BX                      ; POSICION A COPIAR
        POP     DI                      ; Posición inicial
        MOV     DX, TAMANO              ; ROWS
        MOV     CX, TAMANO              ; COLS
        PUSH    AX                      ; OFFSET DE RETORNO
        PUSH    CX
PINTAR_CARRO_FILAS:
        POP     CX
        PUSH    CX

PINTAR_CARRO_COLS:
        MOV     AL, DS:BX
        MOV     ES:BYTE PTR[DI], AL     ; Pintar 1 pixel
        INC     DI
        INC     BX
        LOOP    PINTAR_CARRO_COLS             ; Terminador de columnas
        
        POP     CX
        PUSH    CX
        ADD     DI, 320D
        SUB     DI, CX
        DEC     DX
        CMP     DX, 0
        JA      PINTAR_CARRO_FILAS            ; Terminador de filas
        
    ; CONFIGURAR SEGMENTOS DE MEMORIA ANTERIORES
        POP     CX
        MOV     AX, @data
        MOV     ES, AX
    
        RET
PINTAR_CARRO  ENDP
;  ============================================================================
;       PROC. PARA MANEJO DE CARRO1
;  ============================================================================
CARRO1  PROC    NEAR

CARRO1_PRINCIPAL:
        CALL    PINTAR_CARRO1

        CMP ESTADO, 1               ; Comprobar estado
        JA  CARRO1_SALIDA
        CMP TECLA, 01h              ; ESC?
        JE  CARRO1_SALIDA

;         MOV     HUBO_TECLA, 0
        JMP CARRO1_PRINCIPAL

CARRO1_SALIDA:
    ; SALIR
        RET
CARRO1  ENDP
;  ============================================================================
;       PROC. PARA MANEJO DE CARRO2
;  ============================================================================
CARRO2  PROC    NEAR

CARRO2_PRINCIPAL:
        ; DELAy
        MOV CX, 255*100   
CARRO2_DELAY:
        LOOP CARRO2_DELAY
        
        INC POS2                    ; DIBUJAR AUMENTO
        CALL    PINTAR_CARRO2
        
        CMP     POS2, 270           ; REVISAR SI GANO
        JB      CARRO2_PRINCIPAL
        MOV     ESTADO, 4
        
        JMP CARRO2_PRINCIPAL
        RET
CARRO2  ENDP
;  ============================================================================
;       PROC. PARA MANEJO DE SONIDO
;  ============================================================================
SONIDO  PROC    NEAR

Musiquita:
    ;***** 
    ; SI
    ;*****
    ;convertir frecuencia a numero
    mov ax, 34dch
    mov dx, 12h                 ;1234dc es 1193180 que es lo que se divide
    mov bx, si_         ;entre la frecuencia para encontrar numero que le corresponde
    div bx
    mov freclow, al             ;se guarda el resultado en fnlow 
    mov frecalta, ah                ;y fn high
    
    ;decirle al puerto 43h que vamos a hacer sonar la bocina
    mov al, 10110110b   ; alistarse
    out 43h, al     ;se le pasa el  10110110b

    ;pasarle el fn al puerto 42h (speaker)
    mov al, freclow
    out 42h, al         ;se le pasa primero el low del fn
    mov al, frecalta
    out 42h, al         ;se le pasa el high del fn

    ;encender el speaker
    in al, 61h          ;obtener el estado del puerto 61h (el del speaker)
    or al, 00000011b    ;se va a prender el speaker prendiendo los bits (en 1) 0 y 1
    out 61h, al         ;mandarselo al puerto
    
; ; ;     ;mantener encendido el speaker el tiempo que se requiera
; ; ;     ; ***
; ; ;     ; DELAy
; ; ;     ; ***
; ; ;     sti                     
; ; ;     mov cx,5            ;pone en el contador el numero de ticks                
; ; ;     mov ax,040h                   
; ; ;     mov es,ax               ;apunta el es al bios
; ; ;     mov si,06ch
; ; ;     push ds
; ; ;     mov ds,ax               ;y tambien el ds
; ; ; esperar3:  mov ax,[es:si]       ;obtiene el numero de ticks actuales    
; ; ; esperar4:  cmp ax,[es:si]              
; ; ;     je esperar4             ;se enloopa hasta que sea un tick diferente
; ; ;     loop esperar3           ;lo hace cx veces                 
; ; ;     pop ds
            MOV CX, 255*257
SONIDO_DELAY1:
        LOOP SONIDO_DELAY1
    
    ; despues de transcurrido el tiempo apagar el speaker
    in al, 61h          ;de nuevo, se obtiene el estado del puerto del speaker
    and al, 11111100b   ;se va a apagar el speaker, poniendo los bits (en 0) 0 y 1  
    out 61h, al         ;mandarselo al puerto
    
    ;***** 
    ; DO
    ;*****
    ;convertir frecuencia a numero
    mov ax, 34dch
    mov dx, 12h                 ;1234dc es 1193180 que es lo que se divide
    mov bx, do          ;entre la frecuencia para encontrar numero que le corresponde
    div bx
    mov freclow, al             ;se guarda el resultado en fnlow 
    mov frecalta, ah                ;y fn high
    
    ;decirle al puerto 43h que vamos a hacer sonar la bocina
    mov al, 10110110b   ; alistarse
    out 43h, al     ;se le pasa el  10110110b

    ;pasarle el fn al puerto 42h (speaker)
    mov al, freclow
    out 42h, al         ;se le pasa primero el low del fn
    mov al, frecalta
    out 42h, al         ;se le pasa el high del fn

    ;encender el speaker
    in al, 61h          ;obtener el estado del puerto 61h (el del speaker)
    or al, 00000011b    ;se va a prender el speaker prendiendo los bits (en 1) 0 y 1
    out 61h, al         ;mandarselo al puerto
    
    ;mantener encendido el speaker el tiempo que se requiera
    ; ***
    ; DELAy
    ; ***
; ; ;     pusha
; ; ;     push ds
; ; ;     push es
; ; ;     push si
; ; ;     
; ; ;     mov cx,5            ;pone en el contador el numero de ticks                
; ; ;     mov ax,040h                   
; ; ;     mov es,ax               ;apunta el es al bios
; ; ;     mov si,06ch
; ; ;     mov ds,ax               ;y tambien el ds
; ; ; esperar5:  mov ax,[es:si]       ;obtiene el numero de ticks actuales    
; ; ; esperar6:  cmp ax,[es:si]              
; ; ;     je esperar6         ;se enloopa hasta que sea un tick diferente
; ; ;     loop esperar5           ;lo hace cx veces                 
; ; ;     
; ; ;     pop si
; ; ;     pop es
; ; ;     pop ds
; ; ;     popa
    
            MOV CX, 255*255   
SONIDO_DELAY:
        LOOP SONIDO_DELAY

    
    ; despues de transcurrido el tiempo apagar el speaker
    in al, 61h          ;de nuevo, se obtiene el estado del puerto del speaker
    and al, 11111100b   ;se va a apagar el speaker, poniendo los bits (en 0) 0 y 1  
    out 61h, al         ;mandarselo al puerto
    
    JMP Musiquita
    RET
SONIDO  ENDP

; PROCEDIMIENTO MUSICA


;  ============================================================================
;       Correr el programa principal
;  ============================================================================
END JUEGO
TITLE   MARIO_BRINCOS

INCLUDE 'EMU8086.INC'
                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
        
        mariox  dw  60
        marioy  dw  190
        mariotempx   dw  0    
        mariotempy   dw  0
        hongox  dw 240
        hongoy  dw 195
        hongotempx   dw  0    
        hongotempy   dw  0
        puntaje     dw  0

;************************************************************************************************************
;------------------------------------------------------------------------------------------------------------


        
DATOS   ENDS                    ;CADA SEGMENTO DEBE TERMINARSE CON LA SIGUIENTE SENTENCIA:
                                ;NOMBRE-SEG ENDS



PILA    SEGMENT 
    
        DW      64    DUP(0)    ;DW SIRVE PARA DEFINIR UNA VARIABLE O INICIAR UN AREA DE MEMORIA
                                ;(DEFINE WORD). CON DUP GENERAMOS 64 REPETICIONES DE 0                               ;STACK.
        
PILA    ENDS



CODIGO  SEGMENT 

INICIO  PROC  FAR            ;ESTE PROCEDIMIENTO ES DEL TIPO FAR PORQUE CUANDO TERMINE
                             ;REGRESARA EL CONTROL AL DOS.
                             ;EXISTEN DOS ATRIBUTOS: NEAR Y FAR
                             ;NEAR.- CORRESPONDE A PROCEDIMIENTOS O ETIQUETAS DEFINIDAS
                             ;EN EL SEGMENTO. SOLO CAMBIA IP
                             ;FAR.- PROCEDIMIENTOS O ETIQUETAS DEFINIDOS EN OTROS 
                             ;SEGMENTOS. CAMBIA IP Y EL SEGMENTO DE CODIGO (CS)
    
        PUSH    DS	         ;AL EJECUTARSE EL PROGRAMA DOS GUARDA EN DS LA DIRECCION
        MOV     AX, 0        ;DEL SEGMENTO PREFIJO DEL PROGRAMA. Y ESTA SE GUARDA EN EL
        PUSH    AX           ;STACK PARA REGRESAR EL CONTROL AL DOS AL TERMINO DEL PROGRAMA
                             ;PSP es una zona de un archivo com o exe de 256 bytes que se utiliza
                             ;para alamacenar la cola de ordenes, resguardar ciertos valores, etc.                                    
                                             
        MOV     AX, DATOS    ;SE CARGA EN DS LA DIRECCION DE INICIO DEL SEGMENTO DE DATOS
        MOV     DS, AX       ;DEL PROGRAMA
        MOV     ES, AX


;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------
;COLOCAR LAS MACROS DEL PROGRAMA EN ESTA SECCION

;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------
;COLOCAR EL CODIGO DEL PROGRAMA EN ESTA SECCION
;-------------INTRO----------------;
        mov ah,0
        mov al,03h
        int 10h               ;INICIAMOS EL MODO TEXTO, PARA LIMPIAR PANTALLA
        CALL CLEAR_SCREEN
        GOTOXY 35,10
        PRINT 'MARIO BRINCOS'

        GOTOXY 10,12
        PRINT 'Presione (1) para jugar, para salir cualquier otro: '
        mov ah, 01h
        int 21h
        sub al, 30h       
        CMP al, 1         ;CAPTURAMOS Y COMPARAMOS EL VALOR INGRESADO
        JE JUGAR          ;SI ES IGUAL A 1 JUGAREMOS DE LO CONTRARIO TERMINA EL PROGRAMA
        JMP TERMINAR          
JUGAR:  
        INC puntaje         ;el puntaje aumenta 1 vez por ciclo (x tiempo)      
        SUB hongox, 10
        CMP hongoy, 195   ;MOVEMOS EL HONGO
        JNE MANTENER1
        JMP CONTINUA
MANTENER1:
        MOV hongotempy, 0
        MOV hongox, 240     ;REUBICAMOS SPAWN DEL HONGO       
CONTINUA:
        CALL HONGO         ;DIBUJAMOS EL HONGO
        CALL MARIO         ;DIBUJAMOS MARIO
        CMP marioy, 190    ;COMPROBAMOS SI MARIO SE ENUENTRA EN EL PISO
        JE CONTINUA2       ;SI LO ESTA CONTINUA AHI (EN EL PISO)
        ADD marioy, 5      ; EN CASO CONTRARIO SEGUIRA CAYENDO
CONTINUA2:                
        MOV AL, 0         ;CON ESTAS INSTRUCCIONES HACEMOS PAUSAS PEQUEÑAS DE TIEMPO
        MOV AH, 86H
        MOV CX, 1
        MOV DX, 1         ;EL VALOR 1 ES EL QUE MEJOR SE ADAPTO AL JUEGO
        INT 15H
        CALL BRINCO       ;COMPROBAMOS SI MARIO DEBE DE BRINCAR
CONTINUAR:   
        JMP JUGAR         
TERMINAR:    
        MOV AH,0
        mov AL,03h
        INT 10h            ; REGRESAMOS AL MODO TEXTO
        GOTOXY 35,10
        PRINT 'GAME OVER'   
        GOTOXY 31, 12
        PRINT 'PUNTAJE FINAL: '
        MOV ax, puntaje     ;MOSTRAMOS EL PUNTAJE
        CALL PRINT_NUM_UNS
        MOV AH, 4CH ;solicitud de terminacion del programa
        INT 21H
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------
;COLOCAR LOS PROCEDIMIENTOS DEL PROGRAMA EN ESTA SECCION  

BRINCO PROC NEAR
        mov ah, 6
	    mov dl, 255         ;INTERRUPCION PARA DETECTAR LETRA SIN DETENER
	                        ;POR COMPLETO EL PROGRAMA
	    int 21h 
        CMP AL, 'D'
        JE ARRIBA
        
        CMP AL, 'd'         ;COMPARAMOS EL CARACTER DETECTADO SI ES 'D'
        JE ARRIBA           ;MOVEREMOS A MARIO HACIA ARRIBA
        JMP CONTINUAR 
ARRIBA:
        SUB marioy, 90
        JMP CONTINUAR       
        RET
ENDP COMP_MOV 

MARIO PROC near
        mov ax, mariox
        mov mariotempx, ax
        mov ax, marioy
        mov mariotempy, ax
        
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P1:                      
        MOV AH, 0DH
        INT 10H
        CMP AL, 0110B
        JE TERMINAR           ;COMPARAMOS CON EL COLOR CAFE PARA SABER SI SE TOCO AL HONGO
        
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P1
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P1 
        ;-------------------
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P2:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P2
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P2
        ;----------------
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P3:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P3
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P3
        ;-----------------
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P4:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P4
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P4
        ;---------------- 
        ADD mariotempx, 20
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P5:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P5
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P5
        ;---------------
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P6:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P6
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P6
        ;-----------------
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P7:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P7
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P7
        ;-------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P8:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P8
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P8
        ;-------------------
        SUB mariotempx, 55
        SUB mariotempy, 5
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P9:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P9
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P9
        ;--------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P10:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P10
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P10  
        ;-------------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P11:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P11
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P11
        ;-----------------------
        ADD mariotempx, 20
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P12:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P12
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P12
        ;-------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P13:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P13
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P13
        ;------------------ 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P14:
        MOV AH, 0CH     
        MOV AL, 4h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P14
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P14 
        ;-----------------------
        SUB mariotempy, 5
        SUB mariotempx, 45
        MOV CX, mariotempx
        ADD mariotempx, 15  
P15:
        MOV AH, 0CH     
        MOV AL, 1h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P15
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P15
        ;-----------------
        ADD mariotempx, 10
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 15  
P16:
        MOV AH, 0CH     
        MOV AL, 1h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P16
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P16
        ;---------------------
        SUB mariotempy, 5
        SUB mariotempx, 50  
        MOV CX, mariotempx
        ADD mariotempx, 10  
P17:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P17
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P17
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 40  
P18:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P18
        MOV CX, mariotempx
        SUB CX, 40
        DEC DX
        CMP DX, mariotempy
        JNE P18
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 10  
P19:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P19
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P19
        ;---------------------
        SUB mariotempy, 5
        Sub mariotempx, 60
        MOV CX, mariotempx
        ADD mariotempx, 15  
P20:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P20
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P20
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 30  
P21:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P21
        MOV CX, mariotempx
        SUB CX, 30
        DEC DX
        CMP DX, mariotempy
        JNE P21
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 15  
P22:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P22
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P22
        ;---------------------
        SUB mariotempy, 5 
        Sub mariotempx, 60
        MOV CX, mariotempx
        ADD mariotempx, 10  
P23:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P23
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P23
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P24:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P24
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P24
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P25:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P25
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P25
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P26:
        MOV AH, 0CH     
        MOV AL, 0Eh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P26
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P26
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 10  
P27:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P27
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P27
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P28:
        MOV AH, 0CH     
        MOV AL, 0Eh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P28
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P28
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P29:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P29
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P29
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P30:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P30
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P30
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 10  
P31:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P31
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P31
        ;---------------------
        SUB mariotempy, 5 
        Sub mariotempx, 60
        MOV CX, mariotempx
        ADD mariotempx, 20  
P32:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P32
        MOV CX, mariotempx
        SUB CX, 20
        DEC DX
        CMP DX, mariotempy
        JNE P32
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 20  
P33:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P33
        MOV CX, mariotempx
        SUB CX, 20
        DEC DX
        CMP DX, mariotempy
        JNE P33
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 20  
P34:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P34
        MOV CX, mariotempx
        SUB CX, 20
        DEC DX
        CMP DX, mariotempy
        JNE P34
        ;--------------------- 
        SUB mariotempy, 5 
        Sub mariotempx, 55
        MOV CX, mariotempx
        ADD mariotempx, 15  
P35:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P35
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P35
        ;---------------------  
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P36:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H 
        INC CX
        CMP CX, mariotempx
        JNE P36
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P36
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 10  
P37:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P37
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P37
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P38:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P38
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P38
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 15  
P39:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P39
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P39
        ;--------------------- 
        SUB mariotempy, 5 
        Sub mariotempx, 45
        MOV CX, mariotempx
        ADD mariotempx, 10  
P40:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P40
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P40
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P41:
        MOV AH, 0CH     
        MOV AL, 01h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P41
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P41
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 20  
P42:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P42
        MOV CX, mariotempx
        SUB CX, 20
        DEC DX
        CMP DX, mariotempy
        JNE P42
        ;--------------------- 
        SUB mariotempy, 5 
        Sub mariotempx, 30
        MOV CX, mariotempx
        ADD mariotempx, 40  
P43:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P43
        MOV CX, mariotempx
        SUB CX, 40
        DEC DX
        CMP DX, mariotempy
        JNE P43
        ;--------------------- 
        SUB mariotempy, 5 
        Sub mariotempx, 50
        MOV CX, mariotempx
        ADD mariotempx, 10  
P44:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P44
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P44
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 25  
P45:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P45
        MOV CX, mariotempx
        SUB CX, 25
        DEC DX
        CMP DX, mariotempy
        JNE P45
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 20  
P46:
        MOV AH, 0CH     
        MOV AL, 08h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P46
        MOV CX, mariotempx
        SUB CX, 20
        DEC DX
        CMP DX, mariotempy
        JNE P46
        ;--------------------- 
        SUB mariotempy, 5 
        Sub mariotempx, 55
        MOV CX, mariotempx
        ADD mariotempx, 5  
P47:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P47
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P47
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P48:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P48
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P48
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 10  
P49:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P49
        MOV CX, mariotempx
        SUB CX, 10
        DEC DX
        CMP DX, mariotempy
        JNE P49
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 20  
P50:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P50
        MOV CX, mariotempx
        SUB CX, 20
        DEC DX
        CMP DX, mariotempy
        JNE P50
        ;---------------------  
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P51:
        MOV AH, 0CH     
        MOV AL, 08h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P51
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P51
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 15  
P52:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P52
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P52
        ;---------------------
        SUB mariotempy, 5 
        Sub mariotempx, 60
        MOV CX, mariotempx
        ADD mariotempx, 5  
P53:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P53
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P53
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P54:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P54
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P54
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P55:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P55
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P55
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 20  
P56:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P56
        MOV CX, mariotempx
        SUB CX, 20
        DEC DX
        CMP DX, mariotempy
        JNE P56
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P57:
        MOV AH, 0CH     
        MOV AL, 08h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P57
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P57
        ;--------------------- 
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 15  
P58:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P58
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P58
        ;---------------------
        SUB mariotempy, 5 
        Sub mariotempx, 50
        MOV CX, mariotempx
        ADD mariotempx, 15  
P59:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P59
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P59
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 15  
P60:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P60
        MOV CX, mariotempx
        SUB CX, 15
        DEC DX
        CMP DX, mariotempy
        JNE P60
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P61:
        MOV AH, 0CH     
        MOV AL, 08h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P61
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P61
        ;---------------------
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5  
P62:
        MOV AH, 0CH     
        MOV AL, 0Fh   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P62
        MOV CX, mariotempx
        SUB CX, 5
        DEC DX
        CMP DX, mariotempy
        JNE P62
        ;--------------------- 
        SUB mariotempy, 5 
        Sub mariotempx, 40
        MOV CX, mariotempx
        ADD mariotempx, 50  
P63:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P63
        MOV CX, mariotempx
        SUB CX, 50
        DEC DX
        CMP DX, mariotempy
        JNE P63
        ;---------------------
        SUB mariotempy, 5 
        Sub mariotempx, 45
        MOV CX, mariotempx
        ADD mariotempx, 30  
P64:
        MOV AH, 0CH     
        MOV AL, 04h   
        INT 10H
        INC CX
        CMP CX, mariotempx
        JNE P64
        MOV CX, mariotempx
        SUB CX, 30
        DEC DX
        CMP DX, mariotempy
        JNE P64
        ;---------------------
        RET
            
endm MARIO
                    
HONGO PROC near
        
        MOV AH,0
        MOV AL,13h
        INT 10h 
        
        mov ax, hongox
        mov hongotempx, ax
        mov ax, hongoy
        mov hongotempy, ax
        
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H1:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H1
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H1            
        
;        
;        ;-------------------
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H2:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H2
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H2
;        ;----------------
;        
;        
;        
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H3:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H3
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H3            
        
;        
;;        ;-----------------
        
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H4:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H4
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H4            
;        
;        ;----------------
        
         
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H5:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H5
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H5            
;        ;---------------
        
;        
   ;     
         
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H6:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H6
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H6 
;;        ;-----------------
         
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H7:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H7
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H7 
;        ;-------------------
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H8:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H8
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H8
;        ;-------------------
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H9:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H9
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H9 
;        ;--------------------
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H10:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H10
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H10   
;        ;-------------------------
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H11:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H11
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H11 
;        ;-----------------------
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H12:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H12
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H12 
;        ;-------------------
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H13:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H13
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H13 
;        ;------------------ 
        ADD hongotempx, 0
        MOV DX,  hongotempy
        ADD DX, 3
        MOV CX, hongotempx
        ADD hongotempx, 3   
H14:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H14
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H14 
                 
                 
        ;-----------------------
      
        
        SUB hongotempy, 3
        SUB hongotempx, 40
        MOV CX, hongotempx
        ADD hongotempx, 6  
H15:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H15
        MOV CX, hongotempx
        SUB CX, 6
        DEC DX
        CMP DX, hongotempy
        JNE H15
        ;-----------------

        add dx,3
        mov cx, hongotempx
        add hongotempx, 27
        
       
H16:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H16
        MOV CX, hongotempx
        SUB CX, 27
        DEC DX
        CMP DX, hongotempy
        JNE H16
;        ;---------------------
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
        
       
H17:
        MOV AH, 0CH     
        MOV AL, 7h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H17
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H17
 ;------------------------       
        SUB hongotempy, 3
        SUB hongotempx, 29
        MOV CX, hongotempx
        ADD hongotempx, 26  
H18:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H18
        MOV CX, hongotempx
        SUB CX, 26
        DEC DX
        CMP DX, hongotempy
        JNE H18
;        ;---------------------
        ;
;        
        
        SUB hongotempy, 3
        SUB hongotempx, 35
        MOV CX, hongotempx
        ADD hongotempx, 12 
        
       
H19:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H19
        MOV CX, hongotempx
        SUB CX, 12
        DEC DX
        CMP DX, hongotempy
        JNE H19
;        ;---------------------

        add dx,3
        mov cx, hongotempx
        add hongotempx, 21
            
       
H20:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H20
        MOV CX, hongotempx
        SUB CX, 21
        DEC DX
        CMP DX, hongotempy
        JNE H20
;        ;---------------------
        add dx,3
        mov cx, hongotempx
        add hongotempx, 10
            
       
H21:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H21
        MOV CX, hongotempx
        SUB CX, 10
        DEC DX
        CMP DX, hongotempy
        JNE H21
;        ;---------------------




        SUB hongotempy, 3
        SUB hongotempx, 45
        MOV CX, hongotempx
        ADD hongotempx, 48 
        
       
H22:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H22
        MOV CX, hongotempx
        SUB CX, 48
        DEC DX
        CMP DX, hongotempy
        JNE H22
;        ;--------------------- 

        SUB hongotempy, 3
        SUB hongotempx, 48
        MOV CX, hongotempx
        ADD hongotempx, 12 
        
       
H23:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H23
        MOV CX, hongotempx
        SUB CX, 12
        DEC DX
        CMP DX, hongotempy
        JNE H23                               
;-----------------------

        add dx,3
        mov cx, hongotempx
        add hongotempx, 9
            
       
H24:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H24
        MOV CX, hongotempx
        SUB CX, 9
        DEC DX
        CMP DX, hongotempy
        JNE H24

;----------------------------
;-----------------------

        add dx,3
        mov cx, hongotempx
        add hongotempx, 6
            
       
H25:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H25
        MOV CX, hongotempx
        SUB CX, 6
        DEC DX
        CMP DX, hongotempy
        JNE H25
        
        
        ;-----------------------

        add dx,3
        mov cx, hongotempx
        add hongotempx, 9
            
       
H26:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H26
        MOV CX, hongotempx
        SUB CX, 9
        DEC DX
        CMP DX, hongotempy
        JNE H26
        
        ;-----------------------

        add dx,3
        mov cx, hongotempx
        add hongotempx, 12
            
       
H27:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H27
        MOV CX, hongotempx
        SUB CX, 12
        DEC DX
        CMP DX, hongotempy
        JNE H27
        
        
 ;----------------------
         ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 48
        MOV CX, hongotempx
        ADD hongotempx, 12 
        
       
H28:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H28
        MOV CX, hongotempx
        SUB CX, 12
        DEC DX
        CMP DX, hongotempy
        JNE H28 
        
;----------- 
        ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H29:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H29
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H29
;

 ;-----------------------

     ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H30:
        MOV AH, 0CH     
        MOV AL, 00h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H30
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H30 
        
        
 ;-----------------------

     ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H31:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H31
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H31
        
        
        
 ;-----------------------

     ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 6
            
       
H32:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H32
        MOV CX, hongotempx
        SUB CX, 6
        DEC DX
        CMP DX, hongotempy
        JNE H32
        
        
        
 ;-----------------------

     ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H33:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H33
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H33
        
        
        
 ;-----------------------

     ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H34:
        MOV AH, 0CH     
        MOV AL, 00h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H34
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H34
                
                
                
                
 ;-----------------------

     ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H35:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H35
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H35
        
        
        
 ;-----------------------

     ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 12
            
       
H36:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H36
        MOV CX, hongotempx
        SUB CX, 12
        DEC DX
        CMP DX, hongotempy
        JNE H36
                 
                 
                 
;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 46
        MOV CX, hongotempx
        ADD hongotempx, 10 
        
       
H37:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H37
        MOV CX, hongotempx
        SUB CX, 10
        DEC DX
        CMP DX, hongotempy
        JNE H37 
                   
                   
;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H38:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H38
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H38
        
             ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 18
            
       
H39:
        MOV AH, 0CH     
        MOV AL, 00h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H39
        MOV CX, hongotempx
        SUB CX, 18
        DEC DX
        CMP DX, hongotempy
        JNE H39
        
        
             ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H40:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H40
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H40
;        
             ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 9
            
       
H41:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H41
        MOV CX, hongotempx
        SUB CX, 9
        DEC DX
        CMP DX, hongotempy
        JNE H41
        
        
        ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 43
        MOV CX, hongotempx
        ADD hongotempx, 10 
        
       
H42:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H42
        MOV CX, hongotempx
        SUB CX, 10
        DEC DX
        CMP DX, hongotempy
        JNE H42
        
        
;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H43:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H43
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H43 
               
               
               ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H44:
        MOV AH, 0CH     
        MOV AL, 00h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H44
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H44 
        
        ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 12
            
       
H45:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H45
        MOV CX, hongotempx
        SUB CX, 12
        DEC DX
        CMP DX, hongotempy
        JNE H45 
        
        
        ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H46:
        MOV AH, 0CH     
        MOV AL, 00h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H46
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H46  
        
        
        ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H47:
        MOV AH, 0CH     
        MOV AL, 0fh   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H47
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H47
        
        ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 9
            
       
H48:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H48
        MOV CX, hongotempx
        SUB CX, 9
        DEC DX
        CMP DX, hongotempy
        JNE H48 
                  
                  
                  
                          
        ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 40
        MOV CX, hongotempx
        ADD hongotempx, 3 
        
       
H49:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H49
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H49
        
                ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 7
            
       
H50:
        MOV AH, 0CH     
        MOV AL, 00h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H50
        MOV CX, hongotempx
        SUB CX, 7
        DEC DX
        CMP DX, hongotempy
        JNE H50 
        
        
                ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 18
            
       
H51:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H51
        MOV CX, hongotempx
        SUB CX, 18
        DEC DX
        CMP DX, hongotempy
        JNE H51
        
        
                        ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 7
            
       
H52:
        MOV AH, 0CH     
        MOV AL, 00h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H52
        MOV CX, hongotempx
        SUB CX, 7
        DEC DX
        CMP DX, hongotempy
        JNE H52
        
        
                        ;linea para agregar solo un pixel 
        
        add dx,3
        mov cx, hongotempx
        add hongotempx, 3
            
       
H53:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H53
        MOV CX, hongotempx
        SUB CX, 3
        DEC DX
        CMP DX, hongotempy
        JNE H53
        
        
                ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 36
        MOV CX, hongotempx
        ADD hongotempx, 34 
        
       
H54:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H54
        MOV CX, hongotempx
        SUB CX, 34
        DEC DX
        CMP DX, hongotempy
        JNE H54
        
        
 ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 32
        MOV CX, hongotempx
        ADD hongotempx, 28 
        
       
H55:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H55
        MOV CX, hongotempx
        SUB CX, 28
        DEC DX
        CMP DX, hongotempy
        JNE H55
        
        
        
         ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 25
        MOV CX, hongotempx
        ADD hongotempx, 22 
        
       
H56:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H56
        MOV CX, hongotempx
        SUB CX, 22
        DEC DX
        CMP DX, hongotempy
        JNE H56 
        
        
        
                 ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 19
        MOV CX, hongotempx
        ADD hongotempx, 17 
        
       
H57:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H57
        MOV CX, hongotempx
        SUB CX, 17
        DEC DX
        CMP DX, hongotempy
        JNE H57
        
        
                         ;para agregar otra linea arriba
      ;  add dx,3
;        mov cx, hongotempx
;        add hongotempx, 12
                   
        SUB hongotempy, 3
        SUB hongotempx, 14
        MOV CX, hongotempx
        ADD hongotempx, 11 
        
       
H58:
        MOV AH, 0CH     
        MOV AL, 6h   
        INT 10H
        INC CX
        CMP CX, hongotempx
        JNE H58
        MOV CX, hongotempx
        SUB CX, 11
        DEC DX
        CMP DX, hongotempy
        JNE H58
               
        RET
            
endm HONGO

DEFINE_CLEAR_SCREEN
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
DEFINE_PTHIS      
DEFINE_GET_STRING

CODIGO  ENDS 


        END    INICIO    

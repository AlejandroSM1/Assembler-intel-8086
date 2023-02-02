TITLE   PLANTILLA

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
     
        mariox  dw  0
        marioy  dw  0
        mariotempx   dw  0    
        Mariotempy   dw  0
        
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
        
             mov mariox, 60
             mov marioy, 110
             call dibmario

;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO 

;COLOCAR EN ESTA SECCION LOS PROCEDIMIENTOS DEL CODIGO-----------------------------  
dibmario PROC near
        
        MOV AH,0
        MOV AL,13h
        INT 10h
        mov ax, mariox
        mov mariotempx, ax
        mov ax, marioy
        mov mariotempy, ax
        
        MOV DX,  mariotempy
        ADD DX, 5
        MOV CX, mariotempx
        ADD mariotempx, 5   
P1:
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
        
        
               
        RET
            
endm dibmario

CODIGO  ENDS 


        END    INICIO
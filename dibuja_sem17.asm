TITLE   DIBUJA_FIGURAS

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION  

        MSG1 DB "SELECCIONA UNA FIGURA CUADRADO(1) CIRCULO(2) TRIANGULO(3): $"
        MSG2 DB "CAPTURA EL VALOR DE SU BASE (SE MULTIPLICARA X 10): $" 
        MSG3 DB "DESEA DIBUJAR OTRA FIGURA SI(1) NO(2): $"
        salto DB 13, 10, "$"
        SELEC DB 0
        NUMW DW ?
        NUM DB 0
        BASE DW 0
    
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
 
CUADRADO MACRO BASEC 
        MOV DX, BASEC
        MOV CX, 0
        LOCAL LH1,LH2,LV1, LV2
LH1:
        MOV AH,12
        MOV AL,14
        INT 10H
        INC CX
        CMP CX, BASEC
        JNE LH1
        
        MOV CX, 0
        MOV AX, BASEC
        ADD AX, BASEC  
        MOV DX, AX
        
LH2:
        MOV AH,12
        MOV AL,14
        INT 10H
        INC CX
        CMP CX, BASEC
        JNE LH2 
       
        ;LINEAS VERTICALES
        MOV DX, BASEC
        MOV CX, BASEC
         
        MOV AX, BASEC
        ADD AX, BASEC  
        MOV BX, AX      
LV1:
        MOV AH,12
        MOV AL,14
        INT 10H
        INC DX
        CMP DX, BX
        JNE LV1 
        ;-----------
        
        MOV CX, 0
        MOV DX, BASEC 
        
        MOV AX, BASEC
        ADD AX, BASEC  
        MOV BX, AX   
LV2:
        MOV AH,12
        MOV AL,14
        INT 10H
        INC DX
        CMP DX, BX
        JNE LV2
                
        JMP PREGUNTA        
    ENDM 

TRIANGULO MACRO BASET 
    
        MOV DX, BASET
        MOV CX, 0
        LOCAL L1,L2,L3
L1:
        MOV AH,12
        MOV AL,14
        INT 10H
        INC CX
        CMP CX, BASET
        JNE L1    
        
       ;-------------
        MOV CX, 0
        MOV DX, BASET 
        
        MOV AX, BASET
        ADD AX, BASET  
        MOV BX, AX   
L2:
        MOV AH,12
        MOV AL,14
        INT 10H
        INC DX
        CMP DX, BX
        JNE L2 
        ;--------
        
        MOV CX, BASET
        MOV DX, BASET              ;DX=Y CX=X   
        
        MOV AX, BASET
        ADD AX, BASET  
        MOV BX, AX
L3:
        MOV AH,12
        MOV AL,14
        INT 10H
        INC DX
        DEC CX
        CMP DX, BX
        JNE L3         

        JMP PREGUNTA

    ENDM

CIRCULO MACRO RADIO, SEL
        
        MOV DX, RADIO
        MOV AX, RADIO
        MOV BL, 2
        DIV BL
        MOV AH, 0
        ADD RADIO, AX
        MOV DX, RADIO
        MOV CX, RADIO
        ;---- 
          
        ;DX=Y CX=X 
        MOV DX, RADIO
        MOV AX, RADIO
        ADD AX, RADIO  
        MOV BX, AX
        MOV CX, BX
        ;--------------
        MOV AH,12           
        MOV AL,14
        INT 10H 
DIBUJAR:
        MOV AX, DX ;----
        ADD AX, SEL  ;  |--ESTA SECCION SUSTITUIRA LOS INC PARA ESCALAR EL CIRCULO
        MOV DX, AX ;----
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        ADD AX, SEL 
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        ADD AX, SEL 
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;-------------     
        ;DEC CX
        MOV AX, CX ;----|
        SUB AX, SEL  ;    |------ INSTRUCCIONS PARA SUSTITUIR LOS DEC Y ESCALAR LA IMAGEN
        MOV CX, AX ;----|
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL 
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX   
        ;-------
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14 
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX   
        ;-------      
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H    
        ;-------  
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H   
        ;-------    
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H 
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;------  
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;DX=Y CX=X     
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;------   
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H  
        ;-------           
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX 
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H   
        ;-------    
        MOV AX, CX
        SUB AX, SEL
        MOV CX, AX
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;-------------         
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX 
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;--------- 
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H  
        ;-------    
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H                               
        ;-----------        
        MOV AX, DX
        SUB AX, 3
        MOV DX, AX
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H 
        MOV AX, CX
        ADD AX, SEL
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;DX=Y CX=X     
        MOV AX, DX
        SUB AX, SEL
        MOV DX, AX
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H 
        MOV AX, CX 
        ADD AX, SEL 
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL 
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H 
        ;----------    
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AX, CX 
        ADD AX, SEL 
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;DX=Y CX=X     
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H                               
        ;-----------     
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AX, DX 
        ADD AX, SEL 
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL 
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H  
        ;-------     
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX 
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        ;---------   
        MOV AX, CX 
        ADD AX, SEL  
        MOV CX, AX
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        MOV AX, DX 
        ADD AX, SEL  
        MOV DX, AX
        MOV AH,12           
        MOV AL,14
        INT 10H
        JMP PREGUNTA
        ;-------------               
    ENDM                                                        
                                                 
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------
;COLOCAR EL CODIGO DEL PROGRAMA EN ESTA SECCION    
 
COMIENZO: 
        CALL LIMPIAR_PANTALLA
        ;imprime msg2
        MOV AH, 09h
        LEA DX, MSG1
        INT 21h
    
        MOV ah, 01h
        INT 21h
        SUB AL, 30h
        MOV SELEC, AL
    
        ;despliega salto de linea
        MOV AH, 09H
        LEA DX, salto
        INT 21h
    
        ;imprime msg2
        MOV AH, 09h
        LEA DX, MSG2
        INT 21h
    
        ;captura valor
        mov ah, 01h
        int 21h
        sub al, 30h
        mov NUM, al 
         
        MOV AH, 0 
        MOV AL, NUM
        MOV BL, 10
        MUL BL
        MOV BASE, AX 
        
        MOV AL, SELEC
        CMP AL, 1
        JE CUAD 
        
        MOV AL, SELEC
        CMP AL, 2
        JE CIRC 
        
        MOV AL, SELEC
        CMP AL, 3
        JE TRIANG
        
        CALL LIMPIAR_PANTALLA
        JMP COMIENZO
        
CUAD:        
        ;INICIAMOS EL MODO GRAFICO
        MOV AH,0
        MOV AL, 13H
        INT 10H
        CUADRADO BASE 
CIRC:   
        MOV AH,0
        MOV AL, 13H
        INT 10H 
        MOV AH, 0
        MOV AL, NUM 
        MOV NUMW, AX
        CIRCULO BASE, NUMW

TRIANG: 
        MOV AH,0
        MOV AL, 13H
        INT 10H
        TRIANGULO BASE
 
PREGUNTA: 	
        ;PREGUNTA SI DESEA SALIR DEL PROGRAMA
        MOV AH, 09h
        LEA DX, MSG3
        INT 21h
    
        MOV AH, 01h
        INT 21h
        SUB AL, 30h
        MOV SELEC, AL
        
        MOV AL, SELEC
        CMP AL, 1 
       
        JE COMIENZO

SALIR:  
        CALL LIMPIAR_PANTALLA
        MOV AH, 4CH ;solicitud de terminacion del programa
        INT 21H
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO 

;COLOCAR EN ESTA SECCION LOS PROCEDIMIENTOS DEL CODIGO-----------------------------     

LIMPIAR_PANTALLA PROC
        MOV AH,0h		    ;Funcion para re-establecer modo de texto
	    MOV AL, 03H		
	    INT 10h 
	    
        MOV AH, 06H         ;SCROLL UP
        MOV AL, 0           ;DESPLAZAMOS PANTALLA COMPLETA
        MOV BH, 07          ;ATRIBUTO DE NUEVAS LINEAS
        MOV CH, 0           ;COORD ESQUINA SUP IZ
        MOV CL, 0           ;COORD ESQUINA INF DER (CH, CL)
        MOV DH, 84H         
        MOV DL, 4AH
        INT 10H
        
        MOV BH,0            ;CURSOR EN LA PARTE SUP DE LA PAG
        MOV DL, 0           ;PAG ACT
        MOV DH, 0           ;COL
        MOV AH, 02          ;FILA
        INT 10H 
        RET
LIMPIAR_PANTALLA ENDP

CODIGO  ENDS 

        END    INICIO
TITLE   DIBUJA_FIGURAS

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION  

        MSG1 DB "SELECCIONA UNA FIGURA CUADRADO(1) CIRCULO(2) TRIANGULO(3): $"
        MSG2 DB "CAPTURA EL VALOR DE SU BASE (SE MULTIPLICARA X 10): $"
        salto DB 13, 10, "$"
        n1 DB 0
        n2 DB 0
        BASE DW 0 
        X DB 0
        Y DB 0
    
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
                
        JMP SALIR
        RET        
ENDM   
                                                         
                                                 
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------
;COLOCAR EL CODIGO DEL PROGRAMA EN ESTA SECCION    

        ;imprime msg2
        mov ah, 09h
        lea dx, MSG1
        int 21h
    
        mov ah, 01h
        int 21h
        sub al, 30h
        mov n1, al
    
        ;despliega salto de linea
        mov ah, 09H
        lea dx, salto
        int 21h
    
        ;imprime msg2
        mov ah, 09h
        lea dx, MSG2
        int 21h
    
        ;captura valor
        mov ah, 01h
        int 21h
        sub al, 30h
        mov n2, al 
         
        MOV AH, 0 
        MOV AL, n2
        MOV BL, 10
        MUL BL
        MOV BASE, AX
        
        ;INICIAMOS EL MODO GRAFICO
        MOV AH,0
        MOV AL, 13H
        INT 10H
        CUADRADO BASE
SALIR:
        mov ah, 4CH ;solicitud de terminacion del programa
        int 21H
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO 

;COLOCAR EN ESTA SECCION LOS PROCEDIMIENTOS DEL CODIGO-----------------------------

CODIGO  ENDS 

        END    INICIO
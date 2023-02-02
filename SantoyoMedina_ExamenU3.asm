TITLE   EXAMEN_UNIDAD_3

INCLUDE emu8086.inc 
                                          
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
     
        X           DB      0    
        B           DB      0 
        INTER       DB      0
        RES_ENT     DB      0
        RES_DES     DB      4 DUP(0)
        
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

RESOLVER MACRO X1, B1    
    MOV AH, 0
    MOV AL, X1                
    MOV BL, B1
    DIV BL   
    MOV AH, 0
    MOV RES_ENT, AL 
    MOV INTER, AH
    CMP INTER, 0
    GOTOXY 1,4
    PRINT 'X=' 
    MOV    AH,0
    CALL PRINT_NUM_UNS 
    PRINT '.'
    JE RESUELTA
    JNE DECIMALES    
        
DECIMALES: 
    MOV AH, 0
    MOV AL, INTER
    MOV BL, 100
    MUL BL
    MOV INTER, AH  
    MOV AH, 0
    MOV AL, X1                
    MOV BL, INTER
    DIV BL
    MOV RES_DES[0], AL
    MOV INTER, AH
    CMP INTER, 0
    MOV    AH,0
    CALL PRINT_NUM_UNS
    JE  RESUELTA
    ;-------------
    MOV AH, 0
    MOV AL, INTER
    MOV BL, 100
    MUL BL
    MOV INTER, AH  
    MOV AH, 0
    MOV AL, X1                
    MOV BL, INTER
    DIV BL
    MOV RES_DES[1], AL
    MOV INTER, AH
    CMP INTER, 0  
    MOV    AH,0
    CALL PRINT_NUM_UNS
    JE  RESUELTA1 
    ;-------------
    MOV AH, 0
    MOV AL, INTER
    MOV BL, 100
    MUL BL  
    MOV AH, 0
    MOV INTER, AH
    MOV AL, X1                
    MOV BL, INTER
    DIV BL
    MOV RES_DES[2], AL
    MOV INTER, AH
    CMP INTER, 0
    MOV    AH,0
    CALL PRINT_NUM_UNS
    JE  RESUELTA2
    ;------------------    
    MOV AH, 0
    MOV AL, INTER
    MOV BL, 100
    MUL BL
    MOV INTER, AH 
    MOV AH, 0
    MOV AL, X1                
    MOV BL, INTER
    DIV BL
    MOV RES_DES[3], AL
    MOV INTER, AH
    CMP INTER, 0  
    MOV    AH,0
    CALL PRINT_NUM_UNS
    JE  RESUELTA3 
    ;------------------ 
    MOV AH, 0
    MOV AL, INTER
    MOV BL, 100
    MUL BL
    MOV INTER, AH 
    MOV AH, 0
    MOV AL, X1                
    MOV BL, INTER
    DIV BL
    MOV RES_DES[4], AL
    MOV    AH,0
    CALL PRINT_NUM_UNS
    JMP FIN_CALC
    
     
RESUELTA:
    MOV RES_DES[0], 0
    MOV RES_DES[1], 0
    MOV RES_DES[2], 0
    MOV RES_DES[3], 0 
    JMP FIN_CALC

RESUELTA1:
    MOV RES_DES[1], 0
    MOV RES_DES[2], 0
    MOV RES_DES[3], 0
    JMP FIN_CALC  
    
RESUELTA2:
    MOV RES_DES[2], 0
    MOV RES_DES[3], 0
    JMP FIN_CALC 
    
RESUELTA3:
    MOV RES_DES[3], 0  
        
    JMP FIN_CALC
    
FIN_CALC:
    JMP CONTINUAR1
ENDM

;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------
;COLOCAR EL CODIGO DEL PROGRAMA EN ESTA SECCION
 COMIENZO:        
        CALL CLEAR_SCREEN
        CALL PEDIR_DATOS 
        
CONTINUAR1:
        RESOLVER X, B
        CALL PREGUNTA_REINICIAR   
        
SALIR:   
        
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO 

;COLOCAR EN ESTA SECCION LOS PROCEDIMIENTOS DEL CODIGO-----------------------------

DEFINE_SCAN_NUM 
DEFINE_GET_STRING 
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_PTHIS 
DEFINE_CLEAR_SCREEN

PEDIR_DATOS PROC
        GOTOXY 1,1
        PRINT '  X+  =0'
        GOTOXY 1,1
        CALL SCAN_NUM
        MOV X, CL
        GOTOXY 5,1
        CALL SCAN_NUM
        MOV B, CL
        JMP CONTINUAR1
PEDIR_DATOS ENDP
    
PREGUNTA_REINICIAR PROC 
        MOV X,0
        MOV B,0
        MOV AX,0
        MOV BX,0
        GOTOXY 1,6  
        MOV CX, 0
        PRINT 'DESEA REALIZAR UN NUEVO CALCULO? SI (1) / NO (2) : '
        CALL SCAN_NUM
        CMP CX, 1
        JE COMIENZO
        CMP CX, 2 
        JE SALIR
PREGUNTA_REINICIAR ENDP     
          
        RET
CODIGO  ENDS 


        END    INICIO
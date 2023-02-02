TITLE   ACT_07_03_2022

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
         
    X       DB  40
    TEMP    DB  0
    Y       DB  0
    R       DB  0
    
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
;COLOCAR EL CODIGO DEL PROGRAMA EN ESTA SECCION
       MOV AL, X
       MOV AH, 0 
       MOV TEMP, AL     ;TEMP = X 
       MOV AL, X
       MOV Y, AL        ;Y = X
       MOV AL, Y
       MOV BL, 2 
       DIV BL
       MOV Y, AL        ;Y = Y/2
       
CICLO:
       MOV AL, X 
       MOV AH, 0
       MOV BL, Y
       DIV BL
       MOV X, AL        ;X = INT(X/Y) 
       MOV AL, X
       ADD AL, Y        
       MOV X, AL        ;X = X+Y
       MOV AL, X
       MOV AH,  0
       MOV BL, 2
       DIV BL
       MOV X, AL        ;X = INT(X/2)
               
       MOV AL, X
       MOV BL, Y
       CMP BL, AL
       JE RESULTADO     ;SI LA CONDICION Y = X SE CUMPLE SALTA A RESULTADO
           
       MOV AL, X
       SUB AL, Y    
       CMP AL, 1
       JE RESULTADO     ;SI CONDICION X-Y = 1 SE CUMPLE SALTA A RESULTADO
                        
       MOV AL, X
       SUB AL, Y    
       CMP AL, -1
       JE RESULTADO     ;SI CONDICION X-Y = -1 SE CUMPLE SALTA A RESULTADO
       
       MOV AL, X
       MOV Y, AL        ;Y = X
       MOV AL, TEMP
       MOV X, AL        ;X = TEMP
       JMP CICLO        ;SI NIGUNA CONDICION SE CUMPLIO VUELVE AL CICLO
        
       
RESULTADO:  
      MOV AL, X
      MOV R, AL         ;R = X
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

CODIGO  ENDS 


        END    INICIO    

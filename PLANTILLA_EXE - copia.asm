TITLE   PLANTILLA

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
     
        LADO1   DB  0
        LADO2   DB  0
        LADO3   DB  0
        TIPO    DB  '?'
    
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
        MOV AX, 0    
        MOV BX, 0
        MOV AL, LADO2
        ADD AL, LADO3
        CMP LADO1, AL
        JAE NO_TRIANGULO
        MOV AX,0
        MOV AL, LADO2
        SUB AL, LADO3
        CMP AL, LADO1
        JAE NO_TRIANGULO
                 
        MOV AX, 0
        MOV AL, LADO1
        ADD AL, LADO3
        CMP LADO2, AL
        JAE NO_TRIANGULO
        MOV AX,0
        MOV AL, LADO1
        SUB AL, LADO3
        CMP AL, LADO2
        JAE NO_TRIANGULO
        
        MOV AX, 0
        MOV AL, LADO1
        ADD AL, LADO2
        CMP AL, LADO3
        JAE NO_TRIANGULO
        MOV AX,0
        MOV AL, LADO1
        SUB AL, LADO2
        CMP LADO3, AL
        JBE NO_TRIANGULO 
        
COMPARAR:
        MOV AX, 0
        MOV AL, LADO1
        CMP AL, LADO2
        JE COMPARAR2 
        
        MOV AX, 0
        MOV AL, LADO2
        CMP AL, LADO3
        JE COMPARAR3
        
        MOV AX, 0
        MOV AL, LADO1
        CMP AL, LADO3
        JE COMPARAR4
        
        JMP ESCALENO
         
COMPARAR2:
        MOV AX, 0
        MOV AL, LADO2
        CMP AL, LADO3
        JE EQUILATERO
        MOV TIPO, 'I'
        JMP SALIR
        
COMPARAR3:
        MOV AX, 0
        MOV AL, LADO3
        CMP AL, LADO1
        JE EQUILATERO
        MOV TIPO, 'I'
        JMP SALIR  
        
COMPARAR4:
        MOV AX, 0
        MOV AL, LADO3
        CMP AL, LADO2
        JE EQUILATERO
        MOV TIPO, 'I'
        JMP SALIR 

EQUILATERO:
        MOV TIPO, 'E'
        JMP SALIR     
    
ESCALENO:
        MOV TIPO, 'S'
        JMP SALIR 
        
        
NO_TRIANGULO:
        MOV TIPO, 'N'
        JMP SALIR
        
SALIR: 


        


;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

CODIGO  ENDS 


        END    INICIO    

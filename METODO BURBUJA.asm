TITLE   Metodo burbuja

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
     
NUMEROS DB 3,1,2,7,8,3,5,6 
MENOR   DB 3,1,2,7,8,3,5,6
MAYOR   DB 3,1,2,7,8,3,5,6
        
    
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
                             
ASSUME DS: DATOS, CS: CODIGO, SS: PILA                     
    
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

;;;;Ciclo para acomodar de menor a mayor

CICLO_MENOR: 
MOV SI, 0
MOV DI, 0
MOV CX, 7

CICLO2: 
PUSH CX
MOV AL, MENOR [SI]   
INC SI
MOV BL, MENOR [SI] 
CMP AL, BL 
JG  ES_MAYOR 
JL  ES_MENOR 


ES_MENOR:
INC DI
LOOP CICLO2
POP CX
JMP CICLO_MAYOR
  
 
ES_MAYOR: 

MOV MENOR [DI], BL
MOV MENOR [SI], AL
JMP CICLO_MENOR

;;;;;Ciclo para acomodar de mayor a menor

CICLO_MAYOR:

MOV SI, 0
MOV DI, 0
MOV CX, 7 

CICLO3:
PUSH CX
MOV AL, MAYOR [SI]
INC SI
MOV BL, MAYOR [SI]
CMP AL, BL
JG ES_BIG
JL ES_LOW

ES_BIG:

INC DI
LOOP CICLO3

JMP EXIT

ES_LOW:

MOV MAYOR [DI], BL
MOV MAYOR [SI], AL
JMP CICLO_MAYOR




            

       
        
         
        
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
EXIT:       
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

CODIGO  ENDS 


        END    INICIO    

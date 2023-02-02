TITLE   Practica5U2_Equipo2

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
     
        MAT_A       DB      4,3,2,1,6,1,2,3,4,5,6,7,8,9,10,11
        MAT_B       DB      1,2,3,4,5,6,7,8,9,3,4,5,6,7,8,9
        MAT_R       DB      16   DUP(?)
        MAT_INT     DB      16   DUP(?)
        IND_B       DW      ?
        IND_R       DW      ?
        IND_FILA    DW      ?
    
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
        
        MOV SI,0                ;INDICE DE LA MATRIZ A
        MOV DI,0                ;INDICE DE LA MATRIZ B
        MOV IND_FILA,4          ;LIMITE DE ELEMENTOS POR FILA
        MOV IND_R,0             ;INDICE DE LLA MATRIZ RESULTANTE
                      
INDICES:
        MOV IND_B,DI            ;SALVAMOS EL INDICE DI QUE INICIA EN 0, CORRESPONDE
                                ;A LAS COLUMNAS  DE LA MATRIZ B                                                      
                                                                 
        ;CICLO PARA OBTENER LOS ELEMENTOS DE LA MATRIZ RESULTANTE
MULT1:          
        MOV AL,MAT_A[SI]        ;SE CARGA EN AL A0
        MOV BL,MAT_B[DI]        ;SE CARGA EN BL B0
        MUL BL                  ;MULTIMPLICA AL Y BL
        MOV MAT_INT[SI],AL      ;GUARGA EL RESULTADO EN MAT_INT
        ADD DI,4                ;INCREMENTAMOS DI EN 4 PARA MOVERNOS POR MAT_B
        INC SI                  ;INCREMENTAMOS SI EN 1 PARA MOVERNOS POR MAT_A
        CMP SI,3                ;COMPARAMOS SI CON 3
        JBE MULT1               ;SI <= 3 REGRESA A LA ETIQUETA MULT1
        
        ;SUMA DE LOS ELEMENTOS DE MAT_INT PARA DESPUES GUARDARLO EN MAT_R
        MOV AL, MAT_INT[0]
        ADD AL, MAT_INT[1]
        ADD AL, MAT_INT[2]
        ADD AL, MAT_INT[3]
        
        ;INCREMENTO DEL INDICE DE LA MATRIZ RESULTANTE
        MOV SI,IND_R            ;CARGAMOS EL VALOR DE IND_R EN SI
        MOV MAT_R[SI],AL        ;ALMACENAMOS EL VALOR DE AL EN MAT_R
        INC IND_R               ;INCREMENTAMOS EL IND_R
        MOV SI,0                ;CARGAMOS SI CON 0
        MOV DI, IND_B           ;IND_B ES EL INDICE PARA MOVERNOS POR LAS COLUMNAS DE MAT_B
        INC DI                  ;INCREMENTAMOS DI                 
        DEC IND_FILA            ;DECREMENTA IND_FILA
        CMP IND_FILA,0          ;COMPARAMOS IND_FILA CON 0
        JA  INDICES             ;IND_FILA == 0, TERMINA EL PROCESO 
        
        MOV IND_FILA, 4         ;LIMITE DE ELEMENTOS POR FILA 
        MOV SI,4
        MOV DI,0
        
INDICES2:
        MOV IND_B,DI            ;SALVAMOS EL INDICE DI QUE INICIA EN 1, CORRESPONDE
                                ;A LAS COLUMNAS  DE LA MATRIZ B                                                      
                                                                 
        ;CICLO PARA OBTENER LOS ELEMENTOS DE LA MATRIZ RESULTANTE
MULT2:          
        MOV AL,MAT_A[SI]        ;SE CARGA EN AL A3
        MOV BL,MAT_B[DI]        ;SE CARGA EN BL B1
        MUL BL                  ;MULTIMPLICA AL Y BL
        MOV MAT_INT[SI],AL      ;GUARGA EL RESULTADO EN MAT_INT
        ADD DI,4                ;INCREMENTAMOS DI EN 3 PARA MOVERNOS POR MAT_B
        INC SI                  ;INCREMENTAMOS SI EN 1 PARA MOVERNOS POR MAT_A
        CMP SI,7                ;COMPARAMOS SI CON 7
        JBE MULT2               ;SI <= 7 REGRESA A LA ETIQUETA MULT2
        
        ;SUMA DE LOS ELEMENTOS DE MAT_INT PARA DESPUES GUARDARLO EN MAT_R
        MOV AL, MAT_INT[4]
        ADD AL, MAT_INT[5]
        ADD AL, MAT_INT[6]
        ADD AL, MAT_INT[7]
        
        ;INCREMENTO DEL INDICE DE LA MATRIZ RESULTANTE
        MOV SI,IND_R            ;CARGAMOS EL VALOR DE IND_R EN SI
        MOV MAT_R[SI],AL        ;ALMACENAMOS EL VALOR DE AL EN MAT_R
        INC IND_R               ;INCREMENTAMOS EL IND_R
        MOV SI,4                ;CARGAMOS SI CON 4
        MOV DI, IND_B           ;IND_B ES EL INDICE PARA MOVERNOS POR LAS COLUMNAS DE MAT_B
        INC DI                  ;INCREMENTAMOS DI                 
        DEC IND_FILA            ;DECREMENTA IND_FILA
        CMP IND_FILA,0          ;COMPARAMOS IND_FILA CON 0
        JA  INDICES2            ;IND_FILA == 0, TERMINA EL PROCESO 
        
        MOV IND_FILA, 4         ;LIMITE DE ELEMENTOS POR FILA 
        MOV SI,8
        MOV DI,0
        
INDICES3:
        MOV IND_B,DI            ;SALVAMOS EL INDICE DI QUE CORRESPONDE
                                ;A LAS COLUMNAS  DE LA MATRIZ B                                                      
                                                                 
        ;CICLO PARA OBTENER LOS ELEMENTOS DE LA MATRIZ RESULTANTE
MULT3:          
        MOV AL,MAT_A[SI]        ;SE CARGA EN AL A6
        MOV BL,MAT_B[DI]        ;SE CARGA EN BL B0
        MUL BL                  ;MULTIMPLICA AL Y BL
        MOV MAT_INT[SI],AL      ;GUARGA EL RESULTADO EN MAT_INT
        ADD DI,4                ;INCREMENTAMOS DI EN 4 PARA MOVERNOS POR MAT_B
        INC SI                  ;INCREMENTAMOS SI EN 1 PARA MOVERNOS POR MAT_A
        CMP SI,11                ;COMPARAMOS SI CON 11
        JBE MULT3               ;SI <= 11 REGRESA A LA ETIQUETA MULT3
        
        ;SUMA DE LOS ELEMENTOS DE MAT_INT PARA DESPUES GUARDARLO EN MAT_R
        MOV AL, MAT_INT[8]
        ADD AL, MAT_INT[9]
        ADD AL, MAT_INT[10]
        ADD AL, MAT_INT[11]
        
        ;INCREMENTO DEL INDICE DE LA MATRIZ RESULTANTE
        MOV SI,IND_R            ;CARGAMOS EL VALOR DE IND_R EN SI
        MOV MAT_R[SI],AL        ;ALMACENAMOS EL VALOR DE AL EN MAT_R
        INC IND_R               ;INCREMENTAMOS EL IND_R
        MOV SI,8                ;CARGAMOS SI CON 8
        MOV DI, IND_B           ;IND_B ES EL INDICE PARA MOVERNOS POR LAS COLUMNAS DE MAT_B
        INC DI                  ;INCREMENTAMOS DI                 
        DEC IND_FILA            ;DECREMENTA IND_FILA
        CMP IND_FILA,0          ;COMPARAMOS IND_FILA CON 0
        JA  INDICES3            ;IND_FILA == 0, TERMINA EL PROCESO
        
        MOV IND_FILA, 4         ;LIMITE DE ELEMENTOS POR FILA 
        MOV SI,12
        MOV DI,0
        
INDICES4:
        MOV IND_B,DI            ;SALVAMOS EL INDICE DI QUE CORRESPONDE
                                ;A LAS COLUMNAS  DE LA MATRIZ B                                                      
                                                                 
        ;CICLO PARA OBTENER LOS ELEMENTOS DE LA MATRIZ RESULTANTE
MULT4:          
        MOV AL,MAT_A[SI]        ;SE CARGA EN AL A6
        MOV BL,MAT_B[DI]        ;SE CARGA EN BL B0
        MUL BL                  ;MULTIMPLICA AL Y BL
        MOV MAT_INT[SI],AL      ;GUARGA EL RESULTADO EN MAT_INT
        ADD DI,4                ;INCREMENTAMOS DI EN 4 PARA MOVERNOS POR MAT_B
        INC SI                  ;INCREMENTAMOS SI EN 1 PARA MOVERNOS POR MAT_A
        CMP SI,15                ;COMPARAMOS SI CON 15
        JBE MULT4               ;SI <= 11 REGRESA A LA ETIQUETA MULT3
        
        ;SUMA DE LOS ELEMENTOS DE MAT_INT PARA DESPUES GUARDARLO EN MAT_R
        MOV AL, MAT_INT[12]
        ADD AL, MAT_INT[13]
        ADD AL, MAT_INT[14]
        ADD AL, MAT_INT[15]
        
        ;INCREMENTO DEL INDICE DE LA MATRIZ RESULTANTE
        MOV SI,IND_R            ;CARGAMOS EL VALOR DE IND_R EN SI
        MOV MAT_R[SI],AL        ;ALMACENAMOS EL VALOR DE AL EN MAT_R
        INC IND_R               ;INCREMENTAMOS EL IND_R
        MOV SI,12                ;CARGAMOS SI CON 12
        MOV DI, IND_B           ;IND_B ES EL INDICE PARA MOVERNOS POR LAS COLUMNAS DE MAT_B
        INC DI                  ;INCREMENTAMOS DI                 
        DEC IND_FILA            ;DECREMENTA IND_FILA
        CMP IND_FILA,0          ;COMPARAMOS IND_FILA CON 0
        JA  INDICES4            ;IND_FILA == 0, TERMINA EL PROCESO  
        
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

CODIGO  ENDS 


        END    INICIO    

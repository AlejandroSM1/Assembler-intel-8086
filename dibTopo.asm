TITLE   PEGALE_AL_TOPO

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
 
        TOPOX   DW  0
        TOPOY   DW  0
        TEMPX   DW  0
        TEMPY   DW  0 
        SANDIAX   DW  0
        SANDIAY   DW  0
        STEMPX   DW  0
        STEMPY   DW  0
        COLOR   DB  0
        

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
         
            
        MOV AH,0
        MOV AL,13h
        INT 10h  
        MOV SANDIAX, 170
        MOV SANDIAY, 70
        CALL SANDIA

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

TOPOFELI PROC near
    
    MOV AX, TOPOX 
    MOV TEMPX, AX
    MOV AX, TOPOY 
    MOV TEMPY, AX
    MOV AH,0
    MOV AL,13h
    INT 10h 
    MOV DX, TEMPY
    ADD DX, 9
    MOV CX, TEMPX
    ADD TEMPX, 10          
    MOV COLOR, 0110B  
P1:
    MOV AH, 0CH     
    MOV AL, COLOR   
    INT 10H
    INC CX
    CMP CX, TEMPX
    JNE P1
    MOV CX, TEMPX
    SUB CX, 10
    DEC DX
    CMP DX, TEMPY
    JNE P1 
    ;----------------    
    MOV CX, TEMPX
    SUB TEMPX, 1
    SUB CX, 9
    SUB TEMPY, 2
P2:
    MOV AH, 0CH     
    MOV AL, COLOR     
    INT 10H 
    INC CX
    CMP CX, TEMPX
    JNE P2
    MOV CX, TEMPX
    SUB CX, 8
    DEC DX
    CMP DX, TEMPY
    JNE P2
    ;----------------
    MOV CX, TEMPX
    SUB TEMPX, 1
    SUB CX, 7
    SUB TEMPY, 2
P3:
    MOV AH, 0CH     
    MOV AL, COLOR    
    INT 10H  
    INC CX
    CMP CX, TEMPX
    JNE P3 
    ;----------------
    MOV COLOR, 1010B 
    MOV AX, TOPOX 
    MOV TEMPX, AX
    MOV AX, TOPOY 
    MOV TEMPY, AX
    MOV DX, TEMPY  
    ADD DX, 10
    MOV CX, TEMPX
    DEC CX
    ADD TEMPX, 11            
P4:
    MOV AH, 0CH     
    MOV AL, COLOR  
    INT 10H
    INC CX
    CMP CX, TEMPX
    JNE P4 
    ;---------------
    MOV AX, TOPOX 
    MOV TEMPX, AX
    MOV AX, TOPOY 
    MOV TEMPY, AX
    MOV DX, TEMPY
    ADD DX, 6
    MOV CX, TEMPX 
    ADD CX, 3
    ADD TEMPX, 7          
    MOV COLOR, 1101B  
P5:
    MOV AH, 0CH     
    MOV AL, COLOR   
    INT 10H
    INC CX
    CMP CX, TEMPX
    JNE P5
    ;---------------- 
    MOV AX, TOPOX 
    MOV TEMPX, AX
    MOV AX, TOPOY 
    MOV TEMPY, AX
    MOV DX, TEMPY
    ADD DX, 5
    MOV CX, TEMPX 
    ADD CX, 2
    ADD TEMPX, 8          
    MOV COLOR, 1101B  
P6:
    MOV AH, 0CH     
    MOV AL, COLOR   
    INT 10H
    INC CX
    CMP CX, TEMPX
    JNE P6
    ;---------------- 
    MOV AX, TOPOX 
    MOV TEMPX, AX
    MOV AX, TOPOY 
    MOV TEMPY, AX
    MOV DX, TEMPY
    DEC TEMPY
    ADD DX, 2
    MOV CX, TEMPX 
    ADD CX, 2
    ADD TEMPX, 4          
    MOV COLOR, 1111B  
P7:
    MOV AH, 0CH     
    MOV AL, COLOR   
    INT 10H
    INC CX
    CMP CX, TEMPX
    JNE P7
    MOV CX, TEMPX
    SUB CX, 2
    DEC DX
    CMP DX, TEMPY
    JNE P7
    ;---------------- 
    MOV AX, TOPOX 
    MOV TEMPX, AX
    MOV AX, TOPOY 
    MOV TEMPY, AX
    MOV DX, TEMPY
    DEC TEMPY
    ADD DX, 2
    MOV CX, TEMPX 
    ADD CX, 6
    ADD TEMPX, 8          
    MOV COLOR, 1111B  
P8:
    MOV AH, 0CH     
    MOV AL, COLOR   
    INT 10H
    INC CX
    CMP CX, TEMPX
    JNE P8
    MOV CX, TEMPX
    SUB CX, 2
    DEC DX
    CMP DX, TEMPY
    JNE P8
;---------------- 
    MOV COLOR, 0000B
    MOV AX, TOPOX 
    MOV TEMPX, AX
    MOV AX, TOPOY 
    MOV TEMPY, AX
    MOV DX, TEMPY
    ADD DX, 1
    MOV CX, TEMPX 
    ADD CX, 6         
    MOV AH, 0CH     
    MOV AL, COLOR   
    INT 10H
    SUB CX, 3         
    MOV AH, 0CH     
    MOV AL, COLOR   
    INT 10H 
    ADD CX, 1
    ADD DX, 4         
    MOV AH, 0CH     
    MOV AL, 1111B   
    INT 10H
         
    RET 

ENDP TOPOFELI 

SANDIA PROC NEAR
    
    MOV AX, SANDIAX 
    MOV STEMPX, AX
    MOV AX, SANDIAY 
    MOV STEMPY, AX
     
    MOV DX, STEMPY
    ADD DX, 11
    MOV CX, STEMPX
    SUB CX, 7
    ADD STEMPX, 17           
SV:
    MOV AH, 0CH     
    MOV AL, 0010B   
    INT 10H
    INC CX
    CMP CX, STEMPX
    JNE SV
    MOV CX, STEMPX
    SUB CX, 24
    DEC DX
    CMP DX, STEMPY
    JNE SV
    ;---------------  
    ;-------------
    MOV AX, SANDIAX 
    MOV STEMPX, AX
    MOV AX, SANDIAY 
    MOV STEMPY, AX
     
    MOV DX, STEMPY
    ADD DX, 9
    MOV CX, STEMPX
    SUB CX, 5
    ADD STEMPX, 15           
S0:
    MOV AH, 0CH     
    MOV AL, 1111B   
    INT 10H
    INC CX
    CMP CX, STEMPX
    JNE S0
    MOV CX, STEMPX
    SUB CX, 20
    DEC DX
    CMP DX, STEMPY
    JNE S0
    ;---------------
    MOV AX, SANDIAX 
    MOV STEMPX, AX
    MOV AX, SANDIAY 
    MOV STEMPY, AX
     
    MOV DX, STEMPY
    ADD DX, 8
    MOV CX, STEMPX
    ADD STEMPX, 10           
S1:
    MOV AH, 0CH     
    MOV AL, 0100B   
    INT 10H
    INC CX
    CMP CX, STEMPX
    JNE S1
    MOV CX, STEMPX
    SUB CX, 10
    DEC DX
    CMP DX, STEMPY
    JNE S1 
    ;-----------
    MOV AX, SANDIAX 
    MOV STEMPX, AX
    MOV AX, SANDIAY 
    MOV STEMPY, AX
     
    MOV DX, STEMPY
    ADD DX, 6
    MOV CX, STEMPX
    SUB CX, 4
    ADD STEMPX, 14           
S2:
    MOV AH, 0CH     
    MOV AL, 0100B   
    INT 10H
    INC CX
    CMP CX, STEMPX
    JNE S2
    MOV CX, STEMPX
    SUB CX, 18
    DEC DX
    CMP DX, STEMPY
    JNE S2
    
    RET
    
ENDP SANDIA 
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------

CODIGO  ENDS 


        END    INICIO    

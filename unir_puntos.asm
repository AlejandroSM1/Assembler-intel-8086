TITLE   PLANTILLA

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
     
        CAX     DW  0
        CAY     DW  0
        CBX     DW  0
        CBY     DW  0
        TAX     DW  0
        TAY     DW  0
        TBX     DW  0
        TBY     DW  0 
        TEMPX   DW  0
        TEMPY   DW  0
        X       DW  0
        Y       DW  0 
        M       DW  0 
        B       DW  0
    
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
  
        MOV AH, 00       ;Cargamos el modo de video
        MOV AL, 13H      ;Cargamos el modo grafico 13H en el cual tenemos 256 colores 
        INT 10H          ;Sigue la interrupcion que controla los servicios de pantalla
      
CICLO:           ;Comenzamos el ciclo
        MOV AX,3         ;Obtenemos la informacion del raton
        INT 33H          ;Interrupcion que controla el raton
        SHR CX, 1        ;Se divide entre 2 para obtener la pocision correcta
        CMP BX, 1        ;Comparamos BX com 1(boton izquierdo)
        JE PINTARCA       ;Pintamos nuestro punto X, se realiza un salto condicional
        CMP BX, 2        ;Comparamos BX com 2(boton derecho)
        JE PINTARYCB       ;Pintamos nuestro punto Y, se realiza un salto condicional
        JMP CICLO        ;Salto incondicional a nuestro ciclo 

PINTARCA:         ;Etiqueta pintar COORDENADA A
        MOV AL, 1110B    ;Se carga el color Amarillo
        MOV AH, 0CH      ;Se Dibuja un pixel en pantalla
        INT 10H          ;Interrupcion que controla los servicios de pantalla
        MOV CAX, CX
        MOV CAY, DX
        JMP CICLO        ;Salto incondicional a nuestro ciclo 


PINTARYCB:         ;Etiqueta pintar COORDENADA B
        MOV AL, 1101B    ;Se carga el color Rosa
        MOV AH, 0CH      ;Se Dibuja un pixel en pantalla 
        MOV CBX, CX
        MOV CBY, DX
        INT 10H          ;Interrupcion que controla los servicios de pantalla      
        
CALCULAR_PENDIENTE:
    
        MOV AX, CBX
        SUB AX, CAX  
        MOV TEMPX, AX
        MOV AX, CBY
        SUB AX, CAY
        MOV TEMPY, AX 
        MOV AX, 0 
        MOV BX, 0
        MOV AX, TEMPX
        MOV BX, TEMPY
        DIV BL   
        MOV AH, 0
        MOV M, AX 
        ;HASTA AQUI OBTENEMOS M CORRECTAMENTE       
        MOV AX, CAX
        MOV BX, M
        MUL BL   ; == M * X
        MOV BX, CAY
        SUB BX, AX
        MOV AX, BX
        MOV B, AX ; == Y-(M*X)=B
        ;HASTA AQUI OBTENEMOS EL VALOR DE B
           
        MOV AX, CAX
        MOV X, AX
 PINTAR:        
        MOV AX, X
        MOV BX, M
        MUL BL
        ADD AX, B
        MOV Y, AX 
        ;Y=M*X+B
        
        MOV CX, X
        MOV DX, Y        ;CARGAMOS LAS COORDENADAS GENERADAS POR LA ECUACION
        MOV AL, 1101B    ;Se carga el color Rosa
        MOV AH, 0CH      ;Se Dibuja un pixel en pantalla
        INT 10H          ;----
         
        INC X
        MOV AX, X
        CMP AX, CBX 
        JNE PINTAR      
SALIR:        

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
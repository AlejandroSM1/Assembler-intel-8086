TITLE   PRACTICA_3_UNIDAD_2

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
    d:

    PALABRA db 'Equipo2'       ; declaramos una contrasena y un usuario para el uso del progrma
    CONTRASENA db 'Equipo2'
    CADENA db 7 DUP (?) 
    TAM =($ - d) / 2
    VALIDO db 0   
    
    CUENTA EQU 10                 ; decalramos un registro para declarar error
    CADENA1 DB CUENTA DUP(?)
  
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
        mov CX,TAM
        mov SI,OFFSET PALABRA
        mov DI,OFFSET CADENA
        REP MOVSB                       ; moveremos el usuario  para comprararlo con nuestra contrasena
        
        LEA SI, CADENA
        LEA DI, CONTRASENA
        MOV CX, TAM                     ; comprobamos si efectivamente el usuario coincide con la contrasena
        REPE CMPSB
        JNZ NO   
        JMP CORRECTO
        
CORRECTO:
        MOV VALIDO, 'S'
        MOV DI, OFFSET CADENA
        MOV AL, '2'
        MOV CX, TAM 
        CLD                             ; en caso de ser correcto enviremos la direccion del caracter id
        REPNE SCASB
        JNZ USUARIO_INCORECTO
        
        JMP SALIR
          
USUARIO_INCORECTO:
        
        MOV AL, 0FFh
        MOV DI, OFFSET CADENA1
        MOV CX, CUENTA
        CLD
        REP STOSB                   ; en caso de error mandaremos 10 0 en exadecimal
        
        
        
NO:
        MOV VALIDO, 'N'
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

TITLE   PLANTILLA

                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION

;TIPOS DE VARIABLES

BYTE DB 'S'     ;TIPO BYTE, TIENE 8 BITS: 00000000 o 11111111        
PALABRA DW 'SI' ;TIPO PALABRA TIENE 16 BITS: 0000000000000000 o 1111111111111111

;ARREGLOS  

ARREGLO_BYTE DB 255,10,5,4              ;ARREGLO TIPO BYTE CON NUMEROS
ARREGLO_BYTE_CADENA DB 'HOLA OwO'       ;ARREGLO TIPO BYTE CON CADENA    (GUARDA DE 1 EN 1)

ARREGLO_PALABRA DW 2550,10,5,4          ;ARREGLO TIPO PALABRA CON NUMEROS
ARREGLO_PALABRA_CADENA DW 'HO  LA  :3'  ;ARREGLO TIPO PALABRA CON CADENA (GUARDA DE 2 EN 2) 

;SABER EL NUMERO DE ELEMENTOS DE UN ARREGLO
NUM_ELEMENTOS:                                     ;ETIQUETA PARA INDICAR QUE ARREGLO O ARREGLOS TOMAREMOS
ARREGLO_PRUEBA_BYTE DB 'NO SE ME OCURRE NADA'      
TAM_BYTE = ($ - NUM_ELEMENTOS)                     ;VARIABLE DONDE GUARDAREMOS EL LARGO DEL ARREGLO  

;RELLENAR UN ARREGLO
ARREGLO_PRUEBA_RELLENO DB 15 DUP (1)               ;RELLENA 15 POSICIONES DEL ARREGLO CON 1

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

;=====================================================================================================================
;REGISTROS 

;HAY 4 REGISTROS (AX, BX, CX, DX) TIPO PALABRA  
;CADA REGISTRO SE DIVIDE EN 2 (AL, AH, BL, BH, CL, CH, DL, DH) L PARA LA PARTE BAJA, H PARA LA ALTA

;=====================================================================================================================
;MOVER VALORES

;MOV
;COPIA EL VALOR DE ALGO A OTRA PARTE   
;MOV AX, 256 
;MOV BX, 2
;MOV AX, BX     
;MOV BL, TAM_BYTE
;MOV AL, BL      

;=====================================================================================================================
;LEA
;SIRVE PARA MOVER LA DIRECCION EFECTIVA DE LA VARIABLE 
;LEA SI, ARREGLO_BYTE       

;=====================================================================================================================
;USO DE PILAS   

;LAS PILAS SON EL LUGAR DONDE EL PROGRAMA GUARDA VALORES, PODEMOS USARLAS PARA GUARDAR NUESTROS VALORES
;USANDO UNA ESTRUCTURA LIFO (LAST IN FIRST OUT) 

;PUSH (INGRESA UN VALOR A LA PILA)       
;MOV AX, 255     ;AX = 255
;PUSH AX         ;PILA = 255
        
;POP (EXTRAE EL ULTIMO VALOR DE LA PILA)    
;MOV AX, 0       ;AX = 0
;POP AX          ;AX = 255        

;=====================================================================================================================
;ETIQUETAS

;LAS ETIQUETAS SIRVEN PARA SEPARAR EL CODIGO POR PARTES 
;Y PARA PODER VOLVER A ESA PARTE O SEGMENTO CON LOS SALTOS O CON EL LOOP      

;=====================================================================================================================
;USO DE LOOP

;REPITE UN CICLO (USANDO UNA ETIQUETA) HASTA QUE CX = 0
;MOV CX, 10
;MOV AX, 0

;C1:
;INC AX
;LOOP C1
        
;=====================================================================================================================
;OPERACIONES

;SUMA
;EL COMANDO PARA LA SUMA ES ADD Y SUMA EL OPERANDO 1 CON EL OPERANDO 2   
;MOV AX, 0  ;SIEMPRE REINICIA AX Y BX POR SEGURIDAD (SI NO TIENES ALGO IMPORTANTE GUARDADO)
;MOV BX, 0     
;
;MOV AL, 5  ;AL = 5
;ADD AL, 3  ;AL = 8   
;
;MOV AL, 5  ;AL = 5  
;MOV BL, 3
;ADD AL, BL ;AL = 8 
;
;MOV AL, 5  ;AL = 5
;ADD AL, TAM_BYTE  ;AL = 25      

;RESTA
;EL COMANDO PARA LA RESTA ES SUB Y RESTA EL OPERANDO 1 CON EL OPERANDO 2   
;MOV AX, 0  ;SIEMPRE REINICIA AX Y BX POR SEGURIDAD (SI NO TIENES ALGO IMPORTANTE GUARDADO)
;MOV BX, 0     
;
;MOV AL, 5  ;AL = 5
;SUB AL, 3  ;AL = 2   
;
;MOV AL, 5  ;AL = 5  
;MOV BL, 3
;SUB AL, BL ;AL = 2 
;
;MOV AL, 5  ;AL = 5
;SUB AL, TAM_BYTE  ;AL = -15  

;MULTIPLICACION
;EL COMANDO PARA LA MULTIPLICACION SIN SIGNO ES MUL Y MULTIPLICA EL OPERANDO 1 CON AX   
;MOV AX, 0  ;SIEMPRE REINICIA AX Y BX POR SEGURIDAD (SI NO TIENES ALGO IMPORTANTE GUARDADO)
;MOV BX, 0       
;
;MOV AX, TAM_BYTE  ;AX = 20  
;MOV BX, 3
;MUL BX            ;AX = 60   

;MULTIPLICACION CON SIGNO
;EL COMANDO PARA LA MULTIPLICACION CON SIGNO ES IMUL Y MULTIPLICA EL OPERANDO 1 CON AX   
;MOV AX, 0  ;SIEMPRE REINICIA AX Y BX POR SEGURIDAD (SI NO TIENES ALGO IMPORTANTE GUARDADO)
;MOV BX, 0       
;
;MOV AX, TAM_BYTE  ;AX = 20  
;MOV BX, -3
;IMUL BX            ;AX = -60 

;DIVISION
;EL COMANDO PARA LA DIVISION SIN SIGNO ES DIV Y DIVIDE EL OPERANDO 1 CON AX, EL RESIDUO LO GUARDA EN DX   
;MOV AX, 0  ;SIEMPRE REINICIA AX Y BX POR SEGURIDAD (SI NO TIENES ALGO IMPORTANTE GUARDADO)
;MOV BX, 0       
;
;MOV AX, 23  ;AX = 23  
;MOV BX, 5
;DIV BX      ;AX = 4 / DX = 3   

;DIVISION CON SIGNO
;EL COMANDO PARA LA DIVISION CON SIGNO ES IDIV Y DIVIDE EL OPERANDO 1 CON AX, EL RESIDUO LO GUARDA EN DX   
;MOV AX, 0  ;SIEMPRE REINICIA AX Y BX POR SEGURIDAD (SI NO TIENES ALGO IMPORTANTE GUARDADO)
;MOV BX, 0       
;
;MOV AX, 23  ;AX = 23  
;MOV BX, -5
;IDIV BX     ;AX = -4 / DX = 3   

;=====================================================================================================================
;SALTOS  

;PARA MUCHOS DE LOS SALTOS SE USA EL COMANDO CMP PARA COMPARAR ANTES DE DAR EL SALTO 
;LOS SALTOS USAN ETIQUETAS PARA SABER A DONDE IR SI SON VERDADEROS

;SALTA SI ES IGUAL (JE o JZ)    
;MOV AX, 5    ;MOVEMOS EL 5 A AX
;CMP AX, 5    ;COMPARAMOS AX CON 5
;JE SALIR     ;SI ES IGUAL, SALTA
;
;SALTA SI NO ES IGUAL (JNE o JNZ)    
;MOV AX, 5    ;MOVEMOS EL 5 A AX
;CMP AX, 6    ;COMPARAMOS AX CON 6
;JNZ SALIR    ;SI NO ES IGUAL, SALTA  

;SALTA SI ES MAYOR SIN SIGNO (JA)     
;MOV AX, 5    ;MOVEMOS EL 5 A AX
;CMP AX, 4    ;COMPARAMOS AX CON 4
;JA  SALIR    ;SI ES MAYOR, SALTA  

;SALTA SI ES MAYOR O IGUAL SIN SIGNO (JAE)     
;MOV AX, 5    ;MOVEMOS EL 5 A AX
;CMP AX, 5    ;COMPARAMOS AX CON 5
;JAE SALIR    ;SI ES MAYOR, SALTA 

;SALTA SI ES MENOR SIN SIGNO (JB)     
;MOV AX, 4    ;MOVEMOS EL 4 A AX
;CMP AX, 5    ;COMPARAMOS AX CON 5
;JB  SALIR    ;SI ES MAYOR, SALTA      

;SALTA SI ES MENOR O IGUAL SIN SIGNO (JBE)     
;MOV AX, 5    ;MOVEMOS EL 5 A AX
;CMP AX, 5    ;COMPARAMOS AX CON 5
;JBE SALIR    ;SI ES MAYOR, SALTA  

;SALTA POR QUE SI(JMP)     
;JMP SALIR    ;SALTA A SALIR 
 
;SALIR:   

;=====================================================================================================================
;INCREMENTO Y DECREMENTO

;INC (INCREMENTA EN 1 UN VALOR)
;MOV AX, 255  ;AX = 255
;INC AX       ;AX = 256     

;DEC (DECREMENTA EN 1 UN VALOR)
;MOV AX, 255  ;AX = 255
;DEC AX       ;AX = 254

   
                          
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

CODIGO  ENDS 


        END    INICIO    

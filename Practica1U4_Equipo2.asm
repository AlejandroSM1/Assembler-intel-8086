TITLE   PLANTILLA
include 'emu8086.inc'
                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION


   msg1 db "la suma total es: $"
   msg2 db "ingresa un numero: $"
  
   salto db 13, 10, "$"
   n1 db 0
   n2 db 0
   n3 db 0
   n4 db 0
   n5 db 0
   r db 0
   r1 db 0
   r2 db 0
   r3 db 0
   r4 db 0

;************************************************************************************************************
;------------------------------------------------------------------------------------------------------------


        
DATOS   ENDS                    ;CADA SEGMENTO DEBE TERMINARSE CON LA SIGUIENTE SENTENCIA:
                                ;NOMBRE-SEG ENDS



PILA    SEGMENT 
    
        DW      64    DUP(0)    ;DW SIRVE PARA DEFINIR UNA VARIABLE O INICIAR UN AREA DE MEMORIA
                                ;(DEFINE WORD). CON DUP GENERAMOS 64 REPETICIONES DE 0                               ;STACK.
        
PILA    ENDS



CODIGO  SEGMENT
    
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS MACROS INTERNAS EN ESTA SECCION

;************************************************************************************************************
;------------------------------------------------------------------------------------------------------------    
     

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

    ;imprime msg2
    mov ah, 09h
    lea dx, msg2
    int 21h
    
    ;captura valor
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
    lea dx, msg2
    int 21h
    
    ;captura valor
    mov ah, 01h
    int 21h
    sub al, 30h
    mov n2, al
    
    ;despliega salto de linea
    mov ah, 09H
    lea dx, salto
    int 21h
    
    ;imprime msg2
    mov ah, 09h
    lea dx, msg2
    int 21h
    
    ;captura valor
    mov ah, 01h
    int 21h
    sub al, 30h
    mov n3, al
    
    ;despliega salto de linea
    mov ah, 09H
    lea dx, salto
    int 21h
    
    ;imprime msg2
    mov ah, 09h
    lea dx, msg2
    int 21h
    
    ;captura valor
    mov ah, 01h
    int 21h
    sub al, 30h
    mov n4, al
    
    ;despliega salto de linea
    mov ah, 09H
    lea dx, salto
    int 21h
    
    ;imprime msg2
    mov ah, 09h
    lea dx, msg2
    int 21h
    
    ;captura valor
    mov ah, 01h
    int 21h
    sub al, 30h
    mov n5, al
    
    ;despliega salto de linea
    mov ah, 09H
    lea dx, salto
    int 21h
    
    ;imprime msg1
    mov ah, 09h
    lea dx, msg1
    int 21h
    
    ; suma de las variables n1 y n2
    mov al, n1
    add al, n2
    mov r, al
    ; suma de la variables n3 y n4
    mov al, n3
    add al, n4
    mov r1, al
    ; suma de la variable n5 y r
    mov al, n5
    add al, r
    mov r2, al
    ; suma de la variable r1 y r2
    mov al, r1
    add al, r2
    mov r3, al
    
    ;imprime las unidades
    mov al, r3      ; mueve la varible r al registro al para dejarla libre
    aam             ; ajustar el contenido de la suma al codigo assci
    mov bx, ax
    mov ah, 02h
    mov dl, bh
    add dl, 30h
    int 21h
    
    ;imprimir la decenas
    mov ah, 02h
    mov dl, bl
    add dl, 30h
    int 21h
    
  
    
   
    
    mov ah, 4CH;solicitud de terminaci?n del programa
    int 21H; esta es una interrumpci?n que da salida a DOS
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
;COLOCAR LOS PROCEDIMIENTOS EN ESTA SECCION
    


;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;---------------------------------------------------------------------------------------------------------------- 

CODIGO  ENDS 


DEFINE_CLEAR_SCREEN
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
DEFINE_PTHIS

        END    INICIO    

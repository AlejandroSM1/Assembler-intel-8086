TITLE   PROGRAMASENOACOSENO
                    
include 'emu8086.inc'
                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
                 
                                  
          ARR0 DW 0,174,348,523,697,871,1045,1218,1391,1564
          ARR1 DW 1736,1908,2079,2249,2419,2588,2756,2923,3090,3255
          ARR2 DW 3420,3583,3746,3907,4067,4226,4383,4539,4694,4848
          ARR3 DW 5000,5150,5299,5446,5591,5735,5877,6018,6156,6293 
          ARR4 DW 6427,6560,6691,6819,6946,7071,7193,7313,7431,7547
          ARR5 DW 7660,7771,7880,7986,8090,8191,8290,8386,8480,8571
          ARR6 DW 8660,8746,8829,8910,8987,9063,9135,9205,9271,9335
          ARR7 DW 9396,9455,9510,9563,9612,9659,9702,9743,9781,9816
          ARR8 DW 9848,9876,9902,9925,9945,9961,9975,9986,9993,9998
          ARR9 DW 10000 
          
                              
          SEN DW 0

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
 
 START:
        
       MOV SEN,0
       CALL CLEAR_SCREEN
       CALL PTHIS
       DB 'PROGRAMA DE SENO a COSENO',0
       GOTOXY 0,3 
       CALL PTHIS
       DB 'ESCRIBE EL ANGULO:',0
       GOTOXY 20,3
       CALL SCAN_NUM
       MOV SEN,CX
       JMP COMP
       
COMP:        
        
        CMP SEN,1564
        JBE TRANS1
        CMP SEN,3255
        JBE TRANS2          
        CMP SEN,4848
        JBE TRANS3          
        CMP SEN,6293
        JBE TRANS4
        CMP SEN,7547
        JBE TRANS5
        CMP SEN,8571
        JBE TRANS6
        CMP SEN,9335
        JBE TRANS7
        CMP SEN,9816
        JBE TRANS8
        CMP SEN,9998
        JBE TRANS9
        CMP SEN,10000
        JMP INVALIDO  
        
TRANS1:
    lea SI, ARR0 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO1
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO2 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO3
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO4
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO5
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO6
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO7
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO8
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO9
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD
    jmp EXIT
    
        CAMBIO1:
            lea SI, ARR9 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO2:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO3:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO4:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO5:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO6:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO7:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO8:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO9:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT
           

TRANS2:
    lea SI, ARR1 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO12
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO22 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO32
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO42
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO52
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO62
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO72
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO82
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO92
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD2
    jmp EXIT
    
        CAMBIO12:
            lea SI, ARR8 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO22:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO32:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO42:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO52:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO62:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO72:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO82:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO92:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD2:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS3:
    lea SI, ARR2 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO13
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO23 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO33
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO43
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO53
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO63
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO73
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO83
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO93
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD3
    jmp EXIT
    
        CAMBIO13:
            lea SI, ARR7 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO23:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO33:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO43:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO53:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO63:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO73:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO83:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO93:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD3:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS4:
    lea SI, ARR3 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO14
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO24 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO34
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO44
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO54
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO64
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO74
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO84
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO94
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD2
    jmp EXIT
    
        CAMBIO14:
            lea SI, ARR6 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO24:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO34:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO44:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO54:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO64:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO74:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO84:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO94:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD4:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS5:
    lea SI, ARR4 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO15
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO25 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO35
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO45
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO55
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO65
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO75
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO85
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO95
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD5
    jmp EXIT
    
        CAMBIO15:
            lea SI, ARR5 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO25:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO35:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO45:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO55:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO65:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO75:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO85:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO95:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD5:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS6:
    lea SI, ARR5 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO16
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO26 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO36
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO46
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO56
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO66
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO76
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO86
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO96
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD6
    jmp EXIT
    
        CAMBIO16:
            lea SI, ARR4 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO26:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO36:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO46:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO56:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO66:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO76:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO86:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO96:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD6:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS7:
    lea SI, ARR6 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO17
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO27 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO37
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO47
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO57
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO67
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO77
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO87
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO97
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD7
    jmp EXIT
    
        CAMBIO17:
            lea SI, ARR3 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO27:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO37:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO47:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO57:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO67:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO77:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO87:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO97:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD7:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS8:
    lea SI, ARR7 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO18
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO28 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO38
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO48
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO58
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO68
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO78
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO88
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO98
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD2
    jmp EXIT
    
        CAMBIO18:
            lea SI, ARR2 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO28:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO38:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO48:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO58:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO68:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO78:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO88:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO98:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD8:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS9:
    lea SI, ARR8 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO19
    
    MOV AX, [SI+2]
    CMP SEN,AX
    JZ  CAMBIO29 
    
    MOV AX, [SI+4]
    CMP AX,SEN
    JZ  CAMBIO39
    
    MOV AX, [SI+6]
    CMP AX,SEN
    JZ  CAMBIO49
    
    MOV AX, [SI+8]
    CMP AX,SEN
    JZ  CAMBIO59
    
    MOV AX, [SI+10]
    CMP AX,SEN
    JZ  CAMBIO69
    
    MOV AX, [SI+12]
    CMP AX,SEN
    JZ  CAMBIO79
    
    MOV AX, [SI+14]
    CMP AX,SEN
    JZ  CAMBIO89
    
    MOV AX, [SI+16]
    CMP AX,SEN
    JZ  CAMBIO99
    
    MOV AX, [SI+18]
    CMP AX,SEN
    JZ  CAMBIOD9
    jmp EXIT
    
        CAMBIO19:
            lea SI, ARR1 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
        
        CAMBIO29:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+18]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO39:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+16]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO49:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+14]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO59:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+12]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO69:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+10]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO79:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+8]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO89:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+6]
            CALL PRINT_NUM_UNS
            jmp EXIT
        CAMBIO99:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+4]
            CALL PRINT_NUM_UNS
            jmp EXIT        
        CAMBIOD9:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES: ',0
            GOTOXY 0,3
            MOV AX,[SI+2]
            CALL PRINT_NUM_UNS
            jmp EXIT

TRANS10: 
    lea SI, ARR9 
    
    MOV AX, [SI]
    CMP SEN,AX
    JZ  CAMBIO10
        CAMBIO10:
            lea SI, ARR0 
            CALL CLEAR_SCREEN       
            CALL PTHIS
            DB 'EL COSENO ES:',0
            GOTOXY 0,3
            MOV AX,[SI]
            CALL PRINT_NUM_UNS
            jmp EXIT
            
INVALIDO:

          GOTOXY 0,14
          CALL PTHIS
          DB 'OPERACION INVALIDA',0
          JMP INICIO        

EXIT:
        GOTOXY 0,12
        CALL PTHIS
        DB 'REALIZAR OTRA OPERACION SI(1) NO(CUALQUIER OTRO NUMERO):',0
        CALL SCAN_NUM
        CMP CX,1
        JE START
    .EXIT
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

CODIGO  ENDS 
          
DEFINE_PTHIS
DEFINE_SCAN_NUM
DEFINE_CLEAR_SCREEN
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS 

        END    INICIO    

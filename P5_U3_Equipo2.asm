TITLE   Practica5_Unidad3_Equipo2
include emu8086.inc  
include MACROS.txt
                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                          
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION  
MSJ_USR DB 7 DUP (83) 

VALORES_SENO        DW 0, 175, 349, 523, 698, 872, 1045, 1219, 1392, 1564
                    DW 1736, 1908, 2079, 2250, 2419, 2588, 2756, 2924, 3090, 3256
                    DW 3420, 3584, 3746, 3907, 4067, 4226, 4384, 4540, 4695, 4848
                    DW 5000, 5150, 5299, 5446, 5592, 5736, 5878, 6018, 6157, 6293
                    DW 6428, 6561, 6691, 6820, 6947, 7071, 7193, 7314, 7431, 7547
                    DW 7660, 7771, 7880, 7986, 8090, 8192, 8290, 8387, 8480, 8572
                    DW 8660, 8746, 8829, 8910, 8988, 9063, 9135, 9205, 9272, 9336
                    DW 9397, 9455, 9511, 9563, 9613, 9659, 9703, 9744, 9781, 9816
                    DW 9848, 9877, 9903, 9925, 9945, 9962, 9976, 9986, 9994, 9998
                    DW 10000   
                
VALORES_TANGENTE    DW 0, 175, 349, 524, 699, 875, 1051, 1228, 1405, 1584
                    DW 1763, 1944, 2126, 2309, 2493, 2679, 2867, 3057, 3249, 3443
                    DW 3640, 3839, 4040, 4245, 4452, 4663, 4877, 5095, 5317, 5543
                    DW 5774, 6009, 6249, 6494, 6745, 7002, 7265, 7536, 7813, 8098
                    DW 8391, 8693, 9004, 9325, 9657, 10000, 355, 724, 1106, 1504
                    DW 1918, 2349, 2799, 3270, 3764, 4281, 4826, 5399, 6003, 6643
                    DW 7321, 8040, 8807, 9626, 503, 1445, 2460, 3559, 4751, 6051
                    DW 7475, 9042, 777, 2709, 4874, 7321, 108, 3315, 7046, 1446
                    DW 6713, 3138, 1154, 1443, 5144, 4301, 3007, 811, 6363, 2900
                    DW 0 

VALORES_SECANTE     DW 10000, 2, 6, 14, 24, 38, 55, 75, 98, 125
                    DW 154, 187, 223, 263, 306, 353, 403, 457, 515, 576
                    DW 642, 711, 785, 864, 946, 1034, 1126, 1223, 1326, 1434
                    DW 1547, 1666, 1792, 1924, 2062, 2208, 2361, 2521, 2690, 2868
                    DW 3054, 3250, 3456, 3673, 3902, 4142, 4396, 4663, 4945, 5243
                    DW 5557, 5890, 6243, 6616, 7013, 7434, 7883, 8361, 8871, 9416
                    DW 20000, 627, 1301, 2027, 2812, 3662, 4586, 5593, 6695, 7904
                    DW 9238, 716, 2361, 4203, 6280, 8637, 1336, 4454, 8097, 2408
                    DW 7588, 3925, 1853, 2055, 5668, 4737, 3356, 1073, 6537, 2987
                    DW 0                        
     
ANG_ORIGINAL DW 0 
ANG DW 0       

FUNCION DB 'NNN'  
SEN DB 'SEN'
COS DB 'COS'
TAN DB 'TAN'        
COT DB 'COT'     
SEC DB 'SEC'   
CSC DB 'CSC'    

;************************************************************************************************************
;------------------------------------------------------------------------------------------------------------


        
DATOS   ENDS                    ;CADA SEGMENTO DEBE TERMINARSE CON LA SIGUIENTE SENTENCIA:
                                ;NOMBRE-SEG ENDS

PILA    SEGMENT 
    
        DW      64    DUP(0)    ;DW SIRVE PARA DEFINIR UNA VARIABLE O INICIO UN AREA DE MEMORIA
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

COMIENZO:  
            CALL CLEAR_SCREEN   
            MOV DI, 0 
            MOV MSJ_USR[0], 83      
            MOV MSJ_USR[1], 83
            MOV MSJ_USR[2], 83
            MOV MSJ_USR[3], 83
            MOV MSJ_USR[4], 83
            MOV MSJ_USR[5], 83
            MOV MSJ_USR[6], 83
            MOV ANG_ORIGINAL, 0
            GOTOXY 1, 1
            PRINT 'INGRESA UNA FUNCION: '    
            GOTOXY 1, 2                               
            MOV DX, 8
            CALL GET_STRING    

;/////////////////////////////////////////////////////////////////////////////////////////////
;MACROS
;/////////////////////////////////////////////////////////////////////////////////////////////  

CE_1 MACRO ANG_ORIGINAL       
    MOV CX, ANG_ORIGINAL                   
    CMP CX, 90                              
    JE CE2_SENO                  
ENDM 

CE_3 MACRO ANG_ORIGINAL       
    MOV CX, ANG_ORIGINAL                
    CMP CX, 0                               
    JE CE2_COSENO                
ENDM  

CE_5 MACRO ANG_ORIGINAL       
    MOV CX, ANG_ORIGINAL                
    CMP CX, 90                               
    JE CE3_TANG                
ENDM    

CE_9 MACRO ANG_ORIGINAL      
    MOV CX, ANG_ORIGINAL
    CMP CX, 45                                   
    JAE CE2_TANG	                                             
ENDM  

CE_9 MACRO ANG_ORIGINAL       
    MOV CX, ANG_ORIGINAL                
    CMP CX, 0                               
    JE CE3_COTG                
ENDM    

CE_11 MACRO ANG_ORIGINAL        
    MOV CX, ANG_ORIGINAL
    CMP CX, 45                                   
    JBE CE2_COTG	                                             
ENDM      

CE_13 MACRO ANG_ORIGINAL       
    MOV CX, ANG_ORIGINAL   
    CMP CX, 90                                   
    JE  CE3_SEC	                                             
ENDM     

CE_15 MACRO ANG_ORIGINAL       
    MOV CX, ANG_ORIGINAL 
    CMP CX, 66                                   
    JAE CE_COSEC	                                             
ENDM

;/////////////////////////////////////////////////////////////////////////////////////////////
;OBTENER ANG
;/////////////////////////////////////////////////////////////////////////////////////////////     

ENCONTRAR_UNIDAD:  
            MOV DI, OFFSET MSJ_USR
            ADD DI, 6
            MOV BX, 0 
            MOV BL, MSJ_USR[DI]
            SUB BL, 48
            CMP BL, 10
            JB UNIDAD 
            DEC DI
            MOV BX, 0 
            MOV BL, MSJ_USR[DI]
            SUB BL, 48
            CMP BL, 10
            JB UNIDAD   
            DEC DI
            MOV BX, 0 
            MOV BL, MSJ_USR[DI]
            SUB BL, 48
            CMP BL, 10
            JB UNIDAD 
            JMP ENCONTRAR_DECENA

UNIDAD: 
            MOV AX, 0  
            MOV AL, MSJ_USR[DI]  
            SUB AL, 48 
            ADD ANG_ORIGINAL, AX  

ENCONTRAR_DECENA:
            DEC DI  
            MOV BX, 0 
            MOV BL, MSJ_USR[DI]
            SUB BL, 48
            CMP BL, 10
            JB DECENA 
            DEC SI
            MOV BX, 0 
            MOV BL, MSJ_USR[DI]
            SUB BL, 48
            CMP BL, 10
            JB DECENA
            JMP ENCONTRAR_CENTENA        

DECENA: 
            MOV AX, 0
            MOV BX, 0  
            MOV AL, MSJ_USR[DI]  
            SUB AL, 48
            MOV BL, 10
            MUL BL
            ADD ANG_ORIGINAL, AX  

ENCONTRAR_CENTENA:
            DEC DI  
            MOV BX, 0 
            MOV BL, MSJ_USR[DI]
            SUB BL, 48
            CMP BL, 10
            JB CENTENA 
            JMP COMPROBAR_ANGULO       

CENTENA: 
            MOV AX, 0
            MOV BX, 0  
            MOV AL, MSJ_USR[DI]  
            SUB AL, 48
            MOV BL, 100
            MUL BL
            ADD ANG_ORIGINAL, AX 
            JMP COMPROBAR_ANGULO  

COMPROBAR_ANGULO:   
            CMP ANG_ORIGINAL, 360
            JA  ANGULO_NO_VALIDO
            CMP ANG_ORIGINAL, 0 
            JB  ANGULO_NO_VALIDO
            JMP ENCONTRAR_FUNCION       

ANGULO_NO_VALIDO:
            CALL CLEAR_SCREEN
            PRINT 'ANG NO VALIDO' 
            CALL SCAN_NUM
            JMP REINICIAR 

;/////////////////////////////////////////////////////////////////////////////////////////////
;OBTENER FUNCION
;/////////////////////////////////////////////////////////////////////////////////////////////        

ENCONTRAR_FUNCION:
            MOV CX, 3 
            MOV DI, OFFSET FUNCION
            MOV SI, OFFSET MSJ_USR
            REP MOVSB 

            LEA SI, FUNCION    
            LEA DI, SEN    
            MOV CX, 3
            REPE CMPSB
            JZ SENO  

            LEA SI, FUNCION    
            LEA DI, COS    
            MOV CX, 3
            REPE CMPSB
            JZ COSENO    

            LEA SI, FUNCION    
            LEA DI, TAN    
            MOV CX, 3
            REPE CMPSB
            JZ TANGENTE          

            LEA SI, FUNCION    
            LEA DI, COT    
            MOV CX, 3
            REPE CMPSB
            JZ COTANGENTE           

            LEA SI, FUNCION    
            LEA DI, SEC    
            MOV CX, 3
            REPE CMPSB
            JZ SECANTE         

            LEA SI, FUNCION    
            LEA DI, CSC    
            MOV CX, 3
            REPE CMPSB                
            JZ COSECANTE     
        
            CALL CLEAR_SCREEN
            PRINT 'FUNCION NO VALIDA' 
            CALL SCAN_NUM
            JMP REINICIAR

;/////////////////////////////////////////////////////////////////////////////////////////////
;OBTENER SENO
;/////////////////////////////////////////////////////////////////////////////////////////////        

SENO:
            MOV CX, ANG_ORIGINAL                 
            CMP CX, 90                              
            JBE CUADRANTE1_SENO                                  
            CMP CX, 180                                                                          
            JBE CUADRANTE2_SENO                                                                                                                                    
            CMP CX, 270                                                                      
            JBE CUADRANTE3_SENO                    
            CMP CX, 360                                                                        
            JBE CUADRANTE4_SENO                     

CASO_ESPECIAL_SENO:        
            PRINT '0'
            MOV CX, ANG_ORIGINAL               
            CMP CX, 90                              
            JBE IMPRIMIR_VALOR1                              
            CMP CX, 180                                                                           
            JBE IMPRIMIR_VALOR2                                                                                                                                
            CMP CX, 270                                                                      
            JBE IMPRIMIR_VALOR3                     
            CMP CX, 360                                                                 
            JBE IMPRIMIR_VALOR4                       

CE2_SENO:      
            MOV CX, ANG_ORIGINAL              
            CMP CX, 180                       
            JBE IMPRIMIR1                   
            PRINT ' = -1'
            CALL SCAN_NUM
            JMP REINICIAR

IMPRIMIR1:   
            PRINT ' = 1'
            CALL SCAN_NUM      
            JMP REINICIAR 

CUADRANTE1_SENO:                       
            GOTOXY 1, 3                             
            PRINT 'SENO '                      
            MOV AX, ANG_ORIGINAL                                              
            CALL PRINT_NUM                            
            CE_1 ANG_ORIGINAL
            PRINT ' = 0.'   
            CE_2 ANG_ORIGINAL   

IMPRIMIR_VALOR1:                         
            MOV DI, ANG_ORIGINAL                                                          
            ADD DI, ANG_ORIGINAL                                                        
            MOV AX, VALORES_SENO[DI]                   
            CALL PRINT_NUM   
            CALL SCAN_NUM                                           
            JMP REINICIAR                             

CUADRANTE2_SENO:                                                                                                                                                                                                                                                                                                                                       
            GOTOXY 1, 3                                                                                                          
            PRINT 'SENO '                                                                                                                              
            MOV AX, ANG_ORIGINAL                                                                                                                    
            CALL PRINT_NUM                                                                                                                                                          
            MOV CX, 180                                                                              
            SUB CX, ANG_ORIGINAL                                              
            MOV ANG, CX                                                                        
            CE_1 ANG
            PRINT ' = 0.'   
            CE_2 ANG  
IMPRIMIR_VALOR2:  
            MOV DI, ANG                                        
            ADD DI, ANG                                                                  
            MOV AX, VALORES_SENO[DI]               
            CALL PRINT_NUM                       
            CALL SCAN_NUM                                               
            JMP REINICIAR                              

CUADRANTE3_SENO:                                                                                                                                                                                                                                                                                                                                                                                                                                            
            GOTOXY 1, 3                                                                                                    
            PRINT 'SENO '                                                                                                                              
            MOV AX, ANG_ORIGINAL                                                                                                               
            CALL PRINT_NUM                                                                             
            MOV  CX, ANG_ORIGINAL                                                           
            SUB  CX, 180                                                         
            MOV ANG, CX                               
            CE_1 ANG
            PRINT ' = -0.'   
            CE_2 ANG
IMPRIMIR_VALOR3:                                       
            MOV DI, ANG                                                                  
            ADD DI, ANG                                                             
            MOV AX, VALORES_SENO[DI]                                                        
            CALL PRINT_NUM                           
            CALL SCAN_NUM                                                
            JMP REINICIAR                             

CUADRANTE4_SENO:                                                                                                                                                                                                            
            GOTOXY 1, 3                                                                                                        
            PRINT 'SENO '                                                                                                                               
            MOV AX, ANG_ORIGINAL                                                                                                                   
            CALL PRINT_NUM                                                                             
            MOV CX, 360                                                                                   
            SUB CX, ANG_ORIGINAL                                                      
            MOV ANG, CX                                                                                
            CE_1 ANG
            PRINT ' = -0.'   
            CE_2 ANG
IMPRIMIR_VALOR4:
            MOV DI, ANG                                                                         
            ADD DI, ANG                                                                 
            MOV AX, VALORES_SENO[DI]                                                                                                         
            CALL PRINT_NUM                           
            CALL SCAN_NUM                                                   
            JMP REINICIAR                           

;/////////////////////////////////////////////////////////////////////////////////////////////
;OBTENER COSENO
;/////////////////////////////////////////////////////////////////////////////////////////////             
     
COSENO:     
            MOV CX, ANG_ORIGINAL                      
            CMP CX, 90                              
            JBE CUADRANTE1_COSENO                          
            CMP CX, 180                                                                              
            JBE CUADRANTE2_COSENO                                                                                                                          
            CMP CX, 270                                                                            
            JBE CUADRANTE3_COSENO                     
            CMP CX, 360                                                                       
            JBE CUADRANTE4_COSENO                        

CASO_ESPECIAL_COSENO:        
            PRINT '0'
            MOV CX, ANG_ORIGINAL                 
            CMP CX, 90                              
            JBE IMPRIMIR_VALOR5                                  
            CMP CX, 180                                                                         
            JBE IMPRIMIR_VALOR6                                                                                                                                   
            CMP CX, 270                                                                         
            JBE IMPRIMIR_VALOR7                       
            CMP CX, 360                                                                          
            JBE IMPRIMIR_VALOR8                       

CE2_COSENO:      
            MOV CX, ANG_ORIGINAL                 
            CMP CX, 0                               
            JE  IMPRIMIR2                         
            CMP CX, 360                             
            JE  IMPRIMIR2                           
            PRINT ' = -1'
            CALL SCAN_NUM
            JMP REINICIAR

IMPRIMIR2:   
            PRINT ' = 1'
            CALL SCAN_NUM      
            JMP REINICIAR  

CUADRANTE1_COSENO:
            GOTOXY 1, 3                              
            PRINT 'COSENO '                                                    
            MOV AX, ANG_ORIGINAL                                              
            CALL PRINT_NUM                                                   
            CE_3 ANG_ORIGINAL
            PRINT ' = 0.'   
            CE_4 ANG_ORIGINAL
IMPRIMIR_VALOR5:                                          
            MOV DI, 90                                                                               
            SUB DI, ANG_ORIGINAL                                                        
            ADD DI, DI                                                                               
            MOV AX, VALORES_SENO[DI]                                                                         
            CALL PRINT_NUM                                                    
            CALL SCAN_NUM                            
            JMP REINICIAR                            

CUADRANTE2_COSENO:                                       
            GOTOXY 1, 3                              
            PRINT 'COSENO '                                                     
            MOV AX, ANG_ORIGINAL                                              
            CALL PRINT_NUM                                                                                          
            MOV CX, 180                                                                                    
            SUB CX, ANG_ORIGINAL                                                        
            MOV ANG, CX                           
            CE_3 ANG
            PRINT ' = -0.'   
            CE_4 ANG  
IMPRIMIR_VALOR6:                                                    
            MOV DI, 90                                                                                 
            SUB DI, ANG                                              
            ADD DI, DI                                                  
            MOV AX, VALORES_SENO[DI]                 
            CALL PRINT_NUM                              
            CALL SCAN_NUM                               
            JMP REINICIAR                              

CUADRANTE3_COSENO:    
            GOTOXY 1, 3                             
            PRINT 'COSENO '                                                  
            MOV AX, ANG_ORIGINAL                                        
            CALL PRINT_NUM                                                                                                      
            MOV CX, ANG_ORIGINAL                                                           
            SUB CX, 180                                                          
            MOV ANG, CX 
            CE_3 ANG
            PRINT ' = -0.'   
            CE_4 ANG
IMPRIMIR_VALOR7:                                                           
            MOV DI, 90                                                                  
            SUB DI, ANG                                                                          
            ADD DI, DI                                                                     
            MOV AX, VALORES_SENO[DI]                                                                       
            CALL PRINT_NUM                                          
            CALL SCAN_NUM                                         
            JMP REINICIAR                         


CUADRANTE4_COSENO:     
            GOTOXY 1, 3                              
            PRINT 'COSENO '                                          
            MOV AX, ANG_ORIGINAL                                      
            CALL PRINT_NUM                                                                                                    
            MOV CX, 360                                                                                
            SUB CX, ANG_ORIGINAL                                                      
            MOV ANG, CX 
            CE_3 ANG
            PRINT ' = 0.'   
            CE_4 ANG    
IMPRIMIR_VALOR8:                                                       
            MOV DI, 90                                                                    
            SUB DI, ANG                                                                    
            ADD DI, DI                                                                
            MOV AX, VALORES_SENO[DI]                                                                     
            CALL PRINT_NUM                                          
            CALL SCAN_NUM                                            
            JMP REINICIAR 

;////////////////////////////////////// YA ME CANSE DE TABULAR :C ////////////////////////////////////////
;---- OBTENER TANGENTE----
;///// AYUDA ME TIENEN COMO ESCLAVO PROGRAMANDO EN ENSAMBLADOR 16 BITS Y SOLO ME DAN DE COMER CHEETOS :C /////////          

TANGENTE:     
MOV CX, ANG_ORIGINAL                      
CMP CX, 90                              
JBE CUADRANTE1_TANGENTE                          
CMP CX, 180                                                                              
JBE CUADRANTE2_TANGENTE                                                                                                                         
CMP CX, 270                                                                            
JBE CUADRANTE3_TANGENTE                     
CMP CX, 360                                                                       
JBE CUADRANTE4_TANGENTE                        

CASO_ESPECIAL_TANGENTE:        
PRINT '0'
MOV CX, ANG_ORIGINAL                  
CMP CX, 90                              
JBE IMPRIMIR_VALOR9                                   
CMP CX, 180                                                                         
JBE IMPRIMIR_VALOR10                                                                                                                                   
CMP CX, 270                                                                         
JBE IMPRIMIR_VALOR11                       
CMP CX, 360                                                                          
JBE IMPRIMIR_VALOR12  

CE2_TANG: 
MOV CX, ANG_ORIGINAL                 
CMP CX, 90                              
JBE POSITIVO1                                  
CMP CX, 180                                                                         
JBE NEGATIVO1                                                                                                                                   
CMP CX, 270                                                                         
JBE POSITIVO1                     
  
CMP CX, 360                                                                          
JBE NEGATIVO1  

POSITIVO1:
PRINT ' = '
JMP VALORES_TAN 

NEGATIVO1:
PRINT ' = -'   
JMP VALORES_TAN       

VALORES_TAN:       
MOV CX, ANG                
   
CMP CX, 45                              
JE  VALOR_TAN_1  
CMP CX, 47                              
JBE  VALOR_TAN_2  
CMP CX, 63                              
JBE  VALOR_TAN_3   
CMP CX, 64                              
JE   VALOR_TAN_4    
CMP CX, 71                              
JBE  VALOR_TAN_5  
CMP CX, 72                              
JE   VALOR_TAN_6    
CMP CX, 75                              
JBE  VALOR_TAN_7        
CMP CX, 76                              
JE   VALOR_TAN_8   
CMP CX, 78                              
JBE  VALOR_TAN_9   
CMP CX, 80                              
JBE  VALOR_TAN_10  
CMP CX, 81                              
JE   VALOR_TAN_11    
CMP CX, 82                              
JE   VALOR_TAN_12
CMP CX, 83                              
JE   VALOR_TAN_13
CMP CX, 84                              
JE   VALOR_TAN_14    
CMP CX, 85                              
JE   VALOR_TAN_15  
CMP CX, 86                              
JE   VALOR_TAN_16 
CMP CX, 87                              
JE   VALOR_TAN_17    
CMP CX, 88                              
JE   VALOR_TAN_18   
CMP CX, 89                              
JE   VALOR_TAN_19

VALOR_TAN_1:   
PRINT '1'
CALL SCAN_NUM      
JMP REINICIAR

VALOR_TAN_2:
PRINT '1.0'
JMP VOLVER1   

VALOR_TAN_3:
PRINT '1.'
JMP VOLVER1   

VALOR_TAN_4:
PRINT '2.0'
JMP VOLVER1  

VALOR_TAN_5:
PRINT '2.'
JMP VOLVER1   

VALOR_TAN_6:
PRINT '3.0'
JMP VOLVER1     

VALOR_TAN_7:
PRINT '3.'
JMP VOLVER1    

VALOR_TAN_8:
PRINT '4.0'
JMP VOLVER1     

VALOR_TAN_9:
PRINT '4.'
JMP VOLVER1   

VALOR_TAN_10:
PRINT '5.'
JMP VOLVER1       

VALOR_TAN_11:
PRINT '6.'
JMP VOLVER1

VALOR_TAN_12:
PRINT '7.'
JMP VOLVER1  

VALOR_TAN_13:
PRINT '8.'
JMP VOLVER1   

VALOR_TAN_14:
PRINT '9.'
JMP VOLVER1     

VALOR_TAN_15:
PRINT '11.'
JMP VOLVER1   

VALOR_TAN_16:
PRINT '14.'
JMP VOLVER1    

VALOR_TAN_17:
PRINT '19.'
JMP VOLVER1      

VALOR_TAN_18:
PRINT '28.'
JMP VOLVER1     

VALOR_TAN_19:
PRINT '57.'
JMP VOLVER1 

VOLVER1:
MOV CX, ANG_ORIGINAL                  
CMP CX, 90                              
JBE IMPRIMIR_VALOR9                                  
CMP CX, 180                                                                         
JBE IMPRIMIR_VALOR10                                                                                                                                    
CMP CX, 270                                                                         
JBE IMPRIMIR_VALOR11                     
CMP CX, 360                                                                          
JBE IMPRIMIR_VALOR12   

CE3_TANG:                                
PRINT ' = INFINITO'
CALL SCAN_NUM
JMP REINICIAR 

CUADRANTE1_TANGENTE:
GOTOXY 1, 3                              
PRINT 'TANGENTE '                                                    
MOV AX, ANG_ORIGINAL                                              
CALL PRINT_NUM
MOV ANG, AX                                                   
CE_5 ANG 
CE_9 ANG
PRINT ' = 0.'   
CE_6 ANG
IMPRIMIR_VALOR9:                                          
MOV DI, ANG_ORIGINAL                                                          
ADD DI, ANG_ORIGINAL                                                                              
MOV AX, VALORES_TANGENTE[DI]                                                                         
CALL PRINT_NUM                                                    
CALL SCAN_NUM                            
JMP REINICIAR     

CUADRANTE2_TANGENTE: 
GOTOXY 1, 3                                                                                                          
PRINT 'TANGENTE '                                                                                                                              
MOV AX, ANG_ORIGINAL                                                                                                                    
CALL PRINT_NUM                                                                                                                                                          
MOV CX, 180                                                                              
SUB CX, ANG_ORIGINAL                                              
MOV ANG, CX                                                                        
CE_5 ANG 
CE_9 ANG
PRINT ' = -0.'   
CE_6 ANG  
IMPRIMIR_VALOR10:  
MOV DI, ANG                                        
ADD DI, ANG                                                                  
MOV AX, VALORES_TANGENTE[DI]               
CALL PRINT_NUM                       
CALL SCAN_NUM                                               
JMP REINICIAR  

CUADRANTE3_TANGENTE:  
GOTOXY 1, 3                                                                                                    
PRINT 'TANGENTE '                                                                                                                              
MOV AX, ANG_ORIGINAL                                                                                                               
CALL PRINT_NUM                                                                             
MOV  CX, ANG_ORIGINAL                                                           
SUB  CX, 180                                                         
MOV ANG, CX                               
CE_5 ANG 
CE_9 ANG
PRINT ' = 0.'   
CE_6 ANG 
IMPRIMIR_VALOR11:                                   
MOV DI, ANG                                                                  
ADD DI, ANG                                                             
MOV AX, VALORES_TANGENTE[DI]                                                        
CALL PRINT_NUM                           
CALL SCAN_NUM                                                
JMP REINICIAR 

CUADRANTE4_TANGENTE:
GOTOXY 1, 3                                                                                                        
PRINT 'TANGENTE '                                                                                                                               
MOV AX, ANG_ORIGINAL                                                                                                                   
CALL PRINT_NUM                                                                             
MOV CX, 360                                                                                   
SUB CX, ANG_ORIGINAL                                                      
MOV ANG, CX                                                                                
CE_5 ANG 
CE_9 ANG
PRINT ' = -0.'   
CE_6 ANG 
IMPRIMIR_VALOR12: 
MOV DI, ANG                                                                         
ADD DI, ANG                                                                 
MOV AX, VALORES_TANGENTE[DI]                                                                                                         
CALL PRINT_NUM                           
CALL SCAN_NUM                                                   
JMP REINICIAR

;/////////////////////////////////////////////////////////////////////////////////////////////
;OBTENER COTANGENTE
;/////////////////////////////////////////////////////////////////////////////////////////////             

COTANGENTE:     
MOV CX, ANG_ORIGINAL                      
CMP CX, 90                              
JBE CUADRANTE1_COTANGENTE                          
CMP CX, 180                                                                              
JBE CUADRANTE2_COTANGENTE                                                                                                                           
CMP CX, 270                                                                            
JBE CUADRANTE3_COTANGENTE                      
CMP CX, 360                                                                       
JBE CUADRANTE4_COTANGENTE                        

CASO_ESPECIAL_COTANGENTE:        
PRINT '0'
MOV CX, ANG_ORIGINAL                   
CMP CX, 90                              
JBE IMPRIMIR_VALOR13                                   
CMP CX, 180                                                                         
JBE IMPRIMIR_VALOR14                                                                                                                                   
CMP CX, 270                                                                         
JBE IMPRIMIR_VALOR15                       
CMP CX, 360                                                                          
JBE IMPRIMIR_VALOR16  

CE2_COTG: 
MOV CX, ANG_ORIGINAL                  
CMP CX, 90                              
JBE POSITIVO2                                   
CMP CX, 180                                                                         
JBE NEGATIVO2                                                                                                                                  
CMP CX, 270                                                                        
JBE POSITIVO2                     
CMP CX, 360                                                                          
JBE NEGATIVO2  

POSITIVO2:
PRINT ' = '
JMP VALORES_COT 
NEGATIVO2:
PRINT ' = -'   
JMP VALORES_COT       
VALORES_COT:       
MOV CX, ANG                

CMP CX, 1                              
JE   VALOR_COT_19
CMP CX, 2                              
JE   VALOR_COT_18
CMP CX, 3                              
JE   VALOR_COT_17
CMP CX, 4                              
JE   VALOR_COT_16 
CMP CX, 5                              
JE   VALOR_COT_15
CMP CX, 6                              
JE   VALOR_COT_14
CMP CX, 7                              
JE   VALOR_COT_13
CMP CX, 8                              
JE   VALOR_COT_12
CMP CX, 9                              
JE   VALOR_COT_11 
CMP CX, 11                              
JBE  VALOR_COT_10
CMP CX, 13                              
JBE  VALOR_COT_9 
CMP CX, 14                              
JE   VALOR_COT_8
CMP CX, 17                              
JBE  VALOR_COT_7
CMP CX, 18                              
JE   VALOR_COT_6
CMP CX, 25                              
JBE  VALOR_COT_5 
CMP CX, 26                              
JE   VALOR_COT_4  
CMP CX, 42                              
JBE  VALOR_COT_3    
CMP CX, 44                              
JBE  VALOR_COT_2 
CMP CX, 45                              
JE  VALOR_COT_1                     

VALOR_COT_1:   
PRINT '1'
CALL SCAN_NUM      
JMP REINICIAR

VALOR_COT_2:
PRINT '1.0'
JMP VOLVER2   

VALOR_COT_3:
PRINT '1.'
JMP VOLVER2   

VALOR_COT_4:
PRINT '2.0'
JMP VOLVER2  

VALOR_COT_5:
PRINT '2.'
JMP VOLVER2   

VALOR_COT_6:
PRINT '3.0'
JMP VOLVER2     

VALOR_COT_7:
PRINT '3.'
JMP VOLVER2    

VALOR_COT_8:
PRINT '4.0'
JMP VOLVER2     

VALOR_COT_9:
PRINT '4.'
JMP VOLVER2   

VALOR_COT_10:
PRINT '5.'
JMP VOLVER2       

VALOR_COT_11:
PRINT '6.'
JMP VOLVER2

VALOR_COT_12:
PRINT '7.'
JMP VOLVER2  

VALOR_COT_13:
PRINT '8.'
JMP VOLVER2   

VALOR_COT_14:
PRINT '9.'
JMP VOLVER2     

VALOR_COT_15:
PRINT '11.'
JMP VOLVER2   

VALOR_COT_16:
PRINT '14.'
JMP VOLVER2    

VALOR_COT_17:
PRINT '19.'
JMP VOLVER2      

VALOR_COT_18:
PRINT '28.'
JMP VOLVER2     

VALOR_COT_19:
PRINT '57.'
JMP VOLVER2 

VOLVER2:
MOV CX, ANG_ORIGINAL                
   
CMP CX, 90                              
JBE IMPRIMIR_VALOR13                     
              
CMP CX, 180                                                                         
JBE IMPRIMIR_VALOR14                     
                                                                                                               
CMP CX, 270                                                                         
JBE IMPRIMIR_VALOR15                     
  
CMP CX, 360                                                                          
JBE IMPRIMIR_VALOR16   


CE3_COTG:                                
PRINT ' = INFINITO'
CALL SCAN_NUM
JMP REINICIAR                

CUADRANTE1_COTANGENTE:
GOTOXY 1, 3                              
PRINT 'COTANGENTE '                                                    
MOV AX, ANG_ORIGINAL                                              
CALL PRINT_NUM     
MOV ANG, AX                                              
CE_9 ANG 
CE_11 ANG
PRINT ' = 0.'   
CE_8 ANG
IMPRIMIR_VALOR13:                                          
MOV DI, 90                                                                               
SUB DI, ANG_ORIGINAL                                                        
ADD DI, DI                                                                               
MOV AX, VALORES_TANGENTE[DI]                                                                         
CALL PRINT_NUM                                                    
CALL SCAN_NUM                            
JMP REINICIAR                            


CUADRANTE2_COTANGENTE:                                       
GOTOXY 1, 3                              
PRINT 'COTANGENTE '                                                     
MOV AX, ANG_ORIGINAL                                              
CALL PRINT_NUM                                                                                          
MOV CX, 180                                                                                    
SUB CX, ANG_ORIGINAL                                                        
MOV ANG, CX                           
CE_9 ANG 
CE_11 ANG
PRINT ' = -0.'   
CE_8 ANG 
IMPRIMIR_VALOR14:                                                    
MOV DI, 90                                                                                 
SUB DI, ANG                                              
ADD DI, DI                                                  
MOV AX, VALORES_TANGENTE[DI]                 
CALL PRINT_NUM                              
CALL SCAN_NUM                               
JMP REINICIAR                              

CUADRANTE3_COTANGENTE:    
GOTOXY 1, 3                             
PRINT 'COTANGENTE '                                                  
MOV AX, ANG_ORIGINAL                                        
CALL PRINT_NUM                                                                                                      
MOV CX, ANG_ORIGINAL                                                           
SUB CX, 180                                                          
MOV ANG, CX 
CE_9 ANG 
CE_11 ANG
PRINT ' = 0.'   
CE_8 ANG 
IMPRIMIR_VALOR15:                                                           
MOV DI, 90                                                                  
SUB DI, ANG                                                                          
ADD DI, DI                                                                     
MOV AX, VALORES_TANGENTE[DI]                                                                       
CALL PRINT_NUM                                          
CALL SCAN_NUM                                         
JMP REINICIAR                         


CUADRANTE4_COTANGENTE:     
GOTOXY 1, 3                              
PRINT 'COTANGENTE '                                          
MOV AX, ANG_ORIGINAL                                      
CALL PRINT_NUM                                                                                                    
MOV CX, 360                                                                                
SUB CX, ANG_ORIGINAL                                                      
MOV ANG, CX 
CE_9 ANG 
CE_11 ANG
PRINT ' = -0.'   
CE_8 ANG     
IMPRIMIR_VALOR16:                                                       
MOV DI, 90                                                                    
SUB DI, ANG                                                                    
ADD DI, DI                                                                
MOV AX, VALORES_TANGENTE[DI]                                                                     
CALL PRINT_NUM                                          
CALL SCAN_NUM                                            
JMP REINICIAR 
 
;/////////////////////////////////////////////////////////////////////////////////////////////
;OBTENER SECANTE
;/////////////////////////////////////////////////////////////////////////////////////////////             

SECANTE:     
MOV CX, ANG_ORIGINAL                      
CMP CX, 90                              
JBE CUADRANTE1_SECANTE                         
CMP CX, 180                                                                              
JBE CUADRANTE2_SECANTE                                                                                                                          
CMP CX, 270                                                                            
JBE CUADRANTE3_SECANTE                     
CMP CX, 360                                                                       
JBE CUADRANTE4_SECANTE                        

CASO_ESPECIAL_SECANTE: 
MOV CX, ANG_ORIGINAL                  
CMP CX, 90                              
JBE POSITIVO3                                  
CMP CX, 180                                                                         
JBE NEGATIVO3                                                                                                                                   
CMP CX, 270                                                                         
JBE NEGATIVO3                       
CMP CX, 360                                                                          
JBE POSITIVO3    

POSITIVO3:
PRINT ' = '
JMP VALORES_SEC 

NEGATIVO3:
PRINT ' = -'   
JMP VALORES_SEC    

VALORES_SEC:
MOV CX, ANG
CMP CX, 0                              
JE   VALOR_SEC  
CMP CX, 2                              
JBE  VALOR_SEC_0    
CMP CX, 8                              
JBE  VALOR_SEC_1 
CMP CX, 24                              
JBE  VALOR_SEC_2 

VALOR_SEC:   
PRINT '1'
CALL SCAN_NUM      
JMP REINICIAR

VALOR_SEC_0:
PRINT '1.000'
JMP VOLVER3       

VALOR_SEC_1:
PRINT '1.00'
JMP VOLVER3 

VALOR_SEC_2:
PRINT '1.0'
JMP VOLVER3

CASO_ESPECIAL_SECANTE2: 
MOV CX, ANG_ORIGINAL                  
CMP CX, 90                              
JBE POSITIVO4                                  
CMP CX, 180                                                                         
JBE NEGATIVO4                                                                                                                                   
CMP CX, 270                                                                         
JBE NEGATIVO4                      
CMP CX, 360                                                                          
JBE POSITIVO4  

POSITIVO4:
PRINT ' = '
JMP VALORES_SEC_1 

NEGATIVO4:
PRINT ' = -'   
JMP VALORES_SEC_1       

VALORES_SEC_1:       
MOV CX, ANG                  
CMP CX, 60                              
JE   VALOR_SEC_3    
CMP CX, 61                              
JE   VALOR_SEC_4  
CMP CX, 70                              
JBE  VALOR_SEC_5    
CMP CX, 71                              
JE   VALOR_SEC_6        
CMP CX, 75                              
JBE  VALOR_SEC_7   
CMP CX, 78                              
JBE  VALOR_SEC_8   
CMP CX, 80                              
JBE  VALOR_SEC_9  
CMP CX, 81                              
JE   VALOR_SEC_10    
CMP CX, 82                              
JE   VALOR_SEC_11
CMP CX, 83                              
JE   VALOR_SEC_12
CMP CX, 84                              
JE   VALOR_SEC_13    
CMP CX, 85                              
JE   VALOR_SEC_14  
CMP CX, 86                              
JE   VALOR_SEC_15 
CMP CX, 87                              
JE   VALOR_SEC_16    
CMP CX, 88                              
JE   VALOR_SEC_17   
CMP CX, 89                              
JE   VALOR_SEC_18  

VALOR_SEC_3:
PRINT '2'
JMP REINICIAR   

VALOR_SEC_4:
PRINT '2.0'
JMP VOLVER3  

VALOR_SEC_5:
PRINT '2.'
JMP VOLVER3   

VALOR_SEC_6:
PRINT '3.0'
JMP VOLVER3     

VALOR_SEC_7:
PRINT '3.'
JMP VOLVER3         

VALOR_SEC_8:
PRINT '4.'
JMP VOLVER3   

VALOR_SEC_9:
PRINT '5.'
JMP VOLVER3       

VALOR_SEC_10:
PRINT '6.'
JMP VOLVER3

VALOR_SEC_11:
PRINT '7.'
JMP VOLVER3  

VALOR_SEC_12:
PRINT '8.'
JMP VOLVER3   

VALOR_SEC_13:
PRINT '9.'
JMP VOLVER3     

VALOR_SEC_14:
PRINT '11.'
JMP VOLVER3   

VALOR_SEC_15:
PRINT '14.'
JMP VOLVER3    

VALOR_SEC_16:
PRINT '19.'
JMP VOLVER3      

VALOR_SEC_17:
PRINT '28.'
JMP VOLVER3     

VALOR_SEC_18:
PRINT '57.'
JMP VOLVER3 

VOLVER3:
MOV CX, ANG_ORIGINAL                   
CMP CX, 90                              
JBE IMPRIMIR_VALOR17                                  
CMP CX, 180                                                                         
JBE IMPRIMIR_VALOR18                                                                                                                                  
CMP CX, 270                                                                         
JBE IMPRIMIR_VALOR19                      
CMP CX, 360                                                                          
JBE IMPRIMIR_VALOR20  

CE3_SEC:                                
PRINT ' = INFINITO'
CALL SCAN_NUM
JMP REINICIAR 

CUADRANTE1_SECANTE:
GOTOXY 1, 3                              
PRINT 'SECANTE '                                                    
MOV AX, ANG_ORIGINAL                                              
CALL PRINT_NUM
MOV ANG, AX                                                   
CE_10 ANG  
CE_13 ANG
CE_12 ANG
PRINT ' = 1.'   
IMPRIMIR_VALOR17:                                          
MOV DI, ANG_ORIGINAL                                                          
ADD DI, ANG_ORIGINAL                                                                              
MOV AX, VALORES_SECANTE[DI]                                                                         
CALL PRINT_NUM                                                    
CALL SCAN_NUM                            
JMP REINICIAR     

CUADRANTE2_SECANTE: 
GOTOXY 1, 3                                                                                                          
PRINT 'SECANTE '                                                                                                                              
MOV AX, ANG_ORIGINAL                                                                                                                    
CALL PRINT_NUM                                                                                                                                                          
MOV CX, 180                                                                              
SUB CX, ANG_ORIGINAL                                              
MOV ANG, CX                                                                        
CE_10 ANG  
CE_13 ANG
CE_12 ANG
PRINT ' = -1.'    
IMPRIMIR_VALOR18:  
MOV DI, ANG                                        
ADD DI, ANG                                                                  
MOV AX, VALORES_SECANTE[DI]               
CALL PRINT_NUM                       
CALL SCAN_NUM                                               
JMP REINICIAR  

CUADRANTE3_SECANTE:  
GOTOXY 1, 3                                                                                                    
PRINT 'SECANTE '                                                                                                                              
MOV AX, ANG_ORIGINAL                                                                                                               
CALL PRINT_NUM                                                                             
MOV  CX, ANG_ORIGINAL                                                           
SUB  CX, 180                                                         
MOV ANG, CX                               
CE_10 ANG  
CE_13 ANG
CE_12 ANG
PRINT ' = -1.'   
IMPRIMIR_VALOR19:                                   
MOV DI, ANG                                                                  
ADD DI, ANG                                                             
MOV AX, VALORES_SECANTE[DI]                                                        
CALL PRINT_NUM                           
CALL SCAN_NUM                                                
JMP REINICIAR 

CUADRANTE4_SECANTE:
GOTOXY 1, 3                                                                                                        
PRINT 'SECANTE '                                                                                                                               
MOV AX, ANG_ORIGINAL                                                                                                                   
CALL PRINT_NUM                                                                             
MOV CX, 360                                                                                   
SUB CX, ANG_ORIGINAL                                                      
MOV ANG, CX                                                                                
CE_10 ANG  
CE_13 ANG
CE_12 ANG
PRINT ' = 1.'    
IMPRIMIR_VALOR20: 
MOV DI, ANG                                                                         
ADD DI, ANG                                                                 
MOV AX, VALORES_SECANTE[DI]                                                                                                         
CALL PRINT_NUM                           
CALL SCAN_NUM                                                   
JMP REINICIAR

;/////////////////////////////////////////////////////////////////////////////////////////////
;OBTENER COSECANTE
;/////////////////////////////////////////////////////////////////////////////////////////////                                   
COSECANTE:

MOV CX, ANG_ORIGINAL                      
CMP CX, 90                              
JBE CUADRANTE1_COSECANTE                         
CMP CX, 180                                                                              
JBE CUADRANTE2_COSECANTE                                                                                                                         
CMP CX, 270                                                                            
JBE CUADRANTE3_COSECANTE                     
CMP CX, 360                                                                       
JBE CUADRANTE4_COSECANTE                        

CE_COSEC: 
MOV CX, ANG_ORIGINAL                   
CMP CX, 90                              
JBE POSITIVO5                                   
CMP CX, 180                                                                         
JBE POSITIVO5                                                                                                                                   
CMP CX, 270                                                                         
JBE NEGATIVO5                     
CMP CX, 360                                                                          
JBE NEGATIVO5    

POSITIVO5:
PRINT ' = '
JMP VALORES_CSC 

NEGATIVO5:
PRINT ' = -'   
JMP VALORES_CSC    

VALORES_CSC:
MOV CX, ANG
CMP CX, 90                              
JE   VALOR_CSC  
CMP CX, 88                              
JAE  VALOR_CSC_0     
CMP CX, 82                              
JAE  VALOR_CSC_1 
CMP CX, 66                              
JAE  VALOR_CSC_2 

VALOR_CSC:   
PRINT '1'
CALL SCAN_NUM      
JMP REINICIAR

VALOR_CSC_0:
PRINT '1.000'
JMP VOLVER4   

VALOR_CSC_1:
PRINT '1.00'
JMP VOLVER4   

VALOR_CSC_2:
PRINT '1.0'
JMP VOLVER4

CASO_ESPECIAL_COSECANTE2: 
MOV CX, ANG_ORIGINAL                  
CMP CX, 90                              
JBE POSITIVO6                                  
CMP CX, 180                                                                         
JBE POSITIVO6                                                                                                                                   
CMP CX, 270                                                                         
JBE NEGATIVO6                      
CMP CX, 360                                                                          
JBE NEGATIVO6  

POSITIVO6:
PRINT ' = '
JMP VALORES_CSC_1 

NEGATIVO6:
PRINT ' = -'   
JMP VALORES_CSC_1       

VALORES_CSC_1:       
MOV CX, ANG  
CMP CX, 1                              
JE   VALOR_CSC_18
CMP CX, 2                              
JE   VALOR_CSC_17
CMP CX, 3                              
JE   VALOR_CSC_16 
CMP CX, 4                              
JE   VALOR_CSC_15 
CMP CX, 5                              
JE   VALOR_CSC_14 
CMP CX, 6                              
JE   VALOR_CSC_13   
CMP CX, 7                              
JE   VALOR_CSC_12   
CMP CX, 8                              
JE   VALOR_CSC_11
CMP CX, 9                              
JE   VALOR_CSC_10
CMP CX, 11                              
JBE  VALOR_CSC_9 
CMP CX, 14                              
JBE  VALOR_CSC_8 
CMP CX, 18                              
JBE  VALOR_CSC_7 
CMP CX, 17                              
JE   VALOR_CSC_6
CMP CX, 28                              
JBE  VALOR_CSC_5 
CMP CX, 29                              
JE   VALOR_CSC_4                
CMP CX, 30                              
JE   VALOR_CSC_3         

VALOR_CSC_3:
PRINT '2'
JMP REINICIAR   

VALOR_CSC_4:
PRINT '2.0'
JMP VOLVER4  

VALOR_CSC_5:
PRINT '2.'
JMP VOLVER4   

VALOR_CSC_6:
PRINT '3.0'
JMP VOLVER4     

VALOR_CSC_7:
PRINT '3.'
JMP VOLVER4         

VALOR_CSC_8:
PRINT '4.'
JMP VOLVER4   

VALOR_CSC_9:
PRINT '5.'
JMP VOLVER4       

VALOR_CSC_10:
PRINT '6.'
JMP VOLVER4

VALOR_CSC_11:
PRINT '7.'
JMP VOLVER4  

VALOR_CSC_12:
PRINT '8.'
JMP VOLVER4   

VALOR_CSC_13:
PRINT '9.'
JMP VOLVER4     

VALOR_CSC_14:
PRINT '11.'
JMP VOLVER4   

VALOR_CSC_15:
PRINT '14.'
JMP VOLVER4    

VALOR_CSC_16:
PRINT '19.'
JMP VOLVER4      

VALOR_CSC_17:
PRINT '28.'
JMP VOLVER4     

VALOR_CSC_18:
PRINT '57.'
JMP VOLVER4 

VOLVER4:
MOV CX, ANG_ORIGINAL                  
CMP CX, 90                              
JBE IMPRIMIR_VALOR21                                  
CMP CX, 180                                                                         
JBE IMPRIMIR_VALOR22                                                                                                                                    
CMP CX, 270                                                                         
JBE IMPRIMIR_VALOR23                      
CMP CX, 360                                                                          
JBE IMPRIMIR_VALOR24  


CASO_ESPECIAL_COSECANTE3:                                
PRINT ' = INFINITO'
CALL SCAN_NUM
JMP REINICIAR 

CUADRANTE1_COSECANTE:
GOTOXY 1, 3                              
PRINT 'COSECANTE '                                                    
MOV AX, ANG_ORIGINAL                                              
CALL PRINT_NUM     
MOV ANG, AX                                              
CE_16 ANG
CE_14 ANG 
CE_15 ANG 
PRINT ' = 1.'
IMPRIMIR_VALOR21:                                          
MOV DI, 90                                                                               
SUB DI, ANG_ORIGINAL                                                        
ADD DI, DI                                                                               
MOV AX, VALORES_SECANTE[DI]                                                                         
CALL PRINT_NUM                                                    
CALL SCAN_NUM                            
JMP REINICIAR                            

CUADRANTE2_COSECANTE:                                       
GOTOXY 1, 3                              
PRINT 'COSECANTE '                                                     
MOV AX, ANG_ORIGINAL                                              
CALL PRINT_NUM                                                                                          
MOV CX, 180                                                                                    
SUB CX, ANG_ORIGINAL                                                        
MOV ANG, CX                           
CE_16 ANG
CE_14 ANG 
CE_15 ANG 
PRINT ' = 1.'
IMPRIMIR_VALOR22:                                                    
MOV DI, 90                                                                                 
SUB DI, ANG                                              
ADD DI, DI                                                  
MOV AX, VALORES_SECANTE[DI]                 
CALL PRINT_NUM                              
CALL SCAN_NUM                               
JMP REINICIAR                              

CUADRANTE3_COSECANTE:    
GOTOXY 1, 3                             
PRINT 'COSECANTE '                                                  
MOV AX, ANG_ORIGINAL                                        
CALL PRINT_NUM                                                                                                      
MOV CX, ANG_ORIGINAL                                                           
SUB CX, 180                                                          
MOV ANG, CX 
CE_16 ANG
CE_14 ANG 
CE_15 ANG 
PRINT ' = -1.' 
IMPRIMIR_VALOR23:                                                           
MOV DI, 90                                                                  
SUB DI, ANG                                                                          
ADD DI, DI                                                                     
MOV AX, VALORES_SECANTE[DI]                                                                       
CALL PRINT_NUM                                          
CALL SCAN_NUM                                         
JMP REINICIAR                         

CUADRANTE4_COSECANTE:     
GOTOXY 1, 3                              
PRINT 'COSECANTE '                                          
MOV AX, ANG_ORIGINAL                                      
CALL PRINT_NUM                                                                                                    
MOV CX, 360                                                                                
SUB CX, ANG_ORIGINAL                                                      
MOV ANG, CX  
CE_16 ANG
CE_14 ANG 
CE_15 ANG 
PRINT ' = -1.'     
IMPRIMIR_VALOR24:                                                       
MOV DI, 90                                                                    
SUB DI, ANG                                                                    
ADD DI, DI                                                                
MOV AX, VALORES_SECANTE[DI]                                                                     
CALL PRINT_NUM                                          
CALL SCAN_NUM                                            
JMP REINICIAR 

;/////////////////////////////////////////////////////////////////////////////////////////////
;FINAL
;/////////////////////////////////////////////////////////////////////////////////////////////                                   

REINICIAR: 
CALL CLEAR_SCREEN                                                
GOTOXY 1, 1                                                    
PRINT 'DESEA REINICIAR OTRO CALCULO? SI-(1) NO-(OTRA TECLA CUALQUIERA): ' 
CALL SCAN_NUM                                                   
CMP CX, 1                                                 
JE COMIENZO                                                       

SALIR:          

;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;---------------------------------------------------------------------------------------------------------------- 
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO

CODIGO  ENDS 

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_PTHIS                   
DEFINE_CLEAR_SCREEN
DEFINE_GET_STRING 

        END    INICIO    
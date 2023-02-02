TITLE   PLANTILLA

include 'emu8086.inc'
                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION
          
          DATO DW 0
          SENOR DW 0
          COSENOR DW 0
          CUADRANTE DW 0

          SEN0 DW 0,174,348,523,697,871,1045,1218,1391,1564
          SEN1 DW 1736,1908,2079,2249,2419,2588,2756,2923,3090,3255
          SEN2 DW 3420,3583,3746,3907,4067,4226,4383,4539,4694,4848
          SEN3 DW 5000,5150,5299,5446,5591,5735,5877,6018,6156,6293
          SEN4 DW 6427,6560,6691,6819,6946,7071,7193,7313,7431,7547
          SEN5 DW 7660,7771,7880,7986,8090,8191,8290,8386,8480,8571
          SEN6 DW 8660,8746,8829,8910,8987,9063,9135,9205,9271,9335
          SEN7 DW 9396,9455,9510,9563,9612,9659,9702,9743,9781,9816
          SEN8 DW 9848,9876,9902,9925,9945,9961,9975,9986,9993,9998
          SEN9 DW 10000

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
INICIOCODIGO:
        
       MOV DATO,0
       MOV SENOR,0
       MOV COSENOR,0
       MOV CUADRANTE,1
       CALL CLEAR_SCREEN
       CALL PTHIS
       DB 'PROGRAMA SENO Y COSENO',0
       GOTOXY 0,3 
       CALL PTHIS
       DB 'ESCRIBE EL ANGULO:',0
       GOTOXY 20,3
       CALL SCAN_NUM
       MOV DATO,CX
       JMP ICALCULO:
      
CALCULADO:

       GOTOXY 0,6
       CALL PTHIS
       DB 'EL SENO ES:',0
       GOTOXY 20,6
       MOV AX,SENOR
       CALL PRINT_NUM
       GOTOXY 0,9
       CALL PTHIS
       DB 'EL COSENO ES:',0
       GOTOXY 20,9
       MOV AX,COSENOR
       CALL PRINT_NUM
       JMP PREGUNTAR

        
PREGUNTAR:
         
        GOTOXY 0,12
        CALL PTHIS
        DB 'REALIZAR OTRA OPERACION SI(1) NO(2):',0
        CALL SCAN_NUM
        CMP CX,1
        JE INICIOCODIGO
        CMP CX,2
        JE OPERACIONT
        JMP PREGUNTAR
     
INVALIDO:

          GOTOXY 0,14
          CALL PTHIS
          DB 'OPERACION INVALIDA',0
          JMP INICIOCODIGO 


ICALCULO:
;----------------------------------------------
        CMP DATO,90
        JBE CALCULO1
        CMP DATO,180
        JBE CALCULO2 ;SE COMPRUEBA EN QUE CUADRANTE ENTRA EL ANGULO
        CMP DATO,270
        JBE CALCULO3 ;EN CASO DE SER CUADRANTE 1 SE CUALCULA DIRECTO
        CMP DATO,360
        JBE CALCULO4
        JMP INVALIDO

CALCULO2:

        MOV AX,DATO   ;EN CASO DE CUADRANTE 2 SE HACE EL AJUSTE
        SUB AX,90     ;RESTA 90 AL ANGULO
        MOV CX,2      ;MULTIPLICA EL RESULTANTE POR 2   
        MUL CX        ;SE RESTA EL RESULTADO AL ANGULO ORIGINAL
        SUB DATO,AX   ;ESTE ES EL RESULTADO QUE SE GUARDA
        MOV CUADRANTE,2 ;SE LE DICE AL PROGRAMA QUE ES CUADRANTE 2
        JMP CALCULO1
        
CALCULO3:

        SUB DATO,180
        MOV CUADRANTE,3   ;SOLO SE RESTA 180 AL ANGULO
        JMP CALCULO1
       
CALCULO4:
        
        MOV AX,DATO
        SUB AX,180
        MOV CX,2
        MUL CX         ;EL MISMO AJUSTO QUE EN EL CUADRANTE 2
        SUB DATO,AX    ;AHORA UTILIZANDO 180 EN LA PRIMERA RESTA
        MOV CUADRANTE,4
        JMP CALCULO1
        
       
CALCULO1:
        
        CMP DATO,0
        JL  INVALIDO
        CMP DATO,10
        JB  ESEN0
        CMP DATO,20
        JB ESEN1
        CMP DATO,30
        JB ESEN2
        CMP DATO,40  ;SE COMPRUEBA DONDE ESTA NUESTRO ANGULO DE
        JB ESEN3     ;0 A 90
        CMP DATO,50
        JB ESEN4
        CMP DATO,60
        JB ESEN5
        CMP DATO,70
        JB ESEN6
        CMP DATO,80
        JB ESEN7
        CMP DATO,90
        JB ESEN8
        CMP DATO,90
        JE ESEN9
        JMP INVALIDO
ESEN0:
        MOV AX,DATO      ;EN CADA ARREGO "ESEN" SE HACE LO MISMO
        MOV CX,2         ;MULTIPLICAMOS POR 2 PARA LA DIRECCION
        MUL CX           ;SE REALIZA EL AJUSTE RESTANDO EL DATO
        MOV SI,AX        ;AL ANGULO 90 PARA PODER TOMAR EL VALOR
        MOV AX,SEN0[SI]  ;DE COSENO
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,90       ;COMPROBACION PARA ASEGURARNOS QUE EL COSENO
        JBE ESCOS8       ;DEBE SER CALCULADO

ESEN1:  
        MOV AX,DATO
        SUB AX,10       ;SOLO RESTAREMOS 10,20,30 ETC A AX
        MOV CX,2        ;PARA PODER DIRECCIONARNOS CORRECTAMENTE
        MUL CX
        MOV SI,AX
        MOV AX,SEN1[SI]  ;SE USA EL ARREGLO SEGUN EL ANGULO QUE
        MOV SENOR,AX     ;TENGAMOS
        MOV AX,90
        SUB AX,DATO
        CMP AX,80
        JBE ESCOS7

ESEN2:  
        MOV AX,DATO
        SUB AX,20
        MOV CX,2
        MUL CX
        MOV SI,AX
        MOV AX,SEN2[SI]
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,70
        JBE ESCOS6

ESEN3:  
        MOV AX,DATO
        SUB AX,30
        MOV CX,2
        MUL CX
        MOV SI,AX
        MOV AX,SEN3[SI]
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,60
        JBE ESCOS5

ESEN4:  
        MOV AX,DATO
        SUB AX,40
        MOV CX,2
        MUL CX
        MOV SI,AX
        MOV AX,SEN4[SI]
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,50
        JBE ESCOS4

ESEN5:  
        MOV AX,DATO
        SUB AX,50
        MOV CX,2
        MUL CX
        MOV SI,AX
        MOV AX,SEN5[SI]
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,40
        JBE ESCOS3

ESEN6:  
        MOV AX,DATO
        SUB AX,60
        MOV CX,2
        MUL CX
        MOV SI,AX
        MOV AX,SEN6[SI]
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,30
        JBE ESCOS2

ESEN7:  
        MOV AX,DATO
        SUB AX,70
        MOV CX,2
        MUL CX
        MOV SI,AX
        MOV AX,SEN7[SI]
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,20
        JBE ESCOS1

ESEN8:  
        MOV AX,DATO
        SUB AX,80
        MOV CX,2
        MUL CX
        MOV SI,AX
        MOV AX,SEN8[SI]
        MOV SENOR,AX
        MOV AX,90
        SUB AX,DATO
        CMP AX,10
        JBE ESCOS0

ESEN9:  

       MOV AX,SEN9
       MOV SENOR,AX
       MOV AX,SEN0[0]
       JMP SALIR
       

ESCOS0:
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN0[SI]   ;EN EL CASO DEL COSENO SE HACE LO MISMO
       MOV COSENOR,AX    ;INCLUIDO SU AJUSTE PARA LA DIRECCION.
       JMP SALIR

ESCOS1:
       SUB AX,10
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN1[SI]    ;TAMBIEN SE ELIGE EL REGISTRO SEGUN EL
       MOV COSENOR,AX     ;ANGULO
       JMP SALIR

ESCOS2:
       SUB AX,20
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN2[SI]
       MOV COSENOR,AX
       JMP SALIR

ESCOS3:
       SUB AX,30
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN3[SI]
       MOV COSENOR,AX
       JMP SALIR

ESCOS4:
       SUB AX,40
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN4[SI]
       MOV COSENOR,AX
       JMP SALIR

ESCOS5:
       SUB AX,50
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN5[SI]
       MOV COSENOR,AX
       JMP SALIR
        
ESCOS6:
       SUB AX,60
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN6[SI]
       MOV COSENOR,AX
       JMP SALIR

ESCOS7:
       SUB AX,70
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN7[SI]
       MOV COSENOR,AX
       JMP SALIR
        
ESCOS8:
       SUB AX,80
       MOV CX,2
       MUL CX
       MOV SI,AX
       MOV AX,SEN8[SI]
       MOV COSENOR,AX
       JMP SALIR 

SALIR:

       CMP CUADRANTE,1
       JE  CALCULADO
       CMP CUADRANTE,2
       JE  AJUSTESIGNO2
       CMP CUADRANTE,3
       JE AJUSTESIGNO3     ;COMPRUEBA EL CUADRANTE PARA PODER
       CMP CUADRANTE,4     ;ASIGNAR LOS NEGATIVOS QUE NECESITEMOS
       JE AJUSTESIGNO4
       JMP INVALIDO

AJUSTESIGNO2:
        
        MOV AX,COSENOR
        MOV CX,-1
        MUL CX
        MOV COSENOR,AX
        JMP CALCULADO

AJUSTESIGNO3:
        
        MOV AX,COSENOR
        MOV CX,-1
        MUL CX
        MOV COSENOR,AX
        MOV AX,SENOR
        MOV CX,-1
        MUL CX
        MOV SENOR,AX
        JMP CALCULADO
       
AJUSTESIGNO4:
        
        MOV AX,SENOR
        MOV CX,-1
        MUL CX
        MOV SENOR,AX
        JMP CALCULADO

OPERACIONT:        
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

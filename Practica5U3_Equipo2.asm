TITLE   PRACTICA5_UNIDAD3_MULTIPLICACION_MATRICES_CONSOLA_PROC

INCLUDE emu8086.inc
                     
DATOS   SEGMENT                 ;SEGMENT- PSEUDO OPERADOR QUE NO GENERA CODIGO DE MAQUINA
                                           
;------------------------------------------------------------------------------------------------------------
;************************************************************************************************************
;COLOCAR LAS VARIABLES EN ESTA SECCION 

        COLUMNAS_A DB 0 
        FILAS_A DB 0
        COLUMNAS_B DB 0
        FILAS_B DB 0
        CONTADOR_COL DW 0
        CONT_FILA DW 1 
        CONT_R DW 0

        MAT_A_E1 DB 4 DUP (0) 
        MAT_A_E2 DB 4 DUP (0)
        MAT_A_E3 DB 4 DUP (0)
        MAT_A_E4 DB 4 DUP (0)     
        MAT_B_E1 DB 4 DUP (0)
        MAT_B_E2 DB 4 DUP (0)
        MAT_B_E3 DB 4 DUP (0)
        MAT_B_E4 DB 4 DUP (0)
        MAT_RESULTANTE DB 16 DUP (0)
        MAT_INTERMEDIA DB 4 DUP (0)

    
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
 
;INTRODUCIMOS AL USUARIO A COMO FUNCIONA EL PROGRAMA
;Y OBTENEMOS EL TAMA�O DE LAS MATRICES, DE ESTA MANERA 
;VERIFICAMOS SI PODEMOS REALIZAR LA MULTIPLICACION
FILAS_Y_COLUMNAS: 
        CALL RESET_INDICES
        CALL CLEAR_SCREEN 
        PRINT 'MULTIPLICACION DE DOS MATRICES (MAX 4X4)', 0
        GOTOXY 0,2
        PRINT 'FILAS DE LA MATRIZ A: ',0
        CALL SCAN_NUM 
        MOV FILAS_A, CL  
        GOTOXY 0,3  
        PRINT 'COLUMNAS DE LA MATRIZ A: ', 0  
        CALL SCAN_NUM 
        MOV COLUMNAS_A, CL

        GOTOXY 0,5
        PRINT 'FILAS DE LA MATRIZ B: ', 0  
        CALL SCAN_NUM 
        MOV FILAS_B, CL
        GOTOXY 0,6                   
        PRINT 'COLUMNAS DE LA MATRIZ B: ', 0  
        CALL SCAN_NUM 
        MOV COLUMNAS_B, CL 
        
        MOV BL, FILAS_A
        CMP BL, 4         
        JA NO_SE_PUEDE  

        MOV BL, COLUMNAS_A
        CMP BL, 4         
        JA NO_SE_PUEDE 

        MOV BL, FILAS_B
        CMP BL, 4         
        JA NO_SE_PUEDE    

        MOV BL, COLUMNAS_B
        CMP BL, 4         
        JA NO_SE_PUEDE

        MOV AL, COLUMNAS_A
        MOV BL, FILAS_B 
        CMP BL, AL
        JE SON_IGUALES  

        JMP NO_SE_PUEDE    

;SI LAS MATRICES SON COMPATIBLES, ENTONCES PREPARAMOS NUESTROS VALORES
SON_IGUALES:  
         
;CON ESTA INSTRUCCION CALL RESET_INDICES LLAMAMOS UN PROCEDIMIENTO
;CON EL CUAL NOS ASEGURAMOS DE TENER LAS VARIABLES E INDICES
;RESTABLECIDOS O 'LIMPIOS' PARA USARLOS EN EL PROGRAMA DE FORMA CORRECTA. 
        CALL RESET_INDICES  
        GOTOXY 0,8                   
        PRINT 'MATRICES ACEPTADAS (ENTER PARA CONTINUAR)', 0   
        CALL SCAN_NUM  

;DESPUES DE QUE SE HAYA VALIDADO LA MUTIPLICACION SE COLOCARAN LOS VALORES A LAS MATRICES
RELLENAR_FILA_A1:       

		CALL CLEAR_SCREEN
		GOTOXY 2, 2
		PRINT 'MATRIZ A: '

		GOTOXY 2, 4
		CALL SCAN_NUM
		MOV MAT_A_E1[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR1

		GOTOXY 4,4
		CALL SCAN_NUM
		MOV MAT_A_E1[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR1

		GOTOXY 6, 4
		CALL SCAN_NUM
		MOV MAT_A_E1[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR1

		GOTOXY 8,4
		CALL SCAN_NUM
		MOV MAT_A_E1[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR1
		
COMPARAR1:   
        MOV SI, 0  
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIO1 
        INC CONT_FILA    
        JMP RELLENAR_FILA_A2 

;SE LLENAN LOS VALORES DE LA MATRIZ A SI SUS EPACIOS SUPERAN A 4
RELLENAR_FILA_A2: 
 
        GOTOXY 2, 5
		CALL SCAN_NUM
		MOV MAT_A_E2[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR2

		GOTOXY 4,5
		CALL SCAN_NUM
		MOV MAT_A_E2[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR2

		GOTOXY 6, 5
		CALL SCAN_NUM
		MOV MAT_A_E2[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR2

		GOTOXY 8,5
		CALL SCAN_NUM
		MOV MAT_A_E2[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR2      

COMPARAR2: 
        MOV SI, 0          
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIO1  
        INC CONT_FILA  
        JMP RELLENAR_FILA_A3       

;SE LLENAN LOS VALORES DE LA MATRIZ A SI SUS EPACIOS SUPERAN A 8
RELLENAR_FILA_A3:    

        GOTOXY 2, 6
		CALL SCAN_NUM
		MOV MAT_A_E3[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR3

		GOTOXY 4,6
		CALL SCAN_NUM
		MOV MAT_A_E3[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR3

		GOTOXY 6,6
		CALL SCAN_NUM
		MOV MAT_A_E3[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR3

		GOTOXY 8,6
		CALL SCAN_NUM
		MOV MAT_A_E3[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR3
		
COMPARAR3:    
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIO1  
        INC CONT_FILA   
        JMP RELLENAR_FILA_A4 
            
;SE LLENAN LOS VALORES DE LA MATRIZ A SI SUS EPACIOS SUPERAN A 12
RELLENAR_FILA_A4:          

        GOTOXY 2, 7
		CALL SCAN_NUM
		MOV MAT_A_E4[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR4

		GOTOXY 4,7
		CALL SCAN_NUM
		MOV MAT_A_E4[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR4

		GOTOXY 6,7
		CALL SCAN_NUM
		MOV MAT_A_E4[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR4

		GOTOXY 8,7
		CALL SCAN_NUM
		MOV MAT_A_E4[SI], CL
		INC SI
		MOV DL, COLUMNAS_A
		CMP SI, DX
		JE COMPARAR4     

COMPARAR4:  
        MOV SI, 0         
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIO1

REINICIO1:    
        MOV AH, 0 
        MOV SI, 0
        MOV DI, 0 
        MOV CONTADOR_COL, 0
        MOV CONT_FILA, 1
        JMP RELLENAR_FILA_B1

;SE COMIENZA A RELLENAR LA MATRIZ B
RELLENAR_FILA_B1:
	    GOTOXY 2, 9
	    PRINT 'MATRIZ B: '

	    GOTOXY 2,11
	    CALL SCAN_NUM
	    MOV MAT_B_E1[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR5

	    GOTOXY 4,11
	    CALL SCAN_NUM
	    MOV MAT_B_E1[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR5

	    GOTOXY 6,11
	    CALL SCAN_NUM
	    MOV MAT_B_E1[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR5

	    GOTOXY 8,11
	    CALL SCAN_NUM
	    MOV MAT_B_E1[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR5  

COMPARAR5:   
        MOV SI, 0  
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO2 
        INC CONT_FILA    
        JMP RELLENAR_FILA_B2 

;SE LLENAN LOS VALORES DE LA MATRIZ B SI SUS EPACIOS SUPERAN A 4
RELLENAR_FILA_B2:      

	    GOTOXY 2,12
	    CALL SCAN_NUM
	    MOV MAT_B_E2[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR6

	    GOTOXY 4,12
	    CALL SCAN_NUM
	    MOV MAT_B_E2[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR6

	    GOTOXY 6,12
	    CALL SCAN_NUM
	    MOV MAT_B_E2[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR6

	    GOTOXY 8,12
	    CALL SCAN_NUM
	    MOV MAT_B_E2[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR6 

COMPARAR6:   
        MOV SI, 0  
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO2 
        INC CONT_FILA    
        JMP RELLENAR_FILA_B3

;SE LLENAN LOS VALORES DE LA MATRIZ B SI SUS EPACIOS SUPERAN A 8
RELLENAR_FILA_B3:    

        GOTOXY 2,13
	    CALL SCAN_NUM
	    MOV MAT_B_E3[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR7

	    GOTOXY 4,13
	    CALL SCAN_NUM
	    MOV MAT_B_E3[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR7

	    GOTOXY 6,13
	    CALL SCAN_NUM
	    MOV MAT_B_E3[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR7

	    GOTOXY 8,13
	    CALL SCAN_NUM
	    MOV MAT_B_E3[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR7  

COMPARAR7:   
        MOV SI, 0  
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO2 
        INC CONT_FILA    
        JMP RELLENAR_FILA_B4

;SE LLENAN LOS VALORES DE LA MATRIZ B SI SUS EPACIOS SUPERAN A 12
RELLENAR_FILA_B4:  

        GOTOXY 2,14
	    CALL SCAN_NUM
	    MOV MAT_B_E4[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR8

	    GOTOXY 4,14
	    CALL SCAN_NUM
	    MOV MAT_B_E4[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR8

	    GOTOXY 6,14
	    CALL SCAN_NUM
	    MOV MAT_B_E4[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR8

	    GOTOXY 8,14
	    CALL SCAN_NUM
	    MOV MAT_B_E4[SI], CL
	    INC SI
	    MOV DL, COLUMNAS_B
	    CMP SI, DX
	    JE COMPARAR8 

COMPARAR8:   
        MOV SI, 0  
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO2 

REINICIO2:    
        MOV AH, 0 
        MOV SI, 0
        MOV DI, 0 
        MOV CONTADOR_COL, 0
        MOV CONT_FILA, 1
        JMP MOSTRAR_FILA_A1

MOSTRAR_FILA_A1:  
        CALL CLEAR_SCREEN  
        GOTOXY 2, 2
        PRINT 'MATRIZ A: ', 0 
 
        GOTOXY 2, 4 
        MOV AL, MAT_A_E1[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS1   
          
        GOTOXY 4, 4 
        MOV AL, MAT_A_E1[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS1
         
        GOTOXY 6, 4 
        MOV AL, MAT_A_E1[SI] 
        CALL PRINT_NUM_UNS 

        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS1
        
        GOTOXY 8, 4 
        MOV AL, MAT_A_E1[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS1

COMPARAR_FILAS1:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_B1  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_A2    
 
MOSTRAR_FILA_A2:  
        GOTOXY 2, 5 
        MOV AL, MAT_A_E2[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS2   
          
        GOTOXY 4, 5 
        MOV AL, MAT_A_E2[SI] 
        CALL PRINT_NUM_UNS  

        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS2
         
        GOTOXY 6, 5 
        MOV AL, MAT_A_E2[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS2
        
        GOTOXY 8, 5 
        MOV AL, MAT_A_E2[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS2

COMPARAR_FILAS2:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_B1  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_A3    
 
MOSTRAR_FILA_A3:  
        GOTOXY 2, 6 
        MOV AL, MAT_A_E3[SI] 
        CALL PRINT_NUM_UNS
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS3   
          
        GOTOXY 4, 6 
        MOV AL, MAT_A_E3[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS3
         
        GOTOXY 6, 6 
        MOV AL, MAT_A_E3[SI] 
        CALL PRINT_NUM_UNS   

        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS3
        
        GOTOXY 8, 6 
        MOV AL, MAT_A_E3[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS3

COMPARAR_FILAS3:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_B1  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_A4    
 
MOSTRAR_FILA_A4:  
        GOTOXY 2, 7 
        MOV AL, MAT_A_E4[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS4   
          
        GOTOXY 4, 7 
        MOV AL, MAT_A_E4[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS4
         
        GOTOXY 6, 7 
        MOV AL, MAT_A_E4[SI] 
        CALL PRINT_NUM_UNS   

        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS4
        
        GOTOXY 8, 7 
        MOV AL, MAT_A_E4[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE COMPARAR_FILAS4

COMPARAR_FILAS4:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_B1      
 
MOSTRAR_FILA_B1:
        MOV CONT_FILA, 1   
        GOTOXY 2, 9
        CALL PTHIS
        DB 'MATRIZ B: ', 0 
 
        GOTOXY 2, 11 
        MOV AL, MAT_B_E1[SI] 
        CALL PRINT_NUM_UNS   

        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS5   
          
        GOTOXY 4, 11 
        MOV AL, MAT_B_E1[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS5
         
        GOTOXY 6, 11 
        MOV AL, MAT_B_E1[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS5

        GOTOXY 8, 11 
        MOV AL, MAT_B_E1[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS5

COMPARAR_FILAS5:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO3  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_B2    

MOSTRAR_FILA_B2:   
        GOTOXY 2, 12 
        MOV AL, MAT_B_E2[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS6   
          
        GOTOXY 4, 12 
        MOV AL, MAT_B_E2[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS6
         
        GOTOXY 6, 12 
        MOV AL, MAT_B_E2[SI] 
        CALL PRINT_NUM_UNS 

        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS6
        
        GOTOXY 8, 12 
        MOV AL, MAT_B_E2[SI] 
        CALL PRINT_NUM_UNS         
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS6

COMPARAR_FILAS6:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO3  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_B3    

MOSTRAR_FILA_B3:   
        GOTOXY 2, 13 
        MOV AL, MAT_B_E3[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS7   
          
        GOTOXY 4, 13 
        MOV AL, MAT_B_E3[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS7
         
        GOTOXY 6, 13 
        MOV AL, MAT_B_E3[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS7
        
        GOTOXY 8, 13 
        MOV AL, MAT_B_E3[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS7

COMPARAR_FILAS7:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO3  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_B4    
 
MOSTRAR_FILA_B4:   
        GOTOXY 2, 14 
        MOV AL, MAT_B_E4[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS8   
          
        GOTOXY 4, 14 
        MOV AL, MAT_B_E4[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS8
         
        GOTOXY 6, 14 
        MOV AL, MAT_B_E4[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS8
        
        GOTOXY 8, 14 
        MOV AL, MAT_B_E4[SI] 
        CALL PRINT_NUM_UNS   
        
        INC SI
        MOV DL, COLUMNAS_B
        CMP SI, DX
        JE COMPARAR_FILAS8

COMPARAR_FILAS8:
        MOV SI, 0       
        MOV AX, CONT_FILA
        MOV BL, FILAS_B 
        CMP AX, BX
        JE  REINICIO3    
 
REINICIO3:    
        MOV AH, 0 
        MOV SI, 0
        MOV DI, 0 
        MOV CONTADOR_COL, 0
        MOV CONT_FILA, 1
        JMP MULT  

;MULTIPLICAMOS LA PRIMER FILA DE LA MATRIZ A POR TODAS LAS COLUMNAS DE LA MATRIZ B
MULT:  
        MOV AX, 0
        MOV BX, 0 
        INC CONTADOR_COL 
        
        MOV AL, MAT_A_E1[SI]             
        MOV BL, MAT_B_E1[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR1   
          
        MOV AL, MAT_A_E1[SI]
        MOV BL, MAT_B_E2[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR1 
         
        MOV AL, MAT_A_E1[SI]
        MOV BL, MAT_B_E3[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR1 
        
        MOV AL, MAT_A_E1[SI]
        MOV BL, MAT_B_E4[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR1 

;UNA VEZ TERMINAMOS LAS MULTIPLICACIONES, SUMAMOS TODOS LOS RESULTADOS Y CORROBORAMOS SI RECORRIMOS TODAS LAS COLUMNAS
SUMAR1:  
        MOV AX, 0
        MOV BX, 0 
        
        MOV AL, MAT_INTERMEDIA[0]
        ADD AL, MAT_INTERMEDIA[1]                                   
        ADD AL, MAT_INTERMEDIA[2]
        ADD AL, MAT_INTERMEDIA[3]  
        
        MOV SI, CONT_R
        MOV MAT_RESULTANTE[SI], AL
        INC CONT_R   
        INC DI
        MOV SI, 0
        MOV AX, CONTADOR_COL   
        MOV BL, COLUMNAS_B
        CMP AX, BX 
        JB  MULT 
                
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_R1    
        
        INC CONT_FILA
        MOV DI, 0
        MOV CONTADOR_COL, 0
        MOV AX, 0
        MOV BX, 0 
        JMP MULT2  

;REALIZAMOS EL MISMO PROCESO QUE EN LA SECCION ANTERIOR, PERO CON LA SEGUNDA FILA DEL ARREGLO A
MULT2:     
        MOV AX, 0
        MOV BX, 0 
        INC CONTADOR_COL 
        
        MOV AL, MAT_A_E2[SI]
        MOV BL, MAT_B_E1[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR2  
           
        MOV AL, MAT_A_E2[SI]
        MOV BL, MAT_B_E2[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR2 
         
        MOV AL, MAT_A_E2[SI]
        MOV BL, MAT_B_E3[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR2  
        
        MOV AL, MAT_A_E2[SI]
        MOV BL, MAT_B_E4[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR2 

SUMAR2: 
        MOV AX, 0
        MOV BX, 0  
        
        MOV AL, MAT_INTERMEDIA[0]
        ADD AL, MAT_INTERMEDIA[1]                                   
        ADD AL, MAT_INTERMEDIA[2]
        ADD AL, MAT_INTERMEDIA[3]  
        
        MOV SI, CONT_R
        MOV MAT_RESULTANTE[SI], AL
        INC CONT_R  
        INC DI
        MOV SI, 0
        MOV AX, CONTADOR_COL   
        MOV BL, COLUMNAS_B
        CMP AX, BX 
        JB  MULT2 
                
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_R1  
        
        INC CONT_FILA
        MOV DI, 0
        MOV CONTADOR_COL, 0
        MOV AX, 0
        MOV BX, 0  
        JMP MULT3  

;REALIZAMOS EL MISMO PROCESO QUE EN LA SECCION ANTERIOR, PERO CON LA TERCER FILA DEL ARREGLO A
MULT3:     
        MOV AX, 0
        MOV BX, 0 
        INC CONTADOR_COL 

        MOV AL, MAT_A_E3[SI]
        MOV BL, MAT_B_E1[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR3  
           
        MOV AL, MAT_A_E3[SI]
        MOV BL, MAT_B_E2[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR3 
         
        MOV AL, MAT_A_E3[SI]
        MOV BL, MAT_B_E3[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR3  
        
        MOV AL, MAT_A_E3[SI]
        MOV BL, MAT_B_E4[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR3 

SUMAR3: 
        MOV AX, 0
        MOV BX, 0  
        
        MOV AL, MAT_INTERMEDIA[0]
        ADD AL, MAT_INTERMEDIA[1]                                   
        ADD AL, MAT_INTERMEDIA[2]
        ADD AL, MAT_INTERMEDIA[3]  
        
        MOV SI, CONT_R
        MOV MAT_RESULTANTE[SI], AL
        INC CONT_R  
        INC DI
        MOV SI, 0
        MOV AX, CONTADOR_COL   
        MOV BL, COLUMNAS_B
        CMP AX, BX 
        JB  MULT3 
                
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_R1  
        
        INC CONT_FILA
        MOV DI, 0
        MOV CONTADOR_COL, 0
        MOV AX, 0
        MOV BX, 0  
        JMP MULT4 

;REALIZAMOS EL MISMO PROCESO QUE EN LA SECCION ANTERIOR, PERO CON LA CUARTA FILA DEL ARREGLO A
MULT4:     
        MOV AX, 0
        MOV BX, 0 
        INC CONTADOR_COL 
        
        MOV AL, MAT_A_E4[SI]
        MOV BL, MAT_B_E1[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR4  
           
        MOV AL, MAT_A_E4[SI]
        MOV BL, MAT_B_E2[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR4 
         
        MOV AL, MAT_A_E4[SI]
        MOV BL, MAT_B_E3[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR4  

        MOV AL, MAT_A_E4[SI]
        MOV BL, MAT_B_E4[DI]
        MUL BL
        MOV MAT_INTERMEDIA[SI], AL 
        INC SI
        MOV DL, COLUMNAS_A
        CMP SI, DX
        JE SUMAR4 

SUMAR4: 
        MOV AX, 0
        MOV BX, 0  
        
        MOV AL, MAT_INTERMEDIA[0]
        ADD AL, MAT_INTERMEDIA[1]                                   
        ADD AL, MAT_INTERMEDIA[2]
        ADD AL, MAT_INTERMEDIA[3]  
        
        MOV SI, CONT_R
        MOV MAT_RESULTANTE[SI], AL
        INC CONT_R  
        INC DI
        MOV SI, 0
        MOV AX, CONTADOR_COL   
        MOV BL, COLUMNAS_B
        CMP AX, BX 
        JB  MULT4 
        
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  MOSTRAR_FILA_R1   

MOSTRAR_FILA_R1: 
        MOV CONT_FILA, 1
        MOV SI, 0
        MOV CONTADOR_COL, 1
        GOTOXY 2, 16
        CALL PTHIS
        DB 'MATRIZ RESULTADO: ', 0 
         
        GOTOXY 2, 18 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R1 
        INC CONTADOR_COL  
          
        GOTOXY 6, 18 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R1 
        INC CONTADOR_COL  
         
        GOTOXY 10, 18 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R1 
        INC CONTADOR_COL  
        
        GOTOXY 14, 18 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R1  

COMPARAR_FILAS_R1:      
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIAR_PROGRAMA  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_R2    
 
MOSTRAR_FILA_R2:
        MOV CONTADOR_COL, 1  
        GOTOXY 2, 19 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R2 
        INC CONTADOR_COL   
          
        GOTOXY 6, 19
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R2 
        INC CONTADOR_COL 
 
        GOTOXY 10, 19 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R2 
        INC CONTADOR_COL 
        
        GOTOXY 14, 19
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R2 

COMPARAR_FILAS_R2:      
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIAR_PROGRAMA  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_R3    
 
MOSTRAR_FILA_R3:
        MOV CONTADOR_COL, 1  
        GOTOXY 2, 20 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R3 
        INC CONTADOR_COL    
          
        GOTOXY 6, 20 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R3 
        INC CONTADOR_COL
 
        GOTOXY 10, 20 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R3 
        INC CONTADOR_COL
        
        GOTOXY 14, 20 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R3

COMPARAR_FILAS_R3:      
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIAR_PROGRAMA  
        INC CONT_FILA   
        JMP MOSTRAR_FILA_R4    

MOSTRAR_FILA_R4:
        MOV CONTADOR_COL, 1  
        GOTOXY 2, 21 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R4
        INC CONTADOR_COL   
          
        GOTOXY 6, 21 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R4
        INC CONTADOR_COL  
 
        GOTOXY 10, 21
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R4
        INC CONTADOR_COL  
        
        GOTOXY 14, 21 
        MOV AL, MAT_RESULTANTE[SI] 
        CALL PRINT_NUM_UNS 
        
        INC SI            
        MOV CX, CONTADOR_COL
        MOV DL, COLUMNAS_B
        CMP CX, DX
        JE COMPARAR_FILAS_R4
        
COMPARAR_FILAS_R4:      
        MOV AX, CONT_FILA
        MOV BL, FILAS_A 
        CMP AX, BX
        JE  REINICIAR_PROGRAMA      
 
;SI NO SE PUEDEN MULTIPLICAR, MANDA UNA 'N' NO Y SALE DEL PROGRAMA
NO_SE_PUEDE:
        CALL CLEAR_SCREEN                    
        PRINT 'NO SE PUEDE MULTIPLICAR', 0   
                  
;EN ESTA SECCION LLAMAMOS AL PROCEDIMIENTO LLAMADO PREGUNTA_REINICIAR
;EN EL CUAL REALIZAMOS EL PROCESO NEESARIO PARA DETERMINAR SI EL
;USUARIO DESEA REALIZAR OTRA OPERACION O DESEA SALIR DEL PROGRAMA                  
REINICIAR_PROGRAMA:   
        CALL PREGUNTA_REINICIAR 

SALIR:
        RET                
;----------------------------------------------------------------------------------------------------------------
;****************************************************************************************************************
;----------------------------------------------------------------------------------------------------------------         
    
; return to operating system:
        RET		           ;POR CADA PUNTO DE SALIDA EN EL PROCEDIMIENTO SE DEBE INCLUIR
                           ;UNA INSTRUCCION DE RETORNO RET.
INICIO  ENDP               ;INDICAMOS FIN DE PROCEDIMIENTO INICIO   

DEFINE_SCAN_NUM 
DEFINE_GET_STRING 
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_PTHIS 
DEFINE_CLEAR_SCREEN
                    
;PROCESIMIENTO NECESARIO PARA RESTABLECER LOS VALORES DE LAS VARIABLES
;REGISTROS E INDICES NECESARIOS PARA REALIAR UN CALCULO CORRECTO
RESET_INDICES PROC
        MOV MAT_INTERMEDIA[0], 0
        MOV MAT_INTERMEDIA[1], 0                                   
        MOV MAT_INTERMEDIA[2], 0
        MOV MAT_INTERMEDIA[3], 0
        MOV AH, 0 
        MOV SI, 0
        MOV DI, 0 
        MOV CONTADOR_COL, 0
        MOV CONT_FILA, 1 
        MOV CONT_R, 0
        RET
RESET_INDICES ENDP

;PROCEDIMIENTOO EN EL CUAL DETERMINAMOS SI EL USUARIO DESEA REALIZAR
;OTRA OPERACION O DESEA SALIR DEL PROGRAMA
PREGUNTA_REINICIAR PROC
        CALL SCAN_NUM
        CALL CLEAR_SCREEN
        PRINT 'DESEA REALIZAR UN NUEVO CALCULO? SI (1) / NO (CUALQUIER NUMERO) : '
        CALL SCAN_NUM
        CMP CX, 1
        JE FILAS_Y_COLUMNAS 
        JMP SALIR
        RET
PREGUNTA_REINICIAR ENDP 

CODIGO  ENDS 

        END    INICIO    
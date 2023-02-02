.MODEL SMALL     ;Es un modelo corto
.STACK           ;Segmento de pila
.DATA            ;Segmento de datos
.CODE            ;Segmento de codigo

PIXELES:         ;Etiqueta del programa
MOV AX, @DATA    ;Movemos los datos a AX 
MOV DS, AX       ;Movemos datos a DS

MOV AH, 00       ;Cargamos el modo de video
MOV AL, 13H      ;Cargamos el modo grafico 13H en el cual tenemos 256 colores 
INT 10H          ;Sigue la interrupcion que controla los servicios de pantalla

CICLO:           ;Comenzamos el ciclo
MOV AX,3         ;Obtenemos la informacion del raton
INT 33H          ;Interrupcion que controla el raton
SHR CX, 1        ;Se divide entre 2 para obtener la pocision correcta
CMP BX, 1        ;Comparamos BX com 1(boton izquierdo)
JE PINTARX       ;Pintamos nuestro punto X, se realiza un salto condicional
CMP BX, 2        ;Comparamos BX com 2(boton derecho)
JE PINTARY       ;Pintamos nuestro punto Y, se realiza un salto condicional
JMP CICLO        ;Salto incondicional a nuestro ciclo 

PINTARX:         ;Etiqueta pintar X
MOV AL, 1110B    ;Se carga el color Amarillo
MOV AH, 0CH      ;Se Dibuja un pixel en pantalla
INT 10H          ;Interrupcion que controla los servicios de pantalla
JMP CICLO        ;Salto incondicional a nuestro ciclo 


PINTARY:         ;Etiqueta pintar Y
MOV AL, 1101B    ;Se carga el color Rosa
MOV AH, 0CH      ;Se Dibuja un pixel en pantalla
INT 10H          ;Interrupcion que controla los servicios de pantalla  
JMP CICLO        ;Salto incondicional a nuestro ciclo    


;LINEA:
;
;INC DX
;INT 10H
;CMP DX,100
;JNE LINEA
;
;RET


END              ;Finalizamos el programa 

                 ;AL es donde se colocara el color del pixel
                 ;CX es nuetra columna
                 ;DX es nuestro renglon
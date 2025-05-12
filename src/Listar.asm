.model small
.stack

.data
    pos_vertical db 10
    pos_vertical_decorador db 9
    separador   db '+----+-----------------------------+------------+------------+----------------+',13,10,'$'
    encabezado db '| ID | Descripcion                 | Creacion   | Limite     | Dias restantes |',13,10,'$'
    espacioTarea db'|    |                             |            |            |                |',13,10,'$'
    cantTareas db 10d
    color db 03h
    letra db ' '
    controles   db '[U]Arriba  [D]Abajo  [Q]Salir$'


.code
main proc
    mov ax, @data
    mov ds, ax

    ; Apuntar ES a memoria de video
    mov ax, 0B800h
    mov es, ax
    
    ; Configurar para llenar pantalla
    xor di, di  ; Empezar en posición 0
    mov cx, 80*25   ; Número de caracteres en pantalla
    mov ah, [color] ; Atributo de colore
    mov al, ' ' ; Carácter espacio (para limpiar)

    rep stosw
          
    mov ah, 02h
    mov bh, 0
    mov dh, 0   ;Fila
    mov dl, 0   ;Columna
    int 10h

    ;Empezar a imprimir la tablita
    lea dx, separador
    mov ah, 09h
    int 21h
    ;call saltarLinea

    lea dx, encabezado
    mov ah, 09h
    int 21h

    lea dx, separador
    mov ah, 09h
    int 21h

    mov cl, cantTareas    ; Carga cantTareas en CL (parte baja de CX)
    mov ch, 0             ; Limpia CH (parte alta de CX)

    taskLoop:
        lea dx, espacioTarea
        mov ah, 09h
        int 21h

        lea dx, separador
        mov ah, 09h
        int 21h      
    loop taskLoop

    lea dx, controles
    mov ah, 09h
    int 21h

    finalizar:
    mov ah, 08H        ; Función 1: leer carácter con eco
    int 21h          ; Resultado en AL
    mov letra, al     ; Guardar el carácter en variable 
    
    cmp letra, 'q'
    je salir ; Si no es 'q', continuar

    jmp finalizar ; Si no es 'u' o 'd', volver a leer

    Salir:
    mov ah, 4Ch
    int 21h
main endp

saltarLinea proc
    mov dl, 13         ; Carriage return (CR)
    mov ah, 02h
    int 21h

    mov dl, 10         ; Line feed (LF)
    mov ah, 02h
    int 21h

    ret
saltarLinea endp
end main
.model small
.stack
.386

extrn idBuffer:byte, descriptionBuffer:byte
extrn creationBuffer:byte, endBuffer:byte

extern pos_vertical:byte, separador:byte, encabezado:byte, espacioTarea:byte
extern cantTareas:byte, color:byte, letra:byte, controles:byte
extern acumuladorLineas:byte
extern parse_csv_line:near, fileBuffer:byte, max_lines:byte

public mainlistar

.data
    ;pos_vertical db 3
    ;pos_vertical_decorador db 9
    ;separador   db '+----+-----------------------------+------------+------------+----------------+',13,10,'$'
    ;encabezado db '| ID | Descripcion                 | Creacion   | Limite     | Dias restantes |',13,10,'$'
    ;espacioTarea db'|    |                             |            |            |                |',13,10,'$'
    ;cantTareas db 10d
    ;color db 03h
    ;letra db ' '
    ;controles db '[N]Siguiente..  [Q]Salir$'

.code
mainlistar proc near
    ;mov ax, @data
    ;mov ds, ax

    ; Apuntar ES a memoria de video
    Inicio:
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

    mov cl, [acumuladorLineas]
    mov ch, 0
    ;mov cx, 1

    ;RELLENAR TABLA
    Rellenar:
    mov si, offset fileBuffer
    mov di, cx
    push cx
    call parse_csv_line
    pop cx

    ;Rellenar el id
    mov ah, 02h
    mov bh, 0
    mov dh, [pos_vertical]   ;Fila
    mov dl, 2   ;Columna
    int 10h

    lea dx, idBuffer
    mov ah, 09h
    int 21h

    ;Rellenar la descripcion
    mov ah, 02h
    mov bh, 0
    mov dh, [pos_vertical]   ;Fila
    mov dl, 7   ;Columna
    int 10h

    lea dx, descriptionBuffer
    mov ah, 09h
    int 21h

    ;Rellenar creacion
    mov ah, 02h
    mov bh, 0
    mov dh, [pos_vertical]   ;Fila
    mov dl, 37   ;Columna
    int 10h

    lea dx, creationBuffer
    mov ah, 09h
    int 21h

    ;Rellenar limite
    mov ah, 02h
    mov bh, 0
    mov dh, [pos_vertical]   ;Fila
    mov dl, 50   ;Columna
    int 10h

    lea dx, endBuffer
    mov ah, 09h
    int 21h

    add [pos_vertical], 2
    inc cx
    cmp [pos_vertical], 23 
    jne Rellenar

    mov [acumuladorLineas], cl
    ;add [acumuladorLineas], 1

    finalizar:
    mov ah, 02h
    mov bh, 0
    mov dh, 23   ;Fila
    mov dl, 50   ;Columna
    int 10h
    
    mov ah, 08H        ; Función 1: leer carácter con eco
    int 21h          ; Resultado en AL
    mov letra, al     ; Guardar el carácter en variable 

    cmp letra, 'n'
    je Next

    cmp letra, 'd'
    je Down
    
    cmp letra, 'q'
    je salir ; Si no es 'q', continuar

    jmp finalizar ; Si no es 'u' o 'd', volver a leer

    Next:
    mov [pos_vertical], 3
    mov al, [acumuladorLineas]
    cmp al, [max_lines]
    jge finalizar

    jmp Inicio

    Down:
    mov [pos_vertical], 3
    cmp [acumuladorLineas], 11
    jle finalizar
    sub [acumuladorLineas], 20
    jmp Inicio

    Salir:
    mov ah, 4Ch
    int 21h
mainlistar endp

saltarLinea proc near
    mov dl, 13         ; Carriage return (CR)
    mov ah, 02h
    int 21h

    mov dl, 10         ; Line feed (LF)
    mov ah, 02h
    int 21h

    ret
saltarLinea endp
end mainlistar
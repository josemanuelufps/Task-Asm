.model small
.stack
.386

; ----------------------------------------------------
; === External procedures (from utils.asm) ===
; ----------------------------------------------------
extrn parse_csv_line:near, count_lines:near, calculate_deadline:near
extrn print_number:near

; ----------------------------------------------------
; === External data (from main.asm) ===
; ----------------------------------------------------
extrn idBuffer:byte, descriptionBuffer:byte, day_diff:word
extrn creationBuffer:byte, endBuffer:byte, fileBuffer:byte 

;DATOS DE LISTAR.ASM (ORIGINALMENTE)
extrn colorListar:byte, separador:byte, encabezado:byte, espacioTarea:byte
extrn pos_vertical:byte, cantTareas:byte, letra_Listar:byte, controles:byte
extrn acumuladorLineas:byte, max_lines:byte, lineas_pintadas:byte, lineasPorPagina:byte

public mainListar

.data
    ;colorListar db 03h
    ;separador   db '+----+-----------------------------+------------+------------+----------------+',13,10,'$'
    ;encabezado db '| ID | Descripcion                 | Creacion   | Limite     | Dias restantes |',13,10,'$'
    ;espacioTarea db'|    |                             |            |            |                |',13,10,'$'
    ;pos_vertical db 3
    ;cantTareas db 10d   
    ;letra_Listar db ' '
    ;controles db '[U]Siguiente..  [D]Anterior..  [Q]Salir$'
    ;acumuladorLineas db 1d
    ;max_lines db 0

    ;lineas_pintadas db 0

.code
mainListar proc near
    ; Apuntar ES a memoria de video
    Inicio:
    mov [lineasPorPagina], 10
    call count_lines
    ;mov ax, 0B800h
    ;mov es, ax
    
    ; Configurar para llenar pantalla
    xor di, di  ; Empezar en posición 0
    mov cx, 80*25   ; Número de caracteres en pantalla
    mov ah, [colorListar] ; Atributo de colore
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

    ;inc [acumuladorLineas]

    mov cl, [acumuladorLineas]
    mov ch, 0

    ;RELLENAR TABLA
    Rellenar:
    mov al, [lineas_pintadas]
    mov ah, 0
    cmp al, [max_lines]
    je FinRellenar

    inc cx

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

    ;Rellenar deadline
    mov ah, 02h
    mov bh, 0
    mov dh, [pos_vertical]   ;Fila
    mov dl, 68   ;Columna
    int 10h

    call calculate_deadline
    push ax
    mov ax, [day_diff]
    call print_number
    pop ax


    inc [lineas_pintadas]
    add [pos_vertical], 2   
    dec [lineasPorPagina]
    cmp [pos_vertical], 23 
    jne Rellenar
    FinRellenar:
    mov [acumuladorLineas], cl

    finalizar:
    mov ah, 02h
    mov bh, 0
    mov dh, 23   ;Fila
    mov dl, 50   ;Columna
    int 10h
    
    mov ah, 08H        ; Función 1: leer carácter con eco
    int 21h          ; Resultado en AL
    mov letra_Listar, al     ; Guardar el carácter en variable 

    cmp letra_Listar, 'u'
    je Next

    cmp letra_Listar, 'd'
    je Down
    
    cmp letra_Listar, 'q'
    je salir ; Si no es 'q', continuar

    jmp finalizar ; Si no es 'u' o 'd', volver a leer

    Next:
    mov [pos_vertical], 3
    mov al, [acumuladorLineas]
    ;dec al
    cmp al, [max_lines]
    je finalizar

    jmp Inicio

    Down:
    mov [pos_vertical], 3
    cmp [acumuladorLineas], 10
    jle finalizar

    mov al, [max_lines]
    cmp al,[lineas_pintadas]
    jne Seguir
    
    mov al, [lineasPorPagina]
    add [acumuladorLineas], al
    sub [acumuladorLineas], 20

    mov al, [acumuladorLineas]
    mov [lineas_pintadas], al
    ;dec [lineasPorPagina]
    jmp Inicio

    Seguir:
    sub [acumuladorLineas], 20
    sub [lineas_pintadas], 20
    jmp Inicio

    Salir:
    mov [pos_vertical], 3
    mov [acumuladorLineas], 0d
    mov [lineas_pintadas], 0
    ret

mainListar endp
end mainlistar
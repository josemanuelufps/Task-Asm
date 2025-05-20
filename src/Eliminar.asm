.model small
.stack
.386

public mainEliminar

; ----------------------------------------------------
; === External procedures (from Bye.asm) ===
; ----------------------------------------------------
extrn main:near

; ----------------------------------------------------
; === External procedures (from utils.asm) ===
; ----------------------------------------------------
extern count_lines:near, remove_csv_line:near

; ----------------------------------------------------
; === External data (from main.asm) ===
; ----------------------------------------------------
;DATOS DE ELIMINAR.ASM (ORIGINALMENTE)
extrn colorEliminar:byte, msg_eliminar:byte, msg_eliminar2:byte
extrn msg_vacio:byte, msg_max:byte, msg_max2:byte, max_lines:byte
extrn max_lines_str:byte, controlesEliminar1:byte, controlesEliminar2:byte
extrn controlesEliminar3:byte, letra_Eliminar:byte, OpcionID:byte
extrn OpcionIDStr:byte

.data
    ;colorEliminar db 03h
    ;msg_eliminar db '                  ____       _      _         _____         _    ',13, 10
    ;             db '                 |  _ \  ___| | ___| |_ ___  |_   _|_ _ ___| | __',13, 10
    ;             db '                 | | | |/ _ \ |/ _ \ __/ _ \   | |/ _` / __| |/ /',13, 10
    ;             db '                 | |_| |  __/ |  __/ ||  __/   | | (_| \__ \   < ',13, 10
    ;             db '                 |____/ \___|_|\___|\__\___|   |_|\__,_|___/_|\_\',13, 10, '$'
    ;msg_eliminar2 db 'Seleccione el ID de la tarea que dese eliminar...$'
    ;msg_vacio db 'No existe ninguna tarea. Empieza creando tareas$'
    ;msg_max db 'Seleccion un ID en el rango [1-$'
    ;msg_max2 db '] ==> (   )$'
    ;max_lines db 3d ;Ya esta en el main.asm, recordar borrar
    ;max_lines_str db '000$' 
    ;controlesEliminar1 db '[S]Siguiente ID..  [A]Anterior ID..  [Q]Cancelar$'
    ;controlesEliminar2 db '[Enter]Eliminar$'
    ;controlesEliminar3 db '[Enter]Retroceder..$'
    ;letra_Eliminar db ' '
    ;OpcionID db 1d
    ;OpcionIDStr db '000$'

.code
mainEliminar proc near

    call count_lines
    ;mov ax, @data
    ;mov ds, ax

    ;mov ax, 0B800h
    ;mov es, ax
    
    ; Limpiar pantalla
    xor di, di
    mov cx, 80*25
    mov ah, [colorEliminar]
    mov al, ' '
    rep stosw

    mov ah, 02h
    mov bh, 0
    mov dh, 2
    mov dl, 0
    int 10h

    lea dx, msg_eliminar
    mov ah, 09h
    int 21h

    ;Se valida si al menos hay una tarea
    cmp max_lines, 0
    je Vacio

    mov al, max_lines
    mov ah, 0
    call to_string_lines

    mov ah, 02h
    mov bh, 0
    mov dh, 8
    mov dl, 17
    int 10h

    lea dx, msg_eliminar2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 17
    int 10h

    lea dx, controlesEliminar1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 14
    mov dl, 34
    int 10h

    lea dx, controlesEliminar2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 19
    int 10h

    lea dx, msg_max
    mov ah, 09h
    int 21h

    lea dx, max_lines_str
    mov ah, 09h
    int 21h

    lea dx, msg_max2
    mov ah, 09h
    int 21h

    ; Leer ID
    SeleccionID:
    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 60
    int 10h

    mov al, OpcionID
    mov ah, 0
    call to_string_id

    lea dx, OpcionIDStr
    mov ah, 09h
    int 21h

    mov ah, 08h
    int 21h
    mov letra_Eliminar, al

    cmp letra_Eliminar, 's'
    je AumentarID

    cmp letra_Eliminar, 'a'
    je DisminuirID

    cmp letra_Eliminar, 13
    je Salir

    cmp letra_Eliminar, 'q'
    jne SeleccionID

    jmp Cancelar

    AumentarID:
    mov dl, max_lines
    mov dh, 0
    cmp [OpcionID], dl
    jge SeleccionID

    inc OpcionID
    jmp SeleccionID

    DisminuirID:
    cmp OpcionID, 1
    je SeleccionID

    dec OpcionID
    jmp SeleccionID

    jmp Salir

    Vacio:
    mov ah, 02h
    mov bh, 0
    mov dh, 8
    mov dl, 18
    int 10h

    lea dx, msg_vacio
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 30
    int 10h

    lea dx, controlesEliminar3
    mov ah, 09h
    int 21h

    Letra_Vacio:
    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 39
    int 10h

    mov ah, 08H        ; Función 1: leer carácter con eco
    int 21h          ; Resultado en AL
    mov letra_Eliminar, al     ; Guardar el carácter en variable

    cmp letra_Eliminar, 13
    jne Letra_Vacio

    Cancelar:
    mov OpcionID, 1d
    call main

    Salir:
    mov cl, OpcionID
    mov ch, 0
    call remove_csv_line
    mov OpcionID, 1d
    call main
    mainEliminar endp

; ------------------------------------------------------------
; Convierte AX (max_lines) en ASCII y guarda en max_lines_str
; ------------------------------------------------------------
to_string_lines proc near
    push ax
    push bx
    push cx
    push dx
    lea di, max_lines_str
    mov cx, 3
    mov bx, 10
    add di, 2
.conv_loop_lines:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    loop .conv_loop_lines
    pop dx
    pop cx
    pop bx
    pop ax
    ret
to_string_lines endp

; ------------------------------------------------------------
; Convierte AX (OpcionId) en ASCII y guarda en OpcionIDStr
; ------------------------------------------------------------
to_string_id proc near
    push ax
    push bx
    push cx
    push dx
    lea di, OpcionIDStr
    mov cx, 3
    mov bx, 10
    add di, 2
.conv_loop_id:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    loop .conv_loop_id
    pop dx
    pop cx
    pop bx
    pop ax
    ret
to_string_id endp
end mainEliminar
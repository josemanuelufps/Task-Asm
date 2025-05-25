.model small
.stack
.386

public mainAgregar

; ----------------------------------------------------
; === External procedures (from main.asm) ===
; ----------------------------------------------------
extrn main:near

; ----------------------------------------------------
; === External procedures (from utils.asm) ===
; ----------------------------------------------------
extrn add_task:near

; ----------------------------------------------------
; === External data (from main.asm) ===
; ----------------------------------------------------
extrn endBuffer:byte, descriptionBuffer:byte
;DATOS DE AGREGAR.ASM (ORIGINALMENTE)
extrn colorAgregar:byte, msg_add:byte, msg_add2:byte
extrn separador2:byte, encabezado2:byte, espacioTarea2:byte
extrn descripcion:byte, anio:word, anioStr:byte
extrn mes:byte, mesStr:byte, dia:byte, diaStr:byte
extrn controlesAgregar1:byte, controlesAgregar2:byte
extrn controlesAgregar3:byte, controlesAgregar4:byte
extrn letra_Agregar:byte

.data
    ;colorAgregar db 03h
    ;msg_add     db '          _/_/          _/        _/      _/_/_/_/_/                    _/   ',13, 10
    ;            db '       _/    _/    _/_/_/    _/_/_/          _/      _/_/_/    _/_/_/  _/  _/',13, 10
    ;            db '      _/_/_/_/  _/    _/  _/    _/          _/    _/    _/  _/_/      _/_/    ',13, 10
    ;            db '     _/    _/  _/    _/  _/    _/          _/    _/    _/      _/_/  _/  _/  ',13, 10
    ;            db '    _/    _/    _/_/_/    _/_/_/          _/      _/_/_/  _/_/_/    _/    _/ ',13, 10,'$'

    ;msg_add2    db 13, 10, 'Ingrese una descripcion de maximo 29 caracteres.',13, 10
    ;            db 'Ingrese la fecha limite en el formato especifico (YYYY-MM-DD)',13, 10, '$'
    ;separador2      db '+-----------------------------+-------------+----------+----------+',13,10,'$'
    ;encabezado2     db '| Descripcion                 | Anio (YYYY) | Mes (MM) | Dia (DD) |',13,10,'$'
    ;espacioTarea2   db '|                             |             |          |          |',13,10,'$'

    ;descripcion db 30 dup('$')    ; espacio para caracteres ingresados    
    ;anio dw 2025d
    ;anioStr db '0000$'            ; Aquí se imprimirá el año como cadena
    ;mes db 01d
    ;mesStr db '00$'              ; Aquí se imprimirá el mes como cadena
    ;dia db 01d
    ;diaStr db '00$'              ; Aquí se imprimirá el día como cadena

    ;controlesAgregar1 db '[A]Aumentar Anio..  [D]Disminuir Anio..  [Q]Cancelar$'
    ;controlesAgregar2 db '[A]Aumentar Mes..  [D]Disminuir Mes..  [Q]Cancelar  $'
    ;controlesAgregar3 db '[A]Aumentar Dia..  [D]Disminuir Dia..  [Q]Cancelar  $'
    ;controlesAgregar4 db '[Enter]Continuar$'
    ;letra_Agregar db ' '

.code
mainAgregar proc near

    ;mov ax, @data
    ;mov ds, ax
    ;mov es, ax

    ; Apuntar ES a memoria de video
    ;mov ax, 0B800h
    ;mov es, ax
    
    ; Limpiar pantalla
    xor di, di
    mov cx, 80*25
    mov ah, [colorAgregar]
    mov al, ' '
    rep stosw

    ; Imprimir banner
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 0
    int 10h

    lea dx, msg_add
    mov ah, 09h
    int 21h

    ; Mostrar instrucciones
    mov ah, 02h
    mov dh, 7
    mov dl, 0
    int 10h

    lea dx, msg_add2
    mov ah, 09h
    int 21h

    mov dl, 10
    mov ah, 02h
    int 21h 

    lea dx, separador2
    mov ah, 09h
    int 21h

    lea dx, encabezado2
    mov ah, 09h
    int 21h

    lea dx, separador2
    mov ah, 09h
    int 21h 

    lea dx, espacioTarea2
    mov ah, 09h
    int 21h

    lea dx, separador2
    mov ah, 09h
    int 21h 

    mov ah, 02h
    mov dh, 17
    mov dl, 1
    int 10h

    lea dx, controlesAgregar4
    mov ah, 09h
    int 21h

    DescripcionReturn:
    ; Posicionar cursor para descripción
    mov ah, 02h
    mov dh, 14
    mov dl, 1
    int 10h

    xor cx, cx
    lea si, descripcion

    read_descripcion:
    mov ah, 01h
    int 21h
    cmp al, 13
    je fin_descripcion

    mov [si], al
    inc si
    inc cx
    cmp cx, 29
    jl read_descripcion
    fin_descripcion:
    cmp cx , 0
    je DescripcionReturn

    push cx

    ; Mostrar controles
    mov ah, 02h
    mov dh, 17
    mov dl, 1
    int 10h

    lea dx, controlesAgregar1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov dh, 18
    mov dl, 1
    int 10h

    lea dx, controlesAgregar4
    mov ah, 09h
    int 21h

    ;Inicio leer anio **********************************************************************************************************
    read_anio:
    mov ax, anio
    call to_string_anio

    mov ah, 02h
    mov dh, 14
    mov dl, 35
    int 10h
    
    lea dx, anioStr
    mov ah, 09h
    int 21h

    ; Esperar tecla
    mov ah, 08h
    int 21h
    mov letra_Agregar, al

    cmp letra_Agregar, 'a'
    je AumentarAnio

    cmp letra_Agregar, 'd'
    je DisminuirAnio

    cmp letra_Agregar, 13
    je MensajeMes

    cmp letra_Agregar, 'q'
    jne read_anio

    jmp Cancelar

    AumentarAnio:
    inc anio
    jmp read_anio

    DisminuirAnio:
    dec anio
    jmp read_anio
    ;Fin leer anio *************************************************************************************************************

    ;Mostrar controles
    MensajeMes:
    mov ah, 02h
    mov dh, 17
    mov dl, 1
    int 10h
    
    lea dx, controlesAgregar2
    mov ah, 09h
    int 21h
    ;Inicio leer mes ************************************************************************************************************
    read_mes:
    mov al, mes
    mov ah, 0
    call to_string_mes

    mov ah, 02h
    mov dh, 14
    mov dl, 49
    int 10h

    lea dx, mesStr
    mov ah, 09h
    int 21h

    ; Esperar tecla
    mov ah, 08h
    int 21h
    mov letra_Agregar, al

    cmp letra_Agregar, 'a'
    je AumentarMes

    cmp letra_Agregar, 'd'
    je DisminuirMes

    cmp letra_Agregar, 13
    je MensajeDia

    cmp letra_Agregar, 'q'
    jne read_mes

    jmp Cancelar

    AumentarMes:
    cmp mes, 12
    je read_mes

    inc mes
    jmp read_mes

    DisminuirMes:
    cmp mes, 1
    je read_mes

    dec mes
    jmp read_mes        
    ;Fin leer mes ***************************************************************************************************************

    MensajeDia:
    mov ah, 02h
    mov dh, 17
    mov dl, 1
    int 10h

    lea dx, controlesAgregar3
    mov ah, 09h
    int 21h

    ;Inicio leer dia ************************************************************************************************************
    read_dia:
    mov al, dia
    mov ah, 0
    call to_string_dia

    mov ah, 02h
    mov dh, 14
    mov dl, 60
    int 10h

    lea dx, diaStr
    mov ah, 09h
    int 21h

    ; Esperar tecla
    mov ah, 08h
    int 21h
    mov letra_Agregar, al

    cmp letra_Agregar, 'a'
    je AumentarDia

    cmp letra_Agregar, 'd'
    je DisminuirDia

    cmp letra_Agregar, 13
    je Salir

    cmp letra_Agregar, 'q'
    jne read_dia    

    jmp Cancelar

    AumentarDia:
    cmp dia, 31
    je read_dia

    inc dia
    jmp read_dia

    DisminuirDia:
    cmp dia, 1
    je read_dia

    dec dia
    jmp read_dia
    ;Fin leer dia *************************************************************************************************************** 

    Cancelar:
    call main

    Salir:
    pop cx 
    lea si, descripcion
    lea di, descriptionBuffer
    mov bx, cx           ; bx = cantidad de caracteres ingresados
    mov ah, 0            ; asegurarse de que ah=0

    copy_desc_loop:
    cmp bx, 0
    je end_copy_desc
    mov al, [si]
    mov [di], al
    inc si
    inc di
    dec bx
    jmp copy_desc_loop

    end_copy_desc:
    mov byte ptr [di], '$'
    
    call format_date_end
    call add_task
    call main
mainAgregar endp

; ------------------------------------------------------------
; Convierte AX (anio) en ASCII y guarda en anioStr
; ------------------------------------------------------------
to_string_anio proc near
    push ax
    push bx
    push cx
    push dx
    lea di, anioStr
    mov cx, 4
    mov bx, 10
    add di, 3
.conv_loop_anio:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    loop .conv_loop_anio
    pop dx
    pop cx
    pop bx
    pop ax
    ret
to_string_anio endp

; ------------------------------------------------------------
; Convierte AX (mes) en ASCII y guarda en mesStr
; ------------------------------------------------------------
to_string_mes proc near
    push ax
    push bx
    push cx
    push dx
    lea di, mesStr
    mov cx, 2
    mov bx, 10
    add di, 1
.conv_loop_mes:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    loop .conv_loop_mes
    pop dx
    pop cx
    pop bx
    pop ax
    ret
to_string_mes endp

; ------------------------------------------------------------
; Convierte AX (dia) en ASCII y guarda en diaStr
; ------------------------------------------------------------
to_string_dia proc near
    push ax
    push bx
    push cx
    push dx
    lea di, diaStr
    mov cx, 2
    mov bx, 10
    add di, 1
.conv_loop_dia:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    loop .conv_loop_dia
    pop dx
    pop cx
    pop bx
    pop ax
    ret
to_string_dia endp

    format_date_end proc near
        lea si, endBuffer ; Cambiar por endBuffer
        lea di, anioStr ; Cambiar por el que se usa en Agregar.asm
        mov cx, 4
        @copy_year_buffer:
            mov al, [di]
            mov [si], al
            inc si
            inc di
            dec cx
            cmp cx, 0
            je @continue_format1
            jmp @copy_year_buffer

        @continue_format1:
            mov byte ptr [si], '-'
            inc si

        mov cx, 2
        lea di, mesStr ; Cambiar por el que se usa en Agregar.asm
        @copy_month_buffer:
            mov al, [di]
            mov [si], al
            inc si
            inc di
            dec cx
            cmp cx, 0
            je @continue_format2
            jmp @copy_month_buffer

        @continue_format2:
            mov byte ptr [si], '-'
            inc si

        mov cx, 2
        lea di, diaStr ; Cambiar por el que se usa en Agregar.asm
        @copy_day_buffer:
            mov al, [di]
            mov [si], al
            inc si
            inc di
            dec cx
            cmp cx, 0
            je @continue_format3
            jmp @copy_day_buffer

        @continue_format3:
            ret
    format_date_end endp

end mainAgregar

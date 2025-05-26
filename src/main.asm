; ----------------------------------------------------
; Authors: josemanuelpr@ufps.edu.co
;          andresfelipemp@ufps.edu.co
; ----------------------------------------------------

; ----------------------------------------------------
; How to use (with Masm.exe and Link.exe):
; run these commands (include the last ";", this skips the step of naming the output file))

; Masm.exe main.asm ; 
; Masm.exe utils.asm ;
; Masm.exe listar.asm ;
; Masm.exe welcome.asm ;
; Masm.exe bye.asm ;
; Link.exe main.obj welcome.obj bye.obj listar.obj utils.obj ;
; main.exe

; Keep an eye that the "text.txt" file must be in the same directory as the executable.
; ----------------------------------------------------
.model small
.stack 100h
.386

public main

; ----------------------------------------------------
; === External procedures (from utils.asm) ===
; ----------------------------------------------------
extrn open_file:near, close_file:near, read_file:near, add_task:near
extrn print_str:near, print_chr:near, print_number:near, print_newline:near
extrn parse_csv_line:near, count_lines:near, get_current_date:near
extrn calculate_deadline:near

; ----------------------------------------------------
; === External procedures (from Welcome.asm) ===
; ----------------------------------------------------
extrn mainWelcome:near

; ----------------------------------------------------
; === Public data (from main.asm) ===
; ----------------------------------------------------
public idBuffer, descriptionBuffer, creationBuffer, endBuffer
public filename, filehandle, copy_buffer, fileBuffer
public tempBufferAnio, tempBufferMonth, tempBufferday
public currentAnio, currentMes, currentDia, day_diff

; ----------------------------------------------------
; === Public data to Listar.asm (from main.asm) ===
; ----------------------------------------------------
public colorListar, separador, encabezado, espacioTarea
public pos_vertical, cantTareas, letra_Listar, controles
public acumuladorLineas, max_lines, lineas_pintadas, lineasPorPagina

; ----------------------------------------------------
; === Public data to Welcome.asm (from main.asm) ===
; ----------------------------------------------------
public colorWelcome, mensajeProyecto, mensajeDone
public integrante1, integrante2, metodos
public indicacion, salir, agregar
public listar, eliminar, letra_Welcome

; ----------------------------------------------------
; === Public data to Agregar.asm (from main.asm) ===
; ----------------------------------------------------
public colorAgregar, msg_add, msg_add2, separador2
public encabezado2, espacioTarea2, descripcion
public anio, anioStr, mes, mesStr, dia, diaStr
public controlesAgregar1, controlesAgregar2
public controlesAgregar3, controlesAgregar4
public letra_Agregar

; ----------------------------------------------------
; === Public data to Agregar.asm (from main.asm) ===
; ----------------------------------------------------
public colorEliminar, msg_eliminar, msg_eliminar2
public msg_vacio, msg_max, msg_max2, max_lines_str
public controlesEliminar1, controlesEliminar2
public controlesEliminar3, letra_Eliminar
public OpcionID, OpcionIDStr

; ----------------------------------------------------
; === Public data to Bye.asm (from main.asm) ===
; ----------------------------------------------------
public colorBye, msg_thanks1, msg_thanks2
public msg_thanks3, msg_thanks4, msg_thanks5, msg_thanks6
public msg_for1, msg_for2, msg_for3, msg_for4
public msg_for5, msg_for6, msg_using1, msg_using2
public msg_using3, msg_using4, msg_using5, msg_using6
public msg_using7, msg_using8, msg_me1, msg_me2
public msg_me3, msg_me4, final_msg1, final_msg2
public final_msg3, final_msg4, final_msg5

; ----------------------------------------------------
; === Data segment ===
; ----------------------------------------------------
.data
    ;
    filename    db 'text.txt', 0
    filehandle  dw ?
    fileBuffer      db 8192 dup('$')  ; Read buffer
    copy_buffer      db 8192 dup('$')  ; Read buffer
    success_msg db 'File contents:', 13, 10, '$' ; the 13 and 10 are carriage and line feed
    error_msg   db 'Error!', 13, 10, '$'
    error_msg_op   db 'Error opening!', 13, 10, '$'
    error_msg_re   db 'Error reading!', 13, 10, '$'
    error_msg_cl   db 'Error closing!', 13, 10, '$'
    tempBufferAnio db '0000$'
    tempBufferMonth db '00$'
    tempBufferday db '00$'
    currentAnio dw 0d
    currentMes dw 0d
    currentDia dw 0d
    day_diff dw 0

    ; CSV buffers
    idBuffer          db 4 dup('$')        ; 3 digits + null terminator
    descriptionBuffer db 101 dup('$')      ; 100 chars + null
    creationBuffer    db '2025-02-05$' ;11 dup('$')       ; yyyy-mm-dd + null (10+1)
    endBuffer         db '2026-02-05$' ;11 dup('$')       ; Same as creationBuffer
    
    ; Temporary line buffer
    lineBuffer  db 256 dup('$')            ; For reading one CSV line
    currentLine dw 0                     ; Track which line we're processing

    ;DATOS DE LISTAR.ASM   
    colorListar db 03h
    separador   db '+----+-----------------------------+------------+------------+----------------+',13,10,'$'
    encabezado db '| ID | Descripcion                 | Creacion   | Limite     | Dias restantes |',13,10,'$'
    espacioTarea db'|    |                             |            |            |                |',13,10,'$'
    pos_vertical db 3
    cantTareas db 10d
    letra_Listar db ' '
    controles db '[U]Siguiente..  [D]Anterior..  [Q]Salir$'
    acumuladorLineas db 0d
    max_lines db 0
    lineas_pintadas db 0d
    lineasPorPagina db 11d

    ;DATOS DE WELCOME.ASM
    colorWelcome db 0Fh  ; Fondo negro (0), texto blanco (F)
    mensajeProyecto db 'TUDU - TASK PROJECT$'
    mensajeDone db 'DONE BY$'
    integrante1 db 'Andres Felipe Monsalve Perez - 1152353$'
    integrante2 db 'Jose Manuel Perez Rodriguez - 1152375$'
    metodos db 'El programa contiene los siguientes metodos: $'
    indicacion db 'Presione la tecla correspondiente para continuar...$'
    salir db 'q - Salir$'
    agregar db 'a - Agregar$'
    listar db 'l - Listar$'
    eliminar db 'e - Eliminar$'
    letra_Welcome db ' '

    ;DATOS DE AGREGAR.ASM
    colorAgregar db 03h
    msg_add     db '          _/_/          _/        _/      _/_/_/_/_/                    _/   ',13, 10
                db '       _/    _/    _/_/_/    _/_/_/          _/      _/_/_/    _/_/_/  _/  _/',13, 10
                db '      _/_/_/_/  _/    _/  _/    _/          _/    _/    _/  _/_/      _/_/    ',13, 10
                db '     _/    _/  _/    _/  _/    _/          _/    _/    _/      _/_/  _/  _/  ',13, 10
                db '    _/    _/    _/_/_/    _/_/_/          _/      _/_/_/  _/_/_/    _/    _/ ',13, 10,'$'
    msg_add2    db 13, 10, 'Ingrese una descripcion de maximo 29 caracteres.',13, 10
                db 'No ingrese teclas especiales, y TAMPOCO intente borrar.(Seran ignorados)',13,10
                db 'Ingrese la fecha limite en el formato especifico (YYYY-MM-DD)',13, 10, '$'
    separador2      db '+-----------------------------+-------------+----------+----------+',13,10,'$'
    encabezado2     db '| Descripcion                 | Anio (YYYY) | Mes (MM) | Dia (DD) |',13,10,'$'
    espacioTarea2   db '|                             |             |          |          |',13,10,'$'
    descripcion db 29 dup('$')   
    anio dw 2025d
    anioStr db '0000$'
    mes db 01d
    mesStr db '00$'
    dia db 01d
    diaStr db '00$'
    controlesAgregar1 db '[A]Aumentar Anio..  [D]Disminuir Anio..  [Q]Cancelar$'
    controlesAgregar2 db '[A]Aumentar Mes..  [D]Disminuir Mes..  [Q]Cancelar  $'
    controlesAgregar3 db '[A]Aumentar Dia..  [D]Disminuir Dia..  [Q]Cancelar  $'
    controlesAgregar4 db '[Enter]Continuar$'
    letra_Agregar db ' '

    ;DATOS DE ELIMINAR.ASM
    colorEliminar db 03h
    msg_eliminar db '                  ____       _      _         _____         _    ',13, 10
                 db '                 |  _ \  ___| | ___| |_ ___  |_   _|_ _ ___| | __',13, 10
                 db '                 | | | |/ _ \ |/ _ \ __/ _ \   | |/ _` / __| |/ /',13, 10
                 db '                 | |_| |  __/ |  __/ ||  __/   | | (_| \__ \   < ',13, 10
                 db '                 |____/ \___|_|\___|\__\___|   |_|\__,_|___/_|\_\',13, 10, '$'
    msg_eliminar2 db 'Seleccione el ID de la tarea que dese eliminar...$'
    msg_vacio db 'No existe ninguna tarea. Empieza creando tareas$'
    msg_max db 'Seleccion un ID en el rango [1-$'
    msg_max2 db '] ==> (   )$'
    max_lines_str db '000$' 
    controlesEliminar1 db '[S]Siguiente ID..  [A]Anterior ID..  [Q]Cancelar$'
    controlesEliminar2 db '[Enter]Eliminar$'
    controlesEliminar3 db '[Enter]Retroceder..$'
    letra_Eliminar db ' '
    OpcionID db 1d
    OpcionIDStr db '000$'

    ;DATOS DE BYE.ASM
    colorBye db 03h
    msg_thanks1 db ' _______ _                 _        ','$'
    msg_thanks2 db '|__   __| |               | |       ','$'
    msg_thanks3 db '   | |  | |__   __ _ _ __ | | _____ ','$'
    msg_thanks4 db '   | |  |  _ \ / _` |  _ \| |/ / __|','$'
    msg_thanks5 db '   | |  | | | | (_| | | | |   <\__ \','$'
    msg_thanks6 db '   |_|  |_| |_|\__,_|_| |_|_|\_\___/','$'
    msg_for1 db '  __           ','$'
    msg_for2 db ' / _|          ','$'
    msg_for3 db '| |_ ___  _ __ ','$'
    msg_for4 db '|  _/ _ \|  __|','$'
    msg_for5 db '| || (_) | |   ','$'
    msg_for6 db '|_| \___/|_|   ','$'
    msg_using1   db '           _             ','$'
    msg_using2   db '          (_)            ','$'
    msg_using3   db ' _   _ ___ _ _ __   __ _ ','$'
    msg_using4   db '| | | / __| |  _ \ / _` |','$'
    msg_using5   db '| |_| \__ \ | | | | (_| |','$'
    msg_using6   db ' \__,_|___/_|_| |_|\__, |','$'
    msg_using7   db '                    __/ |','$'
    msg_using8   db '                   |___/ ','$'
    msg_me1  db ' _ __ ___   ___ ','$'
    msg_me2  db '|  _   _ \ / _ \','$'
    msg_me3  db '| | | | | |  __/','$'
    msg_me4  db '|_| |_| |_|\___|','$'
    final_msg1 db '************************************','$'
    final_msg2 db '*                                  *','$' 
    final_msg3 db '*  We would like to get your vote  *','$'
    final_msg4 db '*                                  *','$'  
    final_msg5 db '************************************','$'  

; ----------------------------------------------------
; === Code segment and main program ===
; ----------------------------------------------------
.code
    main proc near
        mov ax, @data
        mov ds, ax
        mov ax, 0B800h
        mov es, ax

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

        ; ----------------------------------------------------
        ; 1. Open file
        mov  ax, @data
        mov  ds, ax
        lea  dx, filename

        call open_file
        jc @error_opening
        mov [filehandle], ax

        ; ----------------------------------------------------
        ; 2. Read file
        ; Read file with proper bounds checking
        mov bx, [filehandle]
        mov cx, 8191            ; Read up to buffer size - 1
        lea dx, fileBuffer
        call read_file
        jc @error_reading

        ; Manually null-terminate the buffer
        mov si, dx
        add si, ax              ; AX = bytes read
        mov byte ptr [si], '$'    ; Null-terminate

        ; ----------------------------------------------------
        ; 3. Close file
        mov bx, [filehandle]
        call close_file
        jc @error_closing

    ; ----------------------------------------------------
        ; 6. Test CSV parsing
        ; Parse line 2 (third line, first data record)
        mov si, offset fileBuffer   ; Pointer to loaded CSV data
        mov di, 82d               ; Line index (0=header, 1=first data)
        call parse_csv_line
        jc @error               ; Handle parsing errors

        ;call mainWelcome

        call calculate_deadline

        call print_newline
        call print_newline

        mov ax, -31000
        call print_number
        ;call get_current_date

        ;call add_task

        jmp @finish_program


    @error_opening:
        lea dx, error_msg_op
        jmp @error    
    @error_reading:
        lea dx, error_msg_re
        jmp @error
    @error_closing:
        lea dx, error_msg_cl
        jmp @error
    
    @error:
        mov ah, 09h
        int 21h
        mov ax, 4C01h      ; Exit with error code
        int 21h
        jmp @finish_program


    @finish_program:
        ; Exit (success)
        mov ax, 4C00h
        int 21h
    
    main endp
end main
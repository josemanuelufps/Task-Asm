; utils.asm
.model small
.386

; === External buffers (these are from main.asm) ===
extrn idBuffer:byte, descriptionBuffer:byte
extrn creationBuffer:byte, endBuffer:byte, max_lines:byte
extrn copy_buffer:byte, filename:byte, filehandle:word
extrn fileBuffer:byte, descripcion:byte
extrn tempBufferAnio:byte, tempBufferMonth:byte, tempBufferday:byte
extrn currentAnio:word, currentMes:word, currentDia:word
extrn day_diff:word

public open_file, close_file, read_file
public print_str, print_chr, print_number, print_newline
public parse_csv_line, count_lines, remove_csv_line, get_current_date
public format_date_creation, store_decimal_in_buffer, add_task, calculate_deadline

.code

    ; ---------------------------------------------------------------------
    ; === File Operations ===
    ; ---------------------------------------------------------------------
    ; Opens a file (read-only)
    ; Input:  DS:DX = filename (null-terminated)
    ; Output: AX = handle (CF=1 on error)
    ; ---------------------------------------------------------------------
    open_file proc near
        mov ah, 3Dh         ; DOS open file
        mov al, 0           ; Read-only mode
        int 21h
        ret
    open_file endp

    ; ---------------------------------------------------------------------
    ; Closes a file
    ; Input:  BX = file handle
    ; Output: CF=1 on error
    ; ---------------------------------------------------------------------
    close_file proc near
        mov ah, 3Eh         ; DOS close file
        int 21h
        ret
    close_file endp


    ; ---------------------------------------------------------------------
    ; Reads file content into buffer
    ; Input:  BX = file handle
    ;         CX = max bytes to read
    ;         DS:DX = buffer address
    ; Output: AX = bytes read (CF=1 on error)
    ;         Buffer filled with data + '$' terminator
    ; ---------------------------------------------------------------------
    read_file proc near
        mov ah, 3Fh         ; DOS read file
        int 21h
        jc  @error          ; Jump if error (CF=1)

        ; Add '$' terminator
        mov si, dx          ; Buffer address
        add si, ax          ; AX = bytes read
        mov byte ptr [si], '$'

    @error:
        ret
    read_file endp



    ; ---------------------------------------------------------------------
    ; === Printing Utilities ===
    ; ---------------------------------------------------------------------
    ; Prints a null-terminated string
    ; Input: DS:DX = string address (ends with '$')
    ; Clobbers: AX
    ; ---------------------------------------------------------------------
    print_str proc near
        mov ah, 09h
        int 21h
        ret
    print_str endp


    ; ---------------------------------------------------------------------
    ; Prints a single character
    ; Input: DL = ASCII character
    ; Clobbers: AX
    ; ---------------------------------------------------------------------
    print_chr proc near
        mov ah, 02h
        int 21h
        ret
    print_chr endp

    ; ---------------------------------------------------------------------
    ; Prints a new line
    ; No input, just need to call it (will modifye AX)
    ; Clobbers: AX
    ; ---------------------------------------------------------------------
    print_newline proc near
        mov dl, 13      ; Carriage Return
        call print_chr
        mov dl, 10      ; Line Feed
        call print_chr
        ret
    print_newline endp

    ; ---------------------------------------------------------------------
    ; Prints a 16-bit signed number
    ; Input: AX = number (-32768 to 32767)
    ; Clobbers: AX, BX, CX, DX
    ; ---------------------------------------------------------------------
    print_number proc near
        push bp
        mov bp, sp
        push bx
        push cx
        push dx

        ; Handle negative numbers
        test ax, ax
        jns @positive
        push ax
        mov dl, '-'
        call print_chr
        pop ax
        neg ax
        jz @zero_case  ; Special case for -32768
        
    @positive:
        ; Convert to string
        mov cx, 0
        mov bx, 10
        
    @divide_loop:
        xor dx, dx
        div bx
        push dx
        inc cx
        test ax, ax
        jnz @divide_loop
        
        ; Print digits
    @print_loop:
        pop dx
        add dl, '0'
        call print_chr
        loop @print_loop
        jmp @done
        
    @zero_case:
        mov dl, '0'
        call print_chr
        
    @done:
        pop dx
        pop cx
        pop bx
        pop bp
        ret
    print_number endp

    
    ; ---------------------------------------------------------------------
    ; === CSV Utilities ===
    ; ---------------------------------------------------------------------
    ; ==============================================
    ; Parses a CSV line into separate fields
    ; Input: DS:SI = pointer to CSV line
    ;        DI = line index (0-based)
    ; Output: Fields stored in buffers
    ; Clobbers: AX, BX, CX, DX, SI, DI
    ; ==============================================
    parse_csv_line proc near
        push bp
        mov bp, sp
        push es
        push di
        push si
        
        ; Set ES = DS for string ops
        push ds
        pop es
        
        ; Skip lines
        mov cx, di
        jcxz @parse_fields
    @skip_loop:
        call skip_to_next_line
        jc @parseerror
        loop @skip_loop
        
    @parse_fields:
        ; Parse ID (first field)
        push si
        mov ax, di
        lea si, idBuffer
        call store_decimal_in_buffer
        pop si
        
        ; Parse Description (second field)
        lea di, descriptionBuffer
        call copy_until_semicolon
        mov byte ptr [di], '$'
        
        ; Parse Creation Date (third field)
        lea di, creationBuffer
        call copy_until_semicolon
        mov byte ptr [di], '$'
        
        ; Parse End Date (fourth field)
        lea di, endBuffer
        call copy_until_newline
        mov byte ptr [di], '$'
        
        clc
        jmp @filedone
        
    @parseerror:
        stc
        
    @filedone:
        pop si
        pop di
        pop es
        pop bp
        ret

    ; Helper: Copies until semicolon (exclusive)
    copy_until_semicolon:
        lodsb
        cmp al, ';'
        je @done_copy
        cmp al, 13      ; CR
        je @unexpected_end
        cmp al, '$'       ; EOF
        je @unexpected_end
        stosb
        jmp copy_until_semicolon
    @done_copy:
        ret
    @unexpected_end:
        dec si
        stc
        ret

    ; Helper: Copies until newline (exclusive) 
    copy_until_newline:
        lodsb
        cmp al, 13      ; CR
        je @done_newline
        cmp al, 10      ; LF
        je @done_newline
        cmp al, '$'       ; EOF
        je @done_newline
        stosb
        jmp copy_until_newline
    @done_newline:
        ret

    ; Helper: Skips to next line
    skip_to_next_line:
        lodsb
        cmp al, 10      ; LF
        je @done_skip
        cmp al, '$'       ; EOF
        jne skip_to_next_line
        stc
        ret
    @done_skip:
        clc
        ret
    parse_csv_line endp

    ; ==============================================
    ; Counts how many items are in the CSV and saves
    ; the result inside the max_lines buffer.
    ; Input: DS:SI = pointer to CSV line
    ; Output: amount of items stored in buffer
    ; Clobbers:
    ; ==============================================
    count_lines proc near
        push si
        xor cx, cx          ; Contador de líneas = 0

    @count_loop:
        mov al, [si]
        inc si
        cmp al, '$'         ; ¿Fin de archivo?
        je @end_count
        cmp al, 10          ; ¿Es LF (salto de línea)?
        jne @count_loop
        inc cx              ; Incrementar contador de líneas
        jmp @count_loop

    @end_count:
        mov [max_lines], cl ; Guardar total de líneas
        pop si
        ret
    count_lines endp

    ; ==============================================
    ; Removes the CX-th data line (1=first record after header) from
    ; the CSV text at DS:SI.  Shifts everything after that line up,
    ; preserving the trailing ‘$’ "sentinel".
    ;
    ; Input: CX = 1-based line index to delete (cannot be zero)
    ;
    ; Output: Buffer with that line removed
    ; Clobbers: AX, BX, DX, SI, DI, CX
    ; ==============================================
    remove_csv_line proc near
        push ax
        push bx
        push cx
        push dx

        lea si, fileBuffer

        ; Inicializamos registros
        mov bx, 0             ; Contador de líneas
        ; cx = linea buscada
        lea di, copy_buffer
        jmp @copy_until_line_found

        ; COPIAR HASTA ENCONTRAR LA LÍNEA
        ; Recorrer buffer y COPIA LOS CARACTEES A copy_buffer
    @copy_until_line_found:
        cmp bx, cx
        je @line_found
        mov al, [si]

        mov [di], al
        inc si
        inc di

        cmp al, '$'
        je @end_of_file
        cmp al, 10            ; LF
        jne @copy_until_line_found

        inc bx
        jmp @copy_until_line_found
    
    @end_of_file:
        mov al, 1 ; 1 means error
        jmp @done_rm ; termina el proceso, pues se ingresó alguna línea no válida
        ; tampoco cambia el archivo

    ; LÍNEA ENCONTRADA
    @line_found:
        cmp bl, [max_lines]
        je @remove_last_line

    @skip_line:
        mov al, [si]       ; Leer carácter
        cmp al, '$'        ; ¿Fin de buffer?
        je @done_rm
        inc si             ; AVANZAR siempre
        cmp al, 10         ; ¿Era LF (10h)? 
        jne @skip_line     ; Si no, seguimos saltando
        ; Si era LF, ya avanzamos sobre él y podemos copiar
        jmp @copy_until_eof
    
    @copy_until_eof:
        mov al, [si]
        mov [di], al
        cmp al, '$'
        je @done_rm

        inc si
        inc di
        jmp @copy_until_eof

    @remove_last_line:
        ; Si el último carácter en copy_buffer es LF (10), lo borramos
        lea ax, copy_buffer
        cmp di, ax          ; ¿estamos al principio?
        je @just_term
        dec di
        mov al, [di]
        cmp al, 10                   ; LF?
        jne @just_term
        ; Borramos LF y retrocedemos a CR
        ; (no hacemos INC di, queremos apuntar justo donde estaba el cr)
        lea ax, copy_buffer
        cmp di, ax
        je @just_term
        dec di
        mov al, [di]
        cmp al, 13                   ; CR?
        jne @just_term
        ; Si es CR, retrocedemos antes del CR
        ; así no queda ni CR ni LF
        ; di ya apunta al primer byte del final de la línea anterior

    @just_term:
        ; Colocamos sólo el terminador $
        mov byte ptr [di], '$'


    @done_rm:
        call write_file
        pop dx
        pop cx
        pop bx
        pop ax
        ret

    @line_not_found:
        pop dx
        pop cx
        pop bx
        pop ax
        ret

    remove_csv_line endp


    ; ==============================================
    ;   Converts the value of AX to ASCII decimal.
    ;   Saves each digit inside the desired buffer and ends with ';'
    ;
    ; input:
    ;   SI = buffer
    ;   AX = value (0 to 65535)
    ; output:
    ;   buffer has the ASCII digits and a ';'
    ; Clobbers: AX, BX, CX, DX, SI, DI
    ; ==============================================
    store_decimal_in_buffer proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, 0              ; digit counter

        mov bx, 10             ; divisor decimal
    @convert_loop:
        xor dx, dx             
        div bx                 ; divide AX / BX -> AX=quotient, DX=remainder
        add dl, '0'            ; to ascii
        push dx           
        
        inc cx                 
        mov ax, ax
        cmp ax, 0
        jne @convert_loop

        ; Ahora CX dígitos empezando en SI+1 hasta SI+CX
        ; Copiar en orden correcto a idBuffer
    @copy_loop:
        pop ax
        mov byte ptr [si], al
        inc si
        loop @copy_loop

        ; Ends with $
        mov byte ptr [si], '$'

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    store_decimal_in_buffer endp

    ; ==============================================
    ; Writes the content from a buffer (that ends with $)
    ; to a file (filehandle).
    ; This will count the amount of bytes until $, and write them
    ; to the file, and finally reopening it and saving the new content
    ; to fileBuffer
    ;
    ; Input:  SI = pointer to buffer that's going to be written
    ;              (ending with '$') (copy_buffer)
    ; Clobbers: AX, BX, DX, SI, DI, CX
    ; ==============================================
    write_file proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ; overwrite the file
        mov ah, 3Ch          
        mov cx, 0            
        lea dx, filename
        int 21h
        jc @error_writting
        mov [filehandle], ax

        lea si, fileBuffer

        mov bx, 0          ; contador de saltos de línea encontrados
        mov di, si         ; DI apunta al lector/escritor dentro de fileBuffer

    .find_loop:
        mov al, [si]       ; leer un byte
        cmp al, '$'        ; fin del buffer?
        je .done           ; si llegamos al '$' sin contar CX líneas, terminamos
        inc si

        cmp al, 10         ; ¿LF (10)? (suponiendo CR(13) LF(10))
        jne .find_loop

        ; Encontramos un LF: contamos línea
        inc bx
        cmp bx, cx
        jne .find_loop

        ; Hemos encontrado la CX-ésima línea: 'si' apunta justo después del LF
        ; Vamos a escribir en DI esta posición:
        ; - CR (13), LF (10) para terminar la última línea
        ; - CR, LF para dejar línea vacía
        ; - '$' terminador
        ; Opcional: luego podemos llenar de '$' el resto hasta el tamaño original.

        ; Ajustar DI al punto de truncado
        mov di, si

        ; Escribir CR LF (fin de la línea CX)
        mov byte ptr [di], 13
        inc di
        mov byte ptr [di], 10
        inc di

        ; Escribir CR LF extra (línea vacía)
        mov byte ptr [di], 13
        inc di
        mov byte ptr [di], 10
        inc di

        ; Escribir '$' terminador
        mov byte ptr [di], '$'
        inc di

        ; Rellenar el resto con '$' (opcional)
    .fill_dollars:
        cmp di, si         ; usa aquí tu longitud máxima, por ejemplo fileBuffer+8192
        ; en este ejemplo solo rellenamos unas cuantas para ilustrar
        mov byte ptr [di], '$'
        inc di
        ; repetir hasta el final deseado...
        ; cmp di, end_of_buffer 
        ; jb .fill_dollars

    .done:
        ; Calculate the amount of bytes to write
        lea si, copy_buffer
        xor cx, cx
    @find_len:
        mov al, [si]
        cmp al, '$'
        je @got_len
        inc si
        inc cx
        jmp @find_len

    @got_len:
        ; write contents to file
        mov bx, [filehandle]
        lea dx, copy_buffer
        mov ah, 40h           ; DOS write file
        int 21h
        jc @error

        ; close file
        mov ah, 3Eh
        mov bx, [filehandle]
        int 21h

        ; Reopen file for reading
        mov ah, 3Dh       
        mov al, 0           
        lea dx, filename
        int 21h
        jc @error
        mov [filehandle], ax

        ; clear copy_buffer with '$'
        lea di, copy_buffer
        mov cx, 8192
        mov al, '$'
        rep stosb

        jmp @done_writting

    @error_writting:
    @done_writting:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret

    write_file endp

    ; ==============================================
    ; Gets the current time in yyyy-mm-dd format inside 
    ; the creationDate buffer
    ; Clobbers: AX, BX, DX, SI, DI, CX
    ; ==============================================
    get_current_date proc near

        
        ; clearing creationBuffer
        lea di, creationBuffer
        mov cx, 11
        mov al, '$'
        rep stosb

        ; Date stored in 
        ; AL = day of the week (0=Sunday)
        ; CX = year (1980-2099)
        ; DH = month (1-12)
        ; DL = day (1-31)
        mov ah, 2Ah
        int 21h

        mov ax, cx
        call to_string_anio2

        mov ah, 0
        mov al, dh
        call to_string_mes2

        mov ah, 0
        mov al, dl
        call to_string_dia2

        call format_date_creation

        ret

    get_current_date endp


    ; ------------------------------------------------------------
    ; Dados los buffers de year, month y day (por separado), los coloca
    ; en un buffer (creationBuffer para la de creación, endBuffer para
    ; la de finalización) formateados con "-"
    ; ------------------------------------------------------------
    format_date_creation proc near

        lea si, creationBuffer ; Cambiar por endBuffer
        lea di, tempBufferAnio ; Cambiar por el que se usa en Agregar.asm
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
        lea di, tempBufferMonth ; Cambiar por el que se usa en Agregar.asm
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
        lea di, tempBufferday ; Cambiar por el que se usa en Agregar.asm
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

    format_date_creation endp


    ; ------------------------------------------------------------
    ; Convierte AX (anio) en ASCII y guarda en tempBufferAnio
    ; ------------------------------------------------------------
    to_string_anio2 proc near
        push ax
        push bx
        push cx
        push dx
        lea di, tempBufferAnio
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
    to_string_anio2 endp

    ; ------------------------------------------------------------
    ; Convierte AX (mes) en ASCII y guarda en tempBufferMonth
    ; ------------------------------------------------------------
    to_string_mes2 proc near
        push ax
        push bx
        push cx
        push dx
        lea di, tempBufferMonth
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
    to_string_mes2 endp

    ; ------------------------------------------------------------
    ; Convierte AX (dia) en ASCII y guarda en tempBufferday
    ; ------------------------------------------------------------
    to_string_dia2 proc near
        push ax
        push bx
        push cx
        push dx
        lea di, tempBufferday
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
    to_string_dia2 endp

    ; ==============================================
    ; Adds the task to the bottom. 
    ; In order to call it, you must have to:
    ; 1) Define the description in descriptionBuffer
    ; 2) Define the end date in endDate buffer
    ;
    ; This method handles the creationDate by itself.
    ; Clobbers: AX, BX, DX, SI, DI, CX
    ; ==============================================
    ; ==============================================
    ; add_task:
    ;   1) Lee todo el CSV en fileBuffer
    ;   2) Copia fileBuffer a copy_buffer (incluyendo '$')
    ;   3) Sustituye el '$' final por CR LF
    ;   4) Añade descripción;creationDate;endDate$
    ;   5) Llama a write_full_buffer para reescribir el archivo completo
    ; Clobbers: AX,BX,CX,DX,SI,DI
    ; ==============================================
    add_task proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ; —————————————————————————————
        ; 1) Lee TODO el CSV a fileBuffer
        ; —————————————————————————————
        ; Reads file content into buffer
        ; Input:  BX = file handle
        ;         CX = max bytes to read
        ;         DS:DX = buffer address
        ; Output: AX = bytes read (CF=1 on error)
        ;         Buffer filled with data + '$' terminator
        mov bx, [filehandle]
        lea dx, filename
        mov cx, 8191
        call read_file

        ; —————————————————————————————
        ; 2) Copia fileBuffer → copy_buffer
        ; —————————————————————————————
        lea si, fileBuffer
        lea di, copy_buffer
    .copy_old:
        mov al, [si]
        mov [di], al
        inc si
        inc di
        cmp al, '$'
        jne .copy_old


        dec di
        mov byte ptr [di], 13
        inc di
        mov byte ptr [di], 10
        inc di

        ; fecha actual para creation_buffer
        push di
        call get_current_date 

        lea si, descriptionBuffer
        pop di

    @copy_desc:
        mov al, [si]
        mov [di], al
        inc si
        inc di
        cmp al, '$'
        jne @copy_desc
        dec di
        mov byte ptr [di], ';'
        inc di
        ;    (c) Copia creationBuffer + ';'
        lea si, creationBuffer
    .copy_cre:
        mov al, [si]
        mov [di], al
        inc si
        inc di
        cmp al, '$'
        jne .copy_cre
        dec di
        mov byte ptr [di], ';'
        inc di
        ;    (d) Copia endBuffer + '$'
        lea si, endBuffer
    .copy_end:
        mov al, [si]
        mov [di], al
        inc si
        inc di
        cmp al, '$'
        jne .copy_end

        ; —————————————————————————————
        ; 5) Reescribe el fichero completo
        ; —————————————————————————————
        lea si, copy_buffer
        call write_full_buffer

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    add_task endp


    ; ==============================================
    ; write_full_buffer:
    ;   Sobrescribe el archivo con lo que haya
    ;   en copy_buffer (terminado en '$') y recarga
    ;   fileBuffer para futuras operaciones.
    ;
    ; Input:  SI = &copy_buffer
    ; Clobbers: AX,BX,CX,DX,SI,DI
    ; ==============================================
    write_full_buffer proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ; 1) Cuenta bytes hasta '$'
        xor cx, cx
    .count_loop:
        mov al, [si]
        cmp al, '$'
        je .have_len
        inc cx
        inc si
        jmp .count_loop

    .have_len:
        push cx              ; guardamos longitud en stack

        ; 2) Abre/trunca el fichero
        mov ah, 3Ch
        mov cx, 0            ; atributos normales
        lea dx, filename
        int 21h
        jc .exit_no_write
        mov [filehandle], ax

        ; 3) Recupera longitud para DOS write
        pop cx               ; CX = número de bytes a escribir

        ; 4) Escribe copy_buffer de una sola vez
        mov bx, [filehandle]
        lea dx, copy_buffer
        mov ah, 40h
        int 21h
        jc .exit_no_write


        ; 5) Cierra archivo
        mov ah, 3Eh
        mov bx, [filehandle]
        int 21h

        ; 7) Limpia copy_buffer
        lea di, copy_buffer
        mov cx, 8192
        mov al, '$'
        rep stosb

        mov dl, '!'
        mov ah, 02h
        int 21h

        

    .exit_no_write:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    write_full_buffer endp



    ; ==============================================
    ; Calculates the time between endBuffer and the current time
    ; of the procedure call. Saves the result inside
    ; "(buffer, idk)"
    ;
    ; Input:  SI = &endBuffer
    ; Clobbers: AX,BX,CX,DX,SI,DI
    ; ==============================================
    calculate_deadline proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ; Clears the buffers (could have trash values)
        mov [currentAnio], 0
        mov [currentMes], 0
        mov [currentDia], 0

        lea si, endBuffer

        mov cx, 4
        @push_year:
            mov ah, 0
            mov al, [si]
            sub al, '0'
            inc si
            push ax
        loop @push_year

        inc si

        mov cx, 2
        @push_month:
            mov ah, 0
            mov al, [si]
            sub al, '0'
            inc si
            push ax
        loop @push_month

        inc si

        mov cx, 2
        @push_day:
            mov ah, 0
            mov al, [si]
            sub al, '0'
            inc si
            push ax
        loop @push_day

        ; Todos los números se encuentra (en crudo) dentro del stack, y en orden
        ; de derecha a izq.
        ; primero los dias, luego meses, y después anios.
        pop ax
        add [currentDia], ax 

        pop ax
        ; voy a probar lo de los shifts, ya que 10x == 8x + 2x
        mov bx, ax      ; guardar el número original
        shl ax, 3       ; AX = n * 8
        mov cx, bx
        shl cx, 1       ; CX = n * 2
        add ax, cx      ; AX = n*8 + n*2 = n*10

        add [currentDia], ax

        xor bx, bx
        xor cx, cx

        ; Dias listos, ahora los meses

        ; Obtener dígitos del mes desde la pila
        pop bx        ; BX = unidades
        pop ax        ; AX = decenas

        ; Calcular mes = decenas * 10 + unidades
        mov cx, ax    ; CX = decenas
        mov ax, cx
        mov cx, 10
        mul cx        ; AX = decenas * 10

        add ax, bx    ; AX = mes (como número completo)

        add [currentMes], ax

        ; Mes listo, ahora el anio
        ; Pop digits
        pop bx        ; unidades
        pop cx        ; decenas
        pop dx        ; centenas
        pop ax        ; millares

        ; AX = millares * 1000
        mov si, 1000
        mul si        ; AX = millares * 1000
        push ax       ; guardamos resultado parcial

        ; CX = decenas * 10
        mov ax, dx    ; AX = centenas
        mov si, 100
        mul si        ; AX = centenas * 100
        push ax

        mov ax, cx    ; AX = decenas
        mov si, 10
        mul si        ; AX = decenas * 10
        push ax

        mov ax, bx    ; unidades
        push ax       ; AX = unidades

        ; Sumar todos los resultados parciales
        xor ax, ax
        pop bx
        add ax, bx
        pop bx
        add ax, bx
        pop bx
        add ax, bx
        pop bx
        add ax, bx
        ; AX ahora contiene el año final
        add [currentAnio], ax

        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx

        ; Ahora a restarle la fecha actual
        ; Date stored in 
        ; AL = day of the week (0=Sunday)
        ; CX = year (1980-2099)
        ; DH = month (1-12)
        ; DL = day (1-31)
        mov ah, 2Ah
        int 21h

        sub [currentAnio], cx
        sub [currentMes], dh
        sub [currentDia], dl


        ; Ahora a ensamblar esos tres buffers en uno solo (en AX)
        ; --- Día ---
        mov ax, [currentDia]    ; AX = currentDia
        ; resultado parcial va en AX
        mov [day_diff], ax

        ; --- Mes ---
        mov ax, [currentMes]
        mov cx, 31
        imul cx                 ; signed AX * 31 → AX = días del mes
        add [day_diff], ax    ; sumamos meses 
        ; day_diff ahora tiene dia + 31*mes
    
        ; --- Año ---
        mov ax, [currentAnio]
        mov cx, 365
        imul cx                 ; BX * 365 → resultado firmado en AX

        ; Ahora sumamos año (AX del año) con day_diff
        add [day_diff], ax

        mov ax, [day_diff]              ; resultado final en AX

        ; Resultado final: AX con signo correcto
        ; también está guardado el resultado en [day_diff]
        call print_number

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    calculate_deadline endp

end ; end of code

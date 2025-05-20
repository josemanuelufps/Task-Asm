; utils.asm
.model small
.386

; === External buffers (these are from main.asm) ===
extrn idBuffer:byte, descriptionBuffer:byte
extrn creationBuffer:byte, endBuffer:byte, max_lines:byte
extrn copy_buffer:byte, filename:byte, filehandle:word
extrn fileBuffer:byte
extrn tempBufferAnio:byte, tempBufferMonth:byte, tempBufferday:byte

public open_file, close_file, read_file
public print_str, print_chr, print_number, print_newline
public parse_csv_line, count_lines, remove_csv_line, get_current_date
public format_date_creation

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
        lea di, idBuffer
        call copy_until_semicolon
        mov byte ptr [di], '$'
        
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
        mov bx, 0           ; Flag para saltar header (0 = saltar, 1 = contar)

    @skip_header:
        mov al, [si]
        inc si
        cmp al, 10          ; ¿Encontró LF (fin de header)?
        je @start_counting
        cmp al, '$'           ; ¿Fin de archivo inesperado?
        je @end_count
        jmp @skip_header

    @start_counting:
        mov bx, 1           ; Marcar que header ya se saltó

    @count_loop:
        mov al, [si]
        inc si
        cmp al, '$'           ; ¿Fin de archivo?
        je @end_count
        cmp al, 10          ; ¿Es LF (salto de línea)?
        jne @count_loop
        inc cx              ; Incrementar contador de líneas de datos
        jmp @count_loop

    @end_count:
        mov [max_lines], cl ; Guardar total de líneas (sin header)
        pop si
        ret
    count_lines endp

    ; ==============================================
    ; Removes the CX-th data line (1=first record after header) from
    ; the CSV text at DS:SI.  Shifts everything after that line up,
    ; preserving the trailing ‘$’ "sentinel".
    ;
    ; Input:  SI = pointer to CSV buffer (header + CRLF + data… + '$')
    ;          CX     = 1-based line index to delete (cannot be zero)
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
        ; Recorrer buffer y copiar los caracteres a copy_buffer
    @copy_until_line_found:
        cmp bx, cx ; bx cuenta las líneas, cx tiene la línea a eliminar
        je @line_found
        ja @line_not_found
        

        mov al, [si]
        cmp al, '$' ; mirar fin del archivo
        je @end_of_file

        cmp al, 10 ; chequear LF (nueva linea, line feed)
        je @newline_found

    @copy_char:
        mov [di], al ; dx apunta al copy_buffer y al tiene el char
        inc si
        inc di
        jmp @copy_until_line_found

    @newline_found:
        inc bx
        jmp @copy_char
    
    @end_of_file:
        mov [di], al
        mov al, 1 ; 1 means error
        jmp @done_rm ; termina el proceso, pues se ingresó alguna línea no válida
        ; tampoco cambia el archivo

    ; LÍNEA ENCONTRADA
    ; ---------------------------------------------------
    ; Se encontró la línea, significa que ahora empieza la parte intermedia de copiado
    @line_found:

        mov al, [si]
        cmp al, '$'
        je @done_rm

        push di ; guarda la posición actual de copy_buffer
        mov di, offset idBuffer
    @start_middle_part:
        ; guarda cada char en id_buffer hasta encontrar ";"
        mov al, [si]
        cmp al, ';'
        je @id_semicolon

        mov [di], al
        inc si
        inc di
        jmp @start_middle_part

    @id_semicolon:
        mov [di], al
        inc si


    @skip_found_line:
        mov al, [si]

        cmp al, '$'
        je @done_rm
        mov al, [si]
        cmp al, 10
        je @second_part

        inc si
        jmp @skip_found_line
    
    ;----------------------------------
    ; now we need to pass the stuff that's inside idBuffer to the modified buffer,
    ; then pass the id from the original to the buffer, and then traverse both pointers
    ; until a line feed (new line). Repeat until EOF.
    @second_part:
        inc si

        mov al, [si]
        cmp al, '$'
        je @done_rm

        pop di ; obtiene la ultima posicion de copy_buffer


    @copy_id_to_modified:
        push si
        lea si, idBuffer
    @copy_id_loop:
        mov al, [si]
        mov [di], al
        inc di
        inc si

        cmp al, '$'
        je @done_rm

        cmp al, ';'
        jne @copy_id_loop


    @collect_original_new_id:
        pop si
        push di
        lea di, idBuffer
    @copy_loop_new_id:
        mov al, [si]       ; tomamos char del origen
        mov [di], al       ; lo guardamos en idBuffer
        inc si
        inc di

        cmp al, '$'
        je @done_rm

        cmp al, ';'        ; llegamos al final del fragmento?
        jne @copy_loop_new_id
        pop di


    @copy_until_lf:
        mov al, [si]       ; leemos de origen
        mov [di], al        ; escribimos en el copy_buffer
        inc si
        inc di
        cmp al, '$'
        je @done_rm
        cmp al, 10        ; es LF??
        jne @copy_until_lf
        jmp @copy_id_to_modified

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



end ; end of code

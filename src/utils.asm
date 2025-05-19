; utils.asm
.model small

; === External buffers (these are from main.asm) ===
extrn idBuffer:byte, descriptionBuffer:byte
extrn creationBuffer:byte, endBuffer:byte, max_lines:byte

public open_file, close_file, read_file
public print_str, print_chr, print_number, print_newline
public parse_csv_line, count_lines

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
        cmp al, 0       ; EOF
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
        cmp al, 0       ; EOF
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
        cmp al, 0       ; EOF
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
    cmp al, 0           ; ¿Fin de archivo inesperado?
    je @end_count
    jmp @skip_header

@start_counting:
    mov bx, 1           ; Marcar que header ya se saltó

@count_loop:
    mov al, [si]
    inc si
    cmp al, 0           ; ¿Fin de archivo?
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

end ; end of code


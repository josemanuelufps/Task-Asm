; utils.asm
.model small

public open_file, close_file, read_file
public print_str, print_chr, print_number, print_newline

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
        
        ; Check if negative
        test ax, ax
        jns @positive
        push ax          ; Save number
        mov dl, '-'
        call print_chr
        pop ax
        neg ax           ; Make positive

    @positive:
        ; Convert to ASCII digits
        mov cx, 0        ; Digit counter
        mov bx, 10       ; Divisor
        
    @divide_loop:
        xor dx, dx
        div bx           ; AX = quotient, DX = remainder
        add dl, '0'      ; Convert to ASCII
        push dx          ; Store digit
        inc cx
        test ax, ax
        jnz @divide_loop
        
        ; Print digits
    @print_loop:
        pop dx
        call print_chr
        loop @print_loop
        
        pop dx
        pop cx
        pop bx
        pop bp
        ret
    print_number endp


end ; end of code


; ----------------------------------------------------
; Authors: josemanuelpr@ufps.edu.co
;          andresfelipemp@ufps.edu.co
; ----------------------------------------------------

; ----------------------------------------------------
; How to use (with Masm.exe and Link.exe):
; run these commands (include the last ";", this skips the step of naming the output file))

; Masm.exe main.asm ; 
; Masm.exe utils.asm ;
; Link.exe main.obj utils.obj ;
; main.exe

; Keep an eye that the "text.txt" file must be in the same directory as the executable.
; ----------------------------------------------------
.model small
.stack 100h
.386

; ----------------------------------------------------
; === External procedures (from utils.asm) ===
; ----------------------------------------------------
extrn open_file:near, close_file:near, read_file:near
extrn print_str:near, print_chr:near, print_number:near, print_newline:near
extrn parse_csv_line:near

; ----------------------------------------------------
; === Data segment ===
; ----------------------------------------------------
public idBuffer, descriptionBuffer, creationBuffer, endBuffer
.data
    ;
    filename    db 'text.txt', 0
    filehandle  dw ?
    fileBuffer      db 4096 dup('$')  ; Read buffer
    success_msg db 'File contents:', 13, 10, '$' ; the 13 and 10 are carriage and line feed
    error_msg   db 'Error!', 13, 10, '$'

    ; CSV buffers
    idBuffer          db 4 dup('$')        ; 3 digits + null terminator
    descriptionBuffer db 101 dup('$')      ; 100 chars + null
    creationBuffer    db 11 dup('$')       ; yyyy-mm-dd + null (10+1)
    endBuffer         db 11 dup('$')       ; Same as creationBuffer
    
    ; Temporary line buffer
    lineBuffer  db 256 dup('$')            ; For reading one CSV line
    currentLine dw 0                     ; Track which line we're processing

; ----------------------------------------------------
; === Code segment and main program ===
; ----------------------------------------------------
.code
    main proc
        mov ax, @data
        mov ds, ax

        ; ----------------------------------------------------
        ; 1. Open file
        lea dx, filename
        call open_file
        jc @error
        mov [filehandle], ax

        ; ----------------------------------------------------
        ; 2. Read file
        ; Read file with proper bounds checking
        mov bx, [filehandle]
        mov cx, 4095            ; Read up to buffer size - 1
        lea dx, fileBuffer
        call read_file
        jc @error

        ; Manually null-terminate the buffer
        mov si, dx
        add si, ax              ; AX = bytes read
        mov byte ptr [si], 0    ; Null-terminate

        ; ----------------------------------------------------
        ; 3. Close file
        mov bx, [filehandle]
        call close_file
        jc @error

        ; ----------------------------------------------------
        ; 4. Print success message + file content
        lea dx, success_msg
        call print_str

        lea dx, fileBuffer
        call print_str
        call print_newline

        ; ----------------------------------------------------
        ; 5. Also, let's print the numbers from 10 to -2 cuz why not
        mov cx, 10       ; Start value (instead of counter)
    @print_numbers:
        mov ax, cx      ; Current number to print
        call print_number
        
        ; Print space between numbers
        mov dl, ' '
        call print_chr
        
        dec cx           ; Move to next number
        cmp cx, -3       ; We want to stop after -2
        jg @print_numbers ; Jump if greater than -3 (stops after -2)
        
        ; Print newline after all numbers
        call print_newline

        ; ----------------------------------------------------
        ; 6. Test CSV parsing
        ; Parse line 2 (third line, first data record)
        mov si, offset fileBuffer   ; Pointer to loaded CSV data
        mov di, 0               ; Line index (0=header, 1=first data)
        call parse_csv_line
        jc @error               ; Handle parsing errors

        ; Print parsed fields
        lea dx, idBuffer
        call print_str
        call print_newline

        lea dx, descriptionBuffer
        call print_str
        call print_newline

        lea dx, creationBuffer
        call print_str
        call print_newline

        lea dx, endBuffer
        call print_str
        call print_newline

        mov si, offset fileBuffer   ; Pointer to loaded CSV data
        mov di, 6               ; Line index (0=header, 1=first data)
        call parse_csv_line
        jc @error               ; Handle parsing errors

        ; Print parsed fields
        lea dx, idBuffer
        call print_str
        call print_newline

        lea dx, descriptionBuffer
        call print_str
        call print_newline

        lea dx, creationBuffer
        call print_str
        call print_newline

        lea dx, endBuffer
        call print_str


        jmp @finish_program

    @error:
        mov ah, 09h
        lea dx, error_msg
        int 21h
        mov ax, 4C01h      ; Exit with error code
        int 21h

    @finish_program:
        ; Exit (success)
        mov ax, 4C00h
        int 21h
    
    main endp
end main
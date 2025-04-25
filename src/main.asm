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


extrn open_file:near, close_file:near, read_file:near
extrn print_str:near, print_chr:near, print_number:near, print_newline:near


.data
    filename    db 'text.txt', 0
    filehandle  dw ?
    buffer      db 4096 dup('$')  ; Read buffer
    success_msg db 'File contents:', 13, 10, '$'
    error_msg   db 'Error!', 13, 10, '$'

.code
    main proc
        mov ax, @data
        mov ds, ax

        ; 1. Open file
        lea dx, filename
        call open_file
        jc @error
        mov [filehandle], ax

        ; 2. Read file
        mov bx, [filehandle]
        mov cx, 4095       ; Max bytes to read (leave space for '$')
        lea dx, buffer
        call read_file
        jc @error

        ; 3. Close file
        mov bx, [filehandle]
        call close_file
        jc @error

        ; 4. Print success message + file content
        lea dx, success_msg
        call print_str

        lea dx, buffer
        call print_str

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
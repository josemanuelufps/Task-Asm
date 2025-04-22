; ----------------------------------------------------
; Authors: josemanuelpr@ufps.edu.co
;          andresfelipemp@ufps.edu.co
; Description: Load tasks from a comma-separated CSV and print the description of the first task
; ----------------------------------------------------

.model small
.stack 100h

.data
    filename    db 'text.txt', 0    ; File name WITH NULL TERMINATOR
    filehandle  dw ?                ; File handler
    buffer      db 4096 dup('$')    ; Read buffer (ENDING WITH $)
    err_msg     db 'Error!', 13, 10, '$'
    success_msg db 'File contents:', 13, 10, '$'

.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; Opening the file
    mov ah, 3Dh         ; DOS open file function (3Dh)
    mov al, 0           ; Reading mode in al
    mov dx, offset filename
    int 21h
    jc error            ; Jump if error (CF==1)

    mov [filehandle], ax ; Save file handle

    ; Reading the file
    mov ah, 3Fh         ; DOS read file function
    mov bx, [filehandle]
    mov cx, 4095        ; Read maximum 4095 bytes
    mov dx, offset buffer
    int 21h
    jc error            ; Jump if error

    ; Add string terminator
    mov si, offset buffer
    add si, ax          ; AX contains bytes read
    mov byte ptr [si], '$'

    ; Close file
    mov ah, 3Eh         ; DOS close file function
    mov bx, [filehandle]
    int 21h

    ; Display success message
    mov ah, 09h
    mov dx, offset success_msg
    int 21h

    ; Display file contents
    mov ah, 09h
    mov dx, offset buffer
    int 21h

    ; Exit
    mov ax, 4C00h
    int 21h

error:
    ; Display error message
    mov ah, 09h
    mov dx, offset err_msg
    int 21h

    ; Exit with error
    mov ax, 4C01h
    int 21h

main endp
end main
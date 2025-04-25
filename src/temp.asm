; ----------------------------------------------------
; This is a temporary file for testing purposes
; ----------------------------------------------------

.model small
.stack 100h

.data
    filename db 'text.txt', 0
    filehandle dw ?
    buffer db 4096 dup('$')
    err_msg db 'Error', 13, 10, '$'
    success_msg db 'File contents:', 13, 10, '$'

.code
main proc near
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; -----------------------------------------------------------
    ; OPENING THE FILE
    ; -----------------------------------------------------------
    mov ah, 3Dh         ; file function (3Dh)
    mov al, 0           
    mov dx, offset filename
    int 21h
    
    jc error ; cf == 1

    mov [filehandle], ax ; Save file handle
    
    ; -----------------------------------------------------------
    ; ACTUALLY READING THE FILE
    ; -----------------------------------------------------------

    mov ah, 3Fh             ; DOS read file function
    mov bx, [filehandle]    ; The handle we just got before
    mov cx, 4095            ; Amount of bytes to read (estimated, we can change it)
                            ; We have to put one minus cuz the "$""
    
    mov dx, offset buffer   ; buffer to store the read data (has to be inside dx)
    int 21h

    jc error

    ; Add string terminator
    mov si, offset buffer
    add si, ax                  ; AX contains bytes read
    mov byte ptr [si], '$'      ; I still haven0t figured out how does this work, but it works
                                ; I think it just adds a "$" at the end of the string
    
    ; -----------------------------------------------------------
    ; Closing the file
    ; -----------------------------------------------------------

    mov ah, 3Eh             ; DOS close file function
    mov bx, [filehandle]    ; The handle we just got before, now to close the file
    int 21h
    
    ; -----------------------------------------------------------
    ; Display success message
    ; -----------------------------------------------------------
    mov ah, 09h
    mov dx, offset success_msg
    int 21h
    
    ; -----------------------------------------------------------
    ; Display file contents
    ; -----------------------------------------------------------
    mov ah, 09h
    mov dx, offset buffer   ; The buffer we have in .data has all the 
                            ; text in text.txt with the "$" at the end
    int 21h
    
    ; Exit
    mov ax, 4C00h
    int 21h

error:
    
    mov ah, 09h
    mov dx, offset err_msg
    int 21h
    
    ; 01 in "AL" for the error
    mov ax, 4C01h
    int 21h

main endp
end main




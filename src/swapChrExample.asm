.model small
.stack 100h

;TODO: comentar lo del stack overflow

.data
    cadena db 'Lorem ipsum dolor sit amet consectetur adipiscing elit fusce aptent, fauci'
           db 'bus bibendum augue malesuada cras dignissim ridiculus orci. Vehicula phare'
           db 'tra integer penatibus eget porta nunc himenaeos ornare praesent phasellus, comm'
           db 'odo suspendisse maecenas aptent tristique taciti pretium senectus molestie cras'
           db ', faucibus erat velit tempus non hac nostra mauris lacinia.$'

.code
main proc
    mov ax, @data
    mov ds, ax
    mov si, offset cadena

procesar:
    mov al, [si]
    cmp al, '$'         ; Fin de cadena
    je imprimir
    cmp al, 'a'         ; Buscar 'a' minúscula
    jne siguiente
    mov byte ptr [si], '?' ; Reemplazar
siguiente:
    inc si
    jmp procesar

imprimir:
    mov ah, 09h
    mov dx, offset cadena
    int 21h
    
    mov ax, 4c00h
    int 21h
main endp
end main
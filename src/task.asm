
.model small
.stack

.data
    archivo db "test.txt$", 0   ; Nombre del archivo
    buffer db 256 dup(0)           ; Buffer para leer una línea
    linea_a_eliminar db "1;Buy milk;2023-09-20;0$", 0 ; Línea que queremos eliminar
    error_msg db 'Error al abrir o manipular el archivo.$', 0
    error_msg2 db 'QUE MIERDA PASA$', 0
    archivo_temp db "temp.txt$", 0
    handle_original dw 0 ; variable para el handle del archivo original


.code
; ----------------------------------------------------
; MAIN
; --------------------------------main:
    ; Inicializar segmento de datos
    mov ax, @data
    mov ds, ax

    ; Abrir archivo original en modo lectura (0x00)
    mov ah, 3Dh
    mov al, 0                 ; Modo: solo lectura
    lea dx, archivo           ; Dirección del archivo
    int 21h                   ; Llamada DOS

    jc error ; Si hubo error, saltar--------------------
main:
    ; Inicializar segmento de datos
    mov ax, @data
    mov ds, ax

    ; Abrir archivo original en modo lectura (0x00)
    mov ah, 3Dh
    mov al, 0                 ; Modo: solo lectura
    lea dx, archivo           ; Dirección del archivo
    int 21h                   ; Llamada DOS

    ;jc error1 ; Si hubo error, saltar
    
    mov [handle_original], ax               ; Guardar el handle del archivo en BX
    ; añadida por andres....                    

    ;CREAMOS EL ARCHIVO TEMPORAL (EL CUAL NO EXISTIA)
    mov ah, 3Ch
    mov cx, 0
    lea dx, archivo_temp
    int 21h                   ; Llamada DOS

    jc error                  ; Si hubo error, saltar

    ; Abrir archivo temporal para escritura
    lea dx, archivo_temp      ; Nombre del archivo temporal
    mov ah, 3Dh
    mov al, 1                 ; Modo: escritura
    int 21h                   ; Llamada DOS

    jc error                  ; Si hubo error, saltar

    jmp leer_archivo         ; Leer el archivo original

;_______________________________________________________________
;aparentemente esta bien hasta este punto.
;algo pasa, como que ya no esta bien AJSJAJS, pasa en la linea 41 con el jc error
;pero la verdad no se que es lo que pasa , ayuda JOSE
;_______________________________________________________________

error:
    ; Si hubo algún error en las operaciones
    mov ah, 09h
    lea dx, error_msg
    int 21h
    mov ah, 4Ch
    int 21h

error1:
    ; Si hubo algún error en las operaciones
    mov ah, 09h
    lea dx, error_msg2
    int 21h
    mov ah, 4Ch
    int 21h

; ----------------------------------------------------
; LEER ARCHIVO
; ----------------------------------------------------

leer_archivo:
    ; Leer un bloque del archivo (ej. 512 bytes)
    mov ah, 3Fh
    lea dx, buffer           ; Buffer para almacenar datos leídos
    mov cx, 512              ; Tamaño del buffer
    mov bx, [handle_original] ; anteriormente HO se quedo con el handle del archivo
    int 21h
    jc error         ; Si hay error, salta

    ; Verificar fin de archivo (AX=0 bytes leídos)
    or ax, ax
    jz fin

    ; Procesar el buffer buscando líneas
    lea si, buffer           ; SI apunta al inicio del buffer
    mov cx, ax               ; CX = bytes leídos

procesar_buffer:
    ; Buscar salto de línea (0Dh 0Ah)
    mov al, [si]            ; Lee un byte del buffer
    cmp al, 0Dh             ; ¿Es carriage return? (inicio de línea)
    jne siguiente_byte
    cmp byte ptr [si+1], 0Ah ; ¿Siguiente byte es line feed? (salto de línea)
    jne siguiente_byte

    ; Encontramos un salto de línea: procesar la línea aquí
    ; ... (tu lógica para comparar o copiar la línea)
    lea di, linea_a_eliminar ; DI apunta a la línea objetivo
    call comparar_linea

    add si, 2               ; Avanza 2 bytes (CR LF)
    sub cx, 2               ; Reduce el contador
    jmp procesar_buffer

siguiente_byte:
    inc si                  ; Avanza al siguiente byte
    dec cx                  ; Decrementa contador
    jnz procesar_buffer     ; Repite hasta procesar todo el buffer

    jmp leer_archivo        ; Lee el siguiente bloque

linea_encontrada:
    ; No copiar la línea al archivo temporal, simplemente saltar
    jmp leer_archivo


; ----------------------------------------------------
; METODO COMPARAR LINEAS
; ----------------------------------------------------
comparar_linea:
    push si
    push di

.next_char:
    mov al, [si]       ; cargar carácter desde buffer
    mov bl, [di]       ; cargar carácter desde línea objetivo

    cmp al, bl         ; ¿son iguales?
    jne .no_igual      ; si no son iguales, salir

    cmp al, '$'        ; ¿llegamos al final de la cadena?
    je .igual          ; si ambos terminaron en '$', son iguales

    inc si             ; avanzar al siguiente carácter
    inc di
    jmp .next_char

.igual:
    pop di
    pop si
    ret                ; ZF = 1

.no_igual:
    pop di
    pop si
    ret                ; ZF = 0

fin:
    ; Cerrar archivo original
    mov ah, 3Eh
    int 21h

    ; Cerrar archivo temporal
    lea dx, archivo_temp
    mov ah, 3Eh
    int 21h

    ; Eliminar archivo original
    lea dx, archivo
    mov ah, 41h
    int 21h

    ; Renombrar archivo temporal a archivo original
    lea dx, archivo_temp
    lea si, archivo
    mov ah, 56h
    int 21h

    ; Terminar programa
    mov ah, 4Ch
    int 21h

end main



.model small
.stack
.386

; ----------------------------------------------------
; === External data (from main.asm) ===
; ----------------------------------------------------
;DATOS DE BYE.ASM (ORIGINALMENTE)
extern colorBye:byte, msg_thanks1:byte, msg_thanks2:byte
extern msg_thanks3:byte, msg_thanks4:byte, msg_thanks5:byte, msg_thanks6:byte
extern msg_for1:byte, msg_for2:byte, msg_for3:byte, msg_for4:byte
extern msg_for5:byte, msg_for6:byte, msg_using1:byte, msg_using2:byte
extern msg_using3:byte, msg_using4:byte, msg_using5:byte, msg_using6:byte
extern msg_using7:byte, msg_using8:byte, msg_me1:byte, msg_me2:byte
extern msg_me3:byte, msg_me4:byte, final_msg1:byte, final_msg2:byte
extern final_msg3:byte, final_msg4:byte, final_msg5:byte

public mainBye

.data
    ;colorBye db 03h
    ;msg_thanks1 db ' _______ _                 _        ','$'
    ;msg_thanks2 db '|__   __| |               | |       ','$'
    ;msg_thanks3 db '   | |  | |__   __ _ _ __ | | _____ ','$'
    ;msg_thanks4 db '   | |  |  _ \ / _` |  _ \| |/ / __|','$'
    ;msg_thanks5 db '   | |  | | | | (_| | | | |   <\__ \','$'
    ;msg_thanks6 db '   |_|  |_| |_|\__,_|_| |_|_|\_\___/','$'
    ;msg_for1 db '  __           ','$'
    ;msg_for2 db ' / _|          ','$'
    ;msg_for3 db '| |_ ___  _ __ ','$'
    ;msg_for4 db '|  _/ _ \|  __|','$'
    ;msg_for5 db '| || (_) | |   ','$'
    ;msg_for6 db '|_| \___/|_|   ','$'
    ;msg_using1   db '           _             ','$'
    ;msg_using2   db '          (_)            ','$'
    ;msg_using3   db ' _   _ ___ _ _ __   __ _ ','$'
    ;msg_using4   db '| | | / __| |  _ \ / _` |','$'
    ;msg_using5   db '| |_| \__ \ | | | | (_| |','$'
    ;msg_using6   db ' \__,_|___/_|_| |_|\__, |','$'
    ;msg_using7   db '                    __/ |','$'
    ;msg_using8   db '                   |___/ ','$'
    ;msg_me1  db ' _ __ ___   ___ ','$'
    ;msg_me2  db '|  _   _ \ / _ \','$'
    ;msg_me3  db '| | | | | |  __/','$'
    ;msg_me4  db '|_| |_| |_|\___|','$'
    ;final_msg1 db '************************************','$'
    ;final_msg2 db '*                                  *','$' 
    ;final_msg3 db '*  We would like to get your vote  *','$'
    ;final_msg4 db '*                                  *','$'  
    ;final_msg5 db '************************************','$'       

.code
mainBye proc near
    ; Apuntar ES a memoria de video
    mov ax, 0B800h
    mov es, ax
    
    ; Configurar para llenar pantalla
    xor di, di  ; Empezar en posición 0
    mov cx, 80*25   ; Número de caracteres en pantalla
    mov ah, [colorBye] ; Atributo de colore
    mov al, ' ' ; Carácter espacio (para limpiar)

    rep stosw

    ;Mensaje de "THANKS" *************************************************************

    mov ah, 02h
    mov bh, 0
    mov dh, 1   ;Fila
    mov dl, 13   ;Columna
    int 10h
    
    lea dx, msg_thanks1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 2   ;Fila
    mov dl, 13   ;Columna
    int 10h
    
    lea dx, msg_thanks2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 3   ;Fila
    mov dl, 13   ;Columna
    int 10h
    
    lea dx, msg_thanks3
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 4   ;Fila
    mov dl, 13   ;Columna
    int 10h
    
    lea dx, msg_thanks4
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 5   ;Fila
    mov dl, 13   ;Columna
    int 10h
    
    lea dx, msg_thanks5
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 6   ;Fila
    mov dl, 13   ;Columna
    int 10h
    
    lea dx, msg_thanks6
    mov ah, 09h
    int 21h

    ;Mensaje de "FOR" *************************************************************

    mov ah, 02h
    mov bh, 0
    mov dh, 1   ;Fila
    mov dl, 53   ;Columna
    int 10h
    
    lea dx, msg_for1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 2   ;Fila
    mov dl, 53   ;Columna
    int 10h
    
    lea dx, msg_for2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 3   ;Fila
    mov dl, 53   ;Columna
    int 10h
    
    lea dx, msg_for3
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 4   ;Fila
    mov dl, 53   ;Columna
    int 10h
    
    lea dx, msg_for4
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 5   ;Fila
    mov dl, 53   ;Columna
    int 10h
    
    lea dx, msg_for5
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 6   ;Fila
    mov dl, 53   ;Columna
    int 10h
    
    lea dx, msg_for6
    mov ah, 09h
    int 21h

    ;Mensaje de "USING" *************************************************************

    mov ah, 02h
    mov bh, 0
    mov dh, 8   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 9   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 10   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using3
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 11   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using4
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 12   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using5
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 13   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using6
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 14   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using7
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 15   ;Fila
    mov dl, 19   ;Columna
    int 10h
    
    lea dx, msg_using8
    mov ah, 09h
    int 21h

    ;Mensaje de "ME" *************************************************************
    
    mov ah, 02h
    mov bh, 0
    mov dh, 10   ;Fila
    mov dl, 47   ;Columna
    int 10h
    
    lea dx, msg_me1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 11   ;Fila
    mov dl, 47   ;Columna
    int 10h
    
    lea dx, msg_me2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 12   ;Fila
    mov dl, 47   ;Columna
    int 10h
    
    lea dx, msg_me3
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 13   ;Fila
    mov dl, 47   ;Columna
    int 10h
    
    lea dx, msg_me4
    mov ah, 09h
    int 21h

    ;Mensaje de "FINAL" *************************************************************

    mov ah, 02h
    mov bh, 0
    mov dh, 18   ;Fila
    mov dl, 23   ;Columna
    int 10h
    
    lea dx, final_msg1
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 19   ;Fila
    mov dl, 23   ;Columna
    int 10h
    
    lea dx, final_msg2
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 20   ;Fila
    mov dl, 23   ;Columna
    int 10h
    
    lea dx, final_msg3
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 21   ;Fila
    mov dl, 23   ;Columna
    int 10h
    
    lea dx, final_msg4
    mov ah, 09h
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 22   ;Fila
    mov dl, 23   ;Columna
    int 10h
    
    lea dx, final_msg5
    mov ah, 09h
    int 21h

    ; Finalizar programa
    ret
mainBye endp
end mainBye

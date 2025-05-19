.model small
.stack 100h
.386

public mainWelcome

; ----------------------------------------------------
; === External procedures (from Listar.asm) ===
; ----------------------------------------------------
extern mainListar:near

; ----------------------------------------------------
; === External procedures (from Bye.asm) ===
; ----------------------------------------------------
extern mainBye:near

; ----------------------------------------------------
; === External data (from main.asm) ===
; ----------------------------------------------------
;DATOS DE WELCOME.ASM (ORIGINALMENTE)
extrn colorWelcome:byte, mensajeProyecto:byte, mensajeDone:byte
extrn integrante1:byte, integrante2:byte, metodos:byte
extrn indicacion:byte, salir:byte, agregar:byte
extrn listar:byte, eliminar:byte, letra_Welcome:byte

.data
    ;colorWelcome db 0Fh  ; Fondo negro (0), texto blanco (F)
    ;mensajeProyecto db 'TUDU - TASK PROJECT$'
    ;mensajeDone db 'DONE BY$'
    ;integrante1 db 'Andres Felipe Monsalve Perez - 1152353$'
    ;integrante2 db 'Jose Manuel Perez Rodriguez - 1152375$'
    ;metodos db 'El programa contiene los siguientes metodos: $'
    ;indicacion db 'Presione la tecla correspondiente para continuar...$'
    ;salir db 'q - Salir$'
    ;agregar db 'a - Agregar$'
    ;listar db 'l - Listar$'
    ;eliminar db 'e - Eliminar$'
    ;letra_Welcome db ' '    

.code
mainWelcome proc near
    ;mov ax, @data
    ;mov ds, ax
    
    ; Apuntar ES a memoria de video
    Inicio:
    mov ax, 0B800h
    mov es, ax
    
    ; Configurar para llenar pantalla
    xor di, di  ; Empezar en posición 0
    mov cx, 80*25   ; Número de caracteres en pantalla
    mov ah, [colorWelcome] ; Atributo de colore
    mov al, ' ' ; Carácter espacio (para limpiar)
    
    ; Llenar pantalla
    rep stosw   ; Almacenar AX (AH=color, AL=carácter) en ES:DI

    ;================================================================================================
    ;================================================================================================
    ;Se empieza a imprimir el dibujo

    ;Carácter 1
    mov di, (2 * 80 + 3) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 4) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 5) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 6) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 7) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 8) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 9) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 10) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 6) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 7) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 6) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 7) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 6) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 7) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 6) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 7) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ;Fin letra T

    ;Carácter 2
    mov di, (2 * 80 + 12) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 13) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 12) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 13) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (4 * 80 + 12) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 13) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 12) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 13) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (6 * 80 + 12) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 13) * 2
    mov ax, 0700h or 219
    mov es:[di], ax  

    mov di, (6 * 80 + 14) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 15) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 16) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 17) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 18) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 17) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 18) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (4 * 80 + 17) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 18) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 17) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 18) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (6 * 80 + 17) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 18) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ; Fin letra U

    ;Carácter 3
    mov di, (2 * 80 + 20) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 21) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 20) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 21) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (4 * 80 + 20) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 21) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 20) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 21) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (6 * 80 + 20) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 21) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 22) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 23) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 22) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 24) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 24) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 24) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 23) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 25) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 25) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 25) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ;Fin letra D

    ;Carácter 4
    mov di, (2 * 80 + 27) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 28) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 27) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 28) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (4 * 80 + 27) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 28) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 27) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 28) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (6 * 80 + 27) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 28) * 2
    mov ax, 0700h or 219
    mov es:[di], ax  

    mov di, (6 * 80 + 29) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 30) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 31) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 32) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 33) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 32) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 33) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (4 * 80 + 32) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 33) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 32) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 33) * 2
    mov ax, 0700h or 219
    mov es:[di], ax   

    mov di, (6 * 80 + 32) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 33) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ; Fin letra U

    ;Separador
    mov di, (4 * 80 + 37) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 38) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 39) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 40) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ;Fin separador

    ;Carácter 5
    mov di, (2 * 80 + 44) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 45) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 46) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 47) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 48) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 49) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 50) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 51) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 47) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 48) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 47) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 48) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 47) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 48) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 47) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 48) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ;Fin letra T

    ;Carácter 6
    mov di, (3 * 80 + 53) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 54) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 53) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 54) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 53) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 54) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 53) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 54) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 55) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 56) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 57) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 58) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 55) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 56) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 57) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 58) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 59) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 60) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 59) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 60) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 59) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 60) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 59) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 60) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ;Fin letra A

    ;Carcácter 7
    mov di, (2 * 80 + 62) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 63) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 64) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 65) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 66) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 67) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 62) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 63) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 64) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 65) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 66) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 67) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 62) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 67) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 62) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 63) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 64) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 65) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 66) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 67) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ;Fin Letra S

    ;Caracter 8
    mov di, (2 * 80 + 69) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 70) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (3 * 80 + 69) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 70) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 69) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 70) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 69) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 70) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 69) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 70) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 71) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (4 * 80 + 72) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 73) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (3 * 80 + 74) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 73) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (5 * 80 + 74) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 75) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (2 * 80 + 76) * 2
    mov ax, 0700h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 75) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    
    mov di, (6 * 80 + 76) * 2
    mov ax, 0700h or 219
    mov es:[di], ax
    ;Fin letra K
    ;================================================================================================
    ;================================================================================================
    ;Logo ufps

    ;Letra U
    mov di, (11 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax   

    mov di, (13 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax   

    mov di, (15 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax  

    mov di, (15 * 80 + 8) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 9) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 10) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 11) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 12) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 11) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 12) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax   

    mov di, (13 * 80 + 11) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 12) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 11) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 12) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax   

    mov di, (15 * 80 + 11) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 12) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax 
    ; Fin letra U

    ;Letra F
    mov di, (11 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax 

    mov di, (11 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax 

    mov di, (12 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax 

    mov di, (13 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax 

    mov di, (14 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax 

    mov di, (15 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 18) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 19) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 20) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    
    mov di, (11 * 80 + 21) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 18) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 19) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 20) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    
    mov di, (13 * 80 + 21) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    ;Fin letra F

    ;Letra P
    mov di, (18 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax   

    mov di, (20 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax   

    mov di, (22 * 80 + 6) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 7) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 8) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    
    mov di, (18 * 80 + 9) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 10) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 11) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 8) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    
    mov di, (20 * 80 + 9) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 10) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 11) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 12) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    ;Fin letra P

    ;Letra S
    mov di, (18 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 18) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 19) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 20) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 21) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    
    mov di, (20 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 18) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 19) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 20) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 21) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 21) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 15) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 16) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 17) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 18) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 19) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 20) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 21) * 2
    mov ax, 0F00h or 219
    mov es:[di], ax
    ;Fin letra S

    ;Borde rojo
    mov di, (10 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 6) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 7) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 11) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 15) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 16) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 17) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (23 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 6) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 7) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 11) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 15) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 16) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 17) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (17 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 5) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (17 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 13) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (17 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 14) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (17 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 22) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 6) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 7) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 11) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 15) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 16) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 17) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 6) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 7) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 11) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 15) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 16) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 17) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    ;Fin borde rojo

    ;Interior letras
    mov di, (11 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (12 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (14 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    
    mov di, (15 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 11) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 11) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 15) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 16) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 17) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 21) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 16) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 17) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 18) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 19) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 20) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 8) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 9) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 10) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 11) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 12) * 2
    mov ax, 0400h or 219
    mov es:[di], ax
    ;Fin interior letras
    ;================================================================================================
    ;================================================================================================
    ;Pintar todo el borde
    mov di, (8 * 80 + 0) * 2
    mov ax, 1100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 1) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 2) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 3) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 4) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 5) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 6) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 7) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 8) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 9) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 10) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 11) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 12) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 13) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 14) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 15) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 16) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 17) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 18) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 19) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 20) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 21) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 22) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 23) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 24) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 25) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 26) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 27) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 28) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 29) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 30) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 31) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 32) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 33) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 34) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 35) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 36) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 37) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 38) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 39) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 40) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 41) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 42) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 43) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 44) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 45) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 46) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 47) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 48) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 49) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 50) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 51) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 52) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 53) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 54) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 55) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 56) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 57) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 58) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 59) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 60) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 61) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 62) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 63) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 64) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 65) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 66) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 67) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 68) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 69) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 70) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 71) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 72) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 73) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 74) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 75) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 76) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 77) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 78) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax
    ;Fin borde parte 1
    ;================================================================================================
    mov di, (1 * 80 + 0) * 2
    mov ax, 1100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 1) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 2) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 3) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 4) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 5) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 6) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 7) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 8) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 9) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 10) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 11) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 12) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 13) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 14) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 15) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 16) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 17) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 18) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 19) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 20) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 21) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 22) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 23) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 24) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 25) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 26) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 27) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 28) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 29) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 30) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 31) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 32) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 33) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 34) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 35) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 36) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 37) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 38) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 39) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 40) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 41) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 42) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 43) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 44) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 45) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 46) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 47) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 48) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 49) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 50) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 51) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 52) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 53) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 54) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 55) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 56) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 57) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 58) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 59) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 60) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 61) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 62) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 63) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 64) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 65) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 66) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 67) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 68) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 69) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 70) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 71) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 72) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 73) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 74) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 75) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 76) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 77) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 78) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (1 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax
    ;Fin borde parte 2
    ;================================================================================================
    mov di, (24 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 1) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 2) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 3) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 4) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 5) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 6) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 7) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 8) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 9) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 10) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 11) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 12) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 13) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 14) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 15) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 16) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 17) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 18) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 19) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 20) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 21) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 22) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 23) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 24) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 25) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 26) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 27) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 28) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 29) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 30) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 31) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 32) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 33) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 34) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 35) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 36) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 37) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 38) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 39) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 40) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 41) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 42) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 43) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 44) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 45) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 46) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 47) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 48) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 49) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 50) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 51) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 52) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 53) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 54) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 55) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 56) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 57) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 58) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 59) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 60) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 61) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 62) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 63) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 64) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 65) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 66) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 67) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 68) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 69) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 70) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 71) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 72) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 73) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 74) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 75) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 76) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 77) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 78) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax
    ;Fin borde parte 3
    ;================================================================================================
    mov di, (1 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (2 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (3 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (4 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (5 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (6 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (7 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (9 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 0) * 2
    mov ax, 0100h or 219
    mov es:[di], ax
    ;Fin borde parte 4
    ;================================================================================================
    mov di, (1  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (2  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (3  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (4  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (5  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (6  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (7  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (8  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (9  * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (10 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (11 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (12 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (13 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (14 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (15 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (16 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (17 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (18 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (19 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (20 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (21 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (22 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (23 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax

    mov di, (24 * 80 + 79) * 2
    mov ax, 0100h or 219
    mov es:[di], ax
    ;Fin borde parte 5
    ;================================================================================================
    ;================================================================================================

    IMPRIMIR:
    ;Mensaje 1
    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 10           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 42        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h                ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, mensajeProyecto       ; Dirección de la cadena de texto
    int 21h                ; Llamada a la interrupción de MS-DOS

    ;Mensaje 2
    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 11           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 47        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, mensajeDone       ; Dirección de la cadena de texto
    int 21h

    ;Integrantes
    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 13           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 32        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h               ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, integrante1    ; Dirección de la cadena de texto
    int 21h

    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 14           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 33        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h                ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, integrante2    ; Dirección de la cadena de texto
    int 21h

    ;Metodos
    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 16           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 30        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h               ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, metodos    ; Dirección de la cadena de texto
    int 21h

    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 17          ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 45        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h               ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, agregar    ; Dirección de la cadena de texto
    int 21h

    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 18           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 45        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h               ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, eliminar    ; Dirección de la cadena de texto
    int 21h

    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 19           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 45        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h               ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, listar    ; Dirección de la cadena de texto
    int 21h

    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 20           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 45        ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h               ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, salir    ; Dirección de la cadena de texto
    int 21h

    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 22           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 28       ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h               ; Llamada a la interrupción de video

    mov ah, 09h            ; Función para imprimir cadena de texto
    lea dx, indicacion    ; Dirección de la cadena de texto
    int 21h

    ;================================================================================================
    ;================================================================================================

    ;Escoger opcion
    Opcion:
    mov ah, 02h            ; Función para mover el cursor
    mov bh, 0              ; Página de video (cero es la principal)
    mov dh, 23           ; Número de fila (0-24, con 0 en la parte superior)
    mov dl, 51       ; Número de columna (0-79, con 0 en la parte izquierda)
    int 10h

    mov ah, 08H        ; Función 1: leer carácter con eco
    int 21h          ; Resultado en AL
    mov letra_Welcome, al     ; Guardar el carácter en variable 

    cmp letra_Welcome, 'a'
    je OpcionAgregar

    cmp letra_Welcome, 'e'
    je OpcionEliminar

    cmp letra_Welcome, 'l'
    je OpcionListar

    cmp letra_Welcome, 'q'
    jne Opcion

    jmp Finalizar

    OpcionAgregar:
    ;Llamar a la función para agregar
    jmp Opcion

    OpcionEliminar:
    ;Llamar a la función para eliminar
    jmp Opcion

    OpcionListar:
    call mainListar
    jmp Inicio
    
    Finalizar:
    call mainBye
    ret
mainWelcome endp
end mainWelcome
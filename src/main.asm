; ----------------------------------------------------
; Wiki from microsoft:
; https://learn.microsoft.com/en-us/windows/win32/api/
; ----------------------------------------------------
; Authors: josemanuelpr@ufps.edu.co
;          andresfelipemp@ufps.edu.co

extern  _GetStdHandle@4
extern  _WriteConsoleA@20
extern  _ExitProcess@4

global  _start

section .data
    msg     db "ODIO LAS MOTOS, CULPA DE ARQUITECTURA", 0Ah  ; 0Ah is basically \n at the end
    msgLen  equ $ - msg                ; length

section .text
_start:
    ; GetStdHandle(STD_OUTPUT_HANDLE = -11)
    push    -11
    call    _GetStdHandle@4

    mov     ebx, eax      ;

    ; WriteConsoleA(handle, buffer, length, NULL, NULL)
    push    0             ; lpNumberOfCharsWritten (NULL)
    push    msgLen        ; nNumberOfCharsToWrite
    push    msg           ; lpBuffer
    push    ebx           ; hConsoleOutput
    call    _WriteConsoleA@20

    ; ExitProcess(0)
    push    0
    call    _ExitProcess@4
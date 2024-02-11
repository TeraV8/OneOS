; Prints null-terminated string to the display (teletype output)
; si - String pointer
printStr:
    pusha
    _printStr_loop:
        mov al, [si]
        cmp al, 0
        jne _printStr_char
        popa
        ret
    _printStr_char:
        mov ah, 0x0e
        xor bh, bh
        int 0x10
        add si, 1
        jmp _printStr_loop

; Clears the screen of all text
; bh - text attributes
clearScreen:
    pusha
    mov ax, 0x0600
    xor cx, cx
    mov dx, 0x184f
    int 0x10
    xor bh, bh
    mov ah, 0x02
    xor dx, dx
    int 0x10
    popa
    ret

; Clears the screen to display error message (never returns)
; si - String pointer
displayError:
    push si
    mov bh, 0x4f
    call clearScreen
    mov ah, 0x02
    xor bh, bh
    mov dx, 0x0b0f
    int 0x10
    mov si, STR_ERROR_GENERIC
    call printStr
    mov ah, 0x02
    mov dx, 0x0c00
    int 0x10
    pop si
    call printStr
    mov ah, 0x01
    mov cx, 0x2706
    int 0x10
    mov ax, 0x0e07
    xor bh, bh
    jmp $

STR_ERROR_GENERIC: db "OneOS encountered an error during the boot process.", 0

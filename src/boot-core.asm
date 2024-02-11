; Prints null-terminated string to the display (teletype output)
; si - String pointer (modified)
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
        int 0x10
        add si, 1
        jmp _printStr_loop

; Clears the screen of all text
clearScreen:
    pusha
    mov ax, 0x0600
    mov bh, 0x07
    xor cx, cx
    mov dx, 0x184f
    int 0x10
    mov bh, 0
    mov ah, 0x02
    xor dx, dx
    int 0x10
    popa
    ret

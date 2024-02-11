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
        int 0x10
        add si, 1
        jmp _printStr_loop

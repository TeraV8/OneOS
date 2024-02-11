[org 0x7c00]

mov si, STR_TEST_MESSAGE
call printStr

jmp $

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

STR_TEST_MESSAGE: db "This is a message that is testing. messing testage.", 0x0a, 0x0d, 0

; IMPORTANT this is end of bootsector
times 510 - ($ - $$) db 0
dw 0xaa55

[org 0x7c00]

mov si, STR_TEST_MESSAGE
call printStr

jmp $

%include "boot-core.asm"

STR_TEST_MESSAGE: db "This is a message that is testing. messing testage.", 0x0a, 0x0d, 0

; IMPORTANT this is end of bootsector
times 510 - ($ - $$) db 0
dw 0xaa55

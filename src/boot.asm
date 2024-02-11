[bits 16]
[org 0x7c00]

call clearScreen

mov si, STR_TEST_MESSAGE
call printStr

jmp $

; Pad out first boot section
times 218 - ($ - $$) db 0
; Keep the "mystery bytes" empty to avoid conflict
times 6 db 0
; Supplementary bootcode here

%include "boot-core.asm"

STR_TEST_MESSAGE: db "This is a message that is testing. messing testage.", 0x0a, 0x0d, 0

; Pad out the second boot section
times 440 - ($ - $$) db 0
; Disk signature
dw 0x0000, 0x0000
; Copy protection (0x5a5a to copy protect)
dw 0x0000
; Partition entries
times 64 db 0
; Boot signature
dw 0xaa55

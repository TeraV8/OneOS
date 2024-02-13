[bits 16]
[org 0x7c00]

; Set display resolution (don't change in bootsector!)
mov ax, 0x0003
int 0x10

;mov bh, 0x07
;call clearScreen

mov si, STR_TEST_MESSAGE
;call printStr
jmp displayError

jmp $

; Pad out first boot section
times 218 - ($ - $$) db 0
; Keep the "mystery bytes" empty to avoid conflict
times 6 db 0
; Supplementary bootcode here

%include "boot-core.asm"

STR_TEST_MESSAGE: db 51, "There is no error, but this is a nice error screen.", 0

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

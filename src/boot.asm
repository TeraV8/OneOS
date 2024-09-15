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

STR_TEST_MESSAGE: db 52, "This non-error message is now horizontally centered.", 0

; Pad out the second boot section
times 440 - ($ - $$) db 0
; Disk signature
dw 0x0000, 0x0000
; Copy protection (0x5a5a to copy protect)
dw 0x0000
; Partition entry 1 -- boot volume
db 0x80 ; bootable flag
db 0xFF, 0xFF, 0xFF ; CHS start address
db 0x00 ; partition type
db 0xFF, 0xFF, 0xFF ; CHS end address
dw 0x0001, 0x0000 ; first logical block
dw 0x07FF, 0x0000 ; size in logical blocks
; Partition entry 2
times 16 db 0
; Partition entry 3
times 16 db 0
; Partition entry 4
times 16 db 0
; Boot signature
dw 0xaa55

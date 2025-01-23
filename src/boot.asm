[bits 16]
[org 0x7c00]

mov [STO_DRIVE], dl

; LOCATION: BOOTSECTOR1
; Set display resolution (don't change in bootsector!)
mov ax, 0x0003
int 0x10

mov bh, 0x07
call clearScreen
mov si, STR_INFO_READEXTBOOT
call printStr

; read the next sectors of the boot memory
mov ah, 0x42
mov dl, [STO_DRIVE]
mov si, BUF_DAP
int 0x13

jmp checkForBootPartitions

; Pad out first boot section
times 218 - ($ - $$) db 0
; Keep the "mystery bytes" empty to avoid conflict
times 6 db 0

; LOCATION: BOOTSECTOR2
%include "boot-core.asm"

STR_INFO_READEXTBOOT: db 21, "Preparing bootloader."
BUF_DAP: db 0x10, 0, word 63, dword 0x7e00, qword 1

; Pad out the second boot section
times 439 - ($ - $$) db 0
STO_DRIVE: resb 1
; Disk signature
db "Test"
; Copy protection (0x5a5a to copy protect)
dw 0x0000
; Partition entry 1 -- boot volume
PARTTAB_ENTRY1:
db 0x80 ; bootable flag
db 0xFF, 0xFF, 0xFF ; CHS start address
db 0x7F ; partition type
db 0xFF, 0xFF, 0xFF ; CHS end address
dw 0x0040, 0x0000 ; first logical block
dw 0x07C0, 0x0000 ; size in logical blocks
; Partition entry 2
PARTTAB_ENTRY2:
times 16 db 0
; Partition entry 3
PARTTAB_ENTRY3:
times 16 db 0
; Partition entry 4
PARTTAB_ENTRY4:
times 16 db 0
; Boot signature
dw 0xaa55

%include "boot-supp.asm"

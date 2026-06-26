[CPU 386]
[BITS 16]
[ORG 0x7c00]

mov [disk_id], dl
mov [dap_size], byte 16
mov [dap_zero], byte 0
mov bx, 0x0007

mov ah, 0x41
mov bx, 0x55aa
int 0x13
mov si, STR_BAD_LBA
jc err

mov [dap_numsect], word 1
mov [dap_addrout], word 0x8200
mov [dap_lbalow], dword 1
mov [dap_lbahi], dword 0
;mov ds:si, dword dap_size
mov si, dap_size
mov ah, 0x42
int 0x13
mov si, STR_BAD_DISK
jc err

mov ax, [0x8200]
cmp ax, 0xaa55
mov si, STR_BAD_LOADER
jne err

; UNCOMMENT FOR RELEASE
jmp skipChecksum

mov si, 0x8204
xor ax, ax
xor bh, bh
checksum_loop:
    cmp si, 0x8400
    je .exit
    mov bl, [si]
    ror ax, 1
    add ax, bx
    inc si
    jmp checksum_loop
.exit:
mov [ldr_cksum], ax
cmp ax, [0x8202]
mov si, STR_BAD_LDRSUM
jne err

mov si, STR_PRE_BOOTLDR
call printStr
mov si, STR_LOADER_OK
call printStr

skipChecksum:

mov [dap_numsect], word 62
mov [dap_addrout], word 0x8400
mov [dap_lbalow], dword 2
mov si, dap_size
mov ah, 0x42
int 0x13
mov si, STR_BAD_DISK
jc err

jmp 0x8204

printStr:
    push ax
    push si
    mov ah, 0x0e
    .loop:
        mov al, [si]
        test al, al
        jz .done
        int 0x10
        inc si
        jmp .loop
    .done:
    pop si
    pop ax
    ret

printHex8:
    push ax
    shr ah, 4
    movzx bx, ah
    mov al, [bx+HEXTABLE]
    mov ah, 0x0e
    mov bx, 0x0007
    int 0x10
    pop ax
    and ah, 0b00001111
    movzx bx, ah
    mov al, [bx+HEXTABLE]
    mov ah, 0x0e
    mov bx, 0x0007
    int 0x10
    ret

err:
    push si
    mov si, STR_PRE_BOOTLDR
    call printStr
    pop si
    call printStr
    cmp si, STR_BAD_DISK
    jne err_badBoot
    call printHex8
err_badBoot:
    mov si, STR_PRE_BOOTLDR
    call printStr
    mov si, STR_BAD_BOOT
    call printStr
    jmp $

HEXTABLE: db "0123456789abcdef"
STR_PRE_BOOTLDR: db 13, 10, "bootldr: ", 0
STR_BAD_BOOT: db "Error caused boot abort", 0
STR_BAD_DISK: db "Disk read fail: error 0x", 0
STR_BAD_LBA: db "LBA not supported", 0
STR_BAD_LOADER: db "Loader not present", 0
STR_BAD_LDRSUM: db "Loader is corrupted", 0
STR_LOADER_OK: db "Loader passed checksum", 0

times (440 - ($ - $$)) db 0
; MBR table - signature + reserved
db "One1"
dw 0
; partition entry 1
db 0x80, 0, 0, 0
db 6, 0, 0, 0
dd 2048
dd 2095104
; partition entries 2-4
times 48 db 0

dw 0xaa55

%include "shared.asm"

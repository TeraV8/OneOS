[CPU 386]
[BITS 16]
[ORG 0x8200]

dw 0xaa55
resw 1

call println
mov si, STR_STAT_LOADER_OK
call logOutput
mov si, STR_TEMP_LOADER
call printStr
mov si, STR_INFO_BOOTDISK
call printStr
mov al, [disk_id]
call printHex8
call println
mov si, STR_TEMP_LOADER
call printStr
mov si, STR_INFO_EOTLABEL
call printStr
mov ax, EOT_ADDR
call printHex16
call println

jmp $

logOutput:
    push si
    mov si, STR_TEMP_LOADER
    call printStr
    pop si
    call printStr
    jmp println         ; tail call

printStr:
    push ax
    push bx
    push si
    mov ah, 0x0e
    mov bx, 0x0007
    .loop:
        mov al, [si]
        test al, al
        jz .done
        int 0x10
        inc si
        jmp .loop
    .done:
    pop si
    pop bx
    pop ax
    ret

println:
    push ax
    mov ax, 0x0e0d
    int 0x10
    mov al, 0x0a
    int 0x10
    pop ax
    ret

printHex8:
    push ax
    push bx
    push ax
    mov ah, 0x0e
    movzx bx, al
    shr bl, 4
    mov al, [HEXTABLE + bx]
    mov bx, 0x0007
    int 0x10
    pop ax
    mov ah, 0x0e
    movzx bx, al
    and bl, 0b00001111
    mov al, [HEXTABLE + bx]
    mov bx, 0x0007
    int 0x10
    pop bx
    pop ax
    ret

printHex16:
    push ax
    push bx
    push ax
    movzx bx, ah
    mov ah, 0x0e
    shr bl, 4
    mov al, [HEXTABLE + bx]
    mov bx, 0x0007
    int 0x10
    pop ax
    movzx bx, ah
    mov ah, 0x0e
    and bl, 0b00001111
    mov al, [HEXTABLE + bx]
    mov bx, 0x0007
    int 0x10
    pop bx
    pop ax
    jmp printHex8           ; tail call

STR_TEMP_LOADER: db "loader: ", 0
STR_STAT_LOADER_OK: db "Loader successfully initialized!", 0
STR_INFO_BOOTDISK: db "Boot disk: 0x", 0
STR_INFO_EOTLABEL: db "End of text address: 0x", 0
HEXTABLE: db "0123456789abcdef"

EOT_ADDR:
times (32256 - ($ - $$)) db 0

%include "shared.asm"

[CPU 386]
[BITS 16]
[ORG 0x8200]

dw 0xaa55
resw 1

call println
mov si, STR_STAT_LOADER_OK
call logOutput

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

STR_TEMP_LOADER: db "loader: ", 0
STR_STAT_LOADER_OK: db "Loader successfully initialized!", 0

times (32256 - ($ - $$)) db 0

%include "shared.asm"

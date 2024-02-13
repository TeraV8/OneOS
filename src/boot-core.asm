printStr:
    pusha
    mov ah, 0x0e
    xor bh, bh
    mov cl, [si]
    _printStr_loop:
        cmp cl, 0
        je _printStr_end
        dec cl
        inc si
        mov al, [si]
        int 0x10
        jmp _printStr_loop
    _printStr_end:
        popa
        ret

; Clears the screen of all text
; bh - text attributes
clearScreen:
    pusha
    mov ax, 0x0600
    xor cx, cx
    mov dx, 0x184f
    int 0x10
    xor bh, bh
    mov ah, 0x02
    xor dx, dx
    int 0x10
    popa
    ret

; Clears the screen to display error message (never returns)
; si - String pointer (indexed)
displayError:
    push si
    mov bh, 0x4f
    call clearScreen
    mov ah, 0x02
    xor bh, bh
    mov dx, 0x0b0f
    int 0x10
    mov si, STR_ERROR_GENERIC
    call printStr
    mov ah, 0x02
    mov dh, 0x0c
    pop si
    ; All this is necessary to center the message
    mov cl, [si]
    mov dl, 80
    sub dl, cl
    shr dl, 1
    jnc _displayError_skipRightBump
    inc dl
    _displayError_skipRightBump:
    ;;
    int 0x10
    call printStr
    mov ah, 0x01
    mov cx, 0x2706
    int 0x10
    ;mov ax, 0x0e07      ; Not sure why this was here?
    ;xor bh, bh          ; ditto
    jmp $

STR_ERROR_GENERIC: db 51, "OneOS encountered an error during the boot process."

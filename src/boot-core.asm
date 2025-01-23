printStr:
    pusha
    mov ah, 0x0e
    xor bh, bh
    mov cl, [si]
	test cl, 0xff
    _printStr_loop:
        jz _printStr_end
        inc si
        mov al, [si]
        int 0x10
        dec cl
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

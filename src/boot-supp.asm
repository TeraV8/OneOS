; Supplemental boot data (yay more instruction + data space!)

checkForBootPartitions:
bt word [PARTTAB_ENTRY1], 7
jnc testPart2
; prepare for first partition
xor si, si
jmp loadFS

testPart2:
bt word [PARTTAB_ENTRY2], 7
jnc testPart3
; prepare for second partition
mov si, 16
jmp loadFS

testPart3:
bt word [PARTTAB_ENTRY3], 7
jnc testPart4
; prepare for third partition
mov si, 32
jmp loadFS

testPart4:
bt word [PARTTAB_ENTRY4], 7
mov si, STR_ERROR_NOBOOT
jnc displayError
; prepare for fourth partition
mov si, 48

loadFS:
mov dl, [STO_DRIVE] ; drive number
mov [BUF_DAP], word 0x10
mov [BUF_DAP+2], word 1
mov [BUF_DAP+4], dword 0x7e00
mov eax, [PARTTAB_ENTRY1+si+8]
mov [BUF_DAP+8], eax
mov [BUF_DAP+12], dword 0
mov si, BUF_DAP
mov ah, 0x42
int 0x13
mov si, STR_ERROR_READFAIL
jc displayError

mov bh, 0x07
call clearScreen
mov si, STR_STATUS_BOOT
call printStr
and dl, 0x7F
mov bl, dl
call printDec8
mov si, STR_STATUS_BOOT_SEP

testFS:
cmp [0x7e00], dword 0x322d5346
mov si, STR_ERROR_BOOTVOL_FORMAT
jne displayError
cmp [0x7e04], dword 0x41393034
jne displayError
xor eax, eax
mov ax, [0x7e30]
cmp ax, 0
je displayError
add eax, [BUF_DAP+8]
mov [BUF_DAP+8], ax
mov [BUF_DAP+10], word 0
mov ax, [0x7e32]
cmp ax, 0
je displayError
mov [BUF_DAP+2], ax
mov [BUF_DAP+5], byte 0x80
mov ah, 0x42
int 0x13
jmp $

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
	adc dl, 0
    ;;
    int 0x10
    call printStr
    mov ah, 0x01
    mov cx, 0x2706
    int 0x10
    jmp $

drawLogo:
	ret

; bl - 8 bit integer (unsigned) to convert into decimal string
getDecimalString8:
	pusha
	mov al, bl
	xor ah, ah
	div byte [CONST10]
	mov cl, ah
	xor ah, ah
	div byte [CONST10]
	cmp al, 0
	je _getDecimalString8_0
	mov [BUF_NUMSTR], byte 3
	add al, 0x30
	add ah, 0x30
	add cl, 0x30
	mov [BUF_NUMSTR+1], al
	mov [BUF_NUMSTR+2], ah
	mov [BUF_NUMSTR+3], cl
	jmp _getDecimalString8_end
	_getDecimalString8_0:
	cmp ah, 0
	je _getDecimalString8_1
	mov [BUF_NUMSTR], byte 2
	add ah, 0x30
	add cl, 0x30
	mov [BUF_NUMSTR+1], ah
	mov [BUF_NUMSTR+2], cl
	jmp _getDecimalString8_end
	_getDecimalString8_1:
	mov [BUF_NUMSTR], byte 1
	add cl, 0x30
	mov [BUF_NUMSTR+1], cl
	_getDecimalString8_end:
	popa
	ret
BUF_NUMSTR: db 3, 0, 0, 0
CONST10: db 10

; bl - 8 bit number to print (unsigned)
printDec8:
	call getDecimalString8
	mov si, BUF_NUMSTR
	jmp printStr

STR_ERROR_GENERIC: db 51, "OneOS encountered an error during the boot process."
STR_ERROR_READFAIL: db 25, "Failed to read from disk!"
STR_ERROR_BOOTVOL_FORMAT: db 16, "Bad boot volume!"
STR_ERROR_NOBOOT: db 28, "No bootable partition found!"
STR_STATUS_BOOT: db 15, "Booting from hd"
STR_STATUS_BOOT_SEP: db 1, "/"

LOGO:
db "             ________                                  ________\r\n\
            /  ____  \\                                /  ____  \\\
           /  /    \\  \\    ________     __________   /  /    \\  \\   __________\
           | |      | |  |/  ____  \\   /  ______  \\  | |      | |  /  ________|\
           | |      | |  |  /    \\  |  | /      \\ |  | |      | |  | /\
           | |      | |  | |      | |  | \\______/ |  | |      | |  | \\________\
           | |      | |  | |      | |  |  ________/  | |      | |  \\________  \\\
           | |      | |  | |      | |  | /           | |      | |           \\ |\
           \\  \\____/  /  | |      | |  | \\________   \\  \\____/  /   ________/ |\
            \\________/   |_|      |_|  \\__________|   \\________/   |__________/"

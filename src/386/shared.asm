
ABSOLUTE 0x7b00
disk_id     resb 1

dap_size    resb 1
dap_zero    resb 1
dap_numsect resw 1
dap_addrout resd 1
dap_lbalow  resd 1
dap_lbahi   resd 1

ldr_cksum   resw 1

ABSOLUTE 0x7e00

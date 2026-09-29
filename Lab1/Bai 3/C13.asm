section .data
    msg_yes db "YES", 10
    len_yes equ $ - msg_yes

    msg_no db "NO", 10
    len_no equ $ - msg_no

section .bss
    input resb 20        ; buffer nhập
    num resd 1

section .text
    global _start
_start:
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, input
    mov edx, 20
    int 0x80

    mov esi, input
    xor eax, eax        ; result = 0

convert:
    mov bl, [esi]
    cmp bl, 10          ; newline?
    je done_convert

    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx

    inc esi
    jmp convert

done_convert:
    mov [num], eax      ; lưu số gốc

    mov ebx, eax        ; ebx = number
    xor ecx, ecx        ; reversed = 0

reverse_loop:
    cmp ebx, 0
    je compare

    mov edx, 0
    mov eax, ebx
    mov edi, 10
    div edi             ; eax = ebx/10, edx = ebx%10

    imul ecx, ecx, 10
    add ecx, edx

    mov ebx, eax
    jmp reverse_loop

compare:
    mov eax, [num]
    cmp eax, ecx
    je print_yes

    ; ===== PRINT NO =====
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_no
    mov edx, len_no
    int 0x80
    jmp exit

print_yes:
    ; ===== PRINT YES =====
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_yes
    mov edx, len_yes
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
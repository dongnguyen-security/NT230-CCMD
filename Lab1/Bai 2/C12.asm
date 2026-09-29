section .bss
    buffer resb 10

section .data
    number dd 64200
    prefix db "0x", 0
    newline db 10

section .text
    global _start

_start:
    mov eax, [number]          ; load number
    mov ecx, 8                 ; 8 hex digits (32-bit)
    mov edi, buffer
    add edi, 8                 ; point to end of buffer

convert_loop:
    dec edi
    mov ebx, eax
    and ebx, 0xF               ; lấy 4 bit cuối

    cmp ebx, 9
    jbe digit
    add ebx, 55                ; 'A' - 10 = 65 - 10 = 55
    jmp store

digit:
    add ebx, 48                ; '0' = 48

store:
    mov [edi], bl
    shr eax, 4                 ; dịch phải 4 bit
    loop convert_loop

    ; in "0x"
    mov eax, 4
    mov ebx, 1
    mov ecx, prefix
    mov edx, 2
    int 0x80

    ; in HEX
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 8
    int 0x80

    ; newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
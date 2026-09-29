section .data
    numbers dd 6, 8, 9, 1, 2
    n dd 5
    min_result dd 0

section .bss
    buffer resb 12

section .text
    global _start

_start:
    ; ===========================================
    ; Tim so nho nhat
    ; ===========================================
    mov esi, numbers
    mov ecx, [n]
    mov eax, [esi]

    dec ecx
    jz save_result

find_min_loop:
    add esi, 4
    mov ebx, [esi]

    cmp eax, ebx
    jle skip_update
    mov eax, ebx

skip_update:
    loop find_min_loop

save_result:
    mov [min_result], eax

    ; ===========================================
    ; Chuyen so thanh chuoi & in ra
    ; ===========================================
    mov eax, [min_result]
    mov edi, buffer + 11
    mov byte [edi], 0xa
    mov ebx, 10

convert_loop:
    dec edi
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl 

    test eax, eax
    jnz convert_loop

    ; ===========================================
    ; Goi syscall de in ra man hinh
    ; ===========================================
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, buffer + 12
    sub edx, edi
    int 0x80

    ; ===========================================
    ; Ket thuc chuong trinh
    ; ===========================================
    mov eax, 1
    xor ebx, ebx
    int 0x80
    

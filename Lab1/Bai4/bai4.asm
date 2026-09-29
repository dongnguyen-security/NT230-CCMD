section .data
    msg_input db "Nhap chuoi can ma hoa: "
    len_input equ $ - msg_input

    msg_enc db "Chuoi sau khi ma hoa: "
    len_enc equ $ - msg_enc

    msg_dec db "Chuoi sau khi giai ma: "
    len_dec equ $ - msg_dec

    key db 0x55

section .bss
    buffer resb 256
    read_len resd 1

section .text
    global _start

_start:
    ; ===========================================
    ; In thong bao yeu cau Nhap
    ; ===========================================
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_input
    mov edx, len_input
    int 0x80

    ; ============================================
    ; Doc chuoi tu ban phim
    ; ============================================
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 256
    int 0x80
    mov [read_len], eax

    ; =============================================
    ; Ma hoa chuoi bang phep XOR 
    ; =============================================
    mov ecx, [read_len]
    dec ecx
    mov esi, buffer
    mov al, [key]

encrypt_loop:
    cmp ecx, 0
    je done_encrypt
    xor byte [esi], al
    inc esi
    dec ecx
    jmp encrypt_loop

done_encrypt:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_enc
    mov edx, len_enc
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [read_len]
    int 0x80

    ; ===========================================
    ; Giai ma chuoi (XOR tiep)
    ; ===========================================
    mov ecx, [read_len]
    dec ecx
    mov esi, buffer 
    mov al, [key]

decrypt_loop:
    cmp ecx, 0
    je done_decrypt
    xor byte [esi], al
    inc esi
    dec ecx
    jmp decrypt_loop

done_decrypt:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_dec
    mov edx, len_dec
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [read_len]
    int 0x80

    ; ============================================
    ; Thoat chuong trinh
    ; ============================================
    mov eax, 1
    xor ebx, ebx
    int 0x80

    
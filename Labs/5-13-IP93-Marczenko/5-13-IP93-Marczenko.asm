.686
.model flat, stdcall
option casemap:none

include <\masm32\include\windows.inc>
include <\masm32\include\dialogs.inc>

include <\masm32\include\user32.inc>
include <\masm32\include\kernel32.inc>
include <\masm32\include\masm32.inc>

includelib <\masm32\lib\user32.lib>
includelib <\masm32\lib\kernel32.lib>
includelib <\masm32\lib\masm32.lib>

.data

dividor dd 4

inputA dd -32, 76, -144, 180, 90, 82, 7
inputC dd 4, 8, 12, -16, 28, 40, 4
inputD dd -1, 2, -9, 18, 3, 2, 12

first_result dd 5 dup(?)
output_result dd 5 dup(?)
	
buffer db 86 dup(?)
output db 512 dup(?)
	
function0 db 'Завдання: ((c/4)+(28*d)) / ((a/d)-c-1)',13,13,0
out_results db "a = %d, c = %d, d = %d,",13,"Проміжний результат = %d;",13,"Остаточний результат = %d",13,13,0
out_error_0 db "a = %d, c = %d, d = %d",13,"Помилка: ділення на 0.",13,13,0
out_error_remainder db "a = %d, c = %d, d = %d",13,"Помилка: результат ділення - не ціле число.",13,13,0

header db 'Лабораторна №5 - в. 13 - ІП-93 - Марченко', 0

.code
start:

mov edi, 0

invoke wsprintf, addr output, addr function0

.WHILE edi <7
    mov eax, inputA[4*edi]
    mov ebx, inputD[4*edi]
    mov ecx, inputC[4*edi]

    ;; a/d
    cmp ebx, 0  
    je error_0 ;; d == 0
    cdq
    idiv ebx
    mov edx,eax
    imul edx, ebx
    cmp edx, inputA[4*edi]
    jne error_remainder ;; a%d != 0

    ;; a/d - c - 1
    sub eax, ecx
    dec eax
    cmp eax, 0
    je error_0 ;; a/d - c - 1 == 0
    mov esi, eax 
    
    ;; c/4
    mov eax, ecx
    cdq
    idiv dividor
    mov edx, eax
    imul edx, dividor
    cmp edx, ecx
    jne error_remainder ;; c%4 != 0

    ;; 28*d
    imul ebx, 28

    ;; c/4 + 28d
    add eax, ebx
    mov ecx, eax
    cdq

    ;; (c/4 + 28d) / (a/d - c - 1)
    idiv esi
    mov edx, eax
    imul edx, esi
    cmp edx, ecx
    jne error_remainder ;; (c/4 + 28d) % (a/d - c - 1) != 0

    mov first_result[4*edi], eax

    test eax, 1
    jnz odd
        mov esi, 2
        cdq
        idiv esi
        jmp outif
    odd:
        imul eax, 5
    outif:

    mov output_result[4*edi], eax 
    invoke wsprintf, addr buffer, addr out_results, inputA[4*edi], inputC[4*edi], inputD[4*edi], first_result[4*edi], output_result[4*edi]
    jmp cont
    error_0:
        invoke wsprintf, addr buffer, addr out_error_0, inputA[4*edi], inputC[4*edi], inputD[4*edi]
        jmp cont
    error_remainder:
        invoke wsprintf, addr buffer, addr out_error_remainder, inputA[4*edi], inputC[4*edi], inputD[4*edi]
        jmp cont
    cont:
        invoke szCatStr, addr output, addr buffer
        inc edi	
.ENDW
invoke MessageBox, 0, addr output, addr header, 0
end start
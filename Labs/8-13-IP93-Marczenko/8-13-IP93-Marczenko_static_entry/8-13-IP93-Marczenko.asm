.486
.model flat, stdcall
option casemap :none

INCLUDE \masm32\include\user32.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\msvcrt.inc

INCLUDELIB \masm32\lib\kernel32.lib     ; for ExitProcess
INCLUDELIB \masm32\lib\user32.lib       ; for MessageBox
INCLUDELIB \masm32\lib\msvcrt.lib       ; for crt_sprintf

INCLUDELIB 8-13-IP93-Marczenko-lib.lib  ; for enumerate

enumerate PROTO :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD, :PTR QWORD

calc MACRO i, buff
    local cont
    local no_error
    
    invoke enumerate, addr a[i*8], addr b[i*8], addr cc[i*8], addr d[i*8], addr res1[i*8], addr res2[i*8], addr res3[i*8], addr res4[i*8], addr res5[i*8], addr res6[i*8],  addr results[i*8]
    cmp eax, 1
    jne no_error
        invoke crt_sprintf, addr buffer, addr error_message
        jmp cont
    no_error:
        invoke crt_sprintf, addr buffer, addr number, results[i*8]
    cont:

    invoke crt_sprintf, addr buffer1, addr number, res1[i*8]
    invoke crt_sprintf, addr buffer2, addr number, res2[i*8]
    invoke crt_sprintf, addr buffer3, addr number, res3[i*8]
    invoke crt_sprintf, addr buffer4, addr number, res4[i*8]
    invoke crt_sprintf, addr buffer5, addr number, res5[i*8]
    invoke crt_sprintf, addr buffer6, addr number, res6[i*8]

    invoke crt_sprintf, buff, addr out_message, a[i*8], b[i*8], cc[i*8], d[i*8],addr buffer1,addr buffer2,addr buffer3,addr buffer4,addr buffer5,addr buffer6, addr buffer
ENDM

.data
    
    header       DB "Лабораторна №8 - в. 13 - ІП-93 - Марченко", 0
    template  DB "Завдання : 2a-c+b/3 / arctg(b-d/2):", 10,
        "I. %s", 10,
        "II. %s", 10,
        "III. %s", 10,
        "IV. %s", 10,
        "V. %s", 10,
        "VI. %s", 0

    out_message              DB "a = %.18f, b = %.18f, c = %.18f, d = %.18f",10,
                              "     d/2 = %s","                       b - d/2 = %s", 10,
                              "     arctg(b-d/2) = %s","          2*a - c = %s", 10,
                              "     b/3 = %s","                      2a-c+b/3 = %s", 10,  "     Результат = %s",10,0
    number                   DB "%.18f", 0
    error_message            DB "Помилка: ділення на 0", 0
    
    current_buff       DD 0
    out_buffer         DB 4096 DUP (0)
    buff_ex1           DB 512 DUP (0)
    buff_ex2           DB 512 DUP (0)
    buff_ex3           DB 512 DUP (0)
    buff_ex4           DB 512 DUP (0)
    buff_ex5           DB 512 DUP (0)
    buff_ex6           DB 512 DUP (0)
    buffersize = $ - buff_ex6
    buffer		     DB 256	DUP (0)

    buffer1            DB 64 DUP (0)
    buffer2            DB 64 DUP (0)
    buffer3            DB 64 DUP (0)
    buffer4            DB 64 DUP (0)
    buffer5            DB 64 DUP (0)
    buffer6            DB 64 DUP (0)
    
    results                DQ 6 DUP (0)
    
    res1                DQ 6 DUP (0)
    res2                DQ 6 DUP (0)
    res3                DQ 6 DUP (0)
    res4                DQ 6 DUP (0)
    res5                DQ 6 DUP (0)
    res6                DQ 6 DUP (0)
    a                  DQ -54.3245, -18.773, 94.8281, 100000000000.4, -0.0000002, -11.3
    b                  DQ 44.25, -116.44834, 639.2826  , 0.000000003 , 0.00002, 4.95
    cc                 DQ 31.43, 1093.94, -23.438, -3900000939.09  , 0.2, 0.8483
    d                  DQ 86.5, -230.89668, 0.51   , 0.0032 , -0.00000004, 9.9
    MB_OK                  EQU 0
.code
    start:
        mov esi, 0
        mov current_buff, offset buff_ex1

        cycle1:
        calc esi, current_buff

        ADD current_buff, buffersize
        INC esi
        CMP esi, 6
        JB cycle1

        invoke crt_sprintf, addr out_buffer, addr template,
            addr buff_ex1, addr buff_ex2,
            addr buff_ex3, addr buff_ex4,
            addr buff_ex5, addr buff_ex6

        invoke MessageBox, 0, addr out_buffer, addr header, MB_OK
        invoke ExitProcess, 0
    END start       
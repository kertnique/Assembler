include \masm32\include\masm32rt.inc
include \masm32\include\Fpu.inc
includelib \masm32\lib\Fpu.lib

extern operation1:PROTO
extern oper3:PROTO
extern out_results: qword
extern operation2:PROTO
public in_b, in_d

write_in MACRO buff, num, error
    local out_if
    local end_if
    cmp error, 0
    je out_if
        invoke crt_sprintf, addr buff, addr error_message
        jmp end_if
    out_if:
        invoke crt_sprintf, addr buff, addr number_message, num
    end_if:
ENDM

move_for8 MACRO in, out
    local cycle1
    mov ax, 0
    cycle1:
    mov     esi, DWORD ptr in[0]
    mov     DWORD ptr out[0], esi
    inc ax
    cmp ax, 2
    ;jne cycle1
    mov     esi, DWORD ptr in[4]
    mov     DWORD ptr out[4], esi
    cmp ax, 2
    ;jne cycle1
ENDM

enumerate MACRO a, b, cc, d, res
    mov     is_error, 0

    ; operation 1 - start
    lea esi, a
    lea edx, cc
    lea eax, count_first
    call operation1
    mov     is_error, 0
    write_in    buff2, count_first, is_error
    ; operation 1 - end

    ; operation 2 - start
    push dword ptr b[4]
    push dword ptr b[0]
    
    push offset count_second
    call operation2
    write_in    buff1, count_second, is_error
    ; operation 2 - end
    
    ; operation 3 - start
    move_for8 b, in_b
    move_for8 d, in_d
    call oper3
    ;cmp out_results, 0
    write_in    buff4, out_results[16], is_error
    write_in    buff5, out_results[8], is_error
    write_in    buff6, out_results, is_error
    ; operation 3 - end

        finit
        fld     count_first
        fld     count_second
        fadd    st, st(1)   
        fstp     count_first
        write_in    buff3, count_first, is_error
        fld     count_first
        fld     out_results
        fcom nulle
        fstsw ax
        sahf
        jz error_is
        fdivp   st(1), st
        fstp    res
        jmp out_if
        error_is:
        mov eax, 1
        mov is_error, eax
        
        out_if:
    write_in    buff7, res, is_error

ENDM

calculate MACRO i, buff
    enumerate a[i*8], b[i*8], cc[i*8], d[i*8], res[i*8]

    invoke crt_sprintf, buff, addr out_message, a[i*8], b[i*8], cc[i*8], d[i*8],
        addr buff1, addr buff2, addr buff3, addr buff4,
        addr buff5, addr buff6, addr buff7

ENDM

.data
    header       DB " Лабораторна №7 - в. 13 - ІП-93 - Марченко", 0
    template  DB " Завдання : 2a-c+b/3 / arctg(b-d/2)", 10,
        "I. %s", 10,
        "II. %s", 10,
        "III. %s", 10,
        "IV. %s", 10,
        "V. %s", 10,
        "VI. %s", 0

    out_message              DB "a = %.18f, b = %.18f, c = %.18f, d = %.18f", 10,
                              "     b/3 = %s","                          2*a-c = %s",10,
                              "     2*a - c + b/3 = %s","            d/2 = %s",10,
                              "     b - d/2 = %s","                      arctg(b-d/2) = %s",10,
                              "     Результат = %s",10, 0
    error_message              DB " Помилка : ділення на 0", 0

    buff1            DB 128 DUP (0)
    buff2            DB 128 DUP (0)
    buff3            DB 128 DUP (0)
    buff4            DB 128 DUP (0)
    buff5            DB 128 DUP (0)
    buff6            DB 128 DUP (0)
    buff7            DB 128 DUP (0)
    buffer_now      DD 0

    out_buffer         DB 4096 DUP (0)
    buffer_ex1           DB 1024 DUP (0)
    buffer_ex2           DB 1024 DUP (0)
    buffer_ex3           DB 1024 DUP (0)
    buffer_ex4           DB 1024 DUP (0)
    buffer_ex5           DB 1024 DUP (0)
    buffer_ex6           DB 1024 DUP (0)
    buff_size = $ - buffer_ex6

    res                DQ 6 DUP (0)
    a                  DQ -54.3245, -18.773, 94.8281, 100000000000.4, -0.0000002, -11.3
    b                  DQ 44.25, -116.44834, 639.2826  , 0.000000003 , 0.00002, 4.95
    cc                 DQ 31.43, 1093.94, -23.438, -3900000939.09  , 0.2, 0.8483
    d                  DQ 86.5, -230.89668, 0.51   , 0.0032 , -0.00000004, 9.9
    in_b               DQ 0.0
    in_d               DQ 0.0
    count_first        DQ 0.0
    count_second       DQ 0.0
    count_third        DQ 0.0
    is_error           DD 0
    nulle              DQ 0.0
    number_message      DB "%.18f", 0
    
    .code
    start:
        mov edi, 0
        mov buffer_now, offset buffer_ex1

        program_cycle:
        calculate edi, buffer_now

        add buffer_now, buff_size
        inc edi
        cmp edi, 6
        jb program_cycle

        invoke crt_sprintf, addr out_buffer, addr template,
            addr buffer_ex1, addr buffer_ex2,
            addr buffer_ex3, addr buffer_ex4,
            addr buffer_ex5, addr buffer_ex6

        invoke MessageBox, 0, addr out_buffer, addr header, MB_OK
        invoke ExitProcess, 0
    END start
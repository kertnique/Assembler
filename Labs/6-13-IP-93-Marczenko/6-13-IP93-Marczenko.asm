INCLUDE \masm32\include\masm32rt.inc
include \masm32\include\Fpu.inc
includelib \masm32\lib\Fpu.lib

enumerate MACRO a, b, cc, d, res
    local fin
    local error_0
    mov     is_error, 0
    finit

    fld     d               ; st(0) = d
    fld     constants[0]        ; st(0) = 2,    st(1) = d
    fdiv                    ; st(0) = d/2
    write_in    buffer1, precision

    fld     b               ; st(0) = b,    st(1) = d/2
    fsubr                   ; st(0) = b - d/2
    write_in    buffer2, precision

    fld1                    ; st(0) = 1,    st(1) = b-d/2
    fpatan                  ; st(0) = arctg(b-d/2)
    write_in    buffer3, precision

    fld     constants[0]        ; st(0) = 2,    st(1) = arctg(b-d/2)
    fld     a               ; st(0) = a,    st(1) = 2,              st(2) = arctg(b-d/2)
    fmulp   st(1), st       ; st(0) = 2a,   st(1) = arctg(b-d/2)
    fld     cc              ; st(0) = c,    st(1) = 2a,             st(2) = arctg(b-d/2)
    fsub                    ; st(0) = 2a-c, st(1) = arctg(b-d/2)
    write_in    buffer4, precision

    fld     b               ; st(0) = b,    st(1) = 2a-c,   st(2) = arctg(b-d/2)
    fld     constants[8]        ; st(0) = 3,    st(1) = b,      st(2) = 2a-c,        st(3) = arctg(b-d/2)
    fdiv                    ; st(0) = b/3,  st(1) = 2a-c,   st(2) = arctg(b-d/2)
    write_in    buffer5, precision

    fadd                    ; st(0) = 2a-c+b/3, st(1) = arctg(b-d/2)
    write_in    buffer6, precision

    fxch    st(1)           ; st(0) = arctg(b-d/2), st(1) = st(0) = 2a-c+b/3

    ftst
    fstsw   AX
    SAHF
    JZ      error_0
    
    fdiv                    ;   st(0) = 2a-c+b/3 / arctg(b-d/2)
    JMP     fin

    error_0:
    mov     is_error, 1

    fin:
    fstp    res
ENDM

write_in MACRO buffer, precision2
    local contin
    local end_func
    
    mov al, is_error 
    cmp al, 1
    jne contin
        invoke crt_sprintf, addr buffer, addr error_message
        jmp end_func 
       
    contin:
    invoke FpuFLtoA, 0, precision2, addr buffer, SRC1_FPU or SRC2_DIMM
    end_func:
ENDM


calc MACRO i, buffer
    local cont
    local no_error
    enumerate a[8*i], b[8*i], cc[8*i], d[8*i], res[8*i]
    cmp is_error, 1
    jne no_error
    invoke crt_sprintf, addr buffer7, addr error_message
    jmp cont
    no_error:
     invoke crt_sprintf, addr buffer7, addr results, res[8*i]
     
    cont:
    invoke crt_sprintf, buffer, addr out_message, a[8*i], b[8*i], cc[8*i], d[8*i],
        addr buffer1, addr buffer2, addr buffer3, addr buffer4, addr buffer5, addr buffer6, addr buffer7
ENDM

.data
    header       DB "Лабораторна №6 - в. 13 - ІП-93 - Марченко", 0
    template  DB "Завдання : 2a-c+b/3 / arctg(b-d/2)", 10,
        "I. %s", 10,
        "II. %s", 10,
        "III. %s", 10,
        "IV. %s", 10,
        "V. %s", 10,
        "VI. %s", 0

    out_message              DB "a = %.18f, b = %.18f, c = %.18f, d = %.18f", 10,
                              "     d/2 = %s","                       b - d/2 = %s", 10,
                              "     arctg(b-d/2) = %s","          2*a - c = %s", 10,
                              "     b/3 = %s","                      2a-c+b/3 = %s", 10,
                              "     Результат = %s",10, 0

    number                DB "   DQ = %.25f", 0
    results               DB "%.18f", 0
    error_message         DB "Помилка: ділення на 0", 0

    out_buffer        DB 4096 DUP (0)
    buff_ex1             DB 1024 DUP (0)
    buff_ex2           DB 1024 DUP (0)
    buff_ex3           DB 1024 DUP (0)
    buff_ex4           DB 1024 DUP (0)
    buff_ex5           DB 1024 DUP (0)
    buff_ex6           DB 1024 DUP (0)
    buff_size = $ - buff_ex6

    buffer1            DB 0128 DUP (' '), 0
    buffer2            DB 0128 DUP (' '), 0
    buffer3            DB 0128 DUP (' '), 0
    buffer4            DB 0128 DUP (' '), 0
    buffer5            DB 0128 DUP (' '), 0
    buffer6            DB 0128 DUP (' '), 0
    buffer7            DB 0128 DUP (0)

    current_buff      DD 0

    res                DQ 6 DUP (0)
    a                  DQ -54.3245, -18.773, 94.8281, 100000000000.4, -0.0000002, -11.3
    b                  DQ 44.25, -116.44834, 639.2826  , 0.000000003 , 0.00002, 4.95
    cc                 DQ 31.43, 1093.94, -23.438, -3900000939.09  , 0.2, 0.8483
    d                  DQ 86.5, -230.89668, 0.51   , 0.0032 , -0.00000004, 9.9
    constants          DQ 2.0, 3.0
    temp               DQ 0.0
    is_error           DB 0
    precision          DD 15    ;; кількість цифр після коми


.code
    start:
        mov esi, 0
        mov current_buff, offset buff_ex1

        cycle:
        calc esi, current_buff

        add current_buff, buff_size
        inc esi
        cmp esi, 6
        JB cycle

        invoke crt_sprintf, addr out_buffer, addr template,
            addr buff_ex1,
            addr buff_ex2,
            addr buff_ex3,
            addr buff_ex4,
            addr buff_ex5,
            addr buff_ex6

        invoke MessageBox, 0, addr out_buffer, addr header, MB_OK
        invoke ExitProcess, 0
    END start
.686
.model flat, stdcall
option casemap :none

.data
    constants          DQ 2.0, 3.0
.code

enumerate PROC a: PTR QWORD, b: PTR QWORD, cc: PTR QWORD, d: PTR QWORD, res1: PTR QWORD, res2: PTR QWORD, res3: PTR QWORD, res4: PTR QWORD, res5: PTR QWORD, res6: PTR QWORD, res: PTR QWORD
    finit
    mov     eax, 0
    finit

    mov ecx, d
    fld     qword ptr[ecx]  ; st(0) = d
    fld     constants[0]    ; st(0) = 2,    st(1) = d
    fdiv                    ; st(0) = d/2
    mov     ecx, res1
    fst    QWORD PTR [ecx]

    mov ecx, b
    fld     qword ptr[ecx]  ; st(0) = b,    st(1) = d/2
    fsubr                   ; st(0) = b - d/2
    mov     ecx, res2
    fst    QWORD PTR [ecx]

    fld1                    ; st(0) = 1,    st(1) = b-d/2
    fpatan                  ; st(0) = arctg(b-d/2)
    mov     ecx, res3
    fst    QWORD PTR [ecx]

    fld     constants[0]    ; st(0) = 2,    st(1) = arctg(b-d/2)

    mov ecx, a
    fld     qword ptr[ecx]  ; st(0) = a,    st(1) = 2,              st(2) = arctg(b-d/2)
    fmulp   st(1), st       ; st(0) = 2a,   st(1) = arctg(b-d/2)
    mov ecx, cc
    fld     qword ptr[ecx]  ; st(0) = c,    st(1) = 2a,             st(2) = arctg(b-d/2)
    fsub                    ; st(0) = 2a-c, st(1) = arctg(b-d/2)
    mov     ecx, res4
    fst    QWORD PTR [ecx]

    mov ecx, b
    fld     qword ptr[ecx]  ; st(0) = b,    st(1) = 2a-c,   st(2) = arctg(b-d/2)
    fld     constants[8]    ; st(0) = 3,    st(1) = b,      st(2) = 2a-c,        st(3) = arctg(b-d/2)
    fdiv                    ; st(0) = b/3,  st(1) = 2a-c,   st(2) = arctg(b-d/2)
    mov     ecx, res5
    fst    QWORD PTR [ecx]

    fadd                    ; st(0) = 2a-c+b/3, st(1) = arctg(b-d/2)
    mov     ecx, res6
    fst    QWORD PTR [ecx]

    fxch    st(1)           ; st(0) = arctg(b-d/2), st(1) = st(0) = 2a-c+b/3

    ftst
    fstsw   AX
    SAHF
    JZ      error_0
    
    fdiv                    ; st(0) = 2a-c+b/3 / arctg(b-d/2)
    JMP     fin

    error_0:
    mov     eax, 1

    fin:
    mov     ecx, res
    fstp    QWORD PTR [ecx]
    RET
enumerate ENDP
END
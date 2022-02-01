; result - 2a-c
; inputs: esi - adress of a, edx - adress of c
; output: eax - adress of result

include \masm32\include\masm32rt.inc

public operation1
public operation2
public oper3, out_results
extern in_b:qword, in_d:qword

.data
    constant    dq 2.0
    out_results dq 0.0, 0.0, 0.0
    constant2   dq 2.0
    constant3   dq  3.0
    zero dq 0.0

.code
    operation1 proc

    finit
    
    fld     constant        ; st(0) = 2
    fld qword ptr [esi]     ; st(0) = a,    st(1) = 2
    fmulp   st(1), st       ; st(0) = 2a
    fld qword ptr [edx]     ; st(0) = c,    st(1) = 2a
    fsub                    ; st(0) = 2a-c
    fstp qword ptr [eax]    ; eax = 2a-c
    ret

    operation1 endp

    operation2 proc

    push ebp
    mov ebp, esp
    push edx

    mov edx, [ebp+8]

    finit
    fld     qword ptr [ebp+12]   ; st(0) = b
    fld     constant3            ; st(0) = 3,    st(1) = b
    fdiv                         ; st(0) = b/3

    fstp    qword ptr [edx]

    pop edx
    pop ebp
    ret 12

operation2 endp 

oper3 proc
   finit
            fld 	in_d
		fld   constant2
            
	    fdiv
	    fst    out_results[16] ; d/2

	    fld     in_b
	    fsubr
          fst   out_results[8]  ; b - d/2

       fld1
       fpatan
	 fstp	out_results
	 ret

	 oper3 endp

end
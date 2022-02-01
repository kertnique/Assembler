
outMessage macro info                                       ; comment - macros (1) to output some message
    invoke MessageBox, 0, addr info, addr info_title, 0     ;; hidden comment - output info with title info_title
endm

Xoring macro                                                ; comment - macros(2) decoding password with XOR
      cld 
      mov bx, 0
      beg_xor:                                              ;; hidden comment - cycle to decifer the password via XOR-function
      CMP bx, pswd_length
      JZ cont
      L1:
      xor pswd_sys[bx], key
      inc bx
      JMP beg_xor
      cont:                                             	;; end of the XORcycle
      endm

Compare macro                                               ; comment - macros(3) comparing input with stored password
      mov bx, 0
      beg_check: ;; cycle to compare input with password
      CMP bx, pswd_length
      JZ equal
      L2:
	mov al, try_pswd[bx]
	mov ah, pswd_sys[bx]                                   ;; hidden comment - comparing passwords
      cmp ah , al
	jne not_equal
      inc bx
      equal: call Equal
      not_equal: call Unequal
endm	

    .386
.model flat, stdcall
option casemap :none

include D:\masm32\include\windows.inc
include D:\masm32\include\dialogs.inc
include D:\masm32\macros\macros.asm
include 4-13-IP93-Marczenko.inc

include D:\masm32\include\user32.inc
include D:\masm32\include\kernel32.inc
include D:\masm32\include\masm32.inc
includelib D:\masm32\lib\user32.lib
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

DialogProcess	PROTO :DWORD,:DWORD,:DWORD,:DWORD

.data
      myname db "ПIБ - Марченко Максим Олегович", 0
      birthday db "Дата народження - 20.08.2008", 0
      zalik db "Залiкова книжка - IП-9316",0
	wrong_pass  db "Неправильний пароль",10,13,0
	info_title db "Iнформацiя",0
	try_pswd  db 25 dup (0)
	pswd_sys db "SBUOLU",0
      key EQU 23h 
	pswd_length dw 6

.code	
start:    
	
	;; initialise starting dialog
	Dialog "Лабораторна 4 - варіант 13 - ІП-93 - Марченко", "MS Sans Serif",12, \            							    
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \   							
        4,7,7,150,90,1024                 							      
		DlgStatic "Пароль:",SS_CENTER,7,5,60,10,100	
		DlgEdit WS_BORDER,7,20,100,11,1000		
		DlgButton "Ввести", WS_TABSTOP,10,40,45,20,IDOK 				
		DlgButton "Скасувати", WS_TABSTOP,65,40,45,20,IDCANCEL 	

	CallModalDialog 0,0,DialogProcess,NULL ;; calling starting dialog

;; configuring user's response	
DialogProcess proc hWindow:DWORD,userMessage:DWORD,wParam:DWORD,lParam:DWORD	
	.IF userMessage == WM_INITDIALOG
       .ELSEIF userMessage == WM_COMMAND
      .IF wParam == IDOK ;; user entered password
	   	invoke GetDlgItemText, hWindow, 1000, addr try_pswd,512
            Xoring
		Compare
      .ENDIF	   
      .IF wParam == IDCANCEL ;; user cancelled entering
		invoke ExitProcess,NULL
      .ENDIF
    .ELSEIF userMessage == WM_CLOSE ;; user exited from the program 
       invoke ExitProcess,NULL
    .ENDIF
    return 0 
DialogProcess endp

Equal proc
         outMessage myname
         outMessage birthday
         outMessage zalik
	   invoke ExitProcess,NULL
Equal endp

Unequal proc
    outMessage wrong_pass
    invoke ExitProcess,NULL
Unequal endp

end start

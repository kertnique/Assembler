.model tiny
.data
    START_MSG   DB "����� �a஫�: $"
    ERROR_MSG   DB "����a���쭮, �஡�� �����.$"
    PASSWD_KEY  DB 23h
    PASSWD      DB "SBUOLU"
    DATA        DB "��㤥��:", 10,
            "�I� - �a�祭�� �a�ᨬ ��������", 10,
            "�a�a  �aத����� - 20.08.2002", 10,
            "����� �a�i�. ������ - I�-9316$"
    PASSWD_LEN  DB 6
	USR_INPUT	DB 32 DUP (?)
.code
	org		100h

.startup
	MAIN: 
  	
    MOV 	AX, 03h
    INT 	10h

    MOV 	AH, 09h
    MOV 	DX, offset START_MSG
    INT 	21h

    MOV		AH, 3Fh
    MOV		BX, 0
    MOV		CX, 32
    MOV		DX, offset USR_INPUT
    INT 	21h

    CMP 	AX, 8
    JNE	EXIT
    MOV 	DI, 0
    VALIDATION:
    MOV		BL, USR_INPUT[DI]
    XOR           BL, PASSWD_KEY
    MOV		BH, PASSWD[DI]
    CMP		BL, BH
    JNE		MAIN

	INC		DI
	CMP		DI, 6
	JB		VALIDATION

	MOV 	AH, 09h
      MOV 	DX, offset DATA
	INT 	21h 
    
    EXIT:
    MOV 	AH, 4Ch
	MOV 	AL, 0
    INT 	21h
END
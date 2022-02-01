.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib

.data
MSGBox_Caption  DB "Lab 1 - Var. 13 - IP-93 - Marczenko", 0
formatSymbol DB "Символьний рядок - '%s'", 0
    bufferSymbol DB 128 DUP (?)
    symbol        DB "2008200", 0

    formatA DB "+A = %d", 0
    formatANeg DB "-A = %d", 0
    formatB DB "+B = %d", 0
    formatBNeg DB "-B = %d", 0
    formatC DB "+C = %d", 0
    formatCNeg DB "-C = %d", 0
    formatD DB "+D = %s", 0
    formatDNeg DB "-D = %s", 0
    formatE DB "+E = %s", 0
    formatENeg DB "-E = %s", 0
    formatF DB "+F = %s", 0
    formatFNeg DB "-F = %s", 0

    MSG_Text DB 128 DUP (?)
    bufferA DB 16 DUP (?)
    bufferANeg DB 16 DUP (?)
    bufferB DB 16 DUP (?)
    bufferBNeg DB 16 DUP (?)
    bufferC DB 16 DUP (?)
    bufferCNeg DB 16 DUP (?)
    bufferD DB 16 DUP (?)
    bufferDNeg DB 16 DUP (?)
    bufferE DB 32 DUP (?)
    bufferENeg DB 32 DUP (?)
    bufferF DB 32 DUP (?)
    bufferFNeg DB 32 DUP (?)

    msgformat DB "%s", 13,
        "%s", 13,"%s", 13,
        "%s", 13,"%s", 13,
        "%s", 13,"%s", 13,
        "%s", 13,"%s", 13,
        "%s", 13,"%s", 13,
        "%s", 13,"%s", 13,0

    
    A sbyte 20d
    ANeg sbyte -20d
    B sword 2008d
    BNeg sword -2008d
    CP sdword 20082002d
    CNeg sdword -20082002d
    D DD 0.002d
    DNeg DD -0.002d
    E DQ 0.216d
    ENeg DQ -0.216d
    F DT 2155.646d
    FNeg DT -2155.646d
    buffD db "0.002",0
    buffDNeg db "-0.002",0
    buffE db  "0.216",0
    buffENeg db "-0.216",0
    buffF db  "2155.646",0
    buffFNeg db "-2155.646",0


.code
start:

;invoke FloatToStr2, D, addr buffD
;invoke FloatToStr2, DNeg, addr buffDNeg
;invoke FloatToStr2, E, addr buffE
;invoke FloatToStr2, ENeg, addr buffENeg
;invoke FloatToStr2, F, addr buffF
;invoke FloatToStr2, FNeg, addr buffFNeg



invoke wsprintf, addr bufferSymbol, addr formatSymbol, addr symbol
    invoke wsprintf, addr bufferA, addr formatA, A
    invoke wsprintf, addr bufferANeg, addr formatANeg, ANeg
    invoke wsprintf, addr bufferB, addr formatB, B
    invoke wsprintf, addr bufferBNeg, addr formatBNeg, BNeg
    invoke wsprintf, addr bufferC, addr formatC, CP
    invoke wsprintf, addr bufferCNeg, addr formatCNeg, CNeg
    invoke wsprintf, addr bufferD, addr formatD, addr buffD
    invoke wsprintf, addr bufferDNeg, addr formatDNeg, addr buffDNeg
    invoke wsprintf, addr bufferE, addr formatE, addr buffE
    invoke wsprintf, addr bufferENeg, addr formatENeg, addr buffENeg
    invoke wsprintf, addr bufferF, addr formatF, addr buffF
    invoke wsprintf, addr bufferFNeg, addr formatFNeg, addr buffFNeg

    invoke wsprintf, addr MSG_Text, addr msgformat,
        addr bufferSymbol,
        addr bufferA, addr bufferANeg,
        addr bufferB, addr bufferBNeg,
        addr bufferC, addr bufferCNeg,
        addr bufferD, addr bufferDNeg,
        addr bufferE, addr bufferENeg,
        addr bufferF, addr bufferFNeg

    invoke MessageBox, NULL, addr MSG_Text, addr MSGBox_Caption, MB_OK
    invoke ExitProcess, NULL
end start
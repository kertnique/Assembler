@echo off
    \masm32\bin\ml /c /coff "8-13-IP93-Marczenko-lib.asm"
    \masm32\bin\Link.exe /OUT:"8-13-IP93-Marczenko-lib.dll" /DEF:8-13-IP93-Marczenko-lib.def /DLL "8-13-IP93-Marczenko-lib.obj"

    \masm32\bin\ml /c /coff "8-13-IP93-Marczenko.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\Link.exe /SUBSYSTEM:console "8-13-IP93-Marczenko.obj"
    if errorlevel 1 goto errlink
    dir "8-13-IP93-Marczenko.*"
    goto finish

  :errlink
    echo _
    echo Link error
    goto finish

  :errasm
    echo _
    echo Assembly Error
    goto finish
    
  :finish

8-13-IP93-Marczenko.exe
pause
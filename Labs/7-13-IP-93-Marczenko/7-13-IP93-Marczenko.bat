@echo off

    \masm32\bin\ml /c /coff "7-13-IP-93-Marczenko.asm"
    \masm32\bin\ml /c /coff "7-13-IP-93-Marczenko-registres.asm"
    if errorlevel 1 goto error_asm

    \masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /out:7-13-IP-93-Marczenko.exe "7-13-IP-93-Marczenko.obj" "7-13-IP-93-Marczenko-registres.obj"
    if errorlevel 1 goto error_link
    dir "7-13-IP-93-Marczenko.*"
    goto out_file

  :error_link
    echo _
    echo Error with linking
    goto out_file

  :error_asm
    echo _
    echo Error with assembling
    goto out_file
    
  :out_file

7-13-IP-93-Marczenko.exe
pause
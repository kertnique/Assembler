@echo off

set startFolder=%cd%
set masm_path="D:\masm32\bin"
set dos_box="C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe"
set filename=%1
set asmfile="2-13-IP93-MarczenkoXOR.asm"

cd /D D:\
cd "%masm_path%"
set folder=%cd%

@echo "ASMFILE = %asmfile%"
@echo "DIR = %folder%"

ml /Bl %masm_path%\link16.exe %asmfile%
%dos_box% -c "mount c %folder% " -c c: -c %filename:.asm=.COM%
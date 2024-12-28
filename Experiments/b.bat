@echo off
echo Build Script: Building %1
call genkickass-script.bat -t C64 -o prg_files -m true -s true -l "E:\dev\github\cityxen\Commodore64_Programming\include"
call KickAss.bat %1
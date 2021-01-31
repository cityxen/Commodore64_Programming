@echo off
echo Build Script: Building %1
start /b genkickass-script.bat -t C64 -o prg_files -m true -s true -l "RETRO_DEV_LIB"
KickAss.bat main.asm

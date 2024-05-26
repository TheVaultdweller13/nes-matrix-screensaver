@echo off
echo.
echo Assembling...
ca65 registers.inc
ca65 main.asm
if not %errorlevel% == 0 (
    echo Error: Failed to compile
    pause
    exit /b %errorlevel%
)
echo - Assembled successfully.

echo.

echo Linking...
ld65 registers.o main.o -C nes.cfg -o main.nes
if not %errorlevel% == 0 (
    echo Error: Failed to link
    pause
    exit /b %errorlevel%
)
echo - Linked successfully.
echo.
pause
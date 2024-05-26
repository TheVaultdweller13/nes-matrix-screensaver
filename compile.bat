@echo off

echo.
echo Assembling...

if not exist build (
    mkdir build
)
if not exist rom (
    mkdir rom
)
ca65 src/main.asm -o build/main.o
if not %errorlevel% == 0 (
    echo Error: Failed to compile
    pause
    exit /b %errorlevel%
)
echo - Assembled successfully.

echo.

echo Linking...
ld65 build/main.o -C nes.cfg -o rom/main.nes
if not %errorlevel% == 0 (
    echo Error: Failed to link
    pause
    exit /b %errorlevel%
)
echo - Linked successfully.
echo.
pause
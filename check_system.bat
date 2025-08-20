@echo off
chcp 65001 > nul
echo 🔍 VoiceClone AI Spanish - Diagnóstico del Sistema
echo ================================================
echo.
python --version
echo.
if exist "venv\Scripts\activate.bat" (
    echo ✅ Entorno virtual: Encontrado
    call venv\Scripts\activate.bat
    echo    🐍 Python en venv: 
    python -c "import sys; print('   ', sys.executable)"
    echo    📦 Paquetes instalados:
    pip list | findstr "torch gradio transformers"
) else (
    echo ❌ Entorno virtual: No encontrado
)
echo.
pause

@echo off
chcp 65001 > nul

echo.
echo 🎙️ VoiceClone AI Spanish - Iniciando aplicación...
echo.

:: Verificar si existe el entorno virtual
if not exist "venv\Scripts\activate.bat" (
    echo ❌ Error: Entorno virtual no encontrado
    echo.
    echo 💡 Ejecuta primero: install_windows.bat
    echo.
    pause
    exit /b 1
)

:: Activar entorno virtual
echo 🔄 Activando entorno virtual...
call venv\Scripts\activate.bat

:: Verificar dependencias principales
echo 🧪 Verificando dependencias...
python -c "import torch, gradio" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Dependencias no instaladas correctamente
    echo.
    echo 💡 Ejecuta: install_windows.bat
    echo.
    pause
    exit /b 1
)

:: Mostrar información del sistema
echo.
echo 📊 Información del sistema:
python -c "import torch; print('🔥 PyTorch:', torch.__version__)"
python -c "import torch; print('🖥️  CUDA:', 'Disponible' if torch.cuda.is_available() else 'No disponible')" 2>nul
if "%ERRORLEVEL%" equ "0" (
    python -c "import torch; print('🎯 GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU')" 2>nul
)

echo.
echo 🚀 Iniciando VoiceClone AI Spanish...
echo 🌐 La aplicación se abrirá en: http://localhost:7863
echo.
echo 💡 Presiona Ctrl+C para detener la aplicación
echo.

:: Ejecutar la aplicación
python app.py

echo.
echo 👋 ¡Aplicación cerrada!
pause

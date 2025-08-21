@echo off
chcp 65001 > nul
echo 🔍 VoiceClone AI Spanish - Diagnóstico del Sistema
echo ================================================
echo.

:: Verificar Python
echo 🐍 Verificando Python...
python --version 2>nul
if %errorlevel% neq 0 (
    echo ❌ Python no encontrado
) else (
    echo ✅ Python encontrado
)

:: Verificar entorno virtual
echo.
echo 📦 Verificando entorno virtual...
if exist "venv\Scripts\activate.bat" (
    echo ✅ Entorno virtual existe
    call venv\Scripts\activate.bat
    
    echo.
    echo 📋 Paquetes instalados en venv:
    python -m pip list
    
    echo.
    echo 🧪 Probando imports críticos...
    
    python -c "import torch; print('✅ PyTorch:', torch.__version__)" 2>nul || echo "❌ PyTorch no disponible"
    python -c "import gradio; print('✅ Gradio:', gradio.__version__)" 2>nul || echo "❌ Gradio no disponible"
    python -c "import transformers; print('✅ Transformers:', transformers.__version__)" 2>nul || echo "❌ Transformers no disponible"
    python -c "import librosa; print('✅ Librosa:', librosa.__version__)" 2>nul || echo "❌ Librosa no disponible"
    python -c "import scipy; print('✅ SciPy:', scipy.__version__)" 2>nul || echo "❌ SciPy no disponible"
    python -c "import numpy; print('✅ NumPy:', numpy.__version__)" 2>nul || echo "❌ NumPy no disponible"
    
    echo.
    echo 🔍 Verificando Spanish-F5...
    python -c "from spanish_f5 import load_model; print('✅ Spanish-F5 funcional')" 2>nul || echo "❌ Spanish-F5 no disponible"
    
) else (
    echo ❌ Entorno virtual no existe
)

:: Verificar herramientas de compilación
echo.
echo 🛠️ Verificando herramientas de compilación...
where ninja 2>nul
if %errorlevel% neq 0 (
    echo ❌ Ninja no encontrado
) else (
    echo ✅ Ninja encontrado
    ninja --version
)

where meson 2>nul
if %errorlevel% neq 0 (
    echo ❌ Meson no encontrado
) else (
    echo ✅ Meson encontrado
    meson --version
)

where cl 2>nul
if %errorlevel% neq 0 (
    echo ❌ MSVC (cl.exe) no encontrado
    echo    💡 Necesitas Visual Studio Build Tools
) else (
    echo ✅ MSVC compilador encontrado
)

echo.
echo 📁 Verificando estructura de archivos...
if exist "src\chatterbox\tts.py" (
    echo ✅ Estructura del proyecto OK
) else (
    echo ❌ Estructura del proyecto incompleta
)

if exist "example_tts.py" (
    echo ✅ Ejemplos encontrados
) else (
    echo ❌ Archivos de ejemplo no encontrados
)

echo.
echo 🏁 Diagnóstico completado
echo.
pause

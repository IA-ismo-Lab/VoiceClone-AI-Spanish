@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo 🎙️ VoiceClone AI Spanish - Instalación Automática Windows
echo ============================================================
echo.

:: Verificar si Python está instalado
echo [1/7] 🐍 Verificando Python...
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Python no está instalado o no está en PATH
    echo.
    echo 📥 Descarga Python 3.9+ desde: https://www.python.org/downloads/
    echo ⚠️  Asegúrate de marcar "Add Python to PATH" durante la instalación
    echo.
    pause
    exit /b 1
)
echo ✅ Python encontrado

:: Obtener versión de Python
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo    Versión: %PYTHON_VERSION%

:: Verificar si es Python 3.9+
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
)
if %MAJOR% lss 3 (
    echo ❌ Error: Se requiere Python 3.9 o superior
    echo    Versión actual: %PYTHON_VERSION%
    pause
    exit /b 1
)
if %MAJOR% equ 3 if %MINOR% lss 9 (
    echo ❌ Error: Se requiere Python 3.9 o superior
    echo    Versión actual: %PYTHON_VERSION%
    pause
    exit /b 1
)

:: Verificar si hay GPU NVIDIA
echo.
echo [2/7] 🖥️ Verificando GPU NVIDIA...
nvidia-smi >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ GPU NVIDIA detectada
    set GPU_AVAILABLE=1
    for /f "tokens=*" %%i in ('nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2^>nul ^| head -n 1') do set GPU_NAME=%%i
    echo    GPU: !GPU_NAME!
) else (
    echo ⚠️  GPU NVIDIA no detectada - se usará CPU
    echo    💡 Para mejor rendimiento, instala drivers NVIDIA
    set GPU_AVAILABLE=0
)

:: Crear entorno virtual
echo.
echo [3/7] 📦 Creando entorno virtual...
if exist "venv" (
    echo ⚠️  El entorno virtual ya existe, eliminando...
    rmdir /s /q venv
)
python -m venv venv
if %ERRORLEVEL% neq 0 (
    echo ❌ Error creando entorno virtual
    pause
    exit /b 1
)
echo ✅ Entorno virtual creado

:: Activar entorno virtual
echo.
echo [4/7] 🔄 Activando entorno virtual...
call venv\Scripts\activate.bat
if %ERRORLEVEL% neq 0 (
    echo ❌ Error activando entorno virtual
    pause
    exit /b 1
)
echo ✅ Entorno virtual activado

:: Actualizar pip
echo.
echo [5/7] ⬆️ Actualizando pip...
python -m pip install --upgrade pip
if %ERRORLEVEL% neq 0 (
    echo ❌ Error actualizando pip
    pause
    exit /b 1
)
echo ✅ pip actualizado

:: Instalar dependencias
echo.
echo [6/7] 📚 Instalando dependencias...
echo    💡 Esto puede tardar varios minutos...

if %GPU_AVAILABLE% equ 1 (
    echo    🚀 Instalando versión con soporte GPU (CUDA)...
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
) else (
    echo    💻 Instalando versión solo CPU...
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
)

if %ERRORLEVEL% neq 0 (
    echo ❌ Error instalando PyTorch
    pause
    exit /b 1
)

pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo ❌ Error instalando dependencias
    pause
    exit /b 1
)
echo ✅ Dependencias instaladas

:: Verificar instalación
echo.
echo [7/7] 🧪 Verificando instalación...
python -c "import torch; print('✅ PyTorch:', torch.__version__)"
if %GPU_AVAILABLE% equ 1 (
    python -c "import torch; print('✅ CUDA disponible:', torch.cuda.is_available())"
    python -c "import torch; print('✅ GPU detectada:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'No disponible')" 2>nul
)
python -c "import gradio; print('✅ Gradio:', gradio.__version__)" 2>nul

echo.
echo ============================================================
echo 🎉 ¡Instalación completada exitosamente!
echo ============================================================
echo.
echo 🚀 Para iniciar la aplicación:
echo    1. Activar entorno: venv\Scripts\activate.bat
echo    2. Ejecutar: python app.py
echo    3. Abrir navegador: http://localhost:7863
echo.
echo 💡 O simplemente ejecuta: run_app.bat
echo.

:: Crear script de ejecución rápida
echo @echo off > run_app.bat
echo call venv\Scripts\activate.bat >> run_app.bat
echo python app.py >> run_app.bat
echo ✅ Script run_app.bat creado para ejecución rápida

echo.
echo 📚 Recursos útiles:
echo    📖 README.md - Documentación completa
echo    🐛 Issues: https://github.com/tu-usuario/VoiceClone-AI-Spanish/issues
echo    💬 Newsletter: https://ia-ismo.com
echo.

if %GPU_AVAILABLE% equ 1 (
    echo 🔥 ¡Configuración optimizada para GPU detectada!
) else (
    echo 💻 Configuración para CPU - Para mejor rendimiento considera una GPU NVIDIA
)

echo.
echo Presiona cualquier tecla para continuar...
pause >nul

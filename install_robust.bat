@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: Configurar directorio de trabajo
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================================
echo 🎙️ VoiceClone AI Spanish - Instalación Ultra Robusta
echo ============================================================
echo 📁 Directorio de trabajo: %CD%
echo.

:: Verificar si Python está instalado
echo [1/8] 🐍 Verificando Python...
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Python no está instalado o no está en PATH
    echo.
    echo 💡 Descargar Python desde: https://www.python.org/downloads/
    echo    ✅ Asegúrate de marcar "Add Python to PATH"
    pause
    exit /b 1
)

:: Mostrar versión de Python
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%v"
echo ✅ Python %PYTHON_VERSION% detectado

:: Crear entorno virtual si no existe
echo.
echo [2/8] 🏗️ Configurando entorno virtual...
if not exist "venv" (
    echo 🔧 Creando entorno virtual...
    python -m venv venv
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error creando entorno virtual
        pause
        exit /b 1
    )
) else (
    echo ✅ Entorno virtual ya existe
)

:: Activar entorno virtual
echo 🔄 Activando entorno virtual...
call venv\Scripts\activate.bat
if %ERRORLEVEL% neq 0 (
    echo ❌ Error activando entorno virtual
    pause
    exit /b 1
)

:: Actualizar pip
echo.
echo [3/8] 📦 Actualizando pip y herramientas básicas...
python -m pip install --upgrade pip setuptools wheel
echo ✅ Herramientas básicas actualizadas

:: Contadores de éxito/fallo
set "SUCCESS_COUNT=0"
set "FAIL_COUNT=0"

:: Instalar dependencias básicas (sin salir por errores)
echo.
echo [4/8] 🧰 Instalando dependencias básicas...

echo    🖥️ Interfaz gráfica...
python -m pip install gradio>=4.0.0
if %ERRORLEVEL% equ 0 (
    echo    ✅ Gradio instalado
    set /a SUCCESS_COUNT+=1
) else (
    echo    ❌ Error con Gradio
    set /a FAIL_COUNT+=1
)

echo    🤖 Machine Learning básico...
python -m pip install transformers>=4.30.0 huggingface-hub>=0.15.0
if %ERRORLEVEL% equ 0 (
    echo    ✅ Transformers instalado
    set /a SUCCESS_COUNT+=1
) else (
    echo    ❌ Error con Transformers
    set /a FAIL_COUNT+=1
)

echo    📊 Ciencia de datos...
python -m pip install numpy pandas pyyaml tqdm
if %ERRORLEVEL% equ 0 (
    echo    ✅ Ciencia de datos instalada
    set /a SUCCESS_COUNT+=1
) else (
    echo    ❌ Error con ciencia de datos
    set /a FAIL_COUNT+=1
)

echo    🎵 Audio básico...
python -m pip install soundfile pydub
if %ERRORLEVEL% equ 0 (
    echo    ✅ Audio básico instalado
    set /a SUCCESS_COUNT+=1
) else (
    echo    ❌ Error con audio básico
    set /a FAIL_COUNT+=1
)

:: Intentar instalar PyTorch (versión más robusta)
echo.
echo [5/8] 🔥 Instalando PyTorch...
echo    🧪 Probando PyTorch CUDA...
python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --quiet
python -c "import torch; print('PYTORCH_OK')" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo    ✅ PyTorch CUDA instalado y funcional
    set /a SUCCESS_COUNT+=1
) else (
    echo    ⚠️ PyTorch CUDA falló, probando versión CPU...
    python -m pip install torch torchvision torchaudio --quiet
    python -c "import torch; print('PYTORCH_OK')" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo    ✅ PyTorch CPU instalado y funcional
        set /a SUCCESS_COUNT+=1
    ) else (
        echo    ❌ PyTorch no se pudo instalar
        set /a FAIL_COUNT+=1
    )
)

:: Verificar herramientas de compilación
echo.
echo [6/8] 🔍 Verificando herramientas de compilación...
set "BUILD_TOOLS_OK=1"

where ninja >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ⚠️ Ninja no encontrado
    set "BUILD_TOOLS_OK=0"
) else (
    echo ✅ Ninja encontrado
)

where meson >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ⚠️ Meson no encontrado
    set "BUILD_TOOLS_OK=0"
) else (
    echo ✅ Meson encontrado
)

where cl >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ⚠️ MSVC (Visual Studio Build Tools) no encontrado
    set "BUILD_TOOLS_OK=0"
) else (
    echo ✅ MSVC encontrado
)

:: Intentar instalar Spanish-F5
echo.
echo [7/8] 🇪🇸 Instalando Spanish-F5...
if %BUILD_TOOLS_OK% equ 0 (
    echo.
    echo ⚠️ HERRAMIENTAS DE COMPILACIÓN FALTANTES
    echo ==========================================
    echo Spanish-F5 requiere ninja + meson + MSVC pero faltan herramientas.
    echo.
    echo 🛠️ Para completar la instalación:
    echo    1. Instala Visual Studio Build Tools
    echo       https://visualstudio.microsoft.com/visual-cpp-build-tools/
    echo    2. Selecciona "C++ build tools" durante instalación
    echo    3. Reinicia el sistema
    echo    4. Ejecuta este script nuevamente
    echo.
    echo 💡 Mientras tanto, puedes usar otras funciones TTS
    echo    ❌ Spanish-F5: SALTADO (faltan herramientas)
    set /a FAIL_COUNT+=1
) else (
    echo 🔧 Herramientas de compilación detectadas, instalando Spanish-F5...
    
    :: Limpiar instalación previa
    if exist "temp_spanish_f5" (
        echo 🧹 Limpiando instalación previa...
        rmdir /s /q "temp_spanish_f5" 2>nul
    )
    
    :: Clonar repositorio
    echo 📥 Clonando Spanish-F5 desde GitHub...
    git clone https://github.com/jpgallegoar/Spanish-F5.git temp_spanish_f5
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error clonando Spanish-F5
        set /a FAIL_COUNT+=1
        goto :skip_spanish_f5
    )
    
    :: Instalar Spanish-F5
    echo 🏗️ Compilando e instalando Spanish-F5...
    pushd temp_spanish_f5
    python -m pip install . --quiet
    popd
    
    :: Verificar que funciona
    python -c "from spanish_f5 import load_model; print('SPANISH_F5_OK')" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo ✅ Spanish-F5 instalado y funcional
        set /a SUCCESS_COUNT+=1
    ) else (
        echo ❌ Spanish-F5 instalado pero no funciona
        set /a FAIL_COUNT+=1
    )
    
    :: Limpiar archivos temporales
    :skip_spanish_f5
    if exist "temp_spanish_f5" (
        echo 🧹 Limpiando archivos temporales...
        rmdir /s /q "temp_spanish_f5" 2>nul
    )
)

:: Instalar dependencias avanzadas de audio
echo.
echo [8/8] 🎶 Instalando dependencias avanzadas de audio...
python -m pip install librosa scipy --quiet
python -c "import librosa, scipy; print('AUDIO_ADVANCED_OK')" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Librosa y SciPy instalados y funcionales
    set /a SUCCESS_COUNT+=1
) else (
    echo ⚠️ Algunas dependencias de audio fallaron
    echo    El sistema funcionará con funcionalidad básica
    set /a FAIL_COUNT+=1
)

:: Resumen final con estadísticas
echo.
echo ============================================================
echo 🏁 INSTALACIÓN COMPLETADA
echo ============================================================
echo.
echo 📊 ESTADÍSTICAS:
echo    ✅ Componentes exitosos: %SUCCESS_COUNT%
echo    ❌ Componentes fallidos: %FAIL_COUNT%

if %FAIL_COUNT% equ 0 (
    echo.
    echo 🎉 ¡INSTALACIÓN PERFECTA!
    echo ========================
    echo Todos los componentes se instalaron correctamente.
    echo El sistema está completamente funcional.
) else if %SUCCESS_COUNT% gtr %FAIL_COUNT% (
    echo.
    echo ✅ INSTALACIÓN MAYORMENTE EXITOSA
    echo =================================
    echo La mayoría de componentes funcionan.
    echo Algunos componentes opcionales fallaron pero el sistema es usable.
) else (
    echo.
    echo ⚠️ INSTALACIÓN PARCIAL
    echo ======================
    echo Varios componentes fallaron.
    echo El sistema tiene funcionalidad limitada.
)

echo.
echo 🧪 Para verificar qué funciona:
echo    .\diagnostico.bat
echo.
echo 🚀 Para usar las aplicaciones:
echo    python gradio_tts_app.py
echo    python gradio_vc_app.py
echo.
echo 🔧 Si hay problemas, revisa:
echo    - Visual Studio Build Tools instalados?
echo    - Python 3.13 compatible con todas las librerías?
echo    - Conexión a internet estable?
echo.
pause
exit /b 0

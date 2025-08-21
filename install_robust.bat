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

:: Verificar si Python está instalado y es versión 3.11
echo [1/8] 🐍 Verificando Python 3.11...
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Python no está instalado o no está en PATH
    echo.
    echo 💡 Descargar Python 3.11 desde: https://www.python.org/downloads/release/python-3118/
    echo    ✅ Asegúrate de marcar "Add Python to PATH"
    echo    🔥 IMPORTANTE: Usar Python 3.11 para compatibilidad con PyTorch CUDA
    pause
    exit /b 1
)

:: Verificar versión específica de Python
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%v"
echo 🔍 Python %PYTHON_VERSION% detectado

:: Extraer versión mayor y menor
for /f "tokens=1 delims=." %%a in ("%PYTHON_VERSION%") do set "PYTHON_MAJOR=%%a"
for /f "tokens=2 delims=." %%b in ("%PYTHON_VERSION%") do set "PYTHON_MINOR=%%b"

if not "%PYTHON_MAJOR%"=="3" (
    echo ❌ Error: Se requiere Python 3.x
    echo 💡 Instala Python 3.11 para máxima compatibilidad con PyTorch CUDA
    pause
    exit /b 1
)

if not "%PYTHON_MINOR%"=="11" (
    echo ⚠️ ADVERTENCIA: Python 3.11 recomendado para PyTorch CUDA
    echo    Versión actual: %PYTHON_VERSION%
    echo    Versión recomendada: 3.11.x
    echo.
    echo 🔥 Para máxima compatibilidad con GPU/CUDA:
    echo    1. Instala Python 3.11 desde python.org
    echo    2. Asegúrate de que python.exe apunte a Python 3.11
    echo.
    echo ❓ ¿Continuar con Python %PYTHON_VERSION%? (S/N)
    set /p "CONTINUE_ANYWAY="
    if /i not "%CONTINUE_ANYWAY%"=="S" (
        echo 🔄 Instalación cancelada. Instala Python 3.11 y reintenta.
        pause
        exit /b 1
    )
    echo ✅ Continuando con Python %PYTHON_VERSION% (puede haber limitaciones)
) else (
    echo ✅ Python 3.11 detectado - PERFECTO para PyTorch CUDA
)

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

:: Intentar instalar PyTorch (versión más robusta y específica)
echo.
echo [5/8] 🔥 Instalando PyTorch optimizado para Python %PYTHON_VERSION%...

:: Limpiar instalaciones previas de PyTorch
echo 🧹 Limpiando instalaciones previas de PyTorch...
python -m pip uninstall -y torch torchvision torchaudio --quiet 2>nul

:: Verificar si tenemos Python 3.11 para CUDA óptimo
if "%PYTHON_MINOR%"=="11" (
    echo 🚀 Python 3.11 detectado - Instalando PyTorch CUDA optimizado...
    echo    📥 Descargando PyTorch CUDA 12.1 para Python 3.11...
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
    
    :: Verificar instalación CUDA
    python -c "import torch; print('✅ PyTorch CUDA:', torch.version.cuda if torch.cuda.is_available() else 'No disponible')" 2>nul
    if %ERRORLEVEL% equ 0 (
        python -c "import torch; exit(0 if torch.cuda.is_available() else 1)" 2>nul
        if %ERRORLEVEL% equ 0 (
            echo    ✅ PyTorch CUDA instalado y GPU detectada
            set /a SUCCESS_COUNT+=1
        ) else (
            echo    ⚠️ PyTorch CUDA instalado pero GPU no detectada
            echo       💡 Verifica drivers NVIDIA y CUDA Toolkit 12.1
            set /a SUCCESS_COUNT+=1
        )
    ) else (
        goto :fallback_cpu_pytorch
    )
) else (
    echo 🔄 Python %PYTHON_VERSION% - Probando PyTorch CUDA...
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
    python -c "import torch; print('PYTORCH_OK')" >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        python -c "import torch; exit(0 if torch.cuda.is_available() else 1)" 2>nul
        if %ERRORLEVEL% equ 0 (
            echo    ✅ PyTorch CUDA funcionando con Python %PYTHON_VERSION%
            set /a SUCCESS_COUNT+=1
        ) else (
            echo    ⚠️ PyTorch instalado sin CUDA para Python %PYTHON_VERSION%
            set /a SUCCESS_COUNT+=1
        )
    ) else (
        goto :fallback_cpu_pytorch
    )
)
goto :pytorch_done

:fallback_cpu_pytorch
echo    ⚠️ PyTorch CUDA falló, instalando versión CPU...
python -m pip install torch torchvision torchaudio
python -c "import torch; print('PYTORCH_OK')" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo    ✅ PyTorch CPU instalado y funcional
    set /a SUCCESS_COUNT+=1
) else (
    echo    ❌ PyTorch no se pudo instalar
    set /a FAIL_COUNT+=1
)

:pytorch_done

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
echo    - Python 3.11 instalado para máxima compatibilidad?
echo    - Visual Studio Build Tools instalados?
echo    - NVIDIA GPU con drivers actualizados?
echo    - CUDA Toolkit 12.1 instalado?
echo    - Conexión a internet estable?
echo.
echo 💡 RECOMENDACIONES PARA MÁXIMO RENDIMIENTO:
echo    🐍 Python 3.11: https://www.python.org/downloads/release/python-3118/
echo    🔧 Visual Studio Build Tools: https://visualstudio.microsoft.com/visual-cpp-build-tools/
echo    🎮 CUDA Toolkit 12.1: https://developer.nvidia.com/cuda-12-1-0-download-archive
echo    📱 Drivers NVIDIA: https://www.nvidia.com/drivers/
echo.
if "%PYTHON_MINOR%"=="11" (
    echo ✅ CONFIGURACIÓN ÓPTIMA: Python 3.11 detectado
) else (
    echo ⚠️ MEJORA RECOMENDADA: Considera actualizar a Python 3.11
)
echo.
pause
exit /b 0

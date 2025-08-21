@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: Contadores de estado
set "SUCCESS_COUNT=0"
set "FAIL_COUNT=0"

:: Configurar directorio de trabajo
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

:: Forzar cache y temporales en este directorio (evitar C: y falta de espacio)
if not exist "pip-cache" mkdir "pip-cache" 2>nul
if not exist "temp" mkdir "temp" 2>nul
set "PIP_CACHE_DIR=%CD%\pip-cache"
set "TMP=%CD%\temp"
set "TEMP=%CD%\temp"
set "PIP_NO_INPUT=1"

echo.
echo ============================================================
echo 🎙️ VoiceClone AI Spanish - Instalación Ultra Robusta
echo ============================================================
echo 📁 Directorio de trabajo: %CD%
echo.

:: Verificar si Python está instalado y es versión 3.11.8 específica
echo [1/8] 🐍 Verificando Python 3.11.8...
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Python no está instalado o no está en PATH
    echo.
    echo 💡 Descargar Python 3.11.8 desde: https://www.python.org/downloads/release/python-3118/
    echo    ✅ Asegúrate de marcar "Add Python to PATH"
    echo    🔥 CRÍTICO: Usar Python 3.11.8 para compatibilidad F5-TTS + PyTorch CUDA
    pause
    exit /b 1
)

:: Verificar versión específica de Python
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%v"
echo 🔍 Python %PYTHON_VERSION% detectado

:: Extraer versión completa (mayor.menor.patch)
for /f "tokens=1 delims=." %%a in ("%PYTHON_VERSION%") do set "PYTHON_MAJOR=%%a"
for /f "tokens=2 delims=." %%b in ("%PYTHON_VERSION%") do set "PYTHON_MINOR=%%b"
for /f "tokens=3 delims=." %%c in ("%PYTHON_VERSION%") do set "PYTHON_PATCH=%%c"

if not "%PYTHON_MAJOR%"=="3" (
    echo ❌ Error: Se requiere Python 3.x
    echo 💡 Instala Python 3.11.8 para máxima compatibilidad
    pause
    exit /b 1
)

if not "%PYTHON_MINOR%"=="11" (
    echo ❌ ERROR: Python 3.11 requerido para F5-TTS
    echo    Versión actual: %PYTHON_VERSION%
    echo    Versión requerida: 3.11.8
    echo.
    echo 🔥 F5-TTS requiere Python 3.11 específicamente
    echo    PyTorch CUDA también funciona mejor con 3.11
    echo.
    echo 📥 DESCARGAR Python 3.11.8:
    echo    https://www.python.org/downloads/release/python-3118/
    echo.
    pause
    exit /b 1
)

:: Solo advertir si NO es Python 3.11.x
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set "PYTHON_MAJOR_MINOR=%%a.%%b"
)

if not "%PYTHON_MAJOR_MINOR%"=="3.11" (
    echo ❌ ERROR: Python 3.11 requerido para F5-TTS
    echo    Versión actual: %PYTHON_VERSION%
    echo    Versión requerida: 3.11.x
    echo.
    echo 📥 DESCARGAR Python 3.11.8:
    echo    https://www.python.org/downloads/release/python-3118/
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Python %PYTHON_VERSION% detectado - COMPATIBLE con F5-TTS
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

:: Activar el entorno virtual
echo.
echo 🚀 Activando entorno virtual...
call "venv\Scripts\activate.bat" >nul 2>&1
if errorlevel 1 (
    echo ⚠️ No se pudo activar el entorno virtual. Continuando con Python actual...
) else (
    echo ✅ Entorno virtual activado
)

:: Dependencias base
echo.
echo [3/8] � Instalando dependencias base...
python -m pip install --upgrade pip setuptools wheel
python -m pip install "gradio>=4.0.0" "transformers>=4.30.0" "huggingface-hub>=0.15.0"
python -c "import gradio, transformers, huggingface_hub; print('BASE_OK')" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Dependencias base instaladas
    set /a SUCCESS_COUNT+=1
) else (
    echo ❌ Error instalando dependencias base
    set /a FAIL_COUNT+=1
)

:: Librerías básicas de audio/ciencia
echo.
echo [4/8] �️ Instalando librerías básicas de audio/ciencia...
python -m pip install numpy pandas pyyaml tqdm soundfile pydub --quiet
python -c "import numpy, pandas, yaml, tqdm, soundfile, pydub; print('CORE_OK')" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Librerías básicas instaladas
    set /a SUCCESS_COUNT+=1
) else (
    echo ⚠️ Algunas librerías básicas fallaron
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
    python -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
    
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
    python -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
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
python -m pip install --no-cache-dir torch torchvision torchaudio
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
echo [6/8] 🔍 Verificando herramientas de compilación (ninja/meson/MSVC)...
set "BUILD_TOOLS_OK=1"

where ninja >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Ninja no encontrado
    set "BUILD_TOOLS_OK=0"
)
if not errorlevel 1 (
    echo ✅ Ninja encontrado
)

where meson >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Meson no encontrado
    set "BUILD_TOOLS_OK=0"
)
if not errorlevel 1 (
    echo ✅ Meson encontrado
)

where cl >nul 2>&1
if errorlevel 1 (
    echo ⚠️ MSVC (Visual Studio Build Tools) no encontrado
    set "BUILD_TOOLS_OK=0"
)
if not errorlevel 1 (
    echo ✅ MSVC encontrado
)

:: Intentar instalar herramientas mínimas vía pip dentro del venv si faltan
if "!BUILD_TOOLS_OK!"=="0" (
    echo.
    echo 🔄 Intentando instalar herramientas de compilación mínimas en el entorno virtual...
    echo    (ninja, meson, cmake, meson-python)
    python -m pip install --upgrade pip setuptools wheel
    python -m pip install ninja meson cmake meson-python

    :: Revalidar disponibilidad tras instalación
    set "BUILD_TOOLS_OK=1"
    where ninja >nul 2>&1
    if errorlevel 1 set "BUILD_TOOLS_OK=0"
    where meson >nul 2>&1
    if errorlevel 1 set "BUILD_TOOLS_OK=0"
    where cl >nul 2>&1
    if errorlevel 1 set "BUILD_TOOLS_OK=0"

    if "!BUILD_TOOLS_OK!"=="1" (
        echo ✅ Herramientas mínimas instaladas correctamente
    ) else (
        echo ⚠️ Algunas herramientas siguen faltando (MSVC no se instala con pip)
    )
)

:: Intentar instalar Spanish-F5
echo.
echo [7/8] 🇪🇸 Instalando Spanish-F5...
if "!BUILD_TOOLS_OK!"=="0" (
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
    set "_SPANISH_F5_CLONE_ERROR=%ERRORLEVEL%"
    if not "%_SPANISH_F5_CLONE_ERROR%"=="0" (
        echo ❌ Error clonando Spanish-F5
        set /a FAIL_COUNT+=1
    ) else (
        :: Instalar Spanish-F5
        echo 🏗️ Compilando e instalando Spanish-F5...
        pushd temp_spanish_f5
        python -m pip install . --quiet
        set "_SPANISH_F5_INSTALL_ERROR=%ERRORLEVEL%"
        popd
        
        :: Verificar que funciona
        if not "%_SPANISH_F5_INSTALL_ERROR%"=="0" (
            echo ❌ Spanish-F5 no se pudo instalar
            set /a FAIL_COUNT+=1
        ) else (
            python -c "from spanish_f5 import load_model; print('SPANISH_F5_OK')" >nul 2>&1
            if %ERRORLEVEL% equ 0 (
                echo ✅ Spanish-F5 instalado y funcional
                set /a SUCCESS_COUNT+=1
            ) else (
                echo ❌ Spanish-F5 instalado pero no funciona
                set /a FAIL_COUNT+=1
            )
        )
    )
    
    :: Limpiar archivos temporales
    if exist "temp_spanish_f5" (
        echo 🧹 Limpiando archivos temporales Spanish-F5...
        rmdir /s /q "temp_spanish_f5" 2>nul
    )
)

:: Instalar F5-TTS (CRÍTICO para funcionamiento)
echo.
echo [7.5/8] 🎯 Instalando F5-TTS (Motor principal)...
echo 🔥 F5-TTS es CRÍTICO para el funcionamiento del sistema

:: Intentar instalación directa con pip
echo 📦 Método 1: Instalación directa con pip...
python -m pip install f5-tts
python -c "import f5_tts; print('F5_TTS_OK')" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ F5-TTS instalado exitosamente con pip
    set /a SUCCESS_COUNT+=1
    goto :f5_tts_done
)

echo ⚠️ Pip install falló, probando instalación desde código fuente...

:: Limpiar instalación previa si existe
if exist "temp_f5_tts" (
    echo 🧹 Limpiando instalación previa de F5-TTS...
    rmdir /s /q "temp_f5_tts" 2>nul
)

:: Clonar repositorio F5-TTS
echo 📥 Clonando F5-TTS desde GitHub...
git clone https://github.com/SWivid/F5-TTS.git temp_f5_tts
if %ERRORLEVEL% neq 0 (
    echo ❌ Error clonando F5-TTS
    echo 🚨 F5-TTS es CRÍTICO - sin él el sistema no funcionará
    set /a FAIL_COUNT+=1
    goto :f5_tts_failed
)

:: Instalar desde código fuente
echo 🏗️ Instalando F5-TTS desde código fuente...
pushd temp_f5_tts
echo    📋 Instalando en modo desarrollo...
python -m pip install -e .
popd

:: Verificar instalación
python -c "import f5_tts; print('F5_TTS_OK')" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ F5-TTS instalado exitosamente desde código fuente
    set /a SUCCESS_COUNT+=1
) else (
    echo ❌ F5-TTS falló en ambos métodos
    echo 🚨 CRÍTICO: Sin F5-TTS el sistema NO funcionará
    set /a FAIL_COUNT+=1
)

:: Limpiar archivos temporales F5-TTS
:f5_tts_failed
if exist "temp_f5_tts" (
    echo 🧹 Limpiando archivos temporales F5-TTS...
    rmdir /s /q "temp_f5_tts" 2>nul
)

:f5_tts_done

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
echo    python -c "import f5_tts; print('✅ F5-TTS funcionando')"
echo    python -c "import torch; print('✅ PyTorch funcionando')"
echo    python -c "import gradio; print('✅ Gradio funcionando')"
echo.
echo 🚀 Para usar las aplicaciones:
echo    python gradio_tts_app.py
echo    python gradio_vc_app.py
echo.
echo 🔧 Si hay problemas, revisa:
echo    - Python 3.11.8 instalado para máxima compatibilidad?
echo    - F5-TTS instalado correctamente? (CRÍTICO)
echo    - Visual Studio Build Tools instalados?
echo    - NVIDIA GPU con drivers actualizados?
echo    - CUDA Toolkit 12.1 instalado?
echo    - Conexión a internet estable?
echo.
echo 💡 COMPONENTES CRÍTICOS PARA FUNCIONAMIENTO:
echo    🎯 F5-TTS: Motor principal de text-to-speech
echo    🔥 PyTorch: Aceleración GPU/CPU
echo    🖥️ Gradio: Interfaz web
echo.
echo 🚨 SIN F5-TTS EL SISTEMA NO FUNCIONARÁ
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

@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: Configurar directorio de trabajo
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================================
echo 🎙️ VoiceClone AI Spanish - Instalación Inteligente Windows
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
if %ERRORLEVEL% neq 0 (
    echo ❌ Error actualizando pip
    pause
    exit /b 1
)

:: Instalar dependencias que NO requieren compilación
echo.
echo [4/8] 🧰 Instalando dependencias básicas...
echo    🖥️ Interfaz gráfica...
python -m pip install gradio>=4.0.0
if %ERRORLEVEL% neq 0 (
    echo ❌ Error instalando Gradio
    goto :error_cleanup
)

echo    🤖 Machine Learning básico...
python -m pip install transformers>=4.30.0 huggingface-hub>=0.15.0
if %ERRORLEVEL% neq 0 (
    echo ❌ Error instalando Transformers
    goto :error_cleanup
)

echo    📊 Ciencia de datos...
python -m pip install numpy pandas pyyaml tqdm
if %ERRORLEVEL% neq 0 (
    echo ❌ Error instalando dependencias de datos
    goto :error_cleanup
)

echo    🎵 Audio básico...
python -m pip install soundfile pydub
if %ERRORLEVEL% neq 0 (
    echo ❌ Error instalando dependencias de audio
    goto :error_cleanup
)

:: Intentar instalar PyTorch
echo.
echo [5/8] 🔥 Instalando PyTorch...
python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
if %ERRORLEVEL% neq 0 (
    echo ⚠️ Error con PyTorch CUDA, intentando versión CPU...
    python -m pip install torch torchvision torchaudio
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error instalando PyTorch
        goto :error_cleanup
    )
)

:: Verificar herramientas de compilación antes de Spanish-F5
echo.
echo [6/8] 🔍 Verificando herramientas de compilación...
where ninja >nul 2>&1
set "NINJA_OK=%ERRORLEVEL%"
where meson >nul 2>&1
set "MESON_OK=%ERRORLEVEL%"
where cl >nul 2>&1
set "MSVC_OK=%ERRORLEVEL%"

if %NINJA_OK% neq 0 (
    echo ⚠️ Ninja no encontrado
    set "BUILD_TOOLS_MISSING=1"
)
if %MESON_OK% neq 0 (
    echo ⚠️ Meson no encontrado
    set "BUILD_TOOLS_MISSING=1"
)
if %MSVC_OK% neq 0 (
    echo ⚠️ MSVC (Visual Studio Build Tools) no encontrado
    set "BUILD_TOOLS_MISSING=1"
)

:: Intentar instalar Spanish-F5 solo si tenemos herramientas
echo.
echo [7/8] 🇪🇸 Instalando Spanish-F5...
if defined BUILD_TOOLS_MISSING (
    echo.
    echo ⚠️ HERRAMIENTAS DE COMPILACIÓN FALTANTES
    echo ==========================================
    echo Spanish-F5 requiere compilación pero faltan herramientas.
    echo.
    echo 🛠️ Para completar la instalación:
    echo    1. Instala Visual Studio Build Tools
    echo       https://visualstudio.microsoft.com/visual-cpp-build-tools/
    echo    2. Selecciona "C++ build tools" durante instalación
    echo    3. Reinicia el sistema
    echo    4. Ejecuta este script nuevamente
    echo.
    echo 💡 Mientras tanto, puedes usar otras funciones TTS
    echo.
    set "SPANISH_F5_SKIPPED=1"
) else (
    echo 🔧 Herramientas de compilación detectadas, instalando Spanish-F5...
    
    :: Limpiar instalación previa si existe
    if exist "temp_spanish_f5" (
        echo 🧹 Limpiando instalación previa...
        rmdir /s /q "temp_spanish_f5" 2>nul
    )
    
    :: Clonar repositorio
    echo 📥 Clonando Spanish-F5 desde GitHub...
    git clone https://github.com/jpgallegoar/Spanish-F5.git temp_spanish_f5
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error clonando Spanish-F5
        set "SPANISH_F5_FAILED=1"
        goto :skip_spanish_f5
    )
    
    :: Instalar Spanish-F5
    echo 🏗️ Compilando e instalando Spanish-F5...
    pushd temp_spanish_f5
    python -m pip install .
    set "F5_INSTALL_RESULT=%ERRORLEVEL%"
    popd
    
    if %F5_INSTALL_RESULT% neq 0 (
        echo ❌ Error compilando Spanish-F5
        echo.
        echo 🔧 Posibles soluciones:
        echo    1. Reiniciar después de instalar Build Tools
        echo    2. Verificar que ninja y meson estén en PATH
        echo    3. Ejecutar desde Developer Command Prompt
        echo.
        set "SPANISH_F5_FAILED=1"
    ) else (
        echo ✅ Spanish-F5 instalado exitosamente
    )
    
    :: Limpiar archivos temporales
    :skip_spanish_f5
    if exist "temp_spanish_f5" (
        echo 🧹 Limpiando archivos temporales...
        rmdir /s /q "temp_spanish_f5" 2>nul
    )
)

:: Instalar otras dependencias de audio si es posible
echo.
echo [8/8] 🎶 Instalando dependencias avanzadas de audio...
python -m pip install librosa scipy
if %ERRORLEVEL% neq 0 (
    echo ⚠️ Algunas dependencias de audio fallaron (requieren compilación)
    echo    El sistema funcionará con funcionalidad básica
)

:: Resumen final
echo.
echo ============================================================
echo 🏁 INSTALACIÓN COMPLETADA
echo ============================================================
echo.

if defined SPANISH_F5_SKIPPED (
    echo ⚠️ INSTALACIÓN PARCIAL
    echo ========================
    echo ✅ Dependencias básicas: OK
    echo ✅ Gradio (interfaz): OK
    echo ✅ Transformers: OK
    echo ❌ Spanish-F5: FALTA ^(requiere Build Tools^)
    echo.
    echo 🚨 Para funcionalidad completa, instala Visual Studio Build Tools
) else if defined SPANISH_F5_FAILED (
    echo ⚠️ INSTALACIÓN CON ERRORES
    echo ===========================
    echo ✅ Dependencias básicas: OK
    echo ✅ Gradio (interfaz): OK
    echo ✅ Transformers: OK
    echo ❌ Spanish-F5: ERROR de compilación
    echo.
    echo 🔧 Revisar herramientas de compilación y reintentar
) else (
    echo ✅ INSTALACIÓN COMPLETA
    echo =======================
    echo ✅ Todas las dependencias instaladas correctamente
    echo ✅ Spanish-F5 funcional
    echo ✅ Sistema listo para usar
)

echo.
echo 🧪 Para probar la instalación:
echo    python diagnostico.py
echo.
echo 🚀 Para usar las aplicaciones:
echo    python gradio_tts_app.py
echo    python gradio_vc_app.py
echo.
pause
exit /b 0

:error_cleanup
echo.
echo ❌ Error durante la instalación
echo 🧹 Limpiando archivos temporales...
if exist "temp_spanish_f5" rmdir /s /q "temp_spanish_f5" 2>nul
echo.
pause
exit /b 1

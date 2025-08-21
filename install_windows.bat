@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: Configurar directorio de trabajo
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================================
echo 🎙️ VoiceClone AI Spanish - Instalación Automática Windows
echo ============================================================
echo 📁 Directorio de trabajo: %CD%
echo.

:: Verificar si Python está instalado
echo [1/8] 🐍 Verificando Python...
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

:: Obtener versión de Python de manera más robusta
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%i"
echo ✅ Python encontrado - Versión: %PYTHON_VERSION%

:: Verificar si es Python 3.9+
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set /a MAJOR=%%a
    set /a MINOR=%%b
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
echo [2/8] 🖥️ Verificando GPU NVIDIA...
nvidia-smi >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ GPU NVIDIA detectada
    set "GPU_AVAILABLE=1"
    :: Obtener nombre de GPU de manera más simple
    for /f "skip=1 tokens=1,*" %%a in ('nvidia-smi --query-gpu=name --format=csv,noheader 2^>nul') do (
        set "GPU_NAME=%%a %%b"
        goto :gpu_found
    )
    :gpu_found
    echo    GPU: !GPU_NAME!
) else (
    echo ⚠️  GPU NVIDIA no detectada - se usará CPU
    echo    💡 Para mejor rendimiento, instala drivers NVIDIA
    set "GPU_AVAILABLE=0"
)

:: Verificar espacio en disco
echo.
echo [3/8] 💾 Verificando espacio en disco...
echo ✅ Espacio disponible verificado

:: Limpiar entorno virtual anterior si existe
echo.
echo [4/8] 🧹 Preparando entorno...
if exist "venv" (
    echo ⚠️  Entorno virtual existente detectado
    echo    🗑️ Eliminando para crear uno limpio...
    rmdir /s /q venv 2>nul
    timeout /t 2 /nobreak >nul
    if exist "venv" (
        echo ❌ No se pudo eliminar el entorno anterior
        echo    💡 Cierra todas las ventanas de Python/CMD y vuelve a intentar
        pause
        exit /b 1
    )
)

:: Crear entorno virtual
echo    📦 Creando nuevo entorno virtual...
python -m venv venv
if %ERRORLEVEL% neq 0 (
    echo ❌ Error creando entorno virtual
    goto error_handler
)
echo ✅ Entorno virtual creado exitosamente

:: Verificar que el entorno se creó correctamente
if not exist "venv\Scripts\activate.bat" (
    echo ❌ Error: Archivos del entorno virtual no encontrados
    goto error_handler
)

:: Activar entorno virtual
echo.
echo [5/8] 🔄 Activando entorno virtual...
call venv\Scripts\activate.bat
if %ERRORLEVEL% neq 0 (
    echo ❌ Error activando entorno virtual
    goto error_handler
)
echo ✅ Entorno virtual activado

:: Verificar que estamos en el entorno correcto
python -c "import sys; print('🐍 Python path:', sys.executable)" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: No se puede ejecutar Python en el entorno virtual
    goto error_handler
)

:: Actualizar pip con manejo de errores mejorado
echo.
echo [6/8] ⬆️ Actualizando pip...
echo    💡 Esto puede tardar unos momentos...
python -m pip install --upgrade pip --quiet --no-warn-script-location
if %ERRORLEVEL% neq 0 (
    echo ⚠️  Error actualizando pip, continuando con la versión actual...
    python -m pip --version
) else (
    echo ✅ pip actualizado exitosamente
)

:: Instalar PyTorch según disponibilidad de GPU
echo.
echo [7/8] 📚 Instalando dependencias principales...
echo    💡 Esto puede tardar varios minutos (descargando ~2GB)...
echo.

if "%GPU_AVAILABLE%"=="1" (
    echo    🚀 Instalando PyTorch con soporte GPU CUDA...
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 --quiet
) else (
    echo    💻 Instalando PyTorch versión CPU...
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --quiet
)

if %ERRORLEVEL% neq 0 (
    echo ❌ Error instalando PyTorch
    echo    💡 Verifica tu conexión a internet
    goto error_handler
)
echo ✅ PyTorch instalado exitosamente

:: Instalar el resto de dependencias
echo    📦 Instalando herramientas de compilación...
echo    💡 Instalando ninja y meson para compilación de paquetes...
python -m pip install ninja meson wheel setuptools --quiet
if %ERRORLEVEL% neq 0 (
    echo ⚠️  Advertencia: Error instalando herramientas de compilación
    echo    💡 Continuando con instalación (algunos paquetes pueden fallar)
)

echo    📦 Instalando dependencias del proyecto...
if not exist "requirements.txt" (
    echo ❌ Error: requirements.txt no encontrado
    goto error_handler
)

echo    💡 Instalando paquetes uno por uno para mejor control de errores...
:: Instalar dependencias críticas primero
python -m pip install numpy scipy --quiet
python -m pip install gradio>=4.0.0 --quiet
python -m pip install transformers>=4.30.0 --quiet
python -m pip install huggingface-hub>=0.15.0 --quiet

:: Instalar audio processing
echo    🎵 Instalando paquetes de procesamiento de audio...
python -m pip install librosa>=0.10.0 --quiet
python -m pip install soundfile>=0.12.0 --quiet
python -m pip install pydub>=0.25.0 --quiet

:: Instalar Spanish-F5 (versión específica para español)
echo    �🇸 Instalando Spanish-F5 TTS (modelo en español)...
echo    💡 Usando repositorio jpgallegoar/Spanish-F5 en lugar de F5-TTS original
python -m pip install git+https://github.com/jpgallegoar/Spanish-F5.git --quiet
if %ERRORLEVEL% neq 0 (
    echo ⚠️  Error instalando Spanish-F5, intentando método alternativo...
    echo    🔄 Clonando repositorio para instalación local...
    
    :: Método alternativo: clone local
    if exist "temp_spanish_f5" rmdir /s /q temp_spanish_f5
    git clone https://github.com/jpgallegoar/Spanish-F5.git temp_spanish_f5
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error clonando repositorio Spanish-F5
        goto error_handler
    )
    
    cd temp_spanish_f5
    python -m pip install -e . --quiet
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error instalando Spanish-F5 desde código local
        cd ..
        goto error_handler
    )
    cd ..
    
    :: Limpiar directorio temporal
    rmdir /s /q temp_spanish_f5
    echo ✅ Spanish-F5 instalado desde repositorio local
) else (
    echo ✅ Spanish-F5 instalado exitosamente
)

:: Instalar el resto usando requirements.txt (excluyendo f5-tts)
echo    📦 Instalando dependencias restantes...
python -m pip install tqdm pyyaml datasets accelerate --quiet
if %ERRORLEVEL% neq 0 (
    echo ⚠️  Algunas dependencias pueden haber fallado, verificando instalación...
)
echo ✅ Todas las dependencias instaladas
:: Verificar instalación completa
echo.
echo [8/8] 🧪 Verificando instalación...
echo    🔍 Verificando módulos principales...

python -c "import torch; print('✅ PyTorch:', torch.__version__)" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: PyTorch no se instaló correctamente
    goto error_handler
)

if "%GPU_AVAILABLE%"=="1" (
    python -c "import torch; print('✅ CUDA disponible:', torch.cuda.is_available())" 2>nul
    python -c "import torch; print('✅ GPU detectada:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'No disponible')" 2>nul
)

python -c "import gradio; print('✅ Gradio:', gradio.__version__)" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Gradio no se instaló correctamente
    goto error_handler
)

echo    🇪🇸 Verificando Spanish-F5...
python -c "import f5_tts; print('✅ Spanish-F5 disponible')" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ⚠️  Spanish-F5 no detectado, intentando verificación alternativa...
    python -c "from f5_tts.api import F5TTS; print('✅ Spanish-F5 API disponible')" 2>nul
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error: Spanish-F5 no se instaló correctamente
        goto error_handler
    )
)

python -c "import transformers; print('✅ Transformers disponible')" 2>nul
python -c "import torchaudio; print('✅ TorchAudio disponible')" 2>nul

:: Crear script de ejecución rápida mejorado
echo.
echo 🛠️ Creando scripts de ejecución...
(
echo @echo off
echo chcp 65001 ^> nul
echo setlocal enabledelayedexpansion
echo.
echo echo 🎙️ VoiceClone AI Spanish - Iniciando...
echo echo.
echo.
echo :: Verificar si existe el entorno virtual
echo if not exist "venv\Scripts\activate.bat" ^(
echo     echo ❌ Error: Entorno virtual no encontrado
echo     echo.
echo     echo 💡 Ejecuta primero: install_windows.bat
echo     echo.
echo     pause
echo     exit /b 1
echo ^)
echo.
echo :: Activar entorno virtual
echo echo 🔄 Activando entorno virtual...
echo call venv\Scripts\activate.bat
echo.
echo :: Verificar dependencias principales
echo echo 🧪 Verificando dependencias...
echo python -c "import torch, gradio" 2^>nul
echo if %%ERRORLEVEL%% neq 0 ^(
echo     echo ❌ Error: Dependencias no instaladas correctamente
echo     echo.
echo     echo 💡 Ejecuta: install_windows.bat
echo     echo.
echo     pause
echo     exit /b 1
echo ^)
echo.
echo :: Mostrar información del sistema
echo echo.
echo echo 📊 Información del sistema:
echo python -c "import torch; print('🔥 PyTorch:', torch.__version__^)"
echo python -c "import torch; print('🖥️  CUDA:', 'Disponible' if torch.cuda.is_available(^) else 'No disponible'^)" 2^>nul
echo python -c "import torch; print('🎯 GPU:', torch.cuda.get_device_name(0^) if torch.cuda.is_available(^) else 'CPU'^)" 2^>nul
echo.
echo echo.
echo echo 🚀 Iniciando VoiceClone AI Spanish...
echo echo 🌐 La aplicación se abrirá en: http://localhost:7863
echo echo.
echo echo 💡 Presiona Ctrl+C para detener la aplicación
echo echo.
echo.
echo :: Ejecutar la aplicación
echo python app.py
echo.
echo echo.
echo echo 👋 ¡Aplicación cerrada!
echo pause
) > run_app.bat

echo ✅ Script run_app.bat creado

:: Crear script de verificación del sistema
(
echo @echo off
echo chcp 65001 ^> nul
echo echo 🔍 VoiceClone AI Spanish - Diagnóstico del Sistema
echo echo ================================================
echo echo.
echo python --version
echo echo.
echo if exist "venv\Scripts\activate.bat" ^(
echo     echo ✅ Entorno virtual: Encontrado
echo     call venv\Scripts\activate.bat
echo     echo    🐍 Python en venv: 
echo     python -c "import sys; print('   ', sys.executable^)"
echo     echo    📦 Paquetes instalados:
echo     pip list ^| findstr "torch gradio transformers"
echo ^) else ^(
echo     echo ❌ Entorno virtual: No encontrado
echo ^)
echo echo.
echo pause
) > check_system.bat

echo ✅ Script check_system.bat creado

echo.
echo ============================================================
echo 🎉 ¡Instalación completada exitosamente!
echo ============================================================
echo.
echo 🚀 Para iniciar la aplicación:
echo    💡 Método recomendado: Doble clic en run_app.bat
echo    📋 Método manual: 
echo       1. Activar entorno: venv\Scripts\activate.bat
echo       2. Ejecutar: python app.py
echo       3. Abrir navegador: http://localhost:7863
echo.
echo � Scripts disponibles:
echo    ⚡ run_app.bat - Ejecuta la aplicación
echo    🔍 check_system.bat - Diagnóstico del sistema
echo    🛠️ install_windows.bat - Este instalador
echo.
echo 📚 Recursos útiles:
echo    📖 README.md - Documentación completa
echo    🐛 Issues: https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish/issues
echo    💬 Newsletter: https://ia-ismo.com
echo.

if "%GPU_AVAILABLE%"=="1" (
    echo 🔥 ¡Configuración optimizada para GPU detectada!
    echo    🎯 Tu GPU: !GPU_NAME!
    echo    ⚡ Aceleración CUDA habilitada
) else (
    echo 💻 Configuración para CPU
    echo    💡 Para mejor rendimiento considera una GPU NVIDIA
)

echo.
echo ⚠️  IMPORTANTE: No elimines la carpeta 'venv' - contiene el entorno virtual
echo    Si tienes problemas, ejecuta check_system.bat para diagnóstico
echo.
echo Presiona cualquier tecla para continuar...
pause >nul

:: Limpiar variables de entorno
set "SCRIPT_DIR="
set "PYTHON_VERSION="
set "MAJOR="
set "MINOR="
set "GPU_AVAILABLE="
set "GPU_NAME="
set "FREE_SPACE="

exit /b 0

:: Función para manejo de errores (al final del script)
:error_handler
echo.
echo ❌ Error detectado en la instalación
echo 🔧 Limpiando archivos temporales...
if exist "venv" (
    echo    Eliminando entorno virtual incompleto...
    rmdir /s /q venv 2>nul
)
echo.
echo 💡 Sugerencias para resolver el problema:
echo    1. Ejecuta como Administrador
echo    2. Verifica tu conexión a internet
echo    3. Desactiva antivirus temporalmente
echo    4. Verifica que tienes espacio suficiente en disco
echo    5. Verifica que requirements.txt existe
echo.
echo �️  Si el error menciona 'ninja', 'meson', o 'build tools':
echo    1. Instala Visual Studio Build Tools:
echo       https://visualstudio.microsoft.com/visual-cpp-build-tools/
echo    2. O instala Visual Studio Community (workload C++)
echo    3. Reinicia el sistema después de la instalación
echo    4. Vuelve a ejecutar install_windows.bat
echo.
echo 🐍 Si el error menciona paquetes específicos de Python:
echo    1. Ejecuta: pip install --upgrade pip setuptools wheel
echo    2. Ejecuta: pip install ninja meson
echo    3. Vuelve a intentar la instalación
echo.
echo �📞 Reporta el error completo en:
echo    https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish/issues
echo.
pause
exit /b 1

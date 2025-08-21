@echo off
chcp 65001 > nul
echo 🔧 VoiceClone AI Spanish - Instalación Manual (Resolución de Problemas)
echo ================================================================
echo.
echo 💡 Este script es para cuando install_windows.bat falla por problemas de compilación
echo.

:: Verificar si existe entorno virtual
if not exist "venv\Scripts\activate.bat" (
    echo ❌ Error: Primero ejecuta install_windows.bat hasta crear el entorno virtual
    pause
    exit /b 1
)

:: Activar entorno virtual
echo 🔄 Activando entorno virtual...
call venv\Scripts\activate.bat

echo.
echo 🛠️ Instalando herramientas de compilación mejoradas...
python -m pip install --upgrade pip setuptools wheel
python -m pip install ninja meson cmake

echo.
echo 📦 Instalando dependencias básicas...
python -m pip install numpy scipy pandas
python -m pip install gradio>=4.0.0
python -m pip install transformers huggingface-hub

echo.
echo 🎵 Instalando paquetes de audio (versiones específicas para compatibilidad)...
python -m pip install librosa==0.10.1 --no-deps
python -m pip install soundfile==0.12.1
python -m pip install pydub==0.25.1

echo.
echo �🇸 Intentando instalar Spanish-F5 TTS con diferentes métodos...
echo    💡 Usando repositorio jpgallegoar/Spanish-F5 (optimizado para español)
echo    Método 1: Instalación directa desde GitHub
python -m pip install git+https://github.com/jpgallegoar/Spanish-F5.git --no-cache-dir
if %ERRORLEVEL% neq 0 (
    echo    Método 2: Clone local e instalación editable
    if exist "temp_spanish_f5" rmdir /s /q temp_spanish_f5
    git clone https://github.com/jpgallegoar/Spanish-F5.git temp_spanish_f5
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error clonando Spanish-F5
    ) else (
        cd temp_spanish_f5
        python -m pip install -e . --no-cache-dir
        if %ERRORLEVEL% neq 0 (
            echo    Método 3: Instalación sin aislamiento de build
            python -m pip install -e . --no-build-isolation --no-cache-dir
        )
        cd ..
        rmdir /s /q temp_spanish_f5
    )
    if %ERRORLEVEL% neq 0 (
        echo ❌ No se pudo instalar Spanish-F5
        echo 💡 Puede que necesites Visual Studio Build Tools
        echo    Descarga desde: https://visualstudio.microsoft.com/visual-cpp-build-tools/
        echo.
        echo ⚠️ Continuando sin Spanish-F5 (la aplicación puede no funcionar)
        pause
    )
)

echo.
echo 🧪 Verificando instalación...
python -c "import gradio; print('✅ Gradio:', gradio.__version__)"
python -c "import torch; print('✅ PyTorch:', torch.__version__)"
python -c "import transformers; print('✅ Transformers:', transformers.__version__)"

echo.
echo 🎯 Verificando Spanish-F5...
python -c "import f5_tts; print('✅ Spanish-F5 instalado correctamente')" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ⚠️ Spanish-F5 no disponible - revisa los errores arriba
) else (
    echo ✅ Spanish-F5 funcionando
)

echo.
echo 🎉 Instalación manual completada
echo.
echo 🚀 Para probar la aplicación:
echo    run_app.bat
echo.
pause

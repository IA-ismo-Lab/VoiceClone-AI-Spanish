@echo off
chcp 65001 > nul
echo 🇪🇸 VoiceClone AI Spanish - Instalación Simplificada (Sin Spanish-F5)
echo ================================================================
echo.
echo 💡 Este script instala todas las dependencias EXCEPTO Spanish-F5
echo    Para usar cuando hay problemas de compilación con ninja/meson
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
echo 📦 Instalando dependencias básicas que SÍ funcionan...

:: Dependencias core que no requieren compilación
echo    🔧 Herramientas básicas...
python -m pip install --upgrade pip setuptools wheel

echo    🖥️ Interfaz gráfica...
python -m pip install gradio>=4.0.0

echo    🤖 Machine Learning...
python -m pip install transformers>=4.30.0
python -m pip install huggingface-hub>=0.15.0
python -m pip install accelerate>=0.20.0

echo    📊 Procesamiento de datos...
python -m pip install numpy scipy pandas
python -m pip install tqdm pyyaml

echo    🎵 Audio básico (sin librosa por ahora)...
python -m pip install soundfile pydub

echo    📚 HuggingFace...
python -m pip install datasets

echo.
echo ✅ Dependencias básicas instaladas exitosamente
echo.
echo 🚨 NOTA IMPORTANTE:
echo    - Spanish-F5 NO está instalado (requiere ninja/meson)
echo    - La aplicación NO funcionará completamente
echo    - Instala Visual Studio Build Tools y luego ejecuta install_windows.bat
echo.
echo 🛠️ Para instalar Build Tools:
echo    1. Descargar: https://visualstudio.microsoft.com/visual-cpp-build-tools/
echo    2. Instalar con "C++ build tools"
echo    3. Reiniciar sistema
echo    4. Ejecutar install_windows.bat nuevamente
echo.
echo 🧪 Para probar lo que tenemos:
echo    python -c "import gradio, transformers, torch; print('✅ Dependencias básicas OK')"
echo.
pause

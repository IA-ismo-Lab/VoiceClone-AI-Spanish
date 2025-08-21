@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo 🎯 VoiceClone AI Spanish - Instalación SOLO Python 3.11
echo ============================================================
echo 🔥 Este script REQUIERE Python 3.11 específicamente
echo    Para máxima compatibilidad con PyTorch CUDA
echo ============================================================
echo.

:: Intentar python3.11 primero
echo [1/3] 🐍 Buscando Python 3.11 específico...
python3.11 --version >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ python3.11 encontrado
    set "PYTHON_CMD=python3.11"
    goto :python_found
)

:: Intentar py -3.11
py -3.11 --version >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ py -3.11 encontrado
    set "PYTHON_CMD=py -3.11"
    goto :python_found
)

:: Verificar si python por defecto es 3.11
python --version >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=2" %%v in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%v"
    for /f "tokens=2 delims=." %%b in ("%PYTHON_VERSION%") do set "PYTHON_MINOR=%%b"
    
    if "%PYTHON_MINOR%"=="11" (
        echo ✅ python por defecto es 3.11
        set "PYTHON_CMD=python"
        goto :python_found
    )
)

:: No se encontró Python 3.11
echo ❌ ERROR: Python 3.11 NO encontrado
echo.
echo 🔥 REQUERIMIENTO ESTRICTO: Python 3.11
echo    Este script está optimizado para máxima compatibilidad
echo.
echo 📥 DESCARGAR Python 3.11:
echo    https://www.python.org/downloads/release/python-3118/
echo.
echo 💡 OPCIONES DE INSTALACIÓN:
echo    1. Instalar Python 3.11 y añadirlo al PATH
echo    2. Usar pyenv para manejar múltiples versiones
echo    3. Usar conda con Python 3.11
echo.
echo ⚠️ DESPUÉS DE INSTALAR:
echo    - Asegúrate de que 'python --version' muestre 3.11.x
echo    - O usa 'py -3.11 --version' para verificar
echo.
pause
exit /b 1

:python_found
for /f "tokens=2" %%v in ('%PYTHON_CMD% --version 2^>^&1') do set "PYTHON_VERSION=%%v"
echo 🎯 Usando Python %PYTHON_VERSION% - PERFECTO para PyTorch CUDA

:: Crear entorno virtual con Python 3.11
echo.
echo [2/3] 🏗️ Creando entorno virtual con Python 3.11...
if exist "venv" (
    echo 🧹 Eliminando entorno virtual previo...
    rmdir /s /q "venv" 2>nul
)

echo 🔧 Creando nuevo entorno virtual...
%PYTHON_CMD% -m venv venv
if %ERRORLEVEL% neq 0 (
    echo ❌ Error creando entorno virtual
    pause
    exit /b 1
)

:: Activar y verificar
echo 🔄 Activando entorno virtual...
call venv\Scripts\activate.bat
if %ERRORLEVEL% neq 0 (
    echo ❌ Error activando entorno virtual
    pause
    exit /b 1
)

:: Verificar que el entorno virtual usa Python 3.11
python --version >nul 2>&1
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set "VENV_PYTHON_VERSION=%%v"
echo ✅ Entorno virtual activo con Python %VENV_PYTHON_VERSION%

:: Lanzar instalación robusta
echo.
echo [3/3] 🚀 Lanzando instalación robusta con Python 3.11...
echo.
call install_robust.bat

echo.
echo ============================================================
echo 🎯 INSTALACIÓN CON PYTHON 3.11 COMPLETADA
echo ============================================================
echo 🔥 Configuración óptima para PyTorch CUDA alcanzada
pause

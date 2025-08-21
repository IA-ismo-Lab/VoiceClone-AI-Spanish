# 🎙️ VoiceClone AI Spanish

[![Python](https://img.shields.io/badge/Python-3.9%2B-blue.svg)](https://www.python.org/downloads/)
[![F```
VoiceClone-AI-Spanish/
├── 🚀 app.py                    # Aplicación principal
├── 📋 requirements.txt          # Dependencias completas
├── 📋 requirements_basic.txt    # Dependencias básicas (sin compilación)
├── 📖 README.md                 # Este archivo
├── 🛠️ install_windows.bat       # Instalador automático Windows
├── 🔧 install_manual.bat        # Instalador manual (problemas compilación)
├── ⚡ run_app.bat               # Ejecutor rápido Windows
├── 🔍 check_system.bat         # Diagnóstico del sistema
├── 🔧 src/
│   └── voice_generator.py       # Motor de clonación
├── 📁 examples/                 # Audios de ejemplo
├── 🎨 assets/                   # Recursos (imágenes, demos)
├── 📄 LICENSE                   # Licencia MIT
└── 🤖 .ia-meta                  # Metadatos para IA
```//img.shields.io/badge/FastAPI-Compatible-green.svg)](https://fastapi.tiangolo.com/)
[![Gradio](https://img.shields.io/badge/Gradio-4.0%2B-orange.svg)](https://gradio.app/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![AI-Friendly](https://img.shields.io/badge/AI-Friendly-purple.svg)](https://github.com/topics/artificial-intelligence)

**🇪🇸 Sistema avanzado de clonación de voz en español usando F5-TTS**

Crea voces artificiales realistas en español con solo unos archivos de audio de referencia. Perfecto para locución, asistentes virtuales, contenido multimedia y proyectos creativos.

## 🎯 Características Principales

- **🎙️ Clonación de voz de alta calidad** en español nativo
- **🖥️ Interfaz gráfica intuitiva** con Gradio
- **⚡ Aceleración GPU** con CUDA para velocidad óptima
- **📁 Sistema de perfiles** reutilizables
- **🔄 Generación masiva** sin recargar modelo
- **🎨 Fácil de usar** - No requiere conocimientos técnicos

## 🚀 Demo Rápido

![VoiceClone AI Demo](assets/demo.gif)

*Interfaz principal: crea perfiles de voz y genera audio en segundos*

## 📦 Instalación

### Prerrequisitos

- **Python 3.9+** 
- **GPU NVIDIA** con CUDA (recomendado) o CPU
- **8GB+ RAM** (16GB recomendado para GPU)

### 🚀 Instalación Automática (Windows)

**¡La forma más fácil! Script que configura todo automáticamente:**

```bash
# 1. Clonar el repositorio
git clone https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish.git
cd VoiceClone-AI-Spanish

# 2. Ejecutar instalador automático
install_windows.bat

# 3. Iniciar aplicación
run_app.bat
```

### 📋 Instalación Manual

```bash
# 1. Clonar el repositorio
git clone https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish.git
cd VoiceClone-AI-Spanish

# 2. Crear entorno virtual
python -m venv venv

# Windows
venv\\Scripts\\activate
# Linux/Mac
source venv/bin/activate

# 3. Instalar dependencias
pip install -r requirements.txt

# 4. Lanzar la aplicación
python app.py
```

### 🌐 Acceso a la Interfaz

Una vez iniciado, accede a: **http://localhost:7863**

### 🎯 Características del Instalador Windows

El script `install_windows.bat` incluye:

- **🔍 Verificación automática** de Python 3.9+
- **🖥️ Detección de GPU** NVIDIA y configuración CUDA
- **📦 Creación automática** de entorno virtual
- **⚡ Instalación optimizada** según tu hardware
- **🧪 Verificación de dependencias** tras instalación
- **🚀 Script de ejecución rápida** (`run_app.bat`)

**Logs detallados durante instalación:**
- ✅ Confirmaciones de cada paso completado
- ⚠️ Advertencias sobre hardware o configuración
- ❌ Errores específicos con soluciones sugeridas

## 🎮 Cómo Usar

### 1️⃣ Crear un Perfil de Voz

1. **Sube archivos de audio** (MP3/WAV) de 10-60 segundos
2. **Asigna un nombre** al perfil (ej: "Maria", "Carlos") 
3. **Añade descripción** opcional
4. **Genera audio de prueba** para verificar calidad

### 2️⃣ Generar Audio

1. **Selecciona el perfil** de voz deseado
2. **Escribe el texto** que quieres generar
3. **Haz clic en "Generar"** y escucha el resultado
4. **Descarga** tu audio clonado

## 🔧 Configuración Avanzada

### Variables de Entorno

```bash
# Forzar uso de CPU (si hay problemas con GPU)
export CUDA_VISIBLE_DEVICES=""

# Directorio de cache personalizado
export HF_HOME="/ruta/personalizada/cache"

# Puerto personalizado
export GRADIO_SERVER_PORT=8080
```

### Optimización GPU

```bash
# Verificar CUDA
python -c "import torch; print(torch.cuda.is_available())"

# Verificar memoria GPU
nvidia-smi
```

## 📁 Estructura del Proyecto

```
VoiceClone-AI-Spanish/
├── 🚀 app.py                    # Aplicación principal
├── 📋 requirements.txt          # Dependencias
├── 📖 README.md                 # Este archivo
├── �️ install_windows.bat       # Instalador automático Windows
├── ⚡ run_app.bat               # Ejecutor rápido Windows
├── �🔧 src/
│   └── voice_generator.py       # Motor de clonación
├── 📁 examples/                 # Audios de ejemplo
├── 🎨 assets/                   # Recursos (imágenes, demos)
├── 📄 LICENSE                   # Licencia MIT
└── 🤖 .ia-meta                  # Metadatos para IA
```

## 🎯 Casos de Uso

### 📺 Creación de Contenido
- **Locución** para videos y podcasts
- **Doblaje** de contenido multimedia
- **Narración** de audiolibros

### 🤖 Tecnología
- **Asistentes virtuales** personalizados
- **Sistemas de respuesta** automatizados
- **Chatbots** con voz natural

### 🎭 Creatividad
- **Personajes** para videojuegos
- **Voces** para animaciones
- **Efectos sonoros** personalizados

## 💡 Consejos para Mejores Resultados

### 🎤 Calidad del Audio de Referencia
- **Sin ruido de fondo** - Grabaciones limpias
- **10-60 segundos** por archivo
- **Voz clara y natural** - Evitar susurros o gritos
- **Variedad tonal** - Diferentes emociones si es posible

### 📝 Generación de Texto
- **1-3 oraciones** funcionan mejor
- **Puntuación correcta** mejora la pronunciación
- **Español nativo** da mejores resultados
- **Estilo consistente** con el audio original

## ⚙️ Tecnología

### 🧠 Modelo Base
- **F5-TTS**: Framework de síntesis de voz de última generación
- **jpgallegoar/F5-Spanish**: Modelo optimizado para español
- **PyTorch**: Aceleración con GPU CUDA

### 🏗️ Arquitectura
- **Gradio**: Interfaz web interactiva
- **HuggingFace**: Distribución de modelos
- **torchaudio**: Procesamiento de audio

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! 

### Cómo Contribuir
1. **Fork** el proyecto
2. **Crea** una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. **Commit** tus cambios (`git commit -am 'Añadir nueva funcionalidad'`)
4. **Push** a la rama (`git push origin feature/nueva-funcionalidad`)
5. **Abre** un Pull Request

### 🐛 Reportar Bugs
- Usa los [Issues de GitHub](https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish/issues)
- Incluye información del sistema y pasos para reproducir

## 📄 Licencia

### 📋 Licencias del Proyecto

- **🏗️ Código del Proyecto**: [MIT License](LICENSE) - Libre para uso comercial y personal
- **🧠 Modelo F5-TTS Base**: MIT License - [SWivid/F5-TTS](https://github.com/SWivid/F5-TTS)
- **🇪🇸 Modelo Español**: [CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0/) - [jpgallegoar/F5-Spanish](https://huggingface.co/jpgallegoar/F5-Spanish)
- **🖥️ Gradio Interface**: Apache 2.0 License
- **🔥 PyTorch**: BSD 3-Clause License

### ⚖️ Uso Responsable
- **✅ Uso personal/educativo/comercial** permitido bajo MIT
- **✅ Modelo español** en dominio público (CC0-1.0)
- **❌ No impersonificar** personas sin consentimiento
- **❌ No generar** contenido dañino o ilegal
- **🛡️ Respetar** derechos de autor y privacidad

## 🏷️ Créditos

### 🎓 Modelos y Tecnología
- **F5-TTS**: [SWivid/F5-TTS](https://github.com/SWivid/F5-TTS)
- **Modelo Español**: [jpgallegoar/F5-Spanish](https://huggingface.co/jpgallegoar/F5-Spanish)
- **Gradio**: [gradio-app/gradio](https://github.com/gradio-app/gradio)

### 👨‍💻 Desarrollo
- Desarrollado por ⚠️ IA-ismo Labs  para la comunidad de IA en español
- Contribuciones de la comunidad open source


### 🆘 Ayuda
- **Documentación**: Revisa este README
- **Issues**: [GitHub Issues](https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish/issues)
- **Discusiones**: [GitHub Discussions](https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish/discussions)

### 🔧 Solución de Problemas Comunes

<details>
<summary><strong>Error "CUDA out of memory"</strong></summary>

```bash
# Reducir uso de memoria
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512

# O usar CPU
export CUDA_VISIBLE_DEVICES=""
```
</details>

<details>
<summary><strong>Error de compilación (ninja/meson)</strong></summary>

Si ves errores como "Could not find ninja" o "meson-python error":

**Solución 1 - Instalar Build Tools:**
```bash
# Descargar e instalar Visual Studio Build Tools
# https://visualstudio.microsoft.com/visual-cpp-build-tools/
# Seleccionar "C++ build tools" durante instalación
# Reiniciar sistema después de instalar
```

**Solución 2 - Script Manual:**
```bash
# Usar instalador alternativo
install_manual.bat
```

**Solución 3 - Instalación paso a paso:**
```bash
# En el entorno virtual activado
pip install ninja meson cmake
pip install --upgrade setuptools wheel
pip install f5-tts --no-build-isolation
```
</details>

<details>
<summary><strong>Audio generado en inglés</strong></summary>

Verifica que estés usando el modelo correcto:
- ✅ `jpgallegoar/F5-Spanish`
- ❌ `SWivid/F5-TTS` (solo inglés)
</details>

<details>
<summary><strong>Calidad de audio baja</strong></summary>

- Mejora el audio de referencia
- Usa textos más cortos
- Verifica que el audio original sea claro
</details>

---

## 🤖 Créditos de Desarrollo

### Desarrollado por:
- **Claude Sonnet 3.5** - Asistente de IA para desarrollo
- **GPT-4** - Asistente de IA para desarrollo  
- **⚠️ IA-ismo Labs** - Alicia Colmenero Fernández

### Metadatos Programables:
- **🤖 IA-Friendly**: Preparado para automatización por otros agentes
- **📡 API-Ready**: Endpoints documentados para integración directa
- **🔄 Agent-Compatible**: Metadatos en `.ia-meta` para detección automática

### Síguenos:
- **📰 Newsletter**: [IA-ismo](https://ia-ismo.com)
- **💻 GitHub**: [@alixiacf](https://github.com/alixiacf)
- **🏢 Organización**: [IA-ismo-Lab](https://github.com/IA-ismo-Lab)

---

## ⭐ ¿Te Gusta el Proyecto?

Si **VoiceClone AI Spanish** te ha sido útil:

- ⭐ **Dale una estrella** al repositorio
- 🐦 **Comparte** en redes sociales
- 🤝 **Contribuye** con mejoras
- 💬 **Cuéntanos** tu experiencia

---

<div align="center">

**🎙️ Hecho por ⚠️IA-ismo Labs para la comunidad de IA en español 🇪🇸**

[⬆️ Volver arriba](#-voiceclone-ai-spanish)

</div>

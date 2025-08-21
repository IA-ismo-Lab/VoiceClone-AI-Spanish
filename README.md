# 🎙️ VoiceClone AI Spanish

[![Python](https://img.shields.io/badge/Python-3.9%2B-blue.svg)](https://www.python.org/downloads/)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.0%2B-red.svg)](https://pytorch.org/)
[![Gradio](https://img.shields.io/badge/Gradio-4.0%2B-orange.svg)](https://gradio.app/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Spanish-F5](https://img.shields.io/badge/Spanish--F5-TTS-green.svg)](https://github.com/jpgallegoar/Spanish-F5)
[![AI-Generated](https://img.shields.io/badge/AI--Generated-Code-purple.svg)](https://github.com/topics/artificial-intelligence)
[![Vibe Code](https://img.shields.io/badge/Vibe--Code-AI--Assisted-ff69b4.svg)](https://github.com/topics/ai-development)

**🇪🇸 Sistema avanzado de clonación de voz en español usando Spanish-F5**

Crea voces artificiales realistas en español con solo unos archivos de audio de referencia. Perfecto para locución, asistentes virtuales, contenido multimedia y proyectos creativos.

> **🤖 Vibe Code - AI Generated Project**  
> Este proyecto ha sido desarrollado completamente por **Inteligencia Artificial** (Claude Sonnet 3.5 + GPT-4).  
> **⚠️ El código NO ha sido revisado por programadores humanos** - Es un experimento de desarrollo IA puro.  
> Usar bajo tu propio riesgo y reportar bugs en [Issues](https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish/issues).

## 🎯 Características Principales

- **🎙️ Clonación de voz de alta calidad** en español nativo
- **🖥️ Interfaz gráfica intuitiva** con Gradio
- **⚡ Aceleración GPU** con CUDA para velocidad óptima
- **📁 Sistema de perfiles** reutilizables
- **🔄 Generación masiva** sin recargar modelo
- **🎨 Fácil de usar** - No requiere conocimientos técnicos

## 🔧 Requisitos del Sistema

### 🐍 Python Recomendado
- **Python 3.11** (ALTAMENTE RECOMENDADO para máxima compatibilidad)
- Python 3.10-3.12 (compatible pero con limitaciones potenciales)

### 🎮 Hardware para GPU (Opcional pero Recomendado)
- **NVIDIA GPU** con soporte CUDA
- **CUDA Toolkit 12.1** 
- **Drivers NVIDIA actualizados**
- **Mínimo 4GB VRAM** (8GB+ recomendado)

### 🛠️ Herramientas de Compilación (Windows)
- **Visual Studio Build Tools** con C++ tools
- **Git** para clonación de repositorios

### 💻 Sistema Operativo
- **Windows 10/11** (script optimizado)
- Linux/macOS (instalación manual)

## 🚀 Demo Rápido

![VoiceClone AI Demo](assets/demo.gif)

*Interfaz principal: crea perfiles de voz y genera audio en segundos*

## 📦 Instalación

### 🎯 Instalación Única y Robusta

**Un solo instalador optimizado para Python 3.11.8:**

```bash
# 1. Instalar Python 3.11.8 desde python.org (CRÍTICO)
# 2. Clonar el repositorio
git clone https://github.com/IA-ismo-Lab/VoiceClone-AI-Spanish.git
cd VoiceClone-AI-Spanish

# 3. Instalación completa
instalar.bat

# 4. Verificar funcionamiento
check.bat
```

### 🔧 Componentes Críticos Instalados

| Componente | Función | Estado |
|------------|---------|--------|
| **F5-TTS** | Motor principal de síntesis | **CRÍTICO** |
| **PyTorch** | Aceleración GPU/CPU | **ESENCIAL** |
| **Gradio** | Interfaz web | **ESENCIAL** |
| Spanish-F5 | Optimización español | Opcional |
| Librosa | Audio avanzado | Opcional |

### ⚡ Requisitos Estrictos

- **Python 3.11.8** específicamente (por compatibilidad F5-TTS)
- **Git** para clonación de repositorios  
- **Visual Studio Build Tools** (Windows)
- **CUDA 12.1 + drivers NVIDIA** (para GPU)

### 🧪 Verificación Post-Instalación

```bash
# Verificar que todo funciona
check.bat

# Si F5-TTS falla, reinstalar
instalar.bat
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
├── ⚡ run_app.bat               # Ejecutor rápido Windows
├── 🛠️ instalar.bat             # Instalador principal Windows
├── 🔧 src/
│   ├── __init__.py
│   └── voice_generator.py       # Motor de clonación
├── 📁 audios/                   # Directorio para audios de entrada
├── 📁 examples/                 # Audios de ejemplo
├── 📁 outputs/                  # Audios generados
├── 📁 profiles/                 # Perfiles de voz guardados
├── 🎨 assets/                   # Recursos (imágenes, demos)
├── 📄 LICENSE                   # Licencia MIT
├── 🤖 .ia-meta                  # Metadatos para IA
└── 🔒 .gitignore                # Archivos ignorados
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
- **Spanish-F5**: Framework de síntesis de voz optimizado para español
- **jpgallegoar/F5-Spanish**: Modelo pre-entrenado específico para español
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
- **Spanish-F5**: [jpgallegoar/Spanish-F5](https://github.com/jpgallegoar/Spanish-F5) - Modelo optimizado para español
- **F5-TTS Base**: [SWivid/F5-TTS](https://github.com/SWivid/F5-TTS) - Framework original
- **Modelo HuggingFace**: [jpgallegoar/F5-Spanish](https://huggingface.co/jpgallegoar/F5-Spanish)
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

### 🎯 Desarrollo 100% IA - Vibe Code:
- **Claude Sonnet 3.5** - Asistente de IA principal para desarrollo y arquitectura
- **GPT-4** - Asistente de IA secundario para validación y optimización
- **⚠️ IA-ismo Labs** - Alicia Colmenero Fernández (Supervisión y testing)

### 🚨 Advertencia Importante:
- **🤖 Código NO revisado** por programadores humanos profesionales
- **⚡ Desarrollo experimental** - Primera generación de código 100% IA
- **🧪 Testing requerido** - Reportar bugs y mejoras en Issues
- **📚 Documentación IA** - Generada automáticamente por modelos de lenguaje

### 🛠️ Tecnologías de Desarrollo IA:
- **Prompt Engineering** avanzado para arquitectura de software
- **Chain-of-Thought** programming para lógica compleja
- **Multi-Agent Collaboration** entre Claude y GPT-4
- **Automated Documentation** generación y mantenimiento

### Metadatos Programables:
- **🤖 IA-Friendly**: Preparado para automatización por otros agentes
- **📡 API-Ready**: Endpoints documentados para integración directa
- **🔄 Agent-Compatible**: Metadatos en `.ia-meta` para detección automática
- **🎨 Vibe-Code**: Marcado como desarrollo IA experimental

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

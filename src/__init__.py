"""
VoiceClone AI Spanish - Módulo Principal

Sistema avanzado de clonación de voz en español usando F5-TTS
"""

__version__ = "1.0.0"
__author__ = "VoiceClone AI Spanish Team"
__license__ = "MIT"

# Importaciones principales
try:
    from .voice_generator import VoiceGenerator, get_voice_generator
    __all__ = ['VoiceGenerator', 'get_voice_generator']
except ImportError:
    # Para compatibilidad durante desarrollo
    __all__ = []

def get_version():
    """Obtener versión del paquete"""
    return __version__

def check_dependencies():
    """Verificar que las dependencias estén instaladas"""
    dependencies = {
        'torch': 'PyTorch',
        'gradio': 'Gradio',
        'transformers': 'HuggingFace Transformers',
        'torchaudio': 'TorchAudio',
        'f5_tts': 'F5-TTS'
    }
    
    missing = []
    for module, name in dependencies.items():
        try:
            __import__(module)
        except ImportError:
            missing.append(name)
    
    if missing:
        print(f"❌ Dependencias faltantes: {', '.join(missing)}")
        print("💡 Ejecuta: pip install -r requirements.txt")
        return False
    else:
        print("✅ Todas las dependencias están instaladas")
        return True

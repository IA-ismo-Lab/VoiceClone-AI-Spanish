"""
🎙️ VoiceClone AI Spanish - Aplicación Principal

Sistema avanzado de clonación de voz en español usando F5-TTS
Interfaz completa para crear y usar perfiles de voz

Autor: VoiceClone AI Spanish Team
Licencia: MIT
Modelo: jpgallegoar/F5-Spanish
"""

import gradio as gr
import torch
from pathlib import Path
import json
import torchaudio
import sys
import shutil
import os
import logging
from typing import Optional, Tuple, List

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Añadir src al path  
sys.path.insert(0, str(Path(__file__).parent / "src"))

try:
    # Importar nuestro generador
    from voice_generator import get_voice_generator
    logger.info("✅ Módulo voice_generator importado correctamente")
except ImportError as e:
    logger.error(f"❌ Error importando voice_generator: {e}")
    raise

class GestorPerfiles:
    """Gestor de perfiles de voz"""
    
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.profiles_dir = self.base_dir / "profiles"
        self.audios_dir = self.base_dir / "audios"
        self.outputs_dir = self.base_dir / "outputs"
        
        # Crear directorios
        self.profiles_dir.mkdir(exist_ok=True)
        self.audios_dir.mkdir(exist_ok=True)
        self.outputs_dir.mkdir(exist_ok=True)
    
    def crear_perfil_desde_archivos(self, nombre_perfil, archivos_subidos, descripcion=""):
        """Crear un nuevo perfil desde archivos subidos"""
        if not nombre_perfil:
            return "❌ Debes especificar un nombre para el perfil"
        
        if not archivos_subidos:
            return "❌ Debes subir al menos un archivo de audio"
        
        try:
            # Crear carpeta del perfil
            perfil_dir = self.profiles_dir / nombre_perfil.lower()
            perfil_dir.mkdir(exist_ok=True)
            
            # Copiar archivos subidos
            audios_referencia = []
            for i, archivo in enumerate(archivos_subidos):
                # Archivo temporal de Gradio
                src_path = Path(archivo.name)
                
                # Destino en el perfil
                extension = src_path.suffix
                dst_path = perfil_dir / f"ref_{i:02d}{extension}"
                
                # Copiar archivo
                shutil.copy2(src_path, dst_path)
                audios_referencia.append(str(dst_path))
                
                print(f"📁 Copiado: {src_path.name} → {dst_path.name}")
            
            # Crear archivo de información del perfil
            perfil_info = {
                "nombre": nombre_perfil,
                "descripcion": descripcion,
                "audios_referencia": audios_referencia,
                "fecha_creacion": str(Path().absolute()),
                "total_audios": len(audios_referencia)
            }
            
            # Guardar información del perfil
            info_file = perfil_dir / "perfil_info.json"
            with open(info_file, "w", encoding="utf-8") as f:
                json.dump(perfil_info, f, indent=2, ensure_ascii=False)
            
            resultado = f"""✅ **Perfil '{nombre_perfil}' creado exitosamente!**

📁 **Ubicación**: {perfil_dir.name}/
🎵 **Audios**: {len(audios_referencia)} archivos
📝 **Descripción**: {descripcion or 'Sin descripción'}

**Archivos copiados:**"""
            
            for audio in audios_referencia:
                resultado += f"\n• {Path(audio).name}"
            
            return resultado
            
        except Exception as e:
            return f"❌ Error creando perfil: {str(e)}"
    
    def listar_perfiles(self):
        """Listar perfiles disponibles"""
        perfiles = []
        
        # Agregar ADA por defecto
        perfiles.append("ADA")
        
        # Buscar perfiles creados
        if self.profiles_dir.exists():
            for perfil_dir in self.profiles_dir.iterdir():
                if perfil_dir.is_dir():
                    perfiles.append(perfil_dir.name)
        
        return perfiles
    
    def obtener_audios_perfil(self, nombre_perfil):
        """Obtener audios de un perfil"""
        if nombre_perfil.upper() == "ADA":
            # Usar audios por defecto de ADA
            return list(self.audios_dir.glob("ADA_*.mp3")) + list(self.audios_dir.glob("*ADA*.mp3"))
        
        # Buscar en perfil personalizado
        perfil_dir = self.profiles_dir / nombre_perfil.lower()
        if perfil_dir.exists():
            return list(perfil_dir.glob("*.mp3")) + list(perfil_dir.glob("*.wav"))
        
        return []

def generar_audio_con_perfil(texto, perfil_seleccionado, gestor):
    """Generar audio usando un perfil específico"""
    if not texto:
        return "❌ Debes escribir un texto", None
    
    if not perfil_seleccionado:
        return "❌ Debes seleccionar un perfil", None
    
    try:
        generator = get_voice_generator()
        
        print(f"🎤 Generando con perfil '{perfil_seleccionado}': {texto[:50]}...")
        
        # Generar audio
        archivo_generado = generator.generate_voice(texto, perfil_seleccionado)
        
        if archivo_generado:
            resultado = f"✅ **Audio generado exitosamente!**\n"
            resultado += f"📁 **Archivo**: {Path(archivo_generado).name}\n"
            resultado += f"🎤 **Perfil**: {perfil_seleccionado}\n"
            resultado += f"📝 **Texto**: {texto[:100]}..."
            
            return resultado, archivo_generado
        else:
            return "❌ Error generando el audio", None
            
    except Exception as e:
        return f"❌ Error: {str(e)}", None

def verificar_estado_sistema():
    """Verificar estado del sistema"""
    try:
        generator = get_voice_generator()
        
        info = f"🔧 **Estado del Sistema**\n\n"
        
        # GPU
        if torch.cuda.is_available():
            info += f"✅ **GPU**: CUDA disponible\n"
            info += f"🎯 **Dispositivo**: {torch.cuda.get_device_name(0)}\n"
        else:
            info += f"❌ **GPU**: Solo CPU disponible\n"
        
        # Modelo
        if generator.load_model():
            info += f"✅ **Modelo**: F5-Spanish cargado\n"
        else:
            info += f"❌ **Modelo**: Error cargando\n"
        
        # Audios
        audios = generator.get_reference_audios("ADA")
        info += f"🎵 **Audios ADA**: {len(audios)} disponibles\n"
        
        # Perfiles
        gestor = GestorPerfiles()
        perfiles = gestor.listar_perfiles()
        info += f"� **Perfiles**: {len(perfiles)} disponibles\n"
        
        return info
        
    except Exception as e:
        return f"❌ Error verificando sistema: {str(e)}"

def crear_interfaz():
    """Crear la interfaz principal con pestañas"""
    
    # Crear gestor de perfiles
    gestor = GestorPerfiles()
    
    with gr.Blocks(title="VoiceClone Spanish", theme=gr.themes.Soft()) as interfaz:
        
        gr.Markdown("""
        # 🎙️ VoiceClone Spanish - Completo
        
        **Sistema completo de clonación de voz en español**
        
        ✅ **Crear perfiles** subiendo archivos de audio  
        ✅ **Usar perfiles** para generar nuevos audios  
        ✅ **Modelo F5-Spanish** optimizado
        """)
        
        with gr.Tabs():
            
            # PESTAÑA 1: CREAR PERFIL
            with gr.Tab("📝 Crear Perfil de Voz"):
                gr.Markdown("""
                ### Crea un nuevo perfil subiendo archivos de audio
                
                Sube 1-5 archivos de audio de la voz que quieres clonar.
                """)
                
                with gr.Row():
                    with gr.Column(scale=2):
                        nombre_perfil = gr.Textbox(
                            label="📝 Nombre del perfil",
                            placeholder="Ej: Maria, Carlos, Locutor1..."
                        )
                        
                        archivos_audio = gr.File(
                            label="🎵 Archivos de audio",
                            file_count="multiple",
                            file_types=[".mp3", ".wav", ".m4a"],
                            height=150
                        )
                        
                        descripcion_perfil = gr.Textbox(
                            label="📄 Descripción (opcional)",
                            placeholder="Ej: Voz femenina, tono profesional, acento argentino...",
                            lines=2
                        )
                        
                        btn_crear_perfil = gr.Button("✨ Crear Perfil", variant="primary", size="lg")
                    
                    with gr.Column(scale=1):
                        resultado_crear = gr.Textbox(
                            label="📊 Resultado de creación",
                            lines=10,
                            interactive=False
                        )
                        
                        # Lista de perfiles existentes
                        perfiles_existentes = gr.Textbox(
                            label="👤 Perfiles existentes",
                            lines=6,
                            interactive=False,
                            value="\n".join([f"• {p}" for p in gestor.listar_perfiles()])
                        )
                        
                        btn_actualizar_lista = gr.Button("🔄 Actualizar Lista", size="sm")
            
            # PESTAÑA 2: USAR PERFIL
            with gr.Tab("🎯 Usar Perfil Existente"):
                gr.Markdown("""
                ### Genera audios con perfiles ya creados
                
                Selecciona un perfil y escribe el texto que quieres generar.
                """)
                
                with gr.Row():
                    with gr.Column(scale=2):
                        perfil_dropdown = gr.Dropdown(
                            label="🎭 Perfil de voz",
                            choices=gestor.listar_perfiles(),
                            value="ADA"
                        )
                        
                        texto_generar = gr.Textbox(
                            label="📝 Texto a generar",
                            placeholder="Escribe el texto que quieres que diga la voz...",
                            lines=4
                        )
                        
                        btn_generar_audio = gr.Button("🎤 Generar Audio", variant="primary", size="lg")
                        
                        # Ejemplos rápidos
                        gr.Markdown("### 💡 Ejemplos rápidos:")
                        with gr.Row():
                            ejemplos = [
                                "Hola, bienvenido a VoiceClone Spanish.",
                                "La inteligencia artificial avanza muy rápido.",
                                "Este audio fue generado por IA.",
                                "Gracias por usar nuestro sistema."
                            ]
                            
                            for i, ejemplo in enumerate(ejemplos):
                                btn_ej = gr.Button(f"📄 {i+1}", size="sm")
                                btn_ej.click(lambda x=ejemplo: x, outputs=texto_generar)
                    
                    with gr.Column(scale=1):
                        resultado_generar = gr.Textbox(
                            label="📊 Resultado de generación",
                            lines=8,
                            interactive=False
                        )
                        
                        audio_generado = gr.Audio(
                            label="🎧 Audio generado",
                            type="filepath"
                        )
                        
                        btn_actualizar_perfiles = gr.Button("🔄 Actualizar Perfiles", size="sm")
            
            # PESTAÑA 3: CONFIGURACIÓN
            with gr.Tab("⚙️ Configuración"):
                gr.Markdown("""
                ### Estado del sistema y configuración
                """)
                
                with gr.Row():
                    with gr.Column():
                        btn_verificar_sistema = gr.Button("🔍 Verificar Sistema", variant="secondary", size="lg")
                        
                        estado_sistema = gr.Textbox(
                            label="🔧 Estado del sistema",
                            lines=10,
                            interactive=False,
                            value="Haz clic en 'Verificar Sistema' para comprobar el estado"
                        )
                    
                    with gr.Column():
                        gr.Markdown("""
                        ### 📚 Guía de Uso
                        
                        **Para crear un perfil:**
                        1. Ve a "Crear Perfil de Voz"
                        2. Escribe un nombre único
                        3. Sube 1-5 archivos de audio (.mp3, .wav)
                        4. Opcionalmente añade una descripción
                        5. Haz clic en "Crear Perfil"
                        
                        **Para usar un perfil:**
                        1. Ve a "Usar Perfil Existente"
                        2. Selecciona el perfil deseado
                        3. Escribe el texto a generar
                        4. Haz clic en "Generar Audio"
                        
                        ### 💡 Consejos:
                        - **Audios**: 10-60 segundos, sin ruido
                        - **Texto**: 1-3 oraciones funcionan mejor
                        - **Idioma**: Español da mejores resultados
                        """)
        
        # EVENTOS DE LA INTERFAZ
        
        # Crear perfil
        btn_crear_perfil.click(
            fn=lambda nombre, archivos, desc: gestor.crear_perfil_desde_archivos(nombre, archivos, desc),
            inputs=[nombre_perfil, archivos_audio, descripcion_perfil],
            outputs=resultado_crear
        )
        
        # Actualizar lista de perfiles
        def actualizar_lista():
            perfiles = gestor.listar_perfiles()
            return "\n".join([f"• {p}" for p in perfiles])
        
        btn_actualizar_lista.click(
            fn=actualizar_lista,
            outputs=perfiles_existentes
        )
        
        # Generar audio
        btn_generar_audio.click(
            fn=lambda texto, perfil: generar_audio_con_perfil(texto, perfil, gestor),
            inputs=[texto_generar, perfil_dropdown],
            outputs=[resultado_generar, audio_generado]
        )
        
        # Actualizar dropdown de perfiles
        def actualizar_dropdown():
            perfiles = gestor.listar_perfiles()
            return gr.Dropdown(choices=perfiles, value=perfiles[0] if perfiles else None)
        
        btn_actualizar_perfiles.click(
            fn=actualizar_dropdown,
            outputs=perfil_dropdown
        )
        
        # Verificar sistema
        btn_verificar_sistema.click(
            fn=verificar_estado_sistema,
            outputs=estado_sistema
        )
        
        # Información final y créditos
        with gr.Row():
            with gr.Column(scale=3):
                gr.Markdown("""
                ### 🏷️ Créditos y Tecnología
                - **Modelo**: [jpgallegoar/F5-Spanish](https://huggingface.co/jpgallegoar/F5-Spanish)
                - **Base**: [F5-TTS](https://github.com/SWivid/F5-TTS)
                - **Interfaz**: Gradio + PyTorch
                - **Uso**: Educativo y experimental
                """)
            
            with gr.Column(scale=1):
                gr.Markdown("""
                <div style="text-align: right; padding: 10px; font-size: 12px; color: #666;">
                <strong>⚠️ IA-ismo Labs</strong><br>
                Desarrollado con IA<br>
                <a href="https://github.com/IA-ismo-Lab" target="_blank">GitHub</a> | 
                <a href="https://ia-ismo.com" target="_blank">Newsletter</a>
                </div>
                """)
    
    return interfaz

if __name__ == "__main__":
    print("🚀 Iniciando VoiceClone Spanish...")
    
    try:
        # Configurar paths permitidos
        base_dir = Path(__file__).parent
        allowed_paths = [
            str(base_dir / "audios"),
            str(base_dir / "outputs"),
            str(base_dir / "profiles"),
            str(Path.home() / "Downloads"),
            str(Path.cwd())
        ]
        
        interfaz = crear_interfaz()
        
        print("🌐 Lanzando interfaz en http://127.0.0.1:7864")
        print("💡 Usa Ctrl+C para salir")
        
        interfaz.launch(
            server_name="127.0.0.1",
            server_port=7864,
            share=False,
            allowed_paths=allowed_paths,
            show_error=True,
            show_api=False
        )
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()

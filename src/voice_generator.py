"""
Generador principal de voz para VoiceClone Spanish
Basado en F5-TTS con modelo jpgallegoar/F5-Spanish
"""

import torch
from pathlib import Path
import torchaudio
import os
from typing import Optional, Tuple, List

class VoiceGenerator:
    """Generador de voz reutilizable"""
    
    def __init__(self):
        self.model = None
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.is_loaded = False
        
        # Determinar rutas base
        self.base_dir = Path(__file__).parent.parent  # VoiceClone_Spanish/
        self.audios_dir = self.base_dir / "audios"
        self.outputs_dir = self.base_dir / "outputs"
        self.profiles_dir = self.base_dir / "profiles"
        
        # Crear directorios si no existen
        self.outputs_dir.mkdir(exist_ok=True)
        self.profiles_dir.mkdir(exist_ok=True)
    
    def load_model(self) -> bool:
        """Cargar el modelo F5-Spanish"""
        if self.is_loaded:
            print("✅ Modelo ya cargado")
            return True
            
        try:
            print("📥 Cargando modelo F5-Spanish...")
            
            # Intentar cargar desde cache local primero
            cache_path = Path("E:/cache/hub/models--jpgallegoar--F5-Spanish/snapshots/4765c14ffd01075479c2fde8615831acc0adca9a/model_1200000.safetensors")
            
            from f5_tts.api import F5TTS
            
            if cache_path.exists():
                print("📂 Usando modelo desde cache local...")
                self.model = F5TTS(
                    model_type="F5-TTS",
                    ckpt_file=str(cache_path),
                    device=self.device
                )
            else:
                print("🌐 Descargando modelo desde HuggingFace...")
                self.model = F5TTS.from_pretrained("jpgallegoar/F5-Spanish")
                
            self.is_loaded = True
            print(f"✅ Modelo cargado en {self.device}")
            return True
            
        except Exception as e:
            print(f"❌ Error cargando modelo: {e}")
            return False
    
    def get_reference_audios(self, voice_name: str = "ADA") -> List[Path]:
        """Obtener audios de referencia para una voz"""
        # Patrón más flexible para buscar audios
        patterns = [
            f"{voice_name}_*.mp3",
            f"{voice_name}_*.wav", 
            f"{voice_name.upper()}_*.mp3",
            f"{voice_name.upper()}_*.wav",
            f"*{voice_name}*.mp3",
            f"*{voice_name}*.wav"
        ]
        
        audios = []
        for pattern in patterns:
            found = list(self.audios_dir.glob(pattern))
            audios.extend(found)
            if audios:  # Si encontramos algunos, usar esos
                break
        
        if not audios:
            # Buscar cualquier audio como fallback
            audios = list(self.audios_dir.glob("*.mp3")) + list(self.audios_dir.glob("*.wav"))
            
        return audios
    
    def generate_voice(self, text: str, voice_name: str = "ADA", ref_text: str = "") -> Optional[str]:
        """Generar audio con una voz específica"""
        
        if not self.is_loaded:
            if not self.load_model():
                return None
        
        # Obtener audios de referencia
        ref_audios = self.get_reference_audios(voice_name)
        
        if not ref_audios:
            print(f"❌ No se encontraron audios de referencia para {voice_name}")
            return None
        
        ref_audio = str(ref_audios[0])
        print(f"🎵 Usando audio de referencia: {Path(ref_audio).name}")
        
        try:
            print(f"🔄 Generando: {text[:50]}...")
            
            # Generar audio
            resultado = self.model.infer(
                ref_file=ref_audio,
                ref_text=ref_text,
                gen_text=text
            )
            
            # Procesar resultado (manejar tupla de 3 elementos)
            if len(resultado) == 3:
                wav_data, sample_rate, _ = resultado
            else:
                wav_data, sample_rate = resultado
            
            # Convertir a tensor si es necesario
            if torch.is_tensor(wav_data):
                audio_tensor = wav_data
            else:
                audio_tensor = torch.tensor(wav_data, dtype=torch.float32)
            
            # Asegurar formato correcto
            if audio_tensor.dim() == 1:
                audio_tensor = audio_tensor.unsqueeze(0)
            
            # Generar nombre de archivo único
            voice_dir = self.outputs_dir / voice_name.lower()
            voice_dir.mkdir(exist_ok=True)
            
            contador = len(list(voice_dir.glob("*.wav")))
            output_file = voice_dir / f"{voice_name.lower()}_{contador:03d}.wav"
            
            # Guardar audio
            torchaudio.save(output_file, audio_tensor, sample_rate)
            
            print(f"✅ Audio generado: {output_file.name}")
            print(f"📊 Duración: {audio_tensor.shape[1] / sample_rate:.2f}s")
            
            return str(output_file)
            
        except Exception as e:
            print(f"❌ Error generando audio: {e}")
            import traceback
            traceback.print_exc()
            return None
    
    def create_voice_profile(self, voice_name: str, reference_audios: List[str], 
                           description: str = "") -> bool:
        """Crear un perfil de voz"""
        try:
            profile_dir = self.profiles_dir / voice_name.lower()
            profile_dir.mkdir(exist_ok=True)
            
            # Copiar audios de referencia
            for i, audio_path in enumerate(reference_audios):
                src = Path(audio_path)
                if src.exists():
                    dst = profile_dir / f"ref_{i:02d}{src.suffix}"
                    if not dst.exists():
                        import shutil
                        shutil.copy2(src, dst)
            
            # Crear archivo de información del perfil
            profile_info = profile_dir / "profile_info.txt"
            with open(profile_info, "w", encoding="utf-8") as f:
                f.write(f"Voice Profile: {voice_name}\n")
                f.write(f"Description: {description}\n")
                f.write(f"Reference audios: {len(reference_audios)}\n")
                f.write(f"Created: {Path().absolute()}\n")
            
            print(f"✅ Perfil '{voice_name}' creado en {profile_dir}")
            return True
            
        except Exception as e:
            print(f"❌ Error creando perfil: {e}")
            return False
    
    def list_voice_profiles(self) -> List[str]:
        """Listar perfiles de voz disponibles"""
        profiles = []
        if self.profiles_dir.exists():
            for profile_dir in self.profiles_dir.iterdir():
                if profile_dir.is_dir():
                    profiles.append(profile_dir.name)
        return profiles
    
    def cleanup_model(self):
        """Limpiar memoria del modelo"""
        if self.model:
            del self.model
            if torch.cuda.is_available():
                torch.cuda.empty_cache()
            self.model = None
            self.is_loaded = False
            print("🧹 Memoria del modelo liberada")

# Instancia global para reutilización
_generator = None

def get_voice_generator() -> VoiceGenerator:
    """Obtener instancia global del generador"""
    global _generator
    if _generator is None:
        _generator = VoiceGenerator()
    return _generator

def generate_voice_quick(text: str, voice_name: str = "ADA") -> Optional[str]:
    """Función rápida para generar voz"""
    generator = get_voice_generator()
    return generator.generate_voice(text, voice_name)

if __name__ == "__main__":
    # Test básico
    generator = VoiceGenerator()
    
    if generator.load_model():
        texto = "Hola, soy ADA y hablo perfectamente en español."
        resultado = generator.generate_voice(texto)
        
        if resultado:
            print(f"✅ Test exitoso: {resultado}")
        else:
            print("❌ Test fallido")
    else:
        print("❌ No se pudo cargar el modelo")

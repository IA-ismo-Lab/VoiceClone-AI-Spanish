@echo off
chcp 65001 > nul
echo 🔍 Diagnóstico Rápido - VoiceClone AI Spanish
echo ==============================================
echo.

echo 🐍 Python:
python --version
echo.

echo 🎯 F5-TTS (CRÍTICO):
python -c "import f5_tts; print('✅ F5-TTS funcionando')" 2>nul || echo "❌ F5-TTS NO disponible"

echo 🔥 PyTorch:
python -c "import torch; print('✅ PyTorch', torch.__version__, '- CUDA:', torch.cuda.is_available())" 2>nul || echo "❌ PyTorch NO disponible"

echo 🖥️ Gradio:
python -c "import gradio; print('✅ Gradio', gradio.__version__)" 2>nul || echo "❌ Gradio NO disponible"

echo 🇪🇸 Spanish-F5:
python -c "from spanish_f5 import load_model; print('✅ Spanish-F5 funcionando')" 2>nul || echo "❌ Spanish-F5 NO disponible"

echo 🎵 Audio:
python -c "import librosa, scipy; print('✅ Audio avanzado funcionando')" 2>nul || echo "⚠️ Audio avanzado limitado"

echo.
echo 🏁 RESUMEN:
echo Si F5-TTS funciona ✅ = Sistema listo para usar
echo Si F5-TTS falla ❌ = Ejecutar install_robust.bat
echo.
pause

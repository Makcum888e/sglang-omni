# 🚀 Installation — Ascend NPU

Installs `sglang-omni` for **Ascend NPUs**.


## Prerequisites

First install upstream SGLang ([Ascend NPU docs](https://docs.sglang.io/docs/hardware-platforms/ascend-npus/getting-started/installation))

## Install SGL-Omni

Install SGL-Omni using `pyproject_npu.toml`.

```bash
cp pyproject.toml .pyproject.cuda.bak
cp pyproject_npu.toml pyproject.toml
pip install -v -e .
cp -f .pyproject.cuda.bak pyproject.toml && rm .pyproject.cuda.bak   # restore CUDA pyproject
```

## CosyVoice extra

Install all extra dependency for NPU first

```bash
bash scripts/ci/npu/install_npu.sh
```

Follow CosyVoice guide ([CosyVoice guide](../cookbook/fun_cosyvoice3.md)) except SGL-Omni installation.


## Serve


CosyVoice3 example

Start server

```bash
sgl-omni serve --model-path /path/to/FunAudioLLM/Fun-CosyVoice3-0.5B-2512/ --config examples/configs/fun_cosyvoice3_0_5b.yaml --port 8000
```

Run client

```bash
curl -X POST http://localhost:8000/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{
    "model": "FunAudioLLM/Fun-CosyVoice3-0.5B-2512",
    "input": "SGLang-Omni makes text-to-speech fast and easy to deploy.",
    "ref_audio": "/path/to/ref_audio.wav",
    "ref_text": "We asked over twenty different people, and they all said it was his."
  }' \
  --output output.wav
```

Health check for any of the above: `curl http://localhost:8000/v1/models`.

> **Expected on XPU:** `Failed to import mooncake` / `Failed to import nixl` warnings are harmless
> — those CUDA-only transfer backends are omitted; tensors move through the `shm` relay instead.

> ✅ Support status: **CosyVoice3 serve end-to-end on Ascend NPU**

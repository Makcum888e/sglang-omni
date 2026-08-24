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

Install ffmpeg

```bash
apt update && apt install -y ffmpeg libavcodec-dev libavformat-dev libavutil-dev
```

Download and install CANN 9.1.0

```bash
wget --header="Referer: https://www.hiascend.com/" https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%209.1.0/Ascend-cann-toolkit_9.1.0_linux-"$(uname -i)".run
wget --header="Referer: https://www.hiascend.com/" https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%209.1.0/Ascend-cann-A3-ops_9.1.0_linux-"$(uname -i)".run
wget --header="Referer: https://www.hiascend.com/" https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%209.1.0/Ascend-cann-nnal_9.1.0_linux-"$(uname -i)".run

chmod +x ./Ascend-cann-toolkit_9.1.0_linux-aarch64.run
chmod +x ./Ascend-cann-A3-ops_9.1.0_linux-aarch64.run
chmod +x ./Ascend-cann-nnal_9.1.0_linux-aarch64.run

./Ascend-cann-toolkit_9.1.0_linux-aarch64.run --install
source /usr/local/Ascend/cann/set_env.sh
./Ascend-cann-A3-ops_9.1.0_linux-aarch64.run --install
source /usr/local/Ascend/cann/set_env.sh
./Ascend-cann-nnal_9.1.0_linux-aarch64.run --install
source /usr/local/Ascend/nnal/atb/set_env.sh
```

Install torch 2.11

```bash
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url ${TORCH_CACHE_URL:="https://download.pytorch.org/whl/cpu"} --extra-index-url ${PYPI_CACHE_URL:="https://pypi.org/simple/"}
pip install torchcodec==0.13.0 --index-url https://download.pytorch.org/whl/cpu
PTA_URL="https://gitcode.com/Ascend/pytorch/releases/download/v26.1.0-pytorch2.11.0/torch_npu-2.11.0-cp311-cp311-manylinux_2_28_aarch64.whl"
pip install ${PTA_URL}
```

Install sgl-kernel-npu

```bash
git clone https://github.com/sgl-project/sgl-kernel-npu.git
(cd sgl-kernel-npu && bash build.sh && pip install ./deep_ep*.whl ./sgl_kernel_npu*.whl)
```

Install CosyVoice dependency

```bash
cp pyproject.toml .pyproject.cuda.bak
cp pyproject_npu.toml pyproject.toml
pip install -v -e ".[fun-cosyvoice3]"
cp -f .pyproject.cuda.bak pyproject.toml && rm .pyproject.cuda.bak   # restore CUDA pyproject
```

Follow CosyVoice guide ([CosyVoice guide](../cookbook/fun_cosyvoice3.md)) except SGL-Omni installation.


## Serve


CosyVoice3 example

Start server

```bash
sgl-omni serve --model-path /path/to/FunAudioLLM/Fun-CosyVoice3-0.5B-2512/ --config examples/configs/fun_cosyvoice3_0_5b.yaml --talker-cuda-graph off --port 8000
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

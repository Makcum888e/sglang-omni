# Extra installations for CosyVoice3

# Install ffmpeg
apt update && apt install -y ffmpeg libavcodec-dev libavformat-dev libavutil-dev

# Download and install CANN 9.1.0
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

# Install torch 2.11
pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url ${TORCH_CACHE_URL:="https://download.pytorch.org/whl/cpu"} --extra-index-url ${PYPI_CACHE_URL:="https://pypi.org/simple/"}
pip install torchcodec==0.13.0 --index-url https://download.pytorch.org/whl/cpu
PTA_URL="https://gitcode.com/Ascend/pytorch/releases/download/v26.1.0-pytorch2.11.0/torch_npu-2.11.0-cp311-cp311-manylinux_2_28_aarch64.whl"
pip install ${PTA_URL}

# Install sgl-kernel-npu
git clone https://github.com/sgl-project/sgl-kernel-npu.git
(cd sgl-kernel-npu && bash build.sh && pip install ./deep_ep*.whl ./sgl_kernel_npu*.whl)

# Install CosyVoice dependency
cp pyproject.toml .pyproject.cuda.bak
cp pyproject_npu.toml pyproject.toml
pip install -v -e ".[fun-cosyvoice3]"
cp -f .pyproject.cuda.bak pyproject.toml && rm .pyproject.cuda.bak   # restore CUDA pyproject

from sglang.srt.platforms.cuda import CudaDeviceMixin

from sglang_omni.platforms.interface import OmniPlatform


class CUDAOmniPlatform(CudaDeviceMixin, OmniPlatform):

    def get_device_str(self, local_rank: int) -> str:
        return f"cuda:{local_rank}"

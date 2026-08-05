"""
SGLang Omni Hardware Platform Abstraction.

Defines OmniPlatform — the base class for Omni platform backends.  OmniPlatform inherits DeviceMixin for shared device operations and adds Omni-specific subsystem factory methods, capability flags, and configuration lifecycle hooks.
"""

from sglang.srt.platforms.device_mixin import DeviceMixin


class OmniPlatform(DeviceMixin):

    def get_device_str(self, local_rank: int) -> str:
        """[Planned] Return ``str`` for the given device id."""
        raise NotImplementedError

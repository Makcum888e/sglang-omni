"""
SGLang Omni Hardware Platform Abstraction.

Defines OmniPlatform — the base class for Omni platform backends.  OmniPlatform inherits DeviceMixin for shared device operations and adds Omni-specific subsystem factory methods, capability flags, and configuration lifecycle hooks.
"""

from __future__ import annotations

from typing import TYPE_CHECKING

from sglang.srt.platforms.device_mixin import DeviceMixin

if TYPE_CHECKING:
    from sglang_omni.pipeline.stage_workers import StageLaunchConfig

from typing import Mapping


class OmniPlatform(DeviceMixin):

    def get_device_str(self, local_rank: int) -> str:
        """[Planned] Return ``str`` for the given device id."""
        raise NotImplementedError

    def get_stage_process_env(
        self,
        spec: StageLaunchConfig,
        env: Mapping[str, str] | None = None,
    ) -> dict[str, str]:
        """[Planned] Return per-process env overrides needed before TP child startup."""
        raise NotImplementedError

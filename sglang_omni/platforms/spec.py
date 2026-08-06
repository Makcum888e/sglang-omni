from dataclasses import dataclass


@dataclass(frozen=True)
class ResolvedPlatformSpec:
    platform_type: str
    device_type: str

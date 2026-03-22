# Root system module. All system-level configuration is delegated to
# submodules in ./system/*.nix. Hosts do not have per-host configuration
# files all host-specific behaviour is defined in modules.

{
    imports = [
        ./system/bootloader.nix
        ./system/locale.nix
        ./system/nix.nix
        ./system/users.nix
        ./system/hostname.nix
        ./system/shells.nix
    ];
}

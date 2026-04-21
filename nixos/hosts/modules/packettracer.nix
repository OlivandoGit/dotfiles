{ config, lib, pkgs, unstable, ... }:

{
  # Packet Tracer 9 is insecure due to QtWebEngine
  nixpkgs.config.permittedInsecurePackages = [
    "ciscoPacketTracer9-9.0.0"
  ];

  environment.systemPackages = [
    pkgs.firejail
    unstable.ciscoPacketTracer9

    # Wrapper that forces sandboxing
    (pkgs.writeShellScriptBin "packettracer" ''
      exec ${pkgs.firejail}/bin/firejail \
        --profile=/etc/firejail/packettracer.profile \
        ${unstable.ciscoPacketTracer9}/bin/packettracer --skip-login --no-sandbox "$@"
    '')
  ];

  # Firejail profile for Packet Tracer
  environment.etc."firejail/packettracer.profile".text = ''
    include /etc/firejail/disable-common.inc
    include /etc/firejail/disable-programs.inc

    private
    net none
    caps.drop all
    seccomp
  '';
}

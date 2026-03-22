{ config, pkgs, lib, ... }:

let
  python = pkgs.python311;

  comfySrc = builtins.fetchTarball {
    url = "https://github.com/Comfy-Org/ComfyUI/archive/refs/tags/v0.15.1.tar.gz";
    sha256 = "11aq54p1rs4ik8fwykdb7gjhxs7w551c1zhbpj7sm0295ycicvmv";
  };

  dataDir = "/var/lib/comfyui";
  port = 8188;

in
{
  options.services.comfyui.enable = lib.mkEnableOption "Enable ComfyUI";

  config = lib.mkIf config.services.comfyui.enable {

    system.activationScripts.comfyui-setup.text = ''
      mkdir -p ${dataDir}
      cp -rn ${comfySrc}/* ${dataDir}/

      mkdir -p ${dataDir}/models
      mkdir -p ${dataDir}/input
      mkdir -p ${dataDir}/output
      mkdir -p ${dataDir}/custom_nodes

      if [ ! -d ${dataDir}/venv ]; then
        ${python}/bin/python -m venv ${dataDir}/venv
        ${dataDir}/venv/bin/pip install --upgrade pip

        # CUDA-enabled PyTorch (cu121) for your 4070 Ti
        ${dataDir}/venv/bin/pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

        # ComfyUI dependencies
        ${dataDir}/venv/bin/pip install -r ${dataDir}/requirements.txt
      fi
    '';

    systemd.services.comfyui = {
      description = "ComfyUI Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        WorkingDirectory = dataDir;
        ExecStart = "${dataDir}/venv/bin/python ${dataDir}/main.py --listen 0.0.0.0 --port ${toString port}";
        Restart = "always";
        RestartSec = "5s";

        Environment = [
          "PYTHONUNBUFFERED=1"
          # Expose NVIDIA driver + C++ runtime to PyTorch
          "LD_LIBRARY_PATH=${config.hardware.nvidia.package}/lib:${pkgs.stdenv.cc.cc.lib}/lib"
        ];
      };
    };
  };
}

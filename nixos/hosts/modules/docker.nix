{
  virtualisation.docker.enable = true;

  hardware.nvidia-container-toolkit.enable = true;
  
  virtualisation.docker.daemon.settings = {
    "default-runtime" = "nvidia";
    "runtimes" = {
      nvidia = {
        path = "nvidia-container-runtime";
        runtimeArgs = [];
      };
    };
  };

}
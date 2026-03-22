{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      UseDns = false;
      X11Forwarding = false;
      
      PermitRootLogin = "prohibit-password"; 
    };
  };
}
{ hostname, hostSettings, ...}:

[

 ]   
  ++ (if hostSettings ? shares then [../modules/shares.nix] else [])
  ++ (if hostSettings ? vpns then [../modules/vpns.nix] else [])

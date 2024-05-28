{ config, pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    firefox # while I switch to chromium
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "bkdgflcldnnnapblkhphbgpggdiikppg"; } # duckduckgo privacy
    ];
  };
}

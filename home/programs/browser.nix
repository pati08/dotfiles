{ config, pkgs, inputs, ...}: {
  programs.firefox = {
    enable = true;
  };

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

def hm-switch [profile: string] {
  enter ~/dotfiles
  let arg = ".#" + $profile
  home-manager switch --flake $arg
}

def os-switch [profile: string] {
  enter ~/dotfiles
  let arg = ".#" + $profile
  sudo nixos-rebuild switch --flake $arg
}

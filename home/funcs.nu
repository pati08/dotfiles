def hm-switch [profile: string] {
  enter ~/dotfiles
  let arg = ".#" + $profile
  home-manager switch --flake $arg
  exit
}

def os-switch [profile: string] {
  enter ~/dotfiles
  sudo nixos-rebuild switch --flake .# ($profile)
  exit
}

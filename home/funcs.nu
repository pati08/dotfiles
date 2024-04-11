def hm-switch [profile: string] {
  pushd ~/dotfiles
  home-manager switch --flake .#$profile
  popd
}

def os-switch [profile: string] {
  pushd ~/dotfiles
  sudo nixos-rebuild switch --flake .#$profile
  popd
}

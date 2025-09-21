{
  config,
  pkgs,
  test,
  filepaths,
  lib,
  ...
}:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = import ./packages-list.nix {
    inherit pkgs;
    inherit config;
    inherit filepaths;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  programs.neovim = import ./neovim {
    inherit filepaths;
    inherit pkgs;
  };

  wayland.windowManager.sway = import ./sway {
    inherit pkgs;
	inherit filepaths;
	inherit lib;
	inherit config;
  };

  programs.kitty = import ./kitty {
    inherit pkgs;
  };

  programs.bash = import ./bash {
  
  };
}

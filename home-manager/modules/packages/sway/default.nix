{ pkgs, filepaths, lib, config }:
let
  sway = filepaths.dotfiles.sway;
in
{
  enable = true;
  config = {
    assigns = {
	  "1: web" = [{ class = "^Firefox$"; }];
	};
	defaultWorkspace = "workspace number 1";
	keybindings = 
	let
      modifier = config.wayland.windowManager.sway.config.modifier;
    in lib.mkOptionDefault {
      "${modifier}+Return" = "exec ${pkgs.kitty}/bin/foot";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
    };

	modifier = "Mod4";
  };
}

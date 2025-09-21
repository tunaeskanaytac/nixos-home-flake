{ pkgs, filepaths, lib, config }:
let
  sway = filepaths.dotfiles.sway;
in
{
  enable = true;
  config = {
    fonts = {
	 names = ["RobotoMono"];
	};
	startup = [
      { command = "soteria"; }
	];
	modifier = "Mod4";
    terminal = "${pkgs.kitty}/bin/kitty";

    output = {
	  "*" = {
	    bg = (sway + "/nix_wp.jpg") + " fill";
	  };
	  eDP-1 = {
	    scale = "1";
	    mode = "1920x1080@144.03Hz";
	  };
	  "Samsung Electric Company LS24AG32x H9JWB02025   " = {
        transform = "270";
	  };
	};

	input = {
	  "type:touchpad" = {
        middle_emulation = "enabled";
        dwt = "enabled";
		tap = "enabled";
		natural_scroll = "enabled";
	  };
	  "type:keyboard" = {
        xkb_layout = "tr,us,de";
	    xkb_options = "grp:alt_space_toggle";
      };
	  "type:pointer" = {
	    accel_profile = "flat";
		pointer_accel = "0";
	  };
	};

    keycodebindings = let
      printcode = "107";
    in {
	  "${printcode}" = "exec ${pkgs.flameshot}/bin/flameshot gui";
	};

	keybindings = 
	let
      modifier = config.wayland.windowManager.sway.config.modifier;
	  terminal = config.wayland.windowManager.sway.config.terminal;
    in lib.mkOptionDefault {
      "${modifier}+Return" = "exec ${terminal}";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun";
    };

    assigns = {
	  "1: web" = [{ class = "^Firefox$"; }];
	};
	defaultWorkspace = "workspace number 1";
  };
}

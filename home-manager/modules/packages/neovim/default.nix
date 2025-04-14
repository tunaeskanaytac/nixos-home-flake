{ filepaths, pkgs }:
let
  nvim = filepaths.dotfiles.nvim;
in
{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  plugins = with pkgs.vimPlugins; [
    # COLORSCHEMES
    gruvbox-material
    catppuccin-nvim
    kanagawa-nvim

    nvim-web-devicons

    nvim-lspconfig
    omnisharp-extended-lsp-nvim

    luasnip
    friendly-snippets
    nvim-treesitter.withAllGrammars
    lspkind-nvim
    nvim-cmp
    cmp-buffer
    cmp-path
    cmp-nvim-lua
    cmp-nvim-lsp
    cmp_luasnip
    nvim-autopairs

    none-ls-nvim

    lualine-nvim
    lualine-lsp-progress
    trouble-nvim

    leap-nvim
    plenary-nvim
    mini-nvim

    which-key-nvim

    obsidian-nvim
    undotree
  ];

  extraPackages = with pkgs; [
    lua-language-server
    nixd
    omnisharp-roslyn

    nixfmt-rfc-style

    dotnet-sdk
    mono
    # msbuild # insecure package
    ripgrep
    tree-sitter
    nodejs_latest
  ];

  extraLuaPackages =
    luaPkgs: with luaPkgs; [
      jsregexp
    ];
  extraLuaConfig = ''
    	-----------------------OPTIONS------------------------------------
        ${builtins.readFile (nvim + "/options.lua")}
    	-----------------------KEYMAPS------------------------------------
    	${builtins.readFile (nvim + "/keymaps.lua")}
    	-----------------------PLUGINS------------------------------------
    	${builtins.readFile (nvim + "/plugins.lua")}
  '';
}

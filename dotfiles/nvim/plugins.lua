require 'nvim-treesitter.configs'.setup {
    incremental_selection = {
   	  enable = true,
   	  keymaps = {
   	    init_selection = "<C-n>",
   	    node_incremental = "<C-n>",
   	    scope_incremental = "<C-s>",
   	    node_decremental = "<C-m>",
   	  }
    },
	highlight = {
		enable = true,

		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

require('leap').create_default_mappings()

require('mini.jump').setup()

require('mini.icons').setup()
require('mini.pick').setup()

require("mini.surround").setup({
	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		add = 'ys',    -- Add surrounding in Normal and Visual modes
		delete = 'ds', -- Delete surrounding
		find = '',     -- Find surrounding (to the right)
		find_left = '', -- Find surrounding (to the left)
		highlight = '', -- Highlight surrounding
		replace = 'cs', -- Replace surrounding
		update_n_lines = '', -- Update `n_lines`
	},
})

require 'nvim-web-devicons'.setup {}

require("luasnip.loaders.from_vscode").lazy_load()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require 'lspconfig'.lua_ls.setup {
	capabilities = capabilities
}
require 'lspconfig'.nixd.setup {
	capabilities = capabilities
}
require 'lspconfig'.pyright.setup {
	capabilities = capabilities
}

local handle = io.popen("which OmniSharp")
local omniSharpDLLDir
if handle ~= nil then
	local omniSharpDir = handle:read("*a")
	omniSharpDLLDir = string.sub(omniSharpDir, 1, string.len(omniSharpDir) - 14) .. "lib/omnisharp-roslyn/OmniSharp.dll"
else
	error("OmniSharp doesn't exist?")
end
require 'lspconfig'.omnisharp.setup {
	cmd = { "dotnet", omniSharpDLLDir },
	handlers = {
		["textDocument/definition"] = require('omnisharp_extended').definition_handler,
		["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
		["textDocument/references"] = require('omnisharp_extended').references_handler,
		["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
	},
	capabilities = capabilities
}

local lspkind = require "lspkind"
lspkind.init()

local cmp = require "cmp"

cmp.setup {
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			},
			{ "i", "c" }
		),

		["<C-space>"] = cmp.mapping {
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
			)
				if cmp.visible() then
					if not cmp.confirm { select = true } then
						return
					end
				else
					cmp.complete()
				end
			end,
		},

		-- ["<tab>"] = cmp.mapping {
		--   i = cmp.config.disable,
		--   c = function(fallback)
		--     fallback()
		--   end,
		-- },

		-- Testing
		["<C-q>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},

		-- If you want tab completion :'(
		--  First you have to just promise to read `:help ins-completion`.
		--
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item({
					behavior = cmp.SelectBehavior.Select
				})
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({
					behavior = cmp.SelectBehavior.Select
				})
			else
				fallback()
			end
		end,
	},

	-- Youtube:
	--    the order of your sources matter (by default). That gives them priority
	--    you can configure:
	--        keyword_length
	--        priority
	--        max_item_count
	--        (more?)
	sources = {
		-- Youtube: Could enable this only for lua, but nvim_lua handles that already.
		{ name = "nvim_lua" },

		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer",  keyword_length = 5 },
	},

	sorting = {
		-- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,

			-- copied from cmp-under, but I don't think I need the plugin for this.
			-- I might add some more of my own.
			function(entry1, entry2)
				local _, entry1_under = entry1.completion_item.label:find "^_+"
				local _, entry2_under = entry2.completion_item.label:find "^_+"
				entry1_under = entry1_under or 0
				entry2_under = entry2_under or 0
				if entry1_under > entry2_under then
					return false
				elseif entry1_under < entry2_under then
					return true
				end
			end,

			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},

	-- Youtube: mention that you need a separate snippets plugin
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	formatting = {
		-- Youtube: How to set up nice formatting for your sources.
		format = lspkind.cmp_format {
			with_text = true,
			menu = {
				buffer = "[buf]",
			nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
				gh_issues = "[issues]",
				tn = "[TabNine]",
			},
		},
	},

	experimental = {
		-- I like the new menu better! Nice work hrsh7th
		native_menu = false,

		-- Let's play with this for a day or two
		ghost_text = true,
	},
}

cmp.setup.cmdline("/", {
	completion = {
		-- Might allow this later, but I don't like it right now really.
		-- Although, perhaps if it just triggers w/ @ then we could.
		--
		-- I will have to come back to this.
		autocomplete = false,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp_document_symbol" },
	}, {
		-- { name = "buffer", keyword_length = 5 },
	}),
})

cmp.setup.cmdline(":", {
	completion = {
		autocomplete = false,
	},

	sources = cmp.config.sources({
		{
			name = "path",
		},
	}, {
		{
			name = "cmdline",
			max_item_count = 20,
			keyword_length = 4,
		},
	}),
})

require('nvim-autopairs').setup({
	check_ts = true,
	ts_config = {
		lua = { 'string' }, -- it will not add a pair on that treesitter node
		javascript = { 'template_string' },
	}
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

require("trouble").setup()
require 'lualine'.setup {
	sections = {
		lualine_c = {
			'filename',
			'lsp_progress'
		}
	}
}

require("obsidian").setup({
	workspaces = {
		{
			name = "ObsidianVault",
			path = "~/Documents/ObsidianVault/",
		},
	},
	-- see below for full list of options 👇
})


local null_ls = require("null-ls")

null_ls.setup({
    sources = {
		null_ls.builtins.diagnostics.ruff,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.nixfmt,
		-- null_ls.builtins.formatting.alejandra.with({
		-- 	extra_args = { "--experimental-config", "../alejandra/alejandra.toml" },
		-- })
    },
})

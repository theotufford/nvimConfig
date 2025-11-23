local pack = {}
function pack.add()
	local packList = {
		"neovim/nvim-lspconfig",
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
		"mason-org/mason-lspconfig.nvim",
		"nvim-lua/plenary.nvim",
		"R-nvim/R.nvim",
	}
	for _, packName in ipairs(packList) do
		vim.pack.add({ { src = "https://github.com/" .. packName } })
	end
	vim.pack.add({ {
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = 'master',
		build = ":TSUpdate"
	} })
end

function pack.setup()
	require "nvim-treesitter".setup()
	require "mason".setup()
	require "r".setup()
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"vale_ls",
			"pyright",
			"eslint",
			"html",
			"cssls",
			"clangd",
		}
	})
	-- LSP settings ---------------------------------------------------------
	local lspconfig = require("lspconfig")
	-- Common on_attach
	local onAttach = function(_, bufnr)
		local opts = { buffer = bufnr, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	end

	-- Lua (for Neovim)
	lspconfig.lua_ls.setup({
		on_attach = onAttach,
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
			},
		}
	})

	-- Python
	lspconfig.pyright.setup({
		on_attach = onAttach,
	})

	-- R, broken for some reason
	--	lspconfig.r_language_server.setup({
	--		on_attach = onAttach,
	--	})

	-- JavaScript / React / TypeScript
	lspconfig.eslint.setup({
		on_attach = onAttach,
	})
	lspconfig.vale_ls.setup({
		on_attach = onAttach,
	})
	-- HTML
	lspconfig.html.setup({
		on_attach = onAttach,
	})

	-- CSS
	lspconfig.cssls.setup({
		on_attach = onAttach,
	})

	-- C / C++ (Pi-Pico)
	lspconfig.clangd.setup({
		on_attach = onAttach,
		cmd = { "clangd", "--background-index" },
	})
	-- treesitter settings ---------------------------------------------------------
	require("nvim-treesitter.configs").setup({
		auto_install = true,
		ensure_installed = {
			"lua",
			"markdown",
			"python",
			"r",
			"javascript",
			"tsx",
			"html",
			"css",
			"c",
			"cpp",
			"bash",
			"json",
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>", -- start selection
				node_incremental = "<CR>", -- grow
				node_decremental = "<BS>", -- shrink
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
		},
	})
	vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format)
end

return pack

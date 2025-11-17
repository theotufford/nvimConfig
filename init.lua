vim.g.mapleader = " "
vim.o.omnifunc = ""
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.o.swapfile = false
vim.o.winborder = "double" 
vim.keymap.set('n', "<leader>o", ":w<CR> :update<CR> :source<CR>")
vim.keymap.set('n', "<leader>w", ":w<CR>")
vim.keymap.set('n', "<leader>q", ":q<CR>")

vim.pack.add({
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/kylechui/nvim-surround" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/echasnovski/mini.pairs"},
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = 'master', build = ":TSUpdate"},
	{ src = "https://github.com/Saghen/blink.cmp", },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.4.0"},
	{ src = "https://github.com/nosduco/remote-sshfs.nvim"},
	{ src = "https://github.com/R-nvim/R.nvim"},

})


vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true,client.id,ev.buf)
		end
	end,
})

require('telescope').load_extension 'remote-sshfs'
require "remote-sshfs".setup()
require "mason".setup()
require "nvim-treesitter".setup()
require "mini.pick".setup()
require "mini.pairs".setup()
require "oil".setup()
require "nvim-surround".setup() -- gotta make these binds better most dont work
require "r".setup()

vim.lsp.enable({'lua_ls', 'typst', 'r', 'rnoweb', 'clangd', 'vscode-eslint-language-server', "ast-grep"})


local api = require('remote-sshfs.api')
vim.keymap.set('n', '<leader>rc', api.connect, {})
vim.keymap.set('n', '<leader>rd', api.disconnect, {})
vim.keymap.set('n', '<leader>re', api.edit, {})


vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format)

vim.cmd("colorscheme carbonfox")
vim.cmd(":hi statusline guibg=NONE")
vim.keymap.set('n', "<leader><leader>", ":Pick files<CR>")
vim.keymap.set('n', "<leader>e", ":Oil<CR>")

vim.keymap.set('n', "<leader>h", ":Pick help<CR>")
vim.keymap.set('n', "<leader>H",  vim.lsp.buf.hover)

require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "javascript", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python" },
	auto_install = true,
	highlight = {
		enable = true, additional_vim_regex_highlighting = false,
	},
}


local ls = require("luasnip")
ls.setup({enable_autosnippets=true})
require("luasnip.loaders.from_vscode").load({ paths = { "./snippets/vscode" } })

vim.keymap.set({"i"}, "<C-e>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-k>", function() ls.jump(-1) end, {silent = true})


require "blink.cmp".setup({
	snippets = { preset = 'luasnip' },
	-- ensure you have the `snippets` source (enabled by default)
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},
	fuzzy = {implementation = "lua"},
	keymap = {
		['<C-k>'] = { 'select_prev', 'fallback' },
		['<C-j>'] = { 'select_next', 'fallback' },
		['<C-e>'] = {
			function(cmp)
				if cmp.snippet_active() then return cmp.accept()
				else return cmp.select_and_accept() end
			end,
		},
	}
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })

local mod = {}
function mod.add()
	vim.pack.add({
		{ src = "https://github.com/kylechui/nvim-surround" },
		{ src = "https://github.com/echasnovski/mini.pairs" },
		{ src = "https://github.com/Saghen/blink.cmp", },
		{ src = "https://github.com/L3MON4D3/LuaSnip",         version = "v2.4.0" },
		{ src = "https://github.com/nosduco/remote-sshfs.nvim" },
	})
end

function mod.setup()
	require('telescope').load_extension 'remote-sshfs'
	require "remote-sshfs".setup()
	require "mini.pairs".setup()
	require "nvim-surround".setup() -- gotta make these binds better most dont work

	local ls = require("luasnip")
	ls.setup({ enable_autosnippets = true })
	require("luasnip.loaders.from_vscode").load({ paths = { "/usr/local/snippets/vscode" } })
	vim.keymap.set({ "i" }, "<C-e>", function() ls.expand() end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(1) end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-k>", function() ls.jump(-1) end, { silent = true })

	require "blink.cmp".setup({
		snippets = { preset = 'luasnip' },
		-- ensure you have the `snippets` source (enabled by default)
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},
		fuzzy = { implementation = "lua" },
		keymap = {
			['<C-k>'] = { 'select_prev', 'fallback' },
			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-e>'] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
			},
		}
	})
	local api = require('remote-sshfs.api')
	vim.keymap.set('n', '<leader>rc', api.connect, {})
	vim.keymap.set('n', '<leader>rd', api.disconnect, {})
	vim.keymap.set('n', '<leader>re', api.edit, {})
end
return mod

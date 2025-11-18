local mod = {}
function mod.add()
	vim.pack.add({
		{ src = "https://github.com/EdenEast/nightfox.nvim" },
		{ src = "https://github.com/echasnovski/mini.pick" },
		{ src = "https://github.com/nvim-telescope/telescope.nvim"},
		{ src = "https://github.com/stevearc/oil.nvim" },
	})
end

function mod.setup()

	vim.cmd("colorscheme carbonfox")

	require "mini.pick".setup()
	require "oil".setup()

	vim.keymap.set('n', "<leader><leader>", ":Pick files<CR>")
	vim.keymap.set('n', "<leader>e", ":Oil<CR>")

	vim.keymap.set('n', "<leader>h", ":Pick help<CR>")
	vim.keymap.set('n', "<leader>H",  vim.lsp.buf.hover)

	local builtin = require('telescope.builtin')
	vim.keymap.set(
		'n',
		'<leader>g',
		builtin.live_grep,
		{ desc = 'Telescope live grep' }
	)
end

return mod

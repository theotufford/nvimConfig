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
	vim.o.winborder = "rounded"
	vim.cmd(":hi statusline guibg=NONE")
	local set = vim.keymap.set
	set('n', "<leader>o", ":w<CR> :update<CR> :source<CR>")
	set('n', "<leader>w", ":w<CR>")
	set('n', "<leader>q", ":q<CR>")
local homeDir = os.getenv("HOME")
package.path = package.path .. ";".. homeDir .."/.config/nvim/packs/?.lua"
local packList = { -- order in which packages are added and then loaded
	"ui",
	"textEditing",
	"langSupport",
}

-- add packages
for _, pack in ipairs(packList) do
	require(pack).add()
end

-- setup / load package
for _, pack in ipairs(packList) do
	require(pack).setup()
end

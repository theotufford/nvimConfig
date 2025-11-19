local pack = {}
function pack.add()
	local packList = {
		"neovim/nvim-lspconfig",
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig" ,
		"mason-org/mason-lspconfig.nvim",
		"nvim-lua/plenary.nvim",
	  "R-nvim/R.nvim",
	}
	for _, packName in ipairs(packList) do
		vim.pack.add({{src = "https://github.com/" .. packName}})
	end
	vim.pack.add({{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = 'master',
		build = ":TSUpdate" }})
end

function pack.setup()
	require "nvim-treesitter".setup()
	require "mason".setup()
	require "mason-lspconfig".setup()
	require "r".setup()
	-- lsp config
	local lspLangList = {
		'lua_ls',
		'python',
		'typst',
		'r',
		'rnoweb',
		'clangd',
		'vscode-eslint-language-server',
		"ast-grep"
	}

	vim.lsp.enable(lspLangList)
	vim.api.nvim_create_autocmd('LspAttach',
		{
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client:supports_method('textDocument/completion') then
					vim.lsp.completion.enable(true, client.id, ev.buf)
				end
			end,
		})

		-- treesitter config
		local tsLangList = {
			"c",
			"javascript",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"python"
		}

	require 'nvim-treesitter.configs'.setup {
		ensure_installed = tsLangList,
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	}

	-- mappings

	vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format)

end

return pack

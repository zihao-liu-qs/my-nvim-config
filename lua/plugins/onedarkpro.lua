-- onedarkpro 主题
vim.pack.add({
	{ src = "https://github.com/olimorris/onedarkpro.nvim" },
})
require("onedarkpro").setup({
	options = {
		transparency = true,
	},
})
vim.cmd("colorscheme onedark")

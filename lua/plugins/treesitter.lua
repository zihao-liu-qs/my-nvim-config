-- nvim-treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}, {
	load = function()
		vim.cmd.packadd("nvim-treesitter")
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"go", "python", "lua", "javascript", "typescript",
				"html", "css", "c", "cpp", "json", "markdown",
			},
			highlight = { enable = true },
			indent = { enable = false },
		})
		vim.cmd("TSUpdate")
	end,
})

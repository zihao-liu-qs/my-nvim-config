-- obsidian.nvim
vim.pack.add({
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim" },
}, {
	load = function()
		vim.cmd.packadd("obsidian.nvim")
		require("obsidian").setup({
			workspaces = {
				{
					name = "personal",
					path = "/Users/liuzihao/Documents/Notes",
				},
			},
			legacy_commands = false,
		})
	end,
})

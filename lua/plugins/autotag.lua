-- nvim-ts-autotag（标签自动闭合/同步重命名，依赖 treesitter html parser）
vim.pack.add({
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
}, {
	load = function()
		vim.cmd.packadd("nvim-ts-autotag")
		require("nvim-ts-autotag").setup()
	end,
})

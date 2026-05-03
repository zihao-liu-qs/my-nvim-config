-- todo-comments.nvim
vim.pack.add({
	{ src = "https://github.com/folke/todo-comments.nvim" },
}, {
	load = function()
		vim.cmd.packadd("todo-comments.nvim")
		require("todo-comments").setup()
	end,
})

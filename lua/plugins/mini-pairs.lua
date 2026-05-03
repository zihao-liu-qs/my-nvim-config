-- mini.pairs（括号/引号自动补全）
vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.pairs" },
}, {
	load = function()
		vim.cmd.packadd("mini.pairs")
		require("mini.pairs").setup()
	end,
})

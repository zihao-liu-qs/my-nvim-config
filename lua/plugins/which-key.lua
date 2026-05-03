-- which-key（快捷键提示）
vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
}, {
	load = function()
		vim.cmd.packadd("which-key.nvim")
		require("which-key").setup({
			preset = "modern",
			delay = 500, -- 避免快速连按（如 dd）时触发
		})
	end,
})

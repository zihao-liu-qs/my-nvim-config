-- mason.nvim（LSP 服务器管理）
vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
}, {
	load = function()
		vim.cmd.packadd("mason.nvim")
		require("mason").setup({
			ui = {
				border = "rounded",
			},
		})
	end,
})

vim.keymap.set("n", "<leader>cm", "<Cmd>Mason<CR>", { desc = "Open Mason" })

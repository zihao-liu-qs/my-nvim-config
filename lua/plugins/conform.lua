-- conform.nvim（保存时自动格式化）
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
}, {
	load = function()
		vim.cmd.packadd("conform.nvim")
		require("conform").setup({
			formatters_by_ft = {
				python = { "ruff_format" },
				html = { "prettierd" },
				css = { "prettierd" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				vue = { "prettierd" },
				json = { "prettierd" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
})

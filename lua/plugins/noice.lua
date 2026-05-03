-- noice（浮动命令行 + 消息管理）
vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
}, {
	load = function()
		vim.cmd.packadd("nui.nvim")
		vim.cmd.packadd("noice.nvim")
	end,
})

vim.cmd.packadd("nui.nvim")
vim.cmd.packadd("noice.nvim")
require("noice").setup({
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
		format = {
			cmdline = { pattern = "^:", icon = "", lang = "vim", view = "cmdline_popup" },
			search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", view = "cmdline_popup" },
			search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", view = "cmdline_popup" },
			filter = { pattern = "^:%s*!", icon = "$", lang = "bash", view = "cmdline_popup" },
			lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua", view = "cmdline_popup" },
		},
	},
	messages = {
		enabled = true,
		view = "notify",
		view_error = "notify",
		view_warn = "notify",
		view_history = "messages",
		view_search = false,
	},
	popupmenu = { enabled = true, backend = "native" },
	notify = { enabled = false },
})

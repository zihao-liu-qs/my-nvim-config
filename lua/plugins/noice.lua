-- noice（浮动命令行 + 消息管理）
-- vim.pack.add({
-- 	{ src = "https://github.com/MunifTanjim/nui.nvim" },
-- 	{ src = "https://github.com/folke/noice.nvim" },
-- }, {
-- 	load = function()
-- 		vim.cmd.packadd("nui.nvim")
-- 		vim.cmd.packadd("noice.nvim")
-- 	end,
-- })
--
-- require("noice").setup({
-- 	cmdline = {
-- 		enabled = true,
-- 		view = "cmdline_popup",
-- 		format = {
-- 			cmdline = { pattern = "^:", icon = "", lang = "vim", view = "cmdline_popup" },
-- 			search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", view = "cmdline_popup" },
-- 			search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", view = "cmdline_popup" },
-- 			filter = { pattern = "^:%s*!", icon = "$", lang = "bash", view = "cmdline_popup" },
-- 			lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua", view = "cmdline_popup" },
-- 		},
-- 	},
-- 	messages = {
-- 		enabled = true,
-- 		view = "notify",
-- 		view_error = "notify",
-- 		view_warn = "notify",
-- 		view_history = "messages",
-- 		view_search = false,
-- 	},
-- 	popupmenu = { enabled = true, backend = "native" },
-- 	notify = { enabled = true },
-- })

vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
}, {
	load = function()
		vim.cmd.packadd("nui.nvim")
		vim.cmd.packadd("noice.nvim")
	end,
})

require("noice").setup({
	-- 只保留命令行浮动（最有价值）
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
	},

	-- 消息：只处理重要的
	messages = {
		enabled = true,
		view = "notify",
	},

	-- 关键：过滤垃圾信息
	routes = {
		{
			filter = { event = "msg_show", find = "written" },
			opts = { skip = true },
		},
		{
			filter = { event = "msg_show", find = "yanked" },
			opts = { skip = true },
		},
	},

	-- LSP：只接管 hover（够用了）
	lsp = {
		hover = {
			enabled = true,
		},
		progress = {
			enabled = false, -- 必关
		},
	},

	-- 其他全部关掉（保持干净）
	popupmenu = { enabled = false },
	notify = { enabled = true },
})

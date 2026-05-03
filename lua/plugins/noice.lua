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
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
	},

	messages = {
		enabled = true,
		view = "notify",
	},

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

	lsp = {
		hover = {
			enabled = true,
		},
		progress = {
			enabled = false, -- 必关
		},
	},

	popupmenu = { enabled = false },
	notify = { enabled = true },
})

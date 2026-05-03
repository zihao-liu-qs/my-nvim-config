-- snacks.nvim
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})
vim.cmd.packadd("snacks.nvim")

-- 启动无文件时打开 sidebar
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			Snacks.explorer({ layout = { preset = "sidebar" } })
		end
	end,
})

vim.keymap.set("n", "<leader>e", function()
	Snacks.explorer({
		layout = { preset = "dropdown", preview = false },
		jump = { close = true },
	})
end, { desc = "Explorer (float)" })

vim.keymap.set("n", "<leader>E", function()
	Snacks.explorer({
		layout = { preset = "sidebar" },
	})
end, { desc = "Explorer (sidebar)" })

-- picker
local p = Snacks.picker
vim.keymap.set("n", "<leader>ff", p.files)
vim.keymap.set("n", "<leader>fg", p.grep)
vim.keymap.set("n", "<leader>fr", p.recent)
vim.keymap.set("n", "<leader>/", p.lines)

Snacks.setup({
	bigfile = { enabled = true },
	explorer = { enabled = true },
	indent = { enabled = true, scope = { enabled = true } },
	notifier = { enabled = true },
})

-- devdocs.nvim — 离线 API 文档浏览器（devdocs.io）
vim.pack.add({
	{ src = "https://github.com/maskudo/devdocs.nvim" },
})
vim.cmd.packadd("devdocs.nvim")

require("devdocs").setup({
	ensure_installed = {
		"go",
		"lua~5.1",
		"html",
		"css",
		"http",
	},
})

-- <leader>d 文档快捷键
vim.keymap.set("n", "<leader>dd", function()
	local devdocs = require("devdocs")
	local installed = devdocs.GetInstalledDocs()
	vim.ui.select(installed, {}, function(selected)
		if not selected then return end
		Snacks.picker.files({ cwd = devdocs.GetDocDir(selected) })
	end)
end, { desc = "Browse devdocs" })

vim.keymap.set("n", "<leader>di", "<Cmd>DevDocs install<CR>", { desc = "Install devdocs" })
vim.keymap.set("n", "<leader>dD", "<Cmd>DevDocs delete<CR>", { desc = "Delete devdocs" })

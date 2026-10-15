-- flash.nvim — 快速跳转（字母标签定位）
vim.pack.add({
	{ src = "https://github.com/folke/flash.nvim" },
})
vim.cmd.packadd("flash.nvim")

require("flash").setup({
	-- 默认标签字符集，可按需精简
	labels = "asdfghjklqwertyuiopzxcvbnm",
	-- 搜索标签颜色
	highlight = {
		backdrop = true,
		matches = true,
	},
	-- 仅保留 s 跳转，禁用其余所有增强
	modes = {
		char = { enabled = false },   -- 禁用 f/F/t/T/;/, 增强
		search = { enabled = false }, -- 禁用 / ? 搜索增强
	},
})

-- s 跳转到任意字符（normal / visual / operator-pending）
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash jump" })

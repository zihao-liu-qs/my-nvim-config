-- rainbow-delimiters.nvim
vim.pack.add({
	{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
}, {
	load = function()
		vim.cmd.packadd("rainbow-delimiters.nvim")
		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = "rainbow-delimiters.strategy.global",
			},
			query = {
				[""] = "rainbow-delimiters",
			},
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		}
	end,
})

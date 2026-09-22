-- nvim-treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}, {
	load = function()
		vim.cmd.packadd("nvim-treesitter")

		-- 检测 C 编译器是否可用（Windows 上常缺失）
		local has_cc = vim.fn.executable("cc") == 1
			or vim.fn.executable("gcc") == 1
			or vim.fn.executable("clang") == 1
			or vim.fn.executable("cl") == 1
			or vim.fn.executable("zig") == 1

		local opts = {
			highlight = { enable = true },
			indent = { enable = false },
		}

		if has_cc then
			opts.ensure_installed = {
				"go", "python", "lua", "javascript", "typescript",
				"html", "css", "c", "cpp", "json", "markdown",
			}
		else
			vim.notify(
				"No C compiler found, skip treesitter auto-install.\n"
				.. "Install one via: winget install zig.zig",
				vim.log.levels.WARN
			)
		end

		require("nvim-treesitter.configs").setup(opts)
	end,
})

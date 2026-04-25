-- Neovim 0.12 vim.pack 插件管理

vim.g.mapleader = " "

-- ===================== 基础选项 =====================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.winborder = "rounded"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.laststatus = 0
vim.opt.showtabline = 0
vim.opt.ruler = false
vim.opt.cmdheight = 1
vim.opt.autoread = true
vim.opt.conceallevel = 2
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("data") .. "/swap//"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.clipboard = "unnamedplus"

-- 静默保存退出
vim.cmd("command! -bang WQ silent! w<bang> | q")

-- 基础快捷键
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "H", "^", { desc = "Move to beginning of line" })
vim.keymap.set("n", "J", "25j", { desc = "Move down 25 lines" })
vim.keymap.set("n", "K", "25k", { desc = "Move up 25 lines" })
vim.keymap.set("n", "L", "$", { desc = "Move to end of line" })
vim.keymap.set("n", "gs", ":split<CR><C-w>j", { desc = "Split and move to new pane" })
vim.keymap.set("n", "gv", ":vsplit<CR><C-w>l", { desc = "VSplit and move to new pane" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch pane left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch pane down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch pane up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch pane right" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ wrap = true, count = -1 })
end, { desc = "prev diagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ wrap = true, count = 1 })
end, { desc = "next diagnostic" })

-- 基础 autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format()
	end,
	pattern = "*",
})
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local dir = vim.fn.expand("%:p:h")
		if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
	pattern = "*",
})
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight copying text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 500 })
	end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

-- 启动时无文件则自动打开 neo-tree 文件树
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- 如果当前 buffer 没有实际文件（空启动 / 无参数）
		local buf = vim.api.nvim_get_current_buf()
		local name = vim.api.nvim_buf_get_name(buf)
		local has_file = name ~= "" and vim.fn.filereadable(name) == 1
		local has_buffers = #vim.api.nvim_list_bufs() > 1

		if not has_file and not has_buffers then
			require("neo-tree.command").execute({
				action = "focus",
				source = "filesystem",
				position = "float",
			})
		end
	end,
})


-- ===================== rainbow-delimiters =====================
vim.pack.add({
	{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
}, {
	load = function()
		vim.cmd.packadd("rainbow-delimiters.nvim")
		---@type rainbow_delimiters.config
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

-- ===================== obsidian =====================
vim.pack.add({
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
}, {
	load = function()
		vim.cmd.packadd("plenary.nvim")
		vim.cmd.packadd("obsidian.nvim")
		require("obsidian").setup({
			workspaces = {
				{
					name = "personal",
					path = "/Users/liuzihao/Documents/Notes",
				},
			},
			legacy_commands = false,
		})
	end,
})

-- ===================== onedarkpro =====================
vim.pack.add({
	{ src = "https://github.com/olimorris/onedarkpro.nvim" },
})
require("onedarkpro").setup({
	options = {
		transparency = true,
	},
})
vim.cmd("colorscheme onedark")


-- ===================== which-key =====================
vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
}, {
	load = function(plug_data)
		vim.cmd.packadd(plug_data.spec.name)
		require("which-key").setup({
			preset = "modern",
			icons = { colors = true },
			win = { border = "rounded" },
			delay = 500,
			show_keys = true,
		})
	end,
})

-- ===================== neo-tree =====================
vim.pack.add({
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
}, {
	load = function(plug_data)
		vim.cmd.packadd(plug_data.spec.name)
		require("neo-tree").setup({
			window = {
				position = "left",
				width = 30,
			},
			close_if_last_window = true,
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
			},
		})
	end,
})
vim.keymap.set("n", "<leader>E", function()
	require("neo-tree.command").execute({
		action = "focus",
		source = "filesystem",
		position = "left",
		toggle = true,
		reveal = true,
		reveal_force_cwd = true,
	})
end, { desc = "Toggle neo-tree sidebar" })
vim.keymap.set("n", "<leader>e", function()
	require("neo-tree.command").execute({
		action = "focus",
		source = "filesystem",
		position = "float",
		toggle = true,
		reveal = true,
		reveal_force_cwd = true,
	})
end, { desc = "Toggle neo-tree floating" })

-- ===================== telescope =====================
vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
}, {
	load = function()
		vim.cmd.packadd("telescope.nvim")
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer fuzzy find" })
		vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope current buffer fuzzy find" })
	end,
})

-- ===================== nvim-treesitter =====================
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}, {
	load = function()
		vim.cmd.packadd("nvim-treesitter")
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"go", "python", "lua", "javascript", "typescript",
				"html", "css", "c", "cpp", "json", "markdown",
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
		vim.cmd("TSUpdate")
	end,
})

-- ===================== nvim-lspconfig =====================
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
}, {
	load = function()
		vim.cmd.packadd("nvim-lspconfig")
		vim.lsp.enable({
			"pyright", -- Python
			"gopls",   -- Go
			"html",    -- HTML
			"cssls",   -- CSS
			"ts_ls",   -- JavaScript/TypeScript
			"clangd",  -- C/C++
		})
	end,
})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gk", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Incoming calls" })
vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Outgoing calls" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>lf", function()
	vim.lsp.buf.format()
end, { desc = "format" })

-- ===================== mason =====================
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

-- ===================== blink.cmp =====================
vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp" },
}, {
	load = function()
		vim.cmd.packadd("blink.cmp")
		require("blink.cmp").setup({
			sources = {
				default = { "lsp", "path", "buffer" },
			},
			keymap = {
				preset = "default",
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
		})
	end,
})

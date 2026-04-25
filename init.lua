-- Neovim 0.12 vim.pack 插件管理

vim.g.mapleader = " "

-- 抑制所有早期消息，防止启动时 "Press ENTER"
vim.notify = function() end

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
	popupmenu = { enabled = false },
	notify = { enabled = false },
})

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
vim.opt.cmdheight = 0
vim.opt.shortmess:append("AWI")  -- 抑制启动消息和 "Press ENTER" 提示
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

-- 启动时无文件则自动打开 snacks explorer
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local name = vim.api.nvim_buf_get_name(buf)
		local has_file = name ~= "" and vim.fn.filereadable(name) == 1
		local has_buffers = #vim.api.nvim_list_bufs() > 1

		if not has_file and not has_buffers then
	Snacks.explorer({
		layout = { preset = "dropdown", preview = false },
		jump = { close = true },
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

-- ===================== snacks =====================
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
}, {
	load = function(plug_data)
		vim.cmd.packadd("snacks.nvim")
	end,
})

vim.keymap.set("n", "<leader>E", function()
	local existing = Snacks.picker.get({ source = "explorer" })[1]
	if existing then
		existing:close()
		return
	end
	Snacks.explorer({
		layout = { preset = "sidebar", preview = false },
		jump = { close = false },
	})
end, { desc = "Toggle snacks explorer sidebar" })

vim.keymap.set("n", "<leader>e", function()
	local existing = Snacks.picker.get({ source = "explorer" })[1]
	if existing then
		existing:close()
		return
	end
	Snacks.explorer({
		layout = { preset = "dropdown", preview = false },
		jump = { close = true },
	})
end, { desc = "Toggle snacks explorer floating" })

-- ===================== Snacks Picker 快捷键 =====================
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fn", function() Snacks.picker.notifications() end, { desc = "Notifications" })
vim.keymap.set("n", "<leader>f/", function() Snacks.picker.lines() end, { desc = "Current buffer fuzzy find" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.lines() end, { desc = "Current buffer fuzzy find" })

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
			indent = { enable = false },  -- 由 snacks.indent 替代
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

-- ========== snacks 所有子模块配置 ==========
Snacks.config.explorer = {
	enabled = true,  -- 文件浏览器（替代 neo-tree）
	trash = true,    -- 使用系统回收站
}

Snacks.config.bigfile = {
	enabled = true,  -- 大文件加载优化（>100MB 自动降级基础功能）
}

Snacks.config.image = {
	enabled = true,  -- 图片查看（需 kitty/wezterm/ghostty 终端支持）
}

Snacks.config.dashboard = {
	enabled = false,  -- 启动仪表盘
}

Snacks.config.debug = {
	enabled = false,  -- 调试工具
}

Snacks.config.dim = {
	enabled = false,  -- 当前窗口外区域变暗
}

Snacks.config.git = {
	enabled = false,  -- Git hunk/diff 工具
}

Snacks.config.gitbrowse = {
	enabled = false,  -- 浏览器打开 GitHub 链接
}

Snacks.config.indent = {
	enabled = true,  -- 缩进引导线
}

Snacks.config.input = {
	enabled = true,  -- 美观输入框
}

Snacks.config.keymap = {
	enabled = false,  -- 快捷键管理
}

Snacks.config.layout = {
	enabled = false,  -- 布局控制
}

Snacks.config.lazygit = {
	enabled = true,  -- 集成 lazygit
}

Snacks.config.notifier = {
	enabled = true,  -- 通知美化
}

Snacks.config.notify = {
	enabled = false,  -- vim.notify 替代
}

Snacks.config.quickfile = {
	enabled = true,  -- 快速跳转预渲染
}

Snacks.config.rename = {
	enabled = false,  -- 重命名文件
}

Snacks.config.scope = {
	enabled = false,  -- 作用域折叠
}

Snacks.config.scratch = {
	enabled = false,  -- 临时便笺
}

Snacks.config.scroll = {
	enabled = false,  -- 平滑滚动
}

Snacks.config.statuscolumn = {
	enabled = false,  -- 自定义状态栏
}

Snacks.config.terminal = {
	enabled = true,  -- 内嵌终端
}

Snacks.config.toggle = {
	enabled = false,  -- 开关管理
}

Snacks.config.win = {
	enabled = false,  -- 窗口管理
}

Snacks.config.words = {
	enabled = true,  -- 光标下单词高亮
}

Snacks.config.zen = {
	enabled = false,  -- 专注模式
}

-- snacks.nvim
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
}, {
	load = function()
		vim.cmd.packadd("snacks.nvim")
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

-- 公共：toggle explorer 函数
local function toggle_explorer(layout, close_on_jump)
	return function()
		local existing = Snacks.picker.get({ source = "explorer" })[1]
		if existing then
			existing:close()
			return
		end
		Snacks.explorer({
			layout = { preset = layout, preview = false },
			jump = { close = close_on_jump },
			actions = {
				botright_split = function(picker, item)
					if not item or item.dir then return end
					local buf = vim.fn.bufadd(item.file)
					vim.bo[buf].buflisted = true
					vim.cmd("botright sbuffer " .. buf)
					if picker.opts.jump.close then picker:close() end
				end,
				botright_vsplit = function(picker, item)
					if not item or item.dir then return end
					local buf = vim.fn.bufadd(item.file)
					vim.bo[buf].buflisted = true
					vim.cmd("botright vert sbuffer " .. buf)
					if picker.opts.jump.close then picker:close() end
				end,
			},
			win = {
				list = {
					keys = {
						["<C-s>"] = "botright_split",
						["<C-v>"] = "botright_vsplit",
					},
				},
			},
		})
	end
end

vim.keymap.set("n", "<leader>E", toggle_explorer("sidebar", false), { desc = "Toggle snacks explorer sidebar" })
vim.keymap.set("n", "<leader>e", toggle_explorer("dropdown", true), { desc = "Toggle snacks explorer floating" })

-- Snacks Picker 快捷键
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fn", function() Snacks.picker.notifications() end, { desc = "Notifications" })
vim.keymap.set("n", "<leader>f/", function() Snacks.picker.lines() end, { desc = "Current buffer fuzzy find" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.lines() end, { desc = "Current buffer fuzzy find" })

-- ========== snacks 子模块配置 ==========
Snacks.setup({
	bigfile = { enabled = true },
	explorer = { enabled = true, trash = true },
	indent = {
		enabled = true,
		-- char = "│",           -- 缩进线字符（默认）
		-- only_current = false, -- 设为 true 则只在当前窗口显示
		scope = {
			enabled = true,      -- 高亮当前作用域
			underline = false,   -- 在作用域起始加下划线
		},
		-- animate = {
		-- 	enabled = true,  -- Neovim >= 0.10 默认开启
		-- 	style = "out",   -- 扩散方向：out/up_down/down/up
		-- },
	},
	image = { enabled = true, force = true },
	input = { enabled = true },
	lazygit = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	terminal = { enabled = true },
	words = { enabled = true },
})

-- ===================== 基础选项 =====================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.winborder = "rounded"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.laststatus = 0
vim.opt.shortmess:append("I") -- 防止启动时闪烁
vim.opt.showtabline = 0
vim.opt.ruler = false
-- 分屏时上方窗口底部会强制显示一行状态栏（默认含灰色文件名），
-- 用单个空格清空它，只保留一行不可见的分隔条（文件路径统一由顶部 winbar 显示）
vim.opt.statusline = " "
vim.opt.cmdheight = 1
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.autoread = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("data") .. "/swap//"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.clipboard = "unnamedplus"
-- 符号列：有符号时自动显示（书签、诊断等）
vim.opt.signcolumn = "auto"
-- 分屏默认方向：右侧 / 下方（snacks explorer 打开文件依赖这两个选项）
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 每个 pane 顶部显示相对路径（onedarkpro 蓝色）
vim.opt.winbar = "%#WinBarPath#%f"
vim.api.nvim_set_hl(0, "WinBarPath", { fg = "#61afef", bold = true })


-- ===================== 基础快捷键 =====================
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
-- "v" 同时作用于可视模式和选择模式，让 HJKL 在 normal/可视/选择下行为一致
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Line start" })
-- J/K 向下/上跳 15 行，并记录到跳转列表（normal 模式可用 Ctrl+o 返回）
local function jump_lines(delta)
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	local target = math.max(1, math.min(line + delta, vim.fn.line("$")))
	vim.cmd(string.format("normal! %dG", target)) -- G 是跳转命令，会记录出发位置
	vim.fn.cursor(target, col)                   -- 恢复列（cursor() 不是跳转，不打断跳转列表）
end

vim.keymap.set("n", "J", function() jump_lines(15) end, { desc = "Down 15 lines" })
vim.keymap.set("n", "K", function() jump_lines(-15) end, { desc = "Up 15 lines" })
vim.keymap.set("v", "J", "15j", { desc = "Down 15 lines" })
vim.keymap.set("v", "K", "15k", { desc = "Up 15 lines" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "Line end" })
-- \ 跳到屏幕最后一行（原生 L，不经 L→$ 重映射）
vim.keymap.set("n", "\\", "L", { desc = "Last line of screen" })
-- | 跳到屏幕第一行（原生 H，不经 H→^ 重映射）
vim.keymap.set("n", "|", "H", { desc = "First line of screen" })

-- zm/zt 滚动位置：zm 光标置于窗口上方 30%，zt 置于上方 5%（zz 已解绑）
local function scroll_cursor_to_percent(percent)
	local win = vim.api.nvim_get_current_win()
	if vim.v.count > 0 then -- 支持 [count]zm / [count]zt / [count]zb：先跳到指定行
		vim.api.nvim_win_set_cursor(win, { vim.v.count, 0 })
	end
	local height = vim.api.nvim_win_get_height(win)
	local target_row = math.max(1, math.floor(height * percent + 0.5))
	local cursor = vim.api.nvim_win_get_cursor(win)
	local view = vim.fn.winsaveview()
	view.topline = cursor[1] - target_row + 1 -- winrestview 会自动 clamp 到有效范围
	vim.fn.winrestview(view)
end

vim.keymap.set("n", "zm", function() scroll_cursor_to_percent(0.40) end, { desc = "Cursor at 40% from top" })
vim.keymap.set("n", "zt", function() scroll_cursor_to_percent(0.08) end, { desc = "Cursor at 8% from top" })
vim.keymap.set("n", "zb", function() scroll_cursor_to_percent(0.90) end, { desc = "Cursor at 90% from top" })
vim.keymap.set("n", "zz", "<Nop>") -- 解绑 zz（防误触居中）

-- 封装居中命令
local function center_cursor()
	vim.cmd("normal! zz")
end

-- 查找目标是否已在其他窗口中打开
local function find_existing_window(location)
	if not location or vim.tbl_isempty(location) then
		return nil
	end
	local loc = type(location[1]) == "table" and location[1] or location
	-- 兼容 Location（uri/range）和 LocationLink（targetUri/targetRange）两种格式
	local target_uri = loc.uri or loc.targetUri
	local target_range = loc.range or loc.targetRange
	if not target_range then
		return nil
	end
	local target_line = target_range.start.line + 1 -- 1-indexed

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if win ~= vim.api.nvim_get_current_win() then
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name = vim.api.nvim_buf_get_name(buf)
			if buf_name == vim.uri_to_fname(target_uri) then
				return win, target_line
			end
		end
	end
	return nil, nil
end

-- 获取 LSP 定义位置
local function get_definition_location()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP client", vim.log.levels.WARN)
		return nil
	end
	local params = vim.lsp.util.make_position_params()
	local result = clients[1].request_sync("textDocument/definition", params, 2000, 0)
	if not result or result.result == nil or vim.tbl_isempty(result.result) then
		return nil
	end
	return result.result
end

-- 跳转到定义 | 复用窗口版本
local function go_to_definition(reuse_window)
	local location = get_definition_location()
	if not location then
		vim.notify("Definition not found", vim.log.levels.INFO)
		return
	end

	local existing_win, target_line = find_existing_window(location)
	if existing_win and reuse_window then
		-- 目标已在其他窗口打开，直接跳转
		vim.api.nvim_set_current_win(existing_win)
		vim.api.nvim_win_set_cursor(existing_win, { target_line, 0 })
		center_cursor()
	else
		-- 在当前窗口跳转
		vim.lsp.util.jump_to_location(location[1] or location, "utf-16")
		center_cursor()
	end
end


-- split + go to definition（复用已有窗口或新建）
local function split_and_goto_definition(direction)
	local location = get_definition_location()
	if not location then
		vim.notify("Definition not found", vim.log.levels.INFO)
		return
	end

	local existing_win, target_line = find_existing_window(location)
	if existing_win then
		-- 目标已在其他窗口打开，直接跳转
		vim.api.nvim_set_current_win(existing_win)
		vim.api.nvim_win_set_cursor(existing_win, { target_line, 0 })
		center_cursor()
	else
		-- 新建 split 并跳转
		vim.cmd(direction == "below" and "belowright split" or "belowright vsplit")
		vim.lsp.util.jump_to_location(location[1] or location, "utf-16")
		center_cursor()
	end
end

vim.keymap.set("n", "gd", function() go_to_definition(true) end, { desc = "Go to definition" })
vim.keymap.set("n", "gs", function() split_and_goto_definition("below") end, { desc = "Split below + go to definition" })
vim.keymap.set("n", "gv", function() split_and_goto_definition("right") end, { desc = "VSplit right + go to definition" })

vim.keymap.set("n", "<C-s>", ":botright split<CR>", { desc = "Split at bottom" })
vim.keymap.set("n", "<C-v>", ":botright vsplit<CR>", { desc = "VSplit at right" })

vim.keymap.set("n", "<leader>r", function()
	vim.cmd("e")
	vim.notify("File reloaded", vim.log.levels.INFO)
end, { desc = "Reload file" })

vim.keymap.set("n", "<leader>R", function()
	local choice = vim.fn.confirm("Confirm to force reload file? This will discard unsaved changes.", "&Yes\n&No", 2)
	if choice == 1 then
		vim.cmd("e!")
		vim.notify("File force reloaded", vim.log.levels.INFO)
	end
end, { desc = "Force reload file" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Pane left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Pane down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Pane up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Pane right" })


-- ===================== 基础 autocmd =====================
-- 保存前创建父目录（格式化由 conform.nvim 负责）
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local dir = vim.fn.expand("%:p:h")
		if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
	pattern = "*",
})

-- 高亮闪烁被复制内容
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 500 })
	end,
})

-- 重新打开文件回到上次位置
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

-- language diagnose detail
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Code diagnostics" })

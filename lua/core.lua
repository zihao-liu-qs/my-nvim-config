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
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.shortmess:append("AWI")
vim.opt.autoread = true
vim.opt.conceallevel = 2
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("data") .. "/swap//"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"
vim.opt.clipboard = "unnamedplus"

-- 每个 pane 顶部显示相对路径（onedarkpro 蓝色）
vim.opt.winbar = "%#WinBarPath#%f"
vim.api.nvim_set_hl(0, "WinBarPath", { fg = "#61afef", bold = true })

-- 静默保存退出
-- vim.cmd("command! -bang WQ silent! w<bang> | q")

-- ===================== 基础快捷键 =====================
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "H", "^", { desc = "Line start" })
vim.keymap.set("n", "J", "25j", { desc = "Down 25 lines" })
vim.keymap.set("n", "K", "25k", { desc = "Up 25 lines" })
vim.keymap.set("n", "L", "$", { desc = "Line end" })


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
	local target_uri = loc.uri
	local target_range = loc.range
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

vim.keymap.set("n", "gd", function() go_to_definition(true) end, { desc = "Go to definition" } )
vim.keymap.set("n", "gs", function() split_and_goto_definition("below") end, { desc = "Split below + go to definition" })
vim.keymap.set("n", "gv", function() split_and_goto_definition("right") end, { desc = "VSplit right + go to definition" })

vim.keymap.set("n", "<C-s>", ":botright split<CR>", { desc = "Split at bottom" })
vim.keymap.set("n", "<C-v>", ":botright vsplit<CR>", { desc = "VSplit at right" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Pane left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Pane down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Pane up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Pane right" })


-- ===================== 基础 autocmd =====================
-- 保存前自动格式化 + 创建父目录
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format()
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

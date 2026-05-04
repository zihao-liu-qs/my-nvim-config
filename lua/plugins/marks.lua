-- marks.nvim — 可视化书签标记
vim.pack.add({
	{ src = "https://github.com/chentoast/marks.nvim" },
})
vim.cmd.packadd("marks.nvim")

require("marks").setup({
	excluded_filetypes = { "qf", "NvimTree", "TelescopePrompt", "toggleterm", "lazy" },
	default_mappings = false,
	-- 始终显示符号列
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	builtin_marks = {}, -- 禁用自动显示 ^<> 等内置标记
	-- 刷新间隔(ms)，越低越及时但越耗性能
	refresh_interval = 150,
	-- 循环跳转
	cyclic = true,
})

-- 确保书签高亮可见
vim.api.nvim_set_hl(0, "MarkSignHL", { fg = "#E5C07B", bold = true })
vim.api.nvim_set_hl(0, "MarkSignNumHL", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "MarkVirtTextHL", { fg = "#98C379", italic = true })

-- <leader>m 统一入口
-- m → 提示所有书签,按对应字符跳转
vim.keymap.set("n", "m", function()
	local all_marks = vim.fn.getmarklist(vim.api.nvim_get_current_buf())
	-- 过滤掉原生自动标记('"[])
	local marks = vim.tbl_filter(function(m)
		local c = m.mark:sub(2, 2)
		return c:match("[a-z]")
	end, all_marks)
	if #marks == 0 then
		vim.notify("没有书签", vim.log.levels.INFO)
		return
	end
	-- 构建提示文本
	local msg = "书签:\n"
	for _, mk in ipairs(marks) do
		local label = mk.mark:sub(2, 2)
		local line = mk.pos[2]
		local text = ""
		if vim.api.nvim_buf_is_valid(mk.pos[1]) then
			text = vim.api.nvim_buf_get_lines(mk.pos[1], line - 1, line, false)[1] or ""
		end
		msg = msg .. string.format("  %s  L%-4d  %s\n", label, line, text)
	end
	msg = msg .. "按字符跳转, ESC 取消: "
	-- 显示在命令行
	vim.cmd("redraw")
	vim.api.nvim_echo({ { msg, "None" } }, false, {})
	-- 等待下一个按键
	local char = vim.fn.getchar()
	if char == 27 then -- ESC 取消
		vim.cmd("redraw")
		return
	end
	local c = string.char(char)
	-- 查找对应书签
	for _, mk in ipairs(marks) do
		if mk.mark:sub(2, 2) == c then
			vim.api.nvim_win_set_cursor(0, { mk.pos[2], mk.pos[3] })
			vim.cmd("normal! zz")
			vim.cmd("redraw")
			return
		end
	end
	vim.cmd("redraw")
	vim.notify("没有书签 '" .. c .. "'", vim.log.levels.INFO)
end, { desc = "列出书签,按字符跳转" })

-- <leader>ma + a-z 设置对应字母书签
for _, c in ipairs(vim.split("abcdefghijklmnopqrstuvwxyz", "")) do
	vim.keymap.set("n", "<leader>ma" .. c, function()
		vim.cmd("normal! m" .. c)
	end, { desc = "设置书签 " .. c })
end

-- 禁用原生 ' + char 跳转
for _, c in ipairs(vim.split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", "")) do
	vim.keymap.set("n", "'" .. c, function()
		vim.notify("用 m + " .. c .. " 跳转书签", vim.log.levels.INFO)
	end, { desc = "禁用原生跳转" })
end

vim.keymap.set("n", "M", function()
	local all_marks = vim.fn.getmarklist() -- 全局书签
	-- 过滤掉原生自动标记和数字标记
	local marks = vim.tbl_filter(function(m)
		local c = m.mark:sub(2, 2)
		return c:match("[a-zA-Z]")
	end, all_marks)
	if #marks == 0 then
		vim.notify("没有书签", vim.log.levels.INFO)
		return
	end
	local msg = "全局书签:\n"
	for _, mk in ipairs(marks) do
		local label = mk.mark:sub(2, 2)
		local file = mk.file or vim.api.nvim_buf_get_name(mk.pos[1])
		-- 提取文件名(相对路径)
		local short_file = vim.fn.fnamemodify(file, ":~:.")
		local line = mk.pos[2]
		msg = msg .. string.format("  %s  %s:%-4d\n", label, short_file, line)
	end
	msg = msg .. "按字符跳转, ESC 取消: "
	vim.cmd("redraw")
	vim.api.nvim_echo({ { msg, "None" } }, false, {})
	local char = vim.fn.getchar()
	if char == 27 then
		vim.cmd("redraw")
		return
	end
	local c = string.char(char)
	for _, mk in ipairs(marks) do
		if mk.mark:sub(2, 2) == c then
			if mk.file then
				vim.cmd("edit " .. vim.fn.fnameescape(mk.file))
			end
			vim.api.nvim_win_set_cursor(0, { mk.pos[2], mk.pos[3] })
			vim.cmd("normal! zz")
			vim.cmd("redraw")
			return
		end
	end
	vim.cmd("redraw")
	vim.notify("没有书签 '" .. c .. "'", vim.log.levels.INFO)
end, { desc = "列出全局书签,按字符跳转" })

vim.keymap.set("n", "<leader>md", function() require("marks").delete_line() end, { desc = "删除当前行书签" })
vim.keymap.set("n", "<leader>ml", function() vim.cmd("MarksListBuf") end, { desc = "当前文件书签" })
vim.keymap.set("n", "<leader>mL", function() vim.cmd("MarksListAll") end, { desc = "所有文件书签" })
vim.keymap.set("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "搜索书签" })

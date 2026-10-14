-- vscode-neovim 专用最小配置（仅 VSCode 扩展加载此文件）
-- 注意：不要在这里加载任何插件。LSP、补全、语法高亮、状态栏等功能
-- 在 VSCode 中由 VSCode 自己提供，加载 Neovim 插件会导致冲突或卡顿。

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 常用：把 VSCode 命令绑定到按键（需要时取消注释）
-- local vscode = require("vscode")
-- vim.keymap.set("n", "<leader>f", function()
--   vscode.action("editor.action.formatDocument")
-- end)

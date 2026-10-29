-- nvim-lspconfig
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
}, {
	load = function()
		vim.cmd.packadd("nvim-lspconfig")

		-- vtsls 替代 ts_ls：配 @vue/typescript-plugin 支持 .vue SFC
		-- vue_ls 是混合模式，只处理 template/CSS，TS 请求转发给同 buffer 的 vtsls
		local vue_language_server_path = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
		vim.lsp.config("vtsls", {
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_language_server_path,
								languages = { "vue" },
								configNamespace = "typescript",
							},
						},
					},
				},
			},
		})

		vim.lsp.enable({
			"pyright",
			"gopls",
			"html",
			"cssls",
			"emmet_language_server",
			"vtsls",
			"vue_ls",
			"clangd",
			"lua_ls",
			"jsonls",
			"bashls",
			"marksman",
			"dockerls",
			"yamlls",
		})
	end,
})

-- LSP 诊断配置：行末显示错误/警告文字
vim.diagnostic.config({
	virtual_text = true,     -- 行末显示诊断文字
	signs = false,           -- 不显示左侧 gutter 图标（保持简洁）
	underline = true,        -- 保留波浪线/下划线
	update_in_insert = false, -- 插入模式不更新诊断（避免打字时闪烁）
})

-- LSP 快捷键
-- 移除 Neovim 0.12 内置 LSP 默认键位（只保留下面自己定义的 gr = references）
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("x", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "grx")

-- gd/gs/gv 已在 core.lua 中定义（带窗口复用逻辑）
vim.keymap.set("n", "gk", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Incoming calls" })
vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Outgoing calls" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })

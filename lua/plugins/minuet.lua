vim.pack.add({
	{ src = "https://github.com/milanglacier/minuet-ai.nvim" },
}, {
	load = function()
		vim.cmd.packadd("minuet-ai.nvim")

		require("minuet").setup({
			provider = "openai_fim_compatible",
			provider_options = {
				openai_fim_compatible = {
					model = "deepseek-v4-flash",
					end_point = "https://api.deepseek.com/beta/completions",
					api_key = "DEEPSEEK_API_KEY_FOR_NVIM_MINUET_AI", -- 环境变量名，不是 key 本身
					name = "Deepseek",
					stream = true,
					optional = {
						max_tokens = 256,
						top_p = 0.9,
						stop = { "\n\n" },
					},
				},
			},

			throttle = 1000, -- ms，请求节流
			debounce = 150, -- ms，输入防抖

			-- 幽灵文本：默认不自动触发，按 <A-y> 手动显示
			virtualtext = {
				auto_trigger_ft = {},
				keymap = {
					accept_line = "<C-j>", -- 接受一行
					next = "<C-h>",   -- 无建议时手动触发 / 有建议时切换下一条
				},
			},
		})
	end,
})

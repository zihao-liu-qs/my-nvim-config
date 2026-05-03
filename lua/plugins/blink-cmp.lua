-- blink.cmp（自动补全 + 括号补全）
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
							return cmp.select_and_accept({ force = true })
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
			snippets = {
				expand = function(snippet)
					vim.snippet.expand(snippet)
				end,
			},
			-- 括号自动补全
			auto_brackets = {
				enabled = true,
			},
		})
	end,
})

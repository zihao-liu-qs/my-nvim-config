vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp" },
}, {
	load = function()
		vim.cmd.packadd("blink.cmp")

		require("blink.cmp").setup({
			sources = {
				default = { "lsp", "path", "buffer" },
			},

			completion = {
				menu = {
					auto_show = true,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 50,
				},
			},

			keymap = {
				preset = "default",
				-- tab 确认补全
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

			signature = {
				enabled = true,
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			snippets = {
				expand = function(snippet)
					vim.snippet.expand(snippet)
				end,
			},
		})
	end,
})

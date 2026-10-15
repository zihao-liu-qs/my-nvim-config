vim.pack.add({
	{
		src = 'https://github.com/ThorstenRhau/token',
		version = vim.version.range('*'),
	},
})

vim.o.background = "light"
vim.cmd.colorscheme("token-ultra")

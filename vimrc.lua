require("ibl").setup()
--vim.treesitter.stop()
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'lua' },
	callback = function() vim.treesitter.stop() end,
})

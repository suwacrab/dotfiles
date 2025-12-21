-- require("ibl").setup()
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'lua' },
	callback = function() vim.treesitter.stop() end,
})

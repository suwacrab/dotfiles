-- require("ibl").setup()
require('lualine').setup({
	options = {
		icons_enabled = false;
		section_separators = { left = '', right = '' };
		component_separators = { left = '◢', right = '◤' };
	}
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'lua' },
	callback = function() vim.treesitter.stop() end,
})


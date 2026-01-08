-- lualine ------------------------------------------------------------------@/
local lualine_ext = {
	sections = {
		lualine_a = { function()
			return vim.fn['tagbar#currenttag']("%s",'<none>')
		end }
	};
	filetypes = { 'tagbar' };
}

require('nvim-tree').setup()
require('nvim-web-devicons').setup()
require('lualine').setup({
	options = {
		icons_enabled = true;
		section_separators = { left = ''; right = '' };
		component_separators = { left = '◢'; right = '◤' };
	};
	sections = {
		lualine_a = {'mode'};
		lualine_b = {'branch'; 'diff'; 'diagnostics'; 'tagbar'};
		lualine_c = {'filename'};
		lualine_x = {'encoding'; 'fileformat'; 'filetype'};
		lualine_y = {'progress'};
		lualine_z = { 
			{ '%3l:%-2.(%c[%v]%)', type = 'stl' };
		};
	};
	extensions = { lualine_ext };
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'lua' },
	callback = function() vim.treesitter.stop() end,
})


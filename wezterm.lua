local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 180
config.initial_rows = 40

-- or, changing the font size and color scheme.
config.font = wezterm.font('tewi')
config.font_size = 8
config.set_environment_variables = {
	COLORTERM="truecolor";
}

-- Finally, return the configuration to wezterm:
return config

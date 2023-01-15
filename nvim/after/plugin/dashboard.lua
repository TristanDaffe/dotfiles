local db = require "dashboard"
db.custom_header = {
	"",
	"",
	"",
	"",
	" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
	"",
	"",
	"",
}
db.custom_center = {
	{
		icon = " ",
		desc = "New File            ",
		action = "DashboardNewFile",
		shortcut = "SPC o",
	},
	{
		icon = " ",
		desc = "Browse Files        ",
		action = "NvimTreeToggle",
		shortcut = "SPC n",
	},
	{
		icon = " ",
		desc = "Find File           ",
		action = "Telescope find_files",
		shortcut = "SPC f",
	},
	{
		icon = " ",
		desc = "Configure Neovim    ",
		action = "edit ~/.config/nvim/init.lua",
		shortcut = "SPC v",
	},
	{
		icon = " ",
		desc = "Exit Neovim              ",
		action = "quit",
	},
}


-----------------------------------------------------------------------------------------------------------------------
--                                                  Ruby theme                                                       --
-----------------------------------------------------------------------------------------------------------------------
local awful = require("awful")

-- This theme was inherited from another with overwriting some values
-- Check parent theme to find full settings list and its description
local theme = require("themes/colored/theme")


-- Color scheme
-----------------------------------------------------------------------------------------------------------------------
theme.color.main   = "#A30817"
theme.color.urgent = "#016B84"
theme.color.desktop_gray = "#707070"

-- Common
-----------------------------------------------------------------------------------------------------------------------
theme.path = awful.util.get_configuration_dir() .. "themes/scarlet"

-- Main config
--------------------------------------------------------------------------------
theme.panel_height = 38 -- panel height
theme.wallpaper    = theme.path .. "/wallpaper/custom.png"
theme.desktopbg    = theme.path .. "/wallpaper/transparent.png"
theme.border_width = 0
theme.useless_gap  = 0
theme.useless_gap_mod = 5
-- Setup parent theme settings
--------------------------------------------------------------------------------
theme:update()


-- Desktop config
-----------------------------------------------------------------------------------------------------------------------

-- Desktop widgets placement
--------------------------------------------------------------------------------
theme.desktop.grid = {
	width  = { 440 },
	height = { 100, 100, 100, 100, 100, 100, 50 },
	edge   = { width = { 50 }, height = { 150, 50, 50, 50, 50, 50 } }
}

theme.desktop.places = {
	cpumem   = { 1, 1 },
	thermal  = { 1, 2 },
	fan      = { 1, 3 },
	transm   = { 1, 4 },
	netspeed = { 1, 5 },
	ssdspeed = { 1, 6 },
	disks    = { 1, 7 },
}


-- Desktop widgets
--------------------------------------------------------------------------------
-- individual widget settings doesn't used by redflat module
-- but grab directly from rc-files to rewrite base style
theme.individual.desktop = { speedmeter = {}, multimeter = {}, multiline = {} }

-- Lines (common part)
theme.desktop.common.pack.lines.line.height = 5
theme.desktop.common.pack.lines.progressbar.chunk = { gap = 6, width = 16 }
theme.desktop.common.pack.lines.tooltip.set_position = function(wibox)
	awful.placement.under_mouse(wibox)
	wibox.y = wibox.y - 30
end

-- Upright bar (common part)
theme.desktop.common.bar.shaped.show.tooltip = true
theme.desktop.common.bar.shaped.tooltip.set_position = theme.desktop.common.pack.lines.tooltip.set_position

-- Speedmeter (base widget)
theme.desktop.speedmeter.compact.icon = {
	up = theme.path .. "/desktop/up.svg",
	down = theme.path .. "/desktop/down.svg",
	margin = { 0, 4, 0, 0}
}
theme.desktop.speedmeter.compact.height.chart = 46
theme.desktop.speedmeter.compact.label.width = 76
theme.desktop.speedmeter.compact.label.height = 15 -- manually set after font size
theme.desktop.speedmeter.compact.label.font = { font = "Play", size = 22, face = 1, slant = 0 }
theme.desktop.speedmeter.compact.margins.label = { 10, 10, 0, 0 }
theme.desktop.speedmeter.compact.margins.chart = { 0, 0, 3, 3 }
theme.desktop.speedmeter.compact.chart = { bar = { width = 6, gap = 3 }, height = nil, zero_height = 0 }
theme.desktop.speedmeter.compact.progressbar = { chunk = { width = 6, gap = 3 }, height = 3 }

-- Speedmeter drive (individual widget)
theme.individual.desktop.speedmeter.drive = {
	unit   = { { "B", -1 }, { "KB", 2 }, { "MB", 2048 } },
}

-- Multimeter (base widget)
theme.desktop.multimeter.upbar          = { width = 32, chunk = { num = 8, line = 4 }, shape = "plain" }
theme.desktop.multimeter.lines.show     = { label = false, tooltip = true, text = false }
theme.desktop.multimeter.icon.full      = true
theme.desktop.multimeter.icon.margin    = { 0, 8, 0, 0 }
theme.desktop.multimeter.height.upright = 66
theme.desktop.multimeter.height.lines   = 20

-- Multimeter cpu and ram (individual widget)
theme.individual.desktop.multimeter.cpumem = {
	labels = { "RAM", "SWAP" },
	icon  = { image = theme.path .. "/desktop/cpu.svg" }
}

-- Multimeter transmission info (individual widget)
theme.individual.desktop.multimeter.transmission = {
	labels = { "SEED", "DNLD" },
	unit   = { { "KB", -1 }, { "MB", 1024^1 } },
	upbar  = { width = 20, chunk = { num = 8, line = 4 }, shape = "plain" },
	icon   = { image = theme.path .. "/desktop/transmission.svg" }
}

-- Multilines (base widget)
theme.desktop.multiline.lines.show     = { label = false, tooltip = true, text = false }
theme.desktop.multiline.icon.margin    = theme.desktop.multimeter.icon.margin
theme.desktop.multiline.icon.full      = true

-- Multilines storage (individual widget)
theme.individual.desktop.multiline.storage = {
	unit      = { { "KB", 1 }, { "MB", 1024^1 }, { "GB", 1024^2 }, { "TB", 1024^3 } },
	icon      = { image = theme.path .. "/desktop/storage.svg" },
	lines     = {
		line        = { height = 25 },
		progressbar = { chunk = { gap = 6, width = 4 } },
	},
}

-- Multilines qemu drive images (individual widget)
theme.individual.desktop.multiline.images = {
	unit = { { "KB", 1 }, { "MB", 1024^1 }, { "GB", 1024^2 } },
}

-- Multilines temperature (individual widget)
theme.individual.desktop.multiline.thermal = {
	digits    = 1,
	icon      = { image = theme.path .. "/desktop/thermometer.svg", margin = { 0, 8, 0, 0 } },
	lines     = {
		line        = { height = 13 },
		text        = { font = { font = "Play", size = 18, face = 1, slant = 0 }, width = 44 },
		label       = { font = { font = "Play", size = 18, face = 1, slant = 0 } },
		gap         = { text = 10 },
		progressbar = { chunk = { gap = 6, width = 4 } },
		show        = { text = true, label = false, tooltip = true },
	},
	unit      = { { "°C", -1 } },
}

-- Multilines fan (individual widget)
theme.individual.desktop.multiline.fan = {
		digits    = 1,
		margin    = { 0, 0, 5, 5 },
		icon      = { image = theme.path .. "/desktop/fan.svg", margin = { 8, 16, 0, 0 } },
		lines     = {
			line        = { height = 13 },
			progressbar = { chunk = { gap = 6, width = 4 } },
			show        = { text = false, label = false, tooltip = true },
		},
		unit      = { { "RPM", -1 }, { "R", 1 } },
}

-- Panel widgets
-----------------------------------------------------------------------------------------------------------------------

-- individual margins for panel widgets
------------------------------------------------------------
theme.widget.wrapper = {
	layoutbox   = { 10, 10, 6, 6 },
	textclock   = { 10, 10, 0, 0 },
	volume      = { 4, 9, 3, 3 },
	keyboard    = { 9, 9, 3, 3 },
	tray        = { 8, 8, 7, 7 },
	cpu         = { 2, 2, 7, 7 },
	ram         = { 2, 2, 7, 7 },
	network     = { 4, 4, 7, 7 },
	taglist     = { 4, 4, 5, 4 },
	pomodoro    = { 4, 4, 7, 7 },
	tasklist    = { 10, 0, 0, 0 }, -- centering tasklist widget
}

-- Various widgets style tuning
------------------------------------------------------------
theme.widget.minitray.set_position = false

-- Audio
theme.gauge.audio.blue.dash.plain = true
theme.gauge.audio.blue.dash.bar.num = 8
theme.gauge.audio.blue.dash.bar.width = 3
theme.gauge.audio.blue.dmargin = { 5, 0, 9, 9 }
theme.gauge.audio.blue.width = 86
theme.gauge.audio.blue.icon = theme.path .. "/widget/audio.svg"

-- Tasklist
theme.widget.tasklist.char_digit = 5
theme.widget.tasklist.task = theme.gauge.task.ruby
theme.widget.tasklist.tasktip.max_width = 1200

-- KB layout indicator
theme.widget.keyboard.icon = theme.path .. "/widget/keyboard.svg"

-- Floating widgets
-----------------------------------------------------------------------------------------------------------------------

-- Calendar width
theme.float.calendar.geometry.width = 400

-- Titlebar helper
theme.float.bartip.names = { "Mini", "Compact", "Full" }

-- client menu tag line
theme.widget.tasklist.winmenu.enable_tagline = false
theme.widget.tasklist.winmenu.icon.tag = theme.path .. "/widget/mark.svg"

theme.float.clientmenu.enable_tagline = false
theme.float.clientmenu.icon.tag = theme.widget.tasklist.winmenu.icon.tag


-- Set hotkey helper size according current fonts and keys scheme
--------------------------------------------------------------------------------
theme.float.hotkeys.geometry   = { width = 1420 }
theme.float.appswitcher.keytip = { geometry = { width = 400 }, exit = true }
theme.float.keychain.keytip    = { geometry = { width = 1020 }, column = 2 }
theme.float.top.keytip         = { geometry = { width = 400 } }
theme.float.apprunner.keytip   = { geometry = { width = 400 } }
theme.widget.updates.keytip    = { geometry = { width = 400 } }
theme.menu.keytip              = { geometry = { width = 400 } }

-- Titlebar
-----------------------------------------------------------------------------------------------------------------------
theme.titlebar.icon_compact = {
	color        = { icon = theme.color.gray, main = theme.color.main, urgent = theme.color.main },
	list         = {
		maximized = theme.path .. "/titlebar/maximized.svg",
		minimized = theme.path .. "/titlebar/minimize.svg",
		close     = theme.path .. "/titlebar/close.svg",
		focus     = theme.path .. "/titlebar/focus.svg",
		unknown   = theme.icon.unknown,
	}
}

-- End
-----------------------------------------------------------------------------------------------------------------------
return theme

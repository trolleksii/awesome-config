-----------------------------------------------------------------------------------------------------------------------
--                                                  Menu config                                                      --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
local redflat = require("redflat")
local awful = require("awful")


-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local menu = {}


-- Build function
-----------------------------------------------------------------------------------------------------------------------
function menu:init(args)

	-- vars
	args = args or {}
	local env = args.env or {} -- fix this?
	local separator = args.separator or { widget = redflat.gauge.separator.horizontal() }
	local theme = args.theme or { auto_hotkey = true }
	local icon_style = args.icon_style or { custom_only = false, scalable_only = false, theme = '/usr/share/icons/Numix' }

	-- theme vars
	local default_icon = redflat.util.base.placeholder()
	local icon = redflat.util.table.check(beautiful, "icon.awesome") and beautiful.icon.awesome or default_icon
	local color = redflat.util.table.check(beautiful, "color.icon") and beautiful.color.icon or nil

	-- icon finder
	local function micon(name)
		return redflat.service.dfparser.lookup_icon(name, icon_style)
	end

	-- extra commands
	local ranger_comm = env.terminal .. " -e ranger"

	-- Application submenu
	------------------------------------------------------------
	local appmenu = redflat.service.dfparser.menu({ icons = icon_style, wm_name = "awesome" })

	-- Awesome submenu
	------------------------------------------------------------
	local awesomemenu = {
		{ "Restart",         awesome.restart,                 micon("system-reboot") },
		separator,
		{ "Awesome config",  env.fm .. " .config/awesome",        micon("folder") },
		{ "Awesome lib",     env.fm .. " /usr/share/awesome/lib", micon("folder") }
	}

	-- Places submenu
	------------------------------------------------------------
	local placesmenu = {
		{ "Home",       env.fm,                     micon("user-home") },
		{ "Downloads",  env.fm .. " Downloads",     micon("folder-download") },
		separator,
		{ "Music",      env.fm .. " /mnt/Music",    micon("orange-folder-music") },
		{ "Torrents",   env.fm .. " /mnt/Torrents", micon("orange-folder-hdd") },
	}

	-- Places submenu
	------------------------------------------------------------
	local mediamenu = {
		{ "OBS", "obs", micon("com.obsproject.Studio"), key = "o" },
		{ "Shotcut", "shotcut", "/opt/Shotcut.app/share/icons/hicolor/128x128/apps/org.shotcut.Shotcut.png", key = "s" },
		{ "Player", string.lower(env.player), micon("deadbeef"), key = "p" },
	}

	-- Exit submenu
	------------------------------------------------------------
	local exitmenu = {
		{ "Reboot",          "reboot",                    micon("system-reboot") },
		{ "Shutdown",        "shutdown now",              micon("gnome-shutdown") },
		separator,
		--{ "Switch user",     "dm-tool switch-to-greeter", micon("gnome-session-switch") },
		--{ "Suspend",         "systemctl suspend" ,        micon("gnome-session-suspend") },
		{ "Log out",         awesome.quit,                micon("gnome-session-logout") },
	}

	-- Main menu
	------------------------------------------------------------
	self.mainmenu = redflat.menu({ theme = theme,
		items = {
			{ "Awesome",		awesomemenu, micon("awesome") },
			{ "Applications",	appmenu,     micon("archlinux-logo") },
			{ "Places",			placesmenu,  micon("folder"), key = "c" },
			{ "Media",			mediamenu,   "/usr/share/icons/ePapirus/24x24/categories/acestream.svg", key = "m" },
			separator,
			{ "Terminal",		env.terminal, micon("Alacritty") },
			{ "VS Code",		"code",       micon("visual-studio-code") },
			{ "Discord",		"/opt/Discord/Discord", "/opt/Discord/discord.png" },
			{ "Chrome",			"google-chrome-stable",  micon("google-chrome") },
			{ "Firefox",		env.browser,  micon("firefox") },
			{ "Ranger",			ranger_comm,  micon("utilities-terminal"), key = "r" },
			separator,
			{ "Exit",         exitmenu,     micon("gnome-shutdown") },
		}
	})

	-- Menu panel widget
	------------------------------------------------------------

	self.widget = redflat.gauge.svgbox(icon, nil, color)
	self.buttons = awful.util.table.join(
		awful.button({ }, 1, function () self.mainmenu:toggle() end)
	)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return menu

-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")
local beautiful = require("beautiful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

rules.base_properties = {
	border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	focus        = awful.client.focus.filter,
	raise        = true,
	size_hints_honor = false,
	screen       = awful.screen.preferred,
	placement    = awful.placement.no_overlap + awful.placement.no_offscreen
}

rules.floating_any = {
	instance = { "DTA", "copyq", },
	class = {
		"Arandr", "Gpick", "Kruler", "MessageWin", "Sxiv", "Wpa_gui", "pinentry", "veromix",
		"xtightvncviewer", "Nemo", "Galculator", "Klavaro"
	},
	name = { "Event Tester", },
	role = { "AlarmWindow", "pop-up", }
}


-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:init(args)

	args = args or {}
	self.base_properties.keys = args.hotkeys.keys.client
	self.base_properties.buttons = args.hotkeys.mouse.client


	-- Build rules
	--------------------------------------------------------------------------------
	self.rules = {
		{
			rule       = {},
			properties = args.base_properties or self.base_properties
		},
		{
			rule_any   = args.floating_any or self.floating_any,
			properties = { floating = true }
		},
		{
			rule_any   = { type = { "normal", "dialog" }},
			properties = { titlebars_enabled = true }
		},
		{
			rule_any = { class = { "firefox", "google-chrome", "Google-chrome"}},
			roperties = { tag = "Web", switchtotag = true }
		},
		{
			rule_any = { class = { "vlc", "gpicview", "obs", "Shotcut" }},
			properties = { tag = "Media", switchtotag = true }
		},
		{
			rule = { class = "Deadbeef" },
			properties = { tag = "Media", switchtotag = false, floating = true }
		},
		{
			rule = { class = "Code" },
			properties = { tag = "Dev", switchtotag = true }
		},
	}


	-- Set rules
	--------------------------------------------------------------------------------
	awful.rules.rules = rules.rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules

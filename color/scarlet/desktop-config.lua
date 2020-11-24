-----------------------------------------------------------------------------------------------------------------------
--                                               Desktop widgets config                                              --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
--local awful = require("awful")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local desktop = {}

-- desktop aliases
local wgeometry = redflat.util.desktop.wgeometry
local workarea = screen[mouse.screen].workarea
local system = redflat.system

local wa = mouse.screen.workarea

-- Desktop widgets
-----------------------------------------------------------------------------------------------------------------------
function desktop:init(args)
	if not beautiful.desktop then return end

	args = args or {}
	local env = args.env or {}
	local autohide = env.desktop_autohide or false

	-- placement
	local grid = beautiful.desktop.grid
	local places = beautiful.desktop.places

	-- Network speed
	--------------------------------------------------------------------------------
	local netspeed = { geometry = wgeometry(grid, places.netspeed, workarea) }

	netspeed.args = {
		meter_function = system.net_speed,
		interface      = "wlp4s0",
		maxspeed       = { up = 45*1024^2, down = 45*1024^2 },
		crit           = { up = 35*1024^2, down = 35*1024^2 },
		timeout        = 2,
		autoscale      = false,
		label          = "NET"
	}

	netspeed.style  = {}

	-- SSD speed
	--------------------------------------------------------------------------------
	local ssdspeed = { geometry = wgeometry(grid, places.ssdspeed, workarea) }

	ssdspeed.args = {
		interface      = "nvme0n1",
		meter_function = system.disk_speed,
		timeout        = 2,
		label          = "SOLID DRIVE"
	}

	ssdspeed.style = beautiful.individual.desktop.speedmeter.drive

	-- CPU and memory usage
	--------------------------------------------------------------------------------
	local cpu_storage = { cpu_total = {}, cpu_active = {} }
	local cpumem = { geometry = wgeometry(grid, places.cpumem, workarea) }

	cpumem.args = {
		topbars = { num = 8, maxm = 100, crit = 90 },
		lines   = { { maxm = 100, crit = 80 }, { maxm = 100, crit = 80 } },
		meter   = { args = cpu_storage, func = system.dformatted.cpumem },
		timeout = 5
	}

	cpumem.style = beautiful.individual.desktop.multimeter.cpumem

	-- Disks
	--------------------------------------------------------------------------------
	local disks = { geometry = wgeometry(grid, places.disks, workarea) }
	local disks_original_height = disks.geometry.height
	disks.geometry.height = beautiful.desktop.multimeter.height.upright

	disks.args = {
		sensors  = {
			{ meter_function = system.fs_info, maxm = 100, crit = 80, name = "root", args = "/"    },
			{ meter_function = system.fs_info, maxm = 100, crit = 80, name = "nas", args  = "/mnt" },
		},
		timeout = 300
	}

	disks.style = beautiful.individual.desktop.multiline.storage

	-- Sensors parser setup
	--------------------------------------------------------------------------------
	local sensors_base_timeout = 10

	system.lmsensors.delay = 2
	system.lmsensors.patterns = {
		cpu  = { match = "k10temp%-pci%-00c3\r?\nAdapter:%sPCI%sadapter\r?\nTdie:%s+%+(%d+)%.%d°[CF]" },
		wifi = { match = "iwlwifi_1%-virtual%-0\r?\nAdapter:%sVirtual%sdevice\r?\ntemp1:%s+%+(%d+)%.%d°[CF]" },
		fan1 = { match = "fan1:%s+(%d+)%sRPM" },
		fan2 = { match = "fan2:%s+(%d+)%sRPM" },
    fan3 = { match = "fan5:%s+(%d+)%sRPM" }
	}

	-- start auto async lmsensors check
	system.lmsensors:soft_start(sensors_base_timeout)


	local ssd_smart_check = system.simple_async("sudo smartctl --attributes /dev/nvme0n1", "Temperature:%s+(%d+)%sCelsius")
	local gpu_temp_check = system.simple_async("nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", "(%d+)")

	-- Temperature indicator for chips
	--------------------------------------------------------------------------------
	local thermal_chips = { geometry = wgeometry(grid, places.thermal, workarea) }

	thermal_chips.args = {
		sensors = {
			{ meter_function = system.lmsensors.get, args = "cpu",  maxm = 100, crit = 75, name = "cpu"  },
			{ meter_function = system.lmsensors.get, args = "wifi", maxm = 100, crit = 75, name = "wifi" },
      { async_function = ssd_smart_check, maxm = 80, crit = 70, name = "ssd" },
			{ async_function = gpu_temp_check, maxm = 105, crit = 80, name = "gpu" }
		},
		timeout = sensors_base_timeout,
	}

	thermal_chips.style = beautiful.individual.desktop.multiline.thermal

	local gpu_fan_check = system.simple_async("nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits", "(%d+)")

  -- Fans
	--------------------------------------------------------------------------------
	local fan = { geometry = wgeometry(grid, places.fan, workarea) }
	fan.args = {
		sensors = {
			{ meter_function = system.lmsensors.get, args = "fan1", maxm = 5000, crit = 4000, name = "fan1" },
			{ meter_function = system.lmsensors.get, args = "fan2", maxm = 5000, crit = 4000, name = "fan2" },
      { meter_function = system.lmsensors.get, args = "fan3", maxm = 5000, crit = 4000, name = "fan3" },
      { async_function = gpu_fan_check, maxm = 100, crit = 90, name = "gpu" }
		},
		timeout = sensors_base_timeout,
	}
	fan.style = beautiful.individual.desktop.multiline.fan

	-- Calendar
	--------------------------------------------------------------------------------
	local cwidth = 100 -- calendar widget width
	local cy = 50      -- calendar widget upper margin
	local cheight = wa.height - cy

	local calendar = {
		args     = { timeout = 60 },
		geometry = { x = wa.width - cwidth, y = cy, width = cwidth, height = cheight }
	}


	-- Initialize all desktop widgets
	--------------------------------------------------------------------------------
	netspeed.body = redflat.desktop.speedmeter.compact(netspeed.args, netspeed.style)
	ssdspeed.body = redflat.desktop.speedmeter.compact(ssdspeed.args, ssdspeed.style)
	cpumem.body   = redflat.desktop.multimeter(cpumem.args, cpumem.style)
	disks.body    = redflat.desktop.multiline(disks.args, disks.style)
	thermal_chips.body = redflat.desktop.multiline(thermal_chips.args, thermal_chips.style)
	fan.body      = redflat.desktop.multiline(fan.args, fan.style)
	calendar.body = redflat.desktop.calendar(calendar.args, calendar.style)

	-- Desktop setup
	--------------------------------------------------------------------------------
	local desktop_objects = {
		calendar, netspeed, ssdspeed, cpumem,
		disks, fan, thermal_chips
	}

	if not autohide then
		redflat.util.desktop.build.static(desktop_objects)
	else
		redflat.util.desktop.build.dynamic(desktop_objects, nil, beautiful.desktopbg, args.buttons)
	end

	calendar.body:activate_wibox(calendar.wibox)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return desktop

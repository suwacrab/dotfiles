print('searching...')
local lsocket; do
	local _,err = pcall(function()
		lsocket = require('socket')
	end)
	if not lsocket then
		print(('lib fail (%s)'):format(err))
		error("couldn't find library");
	end
end
print('lib found')

-- short fns ----------------------------------------------------------------@/
local function popen_read(cmd)
	local handle = assert(io.popen(cmd,"r"))
	local res = assert(handle:read('*a'))
	handle:close()
	return res
end
local function popen_readFixed(cmd)
	return popen_read(cmd):sub(1,-2)
end
local function popen_readRGB(cmd)
	return popen_read(cmd):sub(1,7)
end

local function printf(str,...)
	print(str:format(...))
end
local function execa(...)
	local cmdstr = table.concat({...}," ")
	os.execute(cmdstr)
end
local function execf(str,...)
	execa(str:format(...))
end

-- workarea -----------------------------------------------------------------@/
local MONITOR_X,MONITOR_Y,MONITOR_SIZEX,MONITOR_SIZEY = popen_read(
	"herbstclient monitor_rect 0"
):match("(%w+) (%w+) (%w+) (%w+)")

MONITOR_X = tonumber(MONITOR_X)
MONITOR_Y = tonumber(MONITOR_Y)
MONITOR_SIZEX = tonumber(MONITOR_SIZEX)
MONITOR_SIZEY = tonumber(MONITOR_SIZEY)

local BAR_WIDTH = MONITOR_SIZEX - 16
local BAR_HEIGHT = 18
local BAR_X = (MONITOR_SIZEX-BAR_WIDTH) / 2
local BAR_Y = 8
local MONITOR_ID = 0

local PALETTE_BASE = {
	fg = "#FFFFFF";
	fgSel = popen_readRGB("herbstclient get window_border_inner_color");
	fgLight = "#808080";
	bg = popen_readRGB("herbstclient get frame_border_normal_color");
}
local PALETTE_DARK = {
	fg = PALETTE_BASE.fg;
	fgSel = PALETTE_BASE.fgSel;
	fgLight = PALETTE_BASE.fgLight;
	bg = PALETTE_BASE.bg;
}
local PALETTE_LITE = {
	fg = PALETTE_BASE.bg;
	fgSel = PALETTE_BASE.fgSel;
	fgLight = "#c0c0c0";
	bg = PALETTE_BASE.fg;
}

local PALETTE = PALETTE_DARK
--PALETTE = PALETTE_LITE

local mem_max = tonumber(popen_readFixed('free -m | awk \'/Mem:/ { printf("%3.1f%%", $2) }\''))

local cmd_lemonbar = table.concat({
	'lemonbar -d';
	('-F "%s"'):format(PALETTE.fg);
	('-B "%s"'):format(PALETTE.bg);
--	('-f "terminus:size=8"');
	('-f "tewi:size=8"');
	('-f "k8x12:size=8"');
	('-f "Noto Color Emoji:size=10"');
	('-f "Noto Sans CJK JP:size=8"');
	('-f "JoyPixels:size"');
	('-g %dx%d+%d+%d'):format(BAR_WIDTH,BAR_HEIGHT+8,BAR_X,BAR_Y);
},' ')

execf("herbstclient pad %s %d",MONITOR_ID,
	BAR_Y + BAR_HEIGHT + 8
)

execa('pkill lemonbar')

-- setup background ---------------------------------------------------------@/
do
	local bg_table = {
	--	"/home/suwa/km/art/other/usa_senzoc_01.png";
		"/home/suwa/km/art/other/usa_konchaboy_02.png";
		"/home/suwa/km/art/other/wall00.png";
		"/home/suwa/km/art/other/chun_lanlan_moriyas.jpg";
	}
	math.randomseed(os.time())
	local bg = bg_table[math.random(1,#bg_table)]
	execf('feh --bg-scale %s',bg)
end

-- write to bar
local hnd_lemon = io.popen(cmd_lemonbar,"w")
local cur_title = ""
local truestr_old = ""
local is_halftick = true
local is_batCharging = true

local clock = function() return lsocket.gettime() end
local sleep = function(s)
	lsocket.select(nil,nil,s)
end

local date_update = function()
	local ymd = os.date("%Y.%m.%d")
	local time = os.date("%X")
	local day_idx = tonumber(os.date("%w"))
	local day_table <const> = {
		[0] = "日曜日";
		[1] = "月曜日";
		[2] = "火曜日";
		[3] = "水曜日";
		[4] = "木曜日";
		[5] = "金曜日";
		[6] = "土曜日";
	}
	local day = day_table[day_idx];
	return {
		ymd = ymd;
		time = time;
		day = day;
	}
end

local ScrollableTxt_mt = {}
ScrollableTxt_mt.__index = ScrollableTxt_mt
local ScrollableTxt_new = function(reset,resetlo,start,startlo)
	assert(reset and resetlo and start and startlo,"no arguments")
	local obj = {
		idx = 1;
		wait_reset = 0;
		wait_resetLen = reset;
		wait_resetLenLo = resetlo;
		wait_start = 0;
		wait_startLen = start;
		wait_startLenLo = startlo;
	}
	return setmetatable(obj,ScrollableTxt_mt)
end
function ScrollableTxt_mt:start()
	self.idx = 1
	self.wait_start = 0
	self.wait_reset = 0
end

local titlescroll = ScrollableTxt_new(30,6,20,4)
local notifscroll = ScrollableTxt_new(30,6,16,3)

while true do
	is_halftick = not is_halftick
	-- check herbstluft events --------------------------@/
	do
		-- read lines to memory -------------------------@/
		-- note that if u decide to alternatively use
		-- os.clock(), it's measured in seconds/1000
		local pollrate_table <const> = {
			[false] = 1.0 / 2;
			[true] = 1.0 / 25;
		}
		local poll_rate <const> = pollrate_table[is_batCharging]
		sleep(poll_rate)
	--	local nt = clock() + (poll_rate)
	--	execf("sleep %f",poll_rate)
		local lines = {}
		local fname = "/home/suwa/.config/herbstluftwm/out.txt"
		local file;

		file = io.open(fname,"rb")
		if file then
			local dat = file:read("*all")
			file:close()
			for line in dat:gmatch("([^\n]+)") do
				table.insert(lines,line)
			end
		end
		-- clear out file
		file = io.open(fname,"wb")
		file:close()

		-- read each event ------------------------------@/
		do
			local newtitle = popen_readFixed("herbstclient get_attr tags.focus.focused_client.title")
			if cur_title ~= newtitle then
				titlescroll:start()
			end
			cur_title = newtitle
		end
		for _, line in next, lines do
			local eve_type,eve_args = line:match("([_%w]+)%s(.*)")
			if eve_type == "reload" then
				printf('echo "%s"',eve_type)
				exit(0)
			end
		end
	end

	local taglist = {} do
		local tagstatus_str = popen_read("herbstclient tag_status 0")
		for tag,tagname in tagstatus_str:gmatch("\t([!:#%.]+)(%w+)") do
			--printf('echo "tag status: %s"',tag)
			local entry = {
				focus = false;
				empty = true;
				urgent = false;
				name = tagname;
			}
			if tag == "#" then
				entry.focus = true
				entry.empty = false
			elseif tag == ":" then
				entry.empty = false
			elseif tag == "!" then
				entry.empty = false
				entry.urgent = true;
			end
			taglist[#taglist+1] = entry
		end
	end

	local truestr = ""
	local function textmode_append(str)
		truestr = truestr..str
	end
	local function textmode_appendf(str,...)
		textmode_append(str:format(...))
	end
	local function textmode_selectedSet()
		textmode_appendf('%%{B%s}',PALETTE.fgSel)
		textmode_appendf('%%{F%s}',PALETTE.bg)
	end
	local function textmode_selectedSetRed()
		textmode_append('%{B#ff0000}')
		textmode_appendf('%%{F%s}',PALETTE.bg)
	end
	local function textmode_selectedReset()
		textmode_append("%{B-}")
		textmode_append("%{F-}")
	end
	local function textmode_fgalterSet()
		textmode_appendf('%%{F%s}',PALETTE.fgSel)
	end
	local function textmode_fglightSet()
		textmode_appendf('%%{F%s}',PALETTE.fgLight)
	end
	local function textmode_fgReset()
		truestr = truestr.."%{F-}"
	end
	local function textmode_bgReset()
		textmode_append("%{B-}")
	end
	-- write tags ---------------------------------------@/
	textmode_append("%{T-}")
	for i = 0,9 do
		local tagentry = taglist[i+1]
		local text;
		local tagname = tagentry.name
		if tagentry.focus then
			textmode_selectedSet()
			textmode_appendf("%%{A:herbstclient use_index %d:} %s %%{A}",i,tagname)
			textmode_selectedReset()
		else
			if not tagentry.urgent then
				if tagentry.empty then
					textmode_fglightSet()
				end
				textmode_appendf("%%{A:herbstclient use_index %d:} %s %%{A}",i,tagname)
			else
				textmode_selectedSetRed()
				textmode_appendf("%%{A:herbstclient use_index %d:} %s %%{A}",i,tagname)
				textmode_selectedReset()
			end
			textmode_fgReset()
		end
	end

	-- write window title -------------------------------@/
	textmode_append("%{T-}")
	textmode_fglightSet()
	if use_barSpacing then
		textmode_append("  %{B#00000000}  ")
		textmode_bgReset()
	end
	textmode_append(" ")
	textmode_fgReset()
	do
		local maxlen <const> = 100
		local reset_len = is_batCharging and titlescroll.wait_resetLen or titlescroll.wait_resetLenLo
		local start_len = is_batCharging and titlescroll.wait_startLen or titlescroll.wait_startLenLo

		-- deal with scrolling
		local title = cur_title
		local title_len = #title
	--	local title_len = utf8.len(title)
		if title_len >= maxlen then
			local scroll = titlescroll.idx
			titlescroll.wait_start = titlescroll.wait_start+1
			-- if waiting's already ended, then scroll.
			if titlescroll.wait_start >= start_len then
				local scroll_amt = 1
				if title_len >= 240 then
					-- if title is very long, scroll at 3x speed
					scroll_amt = 3
				end
				scroll = scroll + scroll_amt
				titlescroll.wait_start = titlescroll.wait_start
			end
			-- if title slice >= maxlen, substitute it
			if title_len - titlescroll.idx <= maxlen then
				scroll = title_len - maxlen + 1
				titlescroll.wait_reset = titlescroll.wait_reset+1
				--title = title:sub(utf8.offset(title,scroll))
				title = title:sub(scroll)
			else
				title = title:sub(scroll)
				title = title:sub(1,maxlen).."..."
			end
			titlescroll.idx = scroll;
		end
		textmode_appendf(" %s",title)

		if titlescroll.wait_reset >= reset_len then
			titlescroll.wait_reset = 0
			titlescroll.wait_start = 0
			titlescroll.idx = 1
		end
	end
	
	-- write memory usage -------------------------------@/
	textmode_append("%{r}")
	if use_barSpacing then
		textmode_append("  %{B#00000000}  ")
		textmode_bgReset()
	end
	textmode_append("  %{T-}")

	do
		local mem_cur = tonumber(popen_readFixed('free -m | awk \'/Mem:/ { printf("%3.1f%%", $3) }\''))
		local mem_cent = (mem_cur / mem_max)
		local text = ("%.1fG / %.1fG (%.1f%%)"):format(mem_cur/1024,mem_max/1024,mem_cent*100)
		if mem_cent >= 0.70 then
			local warning_str = "[!!!] " or " "
			local newtext = ("%s%s"):format(warning_str,text)
			if is_halftick then
				text = newtext
			else
				text = (" "):rep(#newtext)
			end
		end
		textmode_appendf("%5s",text)
		textmode_fglightSet()
		textmode_appendf(" | ")
		textmode_fgReset()
	end

	-- write battery ------------------------------------@/
	do
		is_batCharging = tonumber(popen_read("cat /sys/class/power_supply/AC/online")) == 1
		local function disp_battery(battery_id)
			local bat_path = ("/sys/class/power_supply/%s"):format(battery_id)
			local batlevel_now = tonumber(popen_read(("cat %s/energy_now"):format(bat_path)))
			local batlevel_max = tonumber(popen_read(("cat %s/energy_full"):format(bat_path)))
			local divisions = 4

			local batlevel_cent = (batlevel_now / batlevel_max) * 100
			if batlevel_cent >= 79 then
				execa('pkill firefox -9')
			end
			local batlevel_str = ("%.1f%% "):format(batlevel_cent)
			if is_halftick and (not is_batCharging) then
				batlevel_str = (" "):rep(#batlevel_str)
			end
			textmode_append(batlevel_str)
			textmode_fgalterSet()
			textmode_append("[")
			local remain = batlevel_cent
			for i = 1,divisions do
				remain = remain - (100/divisions)
				--textmode_append(remain >= -1 and "■" or "□")
				--textmode_append(remain >= -1 and "■" or "_")
				textmode_append(remain >= -1 and "■" or " ")
			end
			textmode_append("] ")
			textmode_fgReset()
		end
		disp_battery("BAT0")
		disp_battery("BAT1")
	end

	-- write date ---------------------------------------@/
	textmode_append("%{T-}")
	do
		local date = date_update()

		textmode_fglightSet()
		textmode_appendf("| ")
		textmode_fgReset()
		textmode_fgalterSet()
		textmode_fgReset()
		textmode_appendf("%s ",date.ymd)
		textmode_fgalterSet()
		textmode_appendf("%s (%s)",date.time,date.day)
		textmode_fgReset()
		textmode_append("")
	end

	-- write tags ---------------------------------------@/
	if truestr ~= truestr_old then
		local pad_amount = 2
		local pad_str = (' '):rep(pad_amount)
		hnd_lemon:write(('%s%s%s\n'):format(pad_str,truestr,pad_str))
		truestr_old = truestr
	end
end


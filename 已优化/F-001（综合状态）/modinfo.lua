
name = "综合状态"

description = "显示三维数据/温度/淘气值/季节时钟/洞穴时钟等常用数据\n具体内容可在MOD配置里调整\n建议保持默认选项"

author = "Devil"

version = "1.9.2"

api_version = 6
priority = 0

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
hamlet_compatible = true

icon_atlas = "combinedstatus.xml"
icon = "combinedstatus.tex"

forumthread = ""

--[[
Credits:
	Kiopho for writing the original mod and giving me permission to maintain it for DST!
	Soilworker for making SeasonClock and allowing me to incorporate it
	hotmatrixx for making BetterMoon and allowing me to incorporate it
	penguin0616 for adding support for networked naughtiness in DST via their Insight mod
]]

local hud_scale_options = {}
for i = 1,21 do
	local scale = (i-1)*5 + 50
	hud_scale_options[i] = {description = ""..(scale*.01), data = scale}
end

configuration_options =
{
	{
		name = "SHOWTEMPERATURE",
		label = "玩家温度",
		hover = "显示/隐藏玩家当前的温度值",
		options = {
			{ description = "显示", data = true },
			{ description = "隐藏", data = false },
		},
		default = true,
	},
	{
		name = "SHOWWORLDTEMP",
		label = "世界温度",
		hover = "显示/隐藏当前世界的温度值\n(此显示不包含来自火堆等热源的热量影响).",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = false,
	},	
	{
		name = "SHOWTEMPBADGES",
		label = "温度图标",
		hover = "Show images that indicate which temperature is which.",
		options =	{
						{description = "显示", data = true, hover = "Badges will only be shown if both temperatures are shown."},
						{description = "隐藏", data = false, hover = "Badges will never be shown."},
					},
		default = true,
	},	
	{
		name = "UNIT",
		label = "温度单位",
		hover = "Do the right thing, and leave this on Game.",
		options =	{
						{description = "游戏默认", data = "T",
							hover = "The temperature numbers used by the game."
								.."\nFreeze at 0, overheat at 70; get warned 5 from each."},
						{description = "摄氏度", data = "C",
							hover = "The temperature numbers used by the game, but halved to be more reasonable."
								.."\nFreeze at 0, overheat at 35; get warned 2.5 from each."},
						{description = "华氏度", data = "F",
							hover = "Your favorite temperature units that make no sense."
								.."\nFreeze at 32, overheat at 158; get warned 9 from each."},
					},
		default = "T",
	},
	{
		name = "SHOWWANINGMOON",
		label = "显示残月",
		hover = "Show both the waxing and waning moon phases separately."
			 .. "\nDoesn't do anything in DST, which already shows waxing and waning.",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},
	{
		name = "SHOWMOON",
		label = "月相图标",
		hover = "Show the moon phase during day and dusk.",
		options =	{
						{description = "夜晚显示", data = 0, hover = "Show the moon only at night, like usual."},
						{description = "黄昏显示", data = 1, hover = "Show the moon during both night and dusk."},
						{description = "总是显示", data = 2, hover = "Show the moon at all times."},
					},
		default = 1,
	},
	{
		name = "SHOWNEXTFULLMOON",
		label = "预测满月",
		hover = "Predicts the day number of the next full moon,"
			 .. "\nshowing it on the moon badge when moused over.",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = true,
	},
	--[[
	{
		name = "FLIPMOON",
		label = "反转月相",
		hover = "Flips the moon phase (Yes restores the old behavior)."
			.. "\nYes shows the moon as it looks in the Southern Hemisphere.",
		options =	{
						{description = "南半球", data = true, hover = "Show the moon like it is in Southern Hemisphere."},
						{description = "北半球", data = false, hover = "Show the moon like it is in the Northern Hemisphere."},
					},
		default = false,
	},
	]]
	{
		name = "SEASONOPTIONS",
		label = "季节时钟",
		hover = "Adds a clock that shows the seasons, and rearranges the status badges to fit better."
		.."\nAlternatively, adds a badge that shows days into the season and days remaining when moused over.",
		options =	{
						{description = "Micro", data = "Micro"},
						{description = "Compact", data = "Compact"},
						{description = "开启", data = "Clock"},
						{description = "关闭", data = ""},
					},
		default = "Clock",
	},
	{
		name = "SHOWNAUGHTINESS",
		label = "淘气数值",
		hover = "Show the naughtiness of the player.\nDoes not work in Don't Starve Together.",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},	
	{
		name = "SHOWBEAVERNESS",
		label = "木头树值",
		hover = "Show the log meter for Woodie when he is human.\nDoes not work in Don't Starve Together.",
		options =	{
						{description = "一直显示", data = true},
						{description = "海狸显示", data = false},
					},
		default = true,
	},	
	{
		name = "HIDECAVECLOCK",
		label = "洞穴时钟",
		hover = "Show the clock in the caves. Only works for Reign of Giants single-player.",
		options =	{
						{description = "显示", data = false},
						{description = "隐藏", data = true},
					},
		default = false,
	},	
	{
		name = "SHOWSTATNUMBERS",
		label = "数值显示",
		hover = "Show the health, hunger, and sanity numbers.",
		options =	{
						{description = "当前/最大", data = "Detailed"},
						{description = "一直显示", data = true},
						{description = "浮窗显示", data = false},
					},
		default = true,
	},
--[[	
	{
		name = "SHOWMAXONNUMBERS",
		label = "数值信息",
		hover = "Show the \"Max:\" text on the maximum stat numbers to make it clearer.",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},
]]	
	{
		name = "SHOWCLOCKTEXT",
		label = "时钟信息",
		hover = "Show the text on the clock (day number) and season clock (current season).\nIf hidden, the text will only be shown when hovering over.",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},	
	{
		name = "HUDSCALEFACTOR",
		label = "图标大小",
		hover = "Lets you adjust the size of the badges and clocks independently of the rest of the game HUD scale.",
		options = hud_scale_options,
		default = 100,
	},	
}
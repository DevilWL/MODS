
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
感谢致敬原作者们:
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
		hover = "显示/隐藏当前世界的温度值\n(此显示不包含来自火堆等热源的热量影响)",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = false,
	},	
	{
		name = "SHOWTEMPBADGES",
		label = "温度图标",
		hover = "显示用于区分不同温度的图标",
		options =	{
						{description = "显示", data = true, hover = "仅当同时显示两种温度时才显示图标"},
						{description = "隐藏", data = false, hover = "不会显示任何温度图标"},
					},
		default = true,
	},	
	{
		name = "UNIT",
		label = "温度单位",
		hover = "建议保持游戏默认单位，除非有特殊需求",
		options =	{
						{description = "游戏默认", data = "T",
							hover = "游戏使用的温度数值。"
								.."\n0度时会结冰，70度时会过热；距离结冰或过热还有5度时会警告"},
						{description = "摄氏度", data = "C",
							hover = "游戏使用的温度数值，但除以二后更合理。"
								.."\n0度时会结冰，35度时会过热；距离结冰或过热还有2.5度时会警告"},
						{description = "华氏度", data = "F",
							hover = "你最喜欢但不太合理的温度单位。"
								.."\n32度时会结冰，158度时会过热；距离结冰或过热还有9度时会警告"},
					},
		default = "T",
	},
	{
		name = "SHOWWANINGMOON",
		label = "显示残月",
		hover = "显示新月和残月的不同月相图标\n在联机版中已默认显示新月和残月，开启此选项无额外效果",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},
	{
		name = "SHOWMOON",
		label = "月相图标",
		hover = "是否仅在 夜晚（游戏默认）、夜晚和黄昏（黄昏，模组默认）或 始终 显示月亮",
		options =	{
						{description = "夜晚显示", data = 0, hover = "仅在夜晚显示月亮（游戏默认）。"},
						{description = "黄昏显示", data = 1, hover = "在夜晚和黄昏都显示月亮（模组默认）。"},
						{description = "总是显示", data = 2, hover = "始终显示月亮，无论时间段。"},
					},
		default = 1,
	},
	{
		name = "SHOWNEXTFULLMOON",
		label = "预测满月",
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
		hover = "反转月相（开启将恢复旧的显示方式）。"
			.. "\n开启后月相显示为南半球的样式。",
		options =	{
						{description = "南半球", data = true, hover = "以南半球的样式显示月相。"},
						{description = "北半球", data = false, hover = "以北半球的样式显示月相。"},
					},
		default = false,
	},
	]]
	{
		name = "SEASONOPTIONS",
		label = "季节时钟",
		hover = "默认时钟:显示完整的季节时钟。紧凑:显示较小的徽章和季节天数，微型:显示更小的徽章。关闭:则完全禁用季节时钟（选择“关闭”即不显示季节时钟）。",
		options =	{
						{description = "微型", data = "Micro"},
						{description = "紧凑", data = "Compact"},
						{description = "开启", data = "Clock"},
						{description = "关闭", data = "unClock"},
					},
		default = "Clock",
	},
	{
		name = "SHOWNAUGHTINESS",
		label = "淘气数值",
		hover = "是否显示玩家的淘气值。",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},	
	{
		name = "SHOWBEAVERNESS",
		label = "木头树值",
		hover = "是否在伍迪为人类时显示木头值计量表。",
		options =	{
						{description = "一直显示", data = true},
						{description = "海狸显示", data = false},
					},
		default = true,
	},	
	{
		name = "HIDECAVECLOCK",
		label = "洞穴时钟",
		hover = "是否始终在洞穴中显示时钟。",
		options =	{
						{description = "显示", data = false},
						{description = "隐藏", data = true},
					},
		default = false,
	},	
	{
		name = "SHOWSTATNUMBERS",
		label = "数值显示",
		hover = "显示生命、饥饿和精神的数值。",
		options =	{
						{description = "当前/最大", data = "Detailed"},
						{description = "一直显示", data = "Always"},
						{description = "浮窗显示", data = "Tooltip"},
					},
		default = "Always",
	},
 	--[[	
	{
		name = "SHOWMAXONNUMBERS",
		label = "数值信息",
		hover = "在最大数值旁显示“最大值”字样，使信息更清晰。",
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
		hover = "显示时钟上的文字（天数）和季节时钟上的文字（当前季节）。\n如果隐藏，只有鼠标悬停时才会显示文字。",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},	
	{
		name = "HUDSCALEFACTOR",
		label = "图标大小",
		hover = "允许你独立调整图标和时钟的大小，不受游戏 HUD 缩放影响。\n默认值 100 代表 100% 缩放。",
		options = hud_scale_options,
		default = 100, -- 100 表示 100% 缩放
	},	
}



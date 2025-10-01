name = "地窖" 
author = "Devil"
version = "1.0.0"
description = "80格地窖，可以减缓食物腐烂程度"

forumthread = ""

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
--hamlet_compatible = true

priority = -0.0584259222

icon_atlas = "storeroom.xml"
icon = "storeroom.tex"
----------------

configuration_options =
{
	{
		name = "Craft",
		label = "制作难度",
		options =
	{
		{description = "简单", data = "Easy"},
		{description = "普通", data = "Normal"},
		{description = "困难", data = "Hard"},
	},
		default = "Normal",
	},

	{
		name = "Slots",
		label = "格子数量",
		options =
	{
		{description = "20", data = 20},
		{description = "40", data = 40},
		{description = "60", data = 60},
		{description = "80", data = 80},
	},
		default = 80,
	},

	{
		name = "Position",
		label = "放置位置",
		options =
	{
		{description = "左侧", data = "Left"},
		{description = "居中", data = "Center"},
		{description = "右侧", data = "Right"},
	},
		default = "Center",
	},

	{
		name = "FoodSpoilage",
		label = "腐烂速度",
		options =
	{
		{description = "默认", data = 1},
		{description = "0.85倍", data = 0.85},
		{description = "0.75倍", data = 0.75},
		{description = "0.5倍", data = 0.5},
		{description = "0.25倍", data = 0.25},
		{description = "永不腐烂", data = 0},
		{description = "秒烂", data = 999},
	},
		default = 0.5,
	},

	{
		name = "Destroyable",
		label = "是否可被破坏",
		options =
	{
		{description = "所有生物", data = "DestroyByAll"},
		{description = "仅玩家", data = "DestroyByPlayer"},
		{description = "不可破坏", data = "DestroyOff"},
	},
		default = "DestroyByPlayer",
	},

	{
		name = "Language",
		label = "语言设置",
		options =
	{
		{description = "简体中文", data = "Zh"},
		{description = "英语", data = "En"},
		--{description = "法语", data = "Fr"},
		--{description = "德语", data = "Gr"},
		--{description = "土耳其语", data = "Tr"},
	},
		default = "Zh",
	},
}
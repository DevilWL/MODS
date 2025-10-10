name = "新手大礼包"
description = "堆叠上限，快速采集，冰箱加强保鲜，角色移动加快，自动回血等"
author = "Devil"
version = "1.1.0"

forumthread = ""

--DLC支持
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

--模组API版本 单机版：6
api_version = 6

--模组图标
icon_atlas = ""
icon = ""

--模组配置
configuration_options = 
{

	--堆叠上限

	{
		name = "text",
		label = "全部三种堆叠类型",
		options = 
		{
			{description = "数量上限修改", data = false},

		},
		default = false
	},
	{
		name = "stack_size1",
		label = "小型堆叠：树枝等",
		options = 
		{
			{description = "50", data = 50},
			{description = "100", data = 100},
			{description = "200", data = 200},
			{description = "500", data = 500},
			{description = "800", data = 800},
			{description = "999", data = 999},
		},
		default = 200
	},
	{
		name = "stack_size2",
		label = "中型堆叠：木头等",
		options = 
		{
			{description = "50", data = 50},
			{description = "100", data = 100},
			{description = "200", data = 200},
			{description = "500", data = 500},
			{description = "800", data = 800},
			{description = "999", data = 999},
		},
		default = 100
	},
	{
		name = "stack_size3",
		label = "大型堆叠：木板等",
		options = 
		{
			{description = "50", data = 50},
			{description = "100", data = 100},
			{description = "200", data = 200},
			{description = "500", data = 500},
			{description = "800", data = 800},
			{description = "999", data = 999},
		},
		default = 50
	},
	
	--移动速度介绍
	--[[
	{
		name = "text2",
		label = "移动速度保持",
		options = 
		{
			{description = "步行跑步同步", data = false},

		},
		default = false
	},
	]]
		--移动速度开关
	{
		name = "WalkRun",
		label = "是否开启角色加速",
		options = 
		{
			{description = "关闭", data = false},
			{description = "开启", data = true},
		},
		default = false
	},
	
	
	
	
	
	
	
	{
		name = "walk_speed",
		label = "步行速度建议同步",
		options = 
		{
			{description = "不变", data = 4},
			{description = "1.5倍", data = 6},
			{description = "2倍", data = 8},
			{description = "2.5倍", data = 10},
			{description = "3倍", data = 12},
		},
		default = 6
	},
	{
		name = "run_speed",
		label = "跑步速度建议同步",
		options = 
		{
			{description = "不变", data = 6},
			{description = "1.5倍", data = 9},
			{description = "2倍", data = 12},
			{description = "2.5倍", data = 15},
			{description = "3倍", data = 18},
		},
		default = 9
	},
	--后续考虑是否改成1的数值递增
	
	--冰箱保鲜程度
		{
		name = "backpackfridge",
		label = "是否全部背包保鲜",
		options = 
		{
			{description = "关闭", data = false},
			{description = "开启", data = true},

		},
		default = false
	},
		{
		name = "Playerfridge",
		label = "角色自带格子保鲜",
		options = 
		{
			{description = "关闭", data = false},
			{description = "开启", data = true},
		},
		default = false
	},
	
	
	
	{
		name = "icebox_freeze",
		label = "所有种类保鲜效果",
		options = 
		{
			{description = "默认", data = .5},
			{description = "4倍", data = .25},
			{description = "5倍", data = .2},
			{description = "永久", data = 0},
			{description = "回鲜", data = -5},
		},
		default = 0.25
	},
	

	--[[
		{
		name = "attack",
		label = "攻击力",
		options = 
		{
			{description = "默认", data = 34},
			{description = "2倍", data = 68},
			{description = "3倍", data =112},
		},
		default = 68
	},
	]]
	
	{
		name = "MOD_QuickPick",
		label = "是否开启快速采集",
		options = 
		{
			{description = "关闭", data = false},
			{description = "开启", data = true},
		},
		default = true
	},
	
	
	{
		name = "healthregen",
		label = "是否开启角色回血",
		options = 
		{
			{description = "关闭", data = false},
			{description = "开启", data = true},
		},
		default = false
	},
	
	{
		name = "regen_time",
		label = "角色每次回血间隔",
		options = 
		{
			{description = "1秒", data = 1},
			{description = "3秒", data = 3},
			{description = "5秒", data = 5},
			{description = "10秒", data = 10},
		},
		default = 5
	},
	
	{
		name = "regen_health",
		label = "角色每次回复血量",
		options = 
		{
			{description = "1", data = 1},
			{description = "3", data = 3},
			{description = "5", data = 5},
			{description = "10", data = 10},
			{description = "100", data = 100},
			{description = "250", data = 250},
			{description = "500", data = 500},
			{description = "999", data = 999},
		},
		default = 1
	},

	{
		name = "healthregen_chester",
		label = "提高狗箱鸟箱回血",
		options = 
		{
			{description = "关闭", data = false},
			{description = "开启", data = true},
		},
		default = false
	},

	{
		name = "regen_time_chester",
		label = "狗箱鸟箱回血间隔",
		options = 
		{
			{description = "1秒", data = 1},
			{description = "3秒", data = 3},
			{description = "5秒", data = 5},
			{description = "10秒", data = 10},
		},
		default = 1
	},

	{
		name = "regen_health_chester",
		label = "狗箱鸟箱回复血量",
		options = 
		{
			{description = "1", data = 1},
			{description = "3", data = 3},
			{description = "5", data = 5},
			{description = "10", data = 10},
			{description = "100", data = 100},
			{description = "250", data = 250},
			{description = "500", data = 500},
			{description = "999", data = 999},
		},
		default = 250
	},

	{
		name = "wathgrithr_vegetarian",
		label = "是否让女武神吃素",
		options = 
		{
			{description = "关闭", data = false},
			{description = "开启", data = true},
		},
		default = false
	}
	
	
	
}


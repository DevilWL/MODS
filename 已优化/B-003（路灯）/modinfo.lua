name = "路灯"
description = "哈姆雷特路灯和暴食路灯\n永远驱散黑暗"
author = "Devil"
icon_atlas = "lamp.xml"
icon = "lamp.tex"
version = "1.0.0"

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
--hamlet_compatible = true

forumthread = ""

configuration_options =
{
       {
		name = "language",
		label = "语言",
		options =
		{
			{description = "英文", data = "EN"},
			{description = "中文", data = "CN"},
		},
		default = "CN"
        },
       {
		name = "radius",
		label = "范围",
		options =
		{
			{description = "5", data = false},
			{description = "7.5", data = "rad1"},
			{description = "10", data = "rad2"},
			{description = "12.5", data = "rad3"},
			{description = "15", data = "rad4"},
		},
		default = "rad1"
        },
       {
		name = "bright",
		label = "亮度",
		options =
		{
			{description = "60%", data = false},
			{description = "70%", data = "bri1"},
			{description = "75%", data = "bri2"},
			{description = "80%", data = "bri3"},
			{description = "85%", data = "bri4"},
			{description = "90%", data = "bri5"},
			{description = "95%", data = "bri6"},
		},
		default = "bri1"
        },
       {
		name = "difficity",
		label = "配方",
		options =
		{
			{description = "萤火虫", data = "fireflies"},
			{description = "荧光生物", data = "bioluminescence"},

		},
		default = "fireflies"
        },		
}		

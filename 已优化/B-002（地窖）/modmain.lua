PrefabFiles = {
	"cupboard",
}

Assets =
{
	Asset("ATLAS", "minimap/storeroom.xml"),
	Asset("ATLAS", "images/inventoryimages/storeroom.xml"),
}

AddMinimapAtlas("minimap/storeroom.xml")

_G = GLOBAL
STRINGS = _G.STRINGS
RECIPETABS = _G.RECIPETABS
Recipe = _G.Recipe
Ingredient = _G.Ingredient
TECH = _G.TECH
TUNING = _G.TUNING
RECIPE_GAME_TYPE = _G.RECIPE_GAME_TYPE
rawget = _G.rawget
IsDLCEnabled = _G.IsDLCEnabled

_G.STOREROOM_WORK_DIR = "workshop-3456636745"

local modtemperatureduration =
{
	[1] = 0, [0.85] = -0.5, [0.75] = -0.6, [0.5] = -1, [0.25] = -2, [0] = -5, [999] = 5,
}

TUNING.PERISH_STOREROOM_MULT = GetModConfigData("FoodSpoilage")
TUNING.TEMP_STOREROOM_MULT = modtemperatureduration[TUNING.PERISH_STOREROOM_MULT]

local STOREROOM = {}
STOREROOM.SLOTS = GetModConfigData("Slots")
STOREROOM.CRAFT = GetModConfigData("Craft")
STOREROOM.LANG = GetModConfigData("Language")
STOREROOM.DEBUG = false

local ROG_DLC = rawget(_G,"REIGN_OF_GIANTS") and IsDLCEnabled and IsDLCEnabled(_G.REIGN_OF_GIANTS)
local CAPY_DLC = rawget(_G,"CAPY_DLC") and IsDLCEnabled and IsDLCEnabled(_G.CAPY_DLC)
--local HAM_DLC = rawget(_G,"PORKLAND_DLC") and IsDLCEnabled and IsDLCEnabled(_G.PORKLAND_DLC)

local PERISHABLE_MOD = false

--47-60是关于根据不同语音修改MOD介绍的功能
-- description change depending on the language
--[[
local function descriptionchange(str)
	local OldModInfo=_G.ModIndex.GetModInfo
	function NewModInfo(self,modname)
		local res = OldModInfo(self,modname)
			if res and modinfo.name == res.name then
				res.description=str .. res.version
			end
		return res
	end
	_G.ModIndex.GetModInfo=NewModInfo
end
]]
local function updaterecipe(slots)

	if STOREROOM.CRAFT == "Easy" then

		cutstone_value = math.floor(slots / 7)
		boards_value = math.floor(slots / 7)
		limestone_value = math.floor(slots / 20)
		marble_value = math.floor(slots / 20)

	elseif STOREROOM.CRAFT == "Hard" then

		cutstone_value = math.floor(slots / 2.6)
		boards_value = math.floor(slots / 2.6)
		limestone_value = math.floor(slots / 8)
		marble_value = math.floor(slots / 10)

	else

		cutstone_value = math.floor(slots / 4)
		boards_value = math.floor(slots / 4)
		limestone_value = math.floor(slots / 16)
		marble_value = math.floor(slots / 20)
	end
end
updaterecipe(STOREROOM.SLOTS)


if CAPY_DLC then
	cupboard0 = Recipe("cupboard",{ Ingredient("cutstone", cutstone_value), Ingredient("marble", marble_value), Ingredient("boards", boards_value) }, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.VANILLA, "cupboard_placer" )
	cupboard1 = Recipe("cupboard",{ Ingredient("cutstone", cutstone_value), Ingredient("marble", marble_value), Ingredient("boards", boards_value) }, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.ROG, "cupboard_placer" )
	cupboard2 = Recipe("cupboard",{ Ingredient("cutstone", cutstone_value), Ingredient("limestone", limestone_value), Ingredient("boards", boards_value) }, RECIPETABS.TOWN, TECH.SCIENCE_TWO, RECIPE_GAME_TYPE.SHIPWRECKED, "cupboard_placer" )

	cupboard1.atlas = "images/inventoryimages/storeroom.xml"
	cupboard2.atlas = "images/inventoryimages/storeroom.xml"
else
	cupboard0 = Recipe("cupboard",{ Ingredient("cutstone", cutstone_value), Ingredient("marble", marble_value), Ingredient("boards", boards_value) }, RECIPETABS.TOWN, TECH.SCIENCE_TWO, "cupboard_placer")
end
cupboard0.atlas = "images/inventoryimages/storeroom.xml"

local function updatestoreroom(inst)
	if GetModConfigData("Position")==("Left") then
		inst.components.container.widgetpos = _G.Vector3(-110,170,0)
	elseif GetModConfigData("Position")==("Center") then
		inst.components.container.widgetpos = _G.Vector3(360-(STOREROOM.SLOTS*4.5),170,0)
	elseif GetModConfigData("Position")==("Right") then
		inst.components.container.widgetpos = _G.Vector3(820-(STOREROOM.SLOTS*9.3),170,0)
	end

	if STOREROOM.SLOTS == 20 then
		inst.components.container.widgetanimbank = "ui_chest_4x5"
		inst.components.container.widgetanimbuild = "ui_chest_4x5"
	elseif STOREROOM.SLOTS == 40 then
		inst.components.container.widgetanimbank = "ui_chest_5x8"
		inst.components.container.widgetanimbuild = "ui_chest_5x8"
	elseif STOREROOM.SLOTS == 60 then
		inst.components.container.widgetanimbank = "ui_chest_5x12"
		inst.components.container.widgetanimbuild = "ui_chest_5x12"
	else
		inst.components.container.widgetanimbank = "ui_chest_5x16"
		inst.components.container.widgetanimbuild = "ui_chest_5x16"
	end
end

----------------------------------------------------
-------------------- 中文翻译 ---------------------
----------------------------------------------------
if STOREROOM.LANG == "Zh" then
    STRINGS.NAMES.CUPBOARD = " 地窖"
    STRINGS.RECIPE_DESC.CUPBOARD = "建造更多的空间！"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUPBOARD = "这个储物柜真是太棒了！"
    --descriptionchange("我们等待了太久。\n模组版本: ")

--------------------- French ----------------------
--by John2022
elseif STOREROOM.LANG == "Fr" then
	STRINGS.NAMES.CUPBOARD = "Debarras"
	STRINGS.RECIPE_DESC.CUPBOARD = "Besoin de plus d'espace!"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUPBOARD = "J'apprecie beaucoup le gain de place!"
	--descriptionchange("Depuis le temps qu'on l'attendait!\nMod version: ")

--------------------- German ----------------------
-- by Ralkari
elseif STOREROOM.LANG == "Gr" then
	STRINGS.NAMES.CUPBOARD = "Vorratskammer"
	STRINGS.RECIPE_DESC.CUPBOARD = "Brauche mehr Platz!"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUPBOARD = "Ich mag die Vorratskammer!"
	--descriptionchange("Dein personlicher Stauraum.\nMod Version: ")

--------------------- Turkish ----------------------
-- by DestORoyal
elseif STOREROOM.LANG == "Tr" then
    STRINGS.NAMES.CUPBOARD = "Depo"
    STRINGS.RECIPE_DESC.CUPBOARD = "Daha fazla alan gerek!"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUPBOARD = "Bu depoyu gercekten begendim!"
    --descriptionchange("Senin kisisel depo alanin.\nMod versiyonu:  ")

else
	STRINGS.NAMES.CUPBOARD = "Storeroom"
	STRINGS.RECIPE_DESC.CUPBOARD = "Need more space!"
	--STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUPBOARD = "I really like this is a great storeroom!"
end

AddPrefabPostInit("cupboard", updatestoreroom)

----------------------------------------------------
---------------- Pershable PostInit ----------------
----------------------------------------------------

if _G.ModManager and _G.ModManager.enabledmods then
	for i,v in ipairs(_G.ModManager.enabledmods) do
		if v == "workshop-442602018" then 	-- Perishable mod folder
			PERISHABLE_MOD = true
		end
	end
end

if not PERISHABLE_MOD then
	print("Storeroom perishable is loaded")

	if ROG_DLC then 						-- ROG
		modimport "perishable/rog.lua"
	elseif CAPY_DLC then -- SW / Hamlet
		modimport "perishable/sw.lua"
	else
		modimport "perishable/vanila.lua"  -- BASE
	end
else
	print("cr4shmaster's perishable is loaded")

	AddPrefabPostInit("cupboard", function(inst)
		inst:AddTag("crsCustomPerishMult")
		inst.crsCustomPerishMult = TUNING.PERISH_STOREROOM_MULT

		inst:AddTag("crsCustomTempDuration")
		inst.crsCustomTempDuration = TUNING.TEMP_STOREROOM_MULT
	end)

end

---------------------------------------------------
---------------------- DEBUG ----------------------
---------------------------------------------------
if STOREROOM.DEBUG then
	print("<----- STOREROOM DEBUG -----")
	print("SLOTS = " .. STOREROOM.SLOTS)
	print("PERISH = " .. TUNING.PERISH_STOREROOM_MULT)
	print("RECIPE: cutstone = " .. cutstone_value .. " marble = " .. marble_value .. " boards = " ..  boards_value .. " limestone = " ..  limestone_value)
	print("----- STOREROOM DEBUG ----->")
end
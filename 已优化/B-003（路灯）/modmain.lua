--------------------------
---The mod built by HWY---
--------------------------
--Functuon definition	
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local lan = GetModConfigData("language")
local setrad = GetModConfigData("radius")
local bri = GetModConfigData("bright")
local diff = GetModConfigData("difficity")

Assets = 
{
	Asset("IMAGE", "images/inventoryimages/lamppost.tex" ),
	Asset("ATLAS", "images/inventoryimages/lamppost.xml" ),	
	Asset("IMAGE", "images/inventoryimages/gorgelamp.tex" ),
	Asset("ATLAS", "images/inventoryimages/gorgelamp.xml" ),	
}

PrefabFiles =
{
	"lamppost",
	"gorgelamp",
}

AddMinimapAtlas("images/inventoryimages/lamppost.xml")
AddMinimapAtlas("images/inventoryimages/gorgelamp.xml")

local function setintensity(inst)
local light = inst.entity:AddLight()
if setrad == "rad1" then
    inst.Light:SetRadius( 7.5 )
elseif setrad == "rad2" then
	inst.Light:SetRadius( 10 )
elseif setrad == "rad3" then
	inst.Light:SetRadius( 12.5 )
elseif setrad == "rad4" then
	inst.Light:SetRadius( 15 )
end
end

AddPrefabPostInit("lamppost", setintensity)
AddPrefabPostInit("gorgelamp", setintensity)

local function setbright()
if bri == "bri1" then
TUNING.LAMPPOST_INTENSITY = 0.7
elseif bri == "bri2" then
TUNING.LAMPPOST_INTENSITY = 0.75
elseif bri == "bri3" then
TUNING.LAMPPOST_INTENSITY = 0.8
elseif bri == "bri4" then
TUNING.LAMPPOST_INTENSITY = 0.85
elseif bri == "bri5" then
TUNING.LAMPPOST_INTENSITY = 0.9
elseif bri == "bri6" then
TUNING.LAMPPOST_INTENSITY = 0.95
end
end

AddPrefabPostInit("lamppost", setbright)
AddPrefabPostInit("gorgelamp", setbright)

if diff == "fireflies" then
if GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
		local lamppost = Recipe("lamppost",{Ingredient("lantern",1),Ingredient("boards",2),Ingredient("transistor",1),Ingredient("fireflies",2)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,GLOBAL.RECIPE_GAME_TYPE.COMMON,"lamppost_placer",1) 
		lamppost.atlas = "images/inventoryimages/lamppost.xml"
		local gorgelamp = Recipe("gorgelamp",{Ingredient("lantern",1),Ingredient("boards",2),Ingredient("transistor",1),Ingredient("fireflies",2)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,GLOBAL.RECIPE_GAME_TYPE.COMMON,"gorgelamp_placer",1) 
		gorgelamp.atlas = "images/inventoryimages/gorgelamp.xml"
elseif GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then	
		local lamppost = Recipe("lamppost",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("fireflies",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"lamppost_placer")
		lamppost.atlas = "images/inventoryimages/lamppost.xml"	
		local gorgelamp = Recipe("gorgelamp",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("fireflies",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"gorgelamp_placer")
		gorgelamp.atlas = "images/inventoryimages/gorgelamp.xml"	
else
		local lamppost = Recipe("lamppost",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("fireflies",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"lamppost_placer")
		lamppost.atlas = "images/inventoryimages/lamppost.xml"			
		local gorgelamp = Recipe("gorgelamp",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("fireflies",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"gorgelamp_placer")
		gorgelamp.atlas = "images/inventoryimages/gorgelamp.xml"			
end
elseif diff == "bioluminescence" then
if GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
		local lamppost = Recipe("lamppost",{Ingredient("lantern",1),Ingredient("boards",2),Ingredient("transistor",1),Ingredient("bioluminescence",2)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,GLOBAL.RECIPE_GAME_TYPE.COMMON,"lamppost_placer",1) 
		lamppost.atlas = "images/inventoryimages/lamppost.xml"
		local gorgelamp = Recipe("gorgelamp",{Ingredient("lantern",1),Ingredient("boards",2),Ingredient("transistor",1),Ingredient("bioluminescence",2)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,GLOBAL.RECIPE_GAME_TYPE.COMMON,"gorgelamp_placer",1) 
		gorgelamp.atlas = "images/inventoryimages/gorgelamp.xml"		
elseif GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS) then	
		local lamppost = Recipe("lamppost",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("bioluminescence",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"lamppost_placer")
		lamppost.atlas = "images/inventoryimages/lamppost.xml"	
		local gorgelamp = Recipe("gorgelamp",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("bioluminescence",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"gorgelamp_placer")
		gorgelamp.atlas = "images/inventoryimages/gorgelamp.xml"			
else
		local lamppost = Recipe("lamppost",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("bioluminescence",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"lamppost_placer")
		lamppost.atlas = "images/inventoryimages/lamppost.xml"			
		local gorgelamp = Recipe("gorgelamp",{Ingredient("nitre",2),Ingredient("transistor",1),Ingredient("bioluminescence",1)},RECIPETABS.LIGHT,TECH.SCIENCE_TWO,"gorgelamp_placer")
		gorgelamp.atlas = "images/inventoryimages/gorgelamp.xml"				
end
end





if lan=="CN" then
STRINGS.NAMES.LAMPPOST = "路灯"
STRINGS.RECIPE_DESC.LAMPPOST = "世界再无黑暗"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAMPPOST = "很棒的路灯"
STRINGS.NAMES.GORGELAMP = "暴食之灯"
STRINGS.RECIPE_DESC.GORGELAMP = "吞噬黑暗"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GORGELAMP = "吞噬黑暗"
elseif lan=="EN" then
STRINGS.NAMES.LAMPPOST = "street light"
STRINGS.RECIPE_DESC.LAMPPOST = "The world is no longer dark"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAMPPOST = "nice street light"
STRINGS.NAMES.GORGELAMP = "street light"
STRINGS.RECIPE_DESC.GORGELAMP = "The world is no longer dark"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GORGELAMP = "nice street light"
end
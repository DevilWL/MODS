
---------------------------------------------------------------
------------------------------堆叠上限-------------------------
---------------------------------------------------------------

-- 设置自定义堆叠函数
function stackablepostinit(inst)
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = GetModConfigData("stack_size2")
end

-- 单独设置金币与暗影燃料堆叠函数
function stackabledubloonnightmarefuel(inst) --函数名可自行更换
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 999999
end

-- 堆叠上限修改
TUNING.STACK_SIZE_LARGEITEM = GetModConfigData("stack_size3")
TUNING.STACK_SIZE_MEDITEM = GetModConfigData("stack_size2")
TUNING.STACK_SIZE_SMALLITEM = GetModConfigData("stack_size1")

-- 通过API接口使某些不可堆叠物品变成可堆叠
AddPrefabPostInit("rabbit", stackablepostinit)        		 --兔子
AddPrefabPostInit("robin", stackablepostinit)         		 --鸟
AddPrefabPostInit("robin_winter", stackablepostinit) 		 --雪鸟
AddPrefabPostInit("crow", stackablepostinit)         		 --乌鸦
AddPrefabPostInit("parrot", stackablepostinit)      		 --鹦鹉
AddPrefabPostInit("seagull", stackablepostinit)     		 --海鸥
AddPrefabPostInit("toucan", stackablepostinit)     		     --巨嘴鸟
AddPrefabPostInit("crab", stackablepostinit)        		 --螃蟹
AddPrefabPostInit("jellyfish", stackablepostinit)    		 --水母
AddPrefabPostInit("snakeoil", stackablepostinit)     		 --蛇油
AddPrefabPostInit("coral_brain", stackablepostinit)  		 --珊瑚脑
AddPrefabPostInit("lobster", stackablepostinit)      		 --龙虾
AddPrefabPostInit("minotaurhorn", stackablepostinit) 		 --犀牛角
AddPrefabPostInit("tallbirdegg", stackablepostinit)  		 --高鸟蛋
--AddPrefabPostInit("doydoy", stackablepostinit)       		 --渡渡鸟
--AddPrefabPostInit("doydoybaby", stackablepostinit)   		 --渡渡鸟宝宝
AddPrefabPostInit("magic_seal", stackablepostinit)   		 --海豹纹章
AddPrefabPostInit("doydoyegg", stackablepostinit)    		 --渡渡鸟蛋
AddPrefabPostInit("coconade", stackablepostinit)     		 --椰子炸弹
AddPrefabPostInit("obsidiancoconade", stackablepostinit)	 --黑曜石炸弹
AddPrefabPostInit("beemine", stackablepostinit)     		 --蜜蜂地雷
AddPrefabPostInit("quackenbeak", stackablepostinit)   		 --海妖喙

-- 单独设置金币和暗影燃料的数量，方便将来配合RPG类型模组使用
AddPrefabPostInit("dubloon", stackabledubloonnightmarefuel)
AddPrefabPostInit("nightmarefuel", stackabledubloonnightmarefuel)

---------------------------------------------------------------
------------------------------冰箱保鲜-------------------------
---------------------------------------------------------------

-- 角色自带格子保鲜，也会同时作用于各种背包

local Playerfridge = GetModConfigData("Playerfridge")

if Playerfridge == true then
AddPlayerPostInit(function(inst)
inst:AddTag("fridge")
end)
end


local backpackfridge = GetModConfigData("backpackfridge")

local function OnPickup(inst, owner)
    -- 检查玩家是否已经有一个背包
    local hasBackpack = false
    for k, item in pairs(owner.components.inventory:GetItems()) do
        if item.prefab == "backpack" or item.prefab == "your_backpack_prefab_name" then
            hasBackpack = true
            break
        end
    end

    -- 如果已经有背包，则不允许捡起新的背包
    if hasBackpack then
        owner.components.inventory:DropItem(inst) -- 强制丢弃新捡起的背包
        -- 可以添加提示信息
        if owner.components.talker then
            owner.components.talker:Say("我只能携带一个背包！")
        end
        return
    end

    -- 正常捡起背包的逻辑
    inst.components.inventoryitem.cangoincontainer = false
end


local function fridgebackpack(inst)
	inst:AddComponent("inspectable")
    inst:AddTag("fridge")
end

if backpackfridge == true then
	AddPrefabPostInit("backpack", fridgebackpack)
	AddPrefabPostInit("piggyback", fridgebackpack)
	AddPrefabPostInit("krampus_sack", fridgebackpack)
	AddPrefabPostInit("thatchpack", fridgebackpack)
	AddPrefabPostInit("mailpack", fridgebackpack)
	AddPrefabPostInit("piratepack", fridgebackpack)
end

--backpack --背包1
--icepack --保鲜包1
--krampus_sack --小偷包
--mailpack --邮箱包1
--piggyback --小猪包1
--piratepack --海盗背包1
--seasack --海上保鲜袋1
--spicepack --厨师包1
--thatchpack --编织袋1
	
-- 冰箱保鲜程度
TUNING.PERISH_FRIDGE_MULT = GetModConfigData("icebox_freeze")

---------------------------------------------------------------
------------------------------移动速度-------------------------
---------------------------------------------------------------

-- 定义与读取移动速度功能
local WalkRun = GetModConfigData("WalkRun")
-- 移动刷掉开关
if WalkRun == true then
-- 移动速度修改
TUNING.WILSON_WALK_SPEED = GetModConfigData("walk_speed")
TUNING.WILSON_RUN_SPEED = GetModConfigData("run_speed")
end

---------------------------------------------------------------
------------------------------快速采集-------------------------
---------------------------------------------------------------

-- 快速采集函数
local Quick_Pick = GetModConfigData("MOD_QuickPick")

if Quick_Pick == true then
	function MOD_QuickPick(inst)
		if inst.components.pickable then
		inst.components.pickable.quickpick = true
		end
	end
end

--通过API接口使下列植物变成快速采集
AddPrefabPostInit("grass", MOD_QuickPick)
AddPrefabPostInit("sapling", MOD_QuickPick)
AddPrefabPostInit("reeds", MOD_QuickPick)
AddPrefabPostInit("berrybush", MOD_QuickPick)
AddPrefabPostInit("berrybush2", MOD_QuickPick)
AddPrefabPostInit("cactus", MOD_QuickPick)
AddPrefabPostInit("cave_fern", MOD_QuickPick)
AddPrefabPostInit("red_mushroom", MOD_QuickPick)
AddPrefabPostInit("green_mushroom", MOD_QuickPick)
AddPrefabPostInit("blue_mushroom", MOD_QuickPick)
AddPrefabPostInit("cave_banana_tree", MOD_QuickPick)
AddPrefabPostInit("lichen", MOD_QuickPick)
AddPrefabPostInit("marsh_bush", MOD_QuickPick)
AddPrefabPostInit("flower_cave", MOD_QuickPick)
AddPrefabPostInit("flower_cave_double", MOD_QuickPick)
AddPrefabPostInit("flower_cave_triple", MOD_QuickPick)
AddPrefabPostInit("seaweed_planted", MOD_QuickPick)
AddPrefabPostInit("limpetrock", MOD_QuickPick)
AddPrefabPostInit("mussel_farm", MOD_QuickPick)
AddPrefabPostInit("grass_water", MOD_QuickPick)
AddPrefabPostInit("sweet_potato_planted", MOD_QuickPick)
AddPrefabPostInit("coffeebush", MOD_QuickPick)
AddPrefabPostInit("seashell_beached", MOD_QuickPick)
AddPrefabPostInit("tumbleweed", MOD_QuickPick) --风滚草

---------------------------------------------------------------
------------------------------自动回血-------------------------
---------------------------------------------------------------

-- 定义与读取血量回复功能
local healthregen = GetModConfigData("healthregen")
-- 增加血量回复开关
if healthregen == true then
    AddPlayerPostInit(function(inst)
    -- 在玩家实体初始化后执行
    if inst.components.health then
        -- 参数1: 每秒回血量
        -- 参数2: 回血间隔时间
        inst.components.health:StartRegen(GetModConfigData("regen_health"),GetModConfigData("regen_time"))
        -- 可选：设置最大生命值为威尔逊的标准值
        --inst.components.health:SetMaxHealth(TUNING.WILSON_HEALTH)
    end
    end)
end
-- 狗箱/鸟箱自动回血
local healthregen_chester = GetModConfigData("healthregen_chester")
    if healthregen_chester == true then
    AddPrefabPostInit("chester", function(inst)
    if inst.components.health then
        inst.components.health:StartRegen(GetModConfigData("regen_health_chester"),GetModConfigData("regen_time_chester"))
    end
    end)
    AddPrefabPostInit("packim", function(inst)
    if inst.components.health then
        inst.components.health:StartRegen(GetModConfigData("regen_health_chester"),GetModConfigData("regen_time_chester"))
    end
    end)
end

--待添加小偷背包保鲜功能，牙齿陷阱自动重置功能
--回旋镖自动接，老奶奶可以睡觉等常用功能
------------女武神吃素----------------------------
local wathgrithr_vegetarian = GetModConfigData("wathgrithr_vegetarian")
if wathgrithr_vegetarian == true then
    AddPlayerPostInit(function(inst)
        if inst.prefab == "wathgrithr" and inst.components.eater then
            inst.components.eater:SetOmnivore()
        end
    end)
end
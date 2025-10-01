require "prefabutil"  -- 引入prefabutil工具库

local assets=  -- 定义鸟笼使用的动画资源
{
    Asset("ANIM", "anim/bird_cage.zip"),  -- 鸟笼基础动画
    Asset("ANIM", "anim/crow_build.zip"),  -- 乌鸦动画
    Asset("ANIM", "anim/robin_build.zip"),  -- 红雀动画
    Asset("ANIM", "anim/robin_winter_build.zip"),  -- 冬季红雀动画
}

local prefabs =  -- 定义鸟笼相关的预制体
{
    "bird_egg",  -- 鸟蛋
    "crow",  -- 乌鸦
    "robin",  -- 红雀
    "robin_winter",  -- 冬季红雀
    "collapse_small",  -- 摧毁特效
}

local bird_symbols=  -- 定义鸟的各部位符号(用于动画覆盖)
{
    "crow_beak",  -- 鸟喙
    "crow_body",  -- 鸟身
    "crow_eye",  -- 鸟眼
    "crow_leg",  -- 鸟腿
    "crow_wing",  -- 鸟翼
    "tail_feather",  -- 尾羽
}

local function ShouldAcceptItem(inst, item)
    -- 检查是否可以接受物品(种子或肉类)
    local seed_name = string.lower(item.prefab .. "_seeds")
    local can_accept = item.components.edible and (Prefabs[seed_name] or item.prefab == "seeds" or item.components.edible.foodtype == "MEAT") 
    
    -- 排除一些特定物品
    if item.prefab == "egg" or item.prefab == "bird_egg" or item.prefab == "rottenegg" or item.prefab == "monstermeat" then
        can_accept = false
    end
    
    return can_accept
end

local function OnRefuseItem(inst, item)
    inst.AnimState:PlayAnimation("flap")  -- 播放拍打动画
    inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage")  -- 播放拍打声音
    inst.AnimState:PushAnimation("idle_bird")  -- 返回空闲动画
end

local function OnGetItemFromPlayer(inst, giver, item)
    -- 如果鸟笼在睡觉则唤醒
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if item.components.edible then
        local seed_name = string.lower(item.prefab .. "_seeds")
        local can_accept = Prefabs[seed_name] or item.prefab == "seeds" or item.components.edible.foodtype == "MEAT"
        if can_accept then
            local seedspawnprefab = "seeds"  -- 默认种子类型
            
            -- 播放啄食动画序列
            inst.AnimState:PlayAnimation("peck")
            inst.AnimState:PushAnimation("peck")
            inst.AnimState:PushAnimation("peck")
            inst.AnimState:PushAnimation("hop")
            inst.AnimState:PushAnimation("idle_bird", true)
            
            -- 60帧后生成产物
            inst:DoTaskInTime(60*FRAMES, function() 
                if item.components.edible.foodtype == "MEAT" then
                    -- 喂肉生成鸟蛋
                    inst.components.lootdropper:SpawnLootPrefab("bird_egg")
                else
                    -- 喂种子生成更多种子
                    if Prefabs[seed_name] then
                        local num_seeds = math.random(2)
                        for k = 1, num_seeds do
                            local loot = inst.components.lootdropper:SpawnLootPrefab(seed_name)
                        end
                        
                        if math.random() < .5 then
                            inst.components.lootdropper:SpawnLootPrefab(seedspawnprefab)
                        end
                    else
                        inst.components.lootdropper:SpawnLootPrefab(seedspawnprefab)
                    end
                end

                -- 如果笼中有鸟，恢复其新鲜度
                if inst.components.occupiable and inst.components.occupiable.occupant 
                and inst.components.occupiable.occupant:IsValid() and inst.components.occupiable.occupant.components.perishable then
                    inst.components.occupiable.occupant.components.perishable:SetPercent(1)         
                end
            end)
        end
    end
end

local function DoIdle(inst)
    -- 随机选择空闲动作
    local r = math.random()
    if r < .5 then
        inst.AnimState:PlayAnimation("caw")  -- 鸣叫
        if inst.chirpsound then
            inst.SoundEmitter:PlaySound(inst.chirpsound)  -- 播放鸟叫声
        end
    elseif r < .6 then
        inst.AnimState:PlayAnimation("flap")  -- 拍打翅膀
        inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage")
    else
        inst.AnimState:PlayAnimation("hop")  -- 跳跃
    end
    inst.AnimState:PushAnimation("idle_bird")  -- 返回空闲状态
end

local function StopIdling(inst)
    if inst.idletask then
        inst.idletask:Cancel()  -- 停止空闲任务
        inst.idletask = nil
    end
end

local function StartIdling(inst)
    inst.idletask = inst:DoPeriodicTask(6, DoIdle)  -- 每6秒执行一次空闲行为
end

local function ShouldSleep(inst)
    -- 有鸟且是晚上时睡觉
    if inst.components.occupiable:IsOccupied() then
       return GetClock():IsNight()
    else
        return false
    end
end

local function ShouldWake(inst)
    -- 白天时醒来
    return GetClock():IsDay()
end


local function onoccupied(inst, bird)
    -- 停止鸟的腐败
    if bird.components.perishable then
        bird.components.perishable:StopPerishing()
    end

    -- 添加睡眠组件
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    -- 启用交易功能
    --inst.components.trader:Enable()
    
    -- 添加容器组件
    inst:AddComponent("container")
    local slotpos = {}
    for y = 2.5, -0.5, -1 do
        for x = 0, 2 do
            table.insert(slotpos, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
        end
    end
	
	-- 定义物品测试函数，决定哪些物品可以放入容器
    local function itemtest(inst, item, slot)
        -- 允许放入的物品
        if item.prefab == "monstermeat" then
            return false
        elseif (item.components.edible and item.components.edible.foodtype == "SEEDS") then
            return true
        -- 或者是有食用组件且食物类型为肉类的物品
        elseif (item.components.edible and item.components.edible.foodtype == "MEAT") then
            return true
		elseif (item.components.edible and item.components.edible.foodtype == "VEGGIE") then
            return true
        else
            -- 如果没有可交易组件，则不允许放入
            if item.components.tradable == nil then
                return false
            end
        end
    end

	-- 将物品测试函数赋给容器的itemtestfn属性
    inst.components.container.itemtestfn = itemtest
	
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chester_shadow_3x4"
    inst.components.container.widgetanimbuild = "ui_chester_shadow_3x4"
    inst.components.container.widgetpos = Vector3(-55,125,0)
    inst.components.container.side_align_tip = 0
    inst.components.container.type = "birdcageitem"
    
	inst.components.container.widgetbuttoninfo = 
	{
    text = "交易",
    position = Vector3(0, -175, 0),
    fn = function(inst)
        if GetClock():IsNight() then return end
        
        local eggs = 0  -- 鸟蛋数量
        local sound_played = false  -- 音效播放标志
        
        -- 遍历所有槽位
        for i=1, #slotpos do
            local item = inst.components.container:GetItemInSlot(i)
            if item ~= nil then
                -- 处理肉类（堆叠数量）
                if item.components.edible and item.components.edible.foodtype == "MEAT" then
                    local stack = item.components.stackable and item.components.stackable:StackSize() or 1
                    eggs = eggs + stack
                    inst.components.container:ConsumeByName(item.prefab, stack)
                    
                    if not sound_played and stack > 0 then
                        GetPlayer().SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
                        sound_played = true
                    end
                
                -- 处理蔬菜（堆叠数量）
                elseif item.components.edible and item.components.edible.foodtype == "VEGGIE" then
                    local stack = item.components.stackable and item.components.stackable:StackSize() or 1
                    local seed_name = string.lower(item.prefab .. "_seeds")
                    inst.components.container:ConsumeByName(item.prefab, stack)
                    
                    -- 对每个蔬菜单独处理（模拟多次交易行为）
                    for n = 1, stack do
                        -- 与OnGetItemFromPlayer函数中的逻辑保持一致
                        if Prefabs[seed_name] then
                            local num_seeds = math.random(2)  -- 1-2个对应种子
                            for k = 1, num_seeds do
                                local loot = inst.components.lootdropper:SpawnLootPrefab(seed_name)
                                if not inst.components.container:GiveItem(loot) then
                                    -- 如果容器满了，直接掉落在地上
                                    loot.Transform:SetPosition(inst.Transform:GetWorldPosition())
                                end
                            end
                            
                            if math.random() < .5 then  -- 50%几率额外普通种子
                                local loot = inst.components.lootdropper:SpawnLootPrefab("seeds")
                                if not inst.components.container:GiveItem(loot) then
                                    loot.Transform:SetPosition(inst.Transform:GetWorldPosition())
                                end
                            end
                        else
                            -- 没有对应种子则生成普通种子
                            local loot = inst.components.lootdropper:SpawnLootPrefab("seeds")
                            if not inst.components.container:GiveItem(loot) then
                                loot.Transform:SetPosition(inst.Transform:GetWorldPosition())
                            end
                        end
                    end
                    
                    if not sound_played and stack > 0 then
                        GetPlayer().SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
                        sound_played = true
                    end
                end
            end
        end
        
        -- 生成鸟蛋（堆叠数量）
        if eggs > 0 then
            for i = 1, eggs do
                local item = inst.components.lootdropper:SpawnLootPrefab("bird_egg")
                if not inst.components.container:GiveItem(item) then
                    -- 如果容器满了，直接掉落在地上
                    item.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end
        end
    end,
    button_style = "white",
	}
	
	
    -- 覆盖鸟的动画符号
    for k,v in pairs(bird_symbols) do
        local build = bird.prefab .. "_build"
        if bird.trappedbuild then
            build = bird.trappedbuild
        end
        inst.AnimState:OverrideSymbol(v, build, v)
    end

    -- 特殊处理海盗鹦鹉的帽子
    if bird.prefab == "parrot_pirate" then
        inst.AnimState:Show("HAT")
    else
        inst.AnimState:Hide("HAT")
    end

    -- 设置鸟叫声
    inst.chirpsound = bird.sounds and bird.sounds.chirp
    inst.AnimState:PlayAnimation("flap")
    inst.AnimState:PushAnimation("idle_bird", true)
    StartIdling(inst)  -- 开始空闲行为
end

local function onemptied(inst, bird)
    inst:RemoveComponent("sleeper")  -- 移除睡眠组件
    StopIdling(inst)  -- 停止空闲行为
    --inst.components.trader:Disable()  -- 禁用交易
    
    -- 移除容器组件
    if inst.components.container then
        inst:RemoveComponent("container")
    end
    
    -- 清除所有鸟的动画覆盖
    for k,v in pairs(bird_symbols) do
        inst.AnimState:ClearOverrideSymbol(v)
    end
    
    inst.AnimState:Hide("HAT")  -- 隐藏帽子
    inst.AnimState:PlayAnimation("idle", true)  -- 播放空闲动画
end


local function onhammered(inst, worker)
    -- 如果有鸟则释放
    if inst.components.occupiable:IsOccupied() then
        local item = inst.components.occupiable:Harvest()
        if item then
            item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            item.components.inventoryitem:OnDropped()
        end
    end
    
    inst.components.lootdropper:DropLoot()  -- 掉落物品
    inst:Remove()  -- 移除鸟笼
end

local function onhit(inst, worker)
    -- 根据是否有鸟播放不同动画
    if inst.components.occupiable:IsOccupied() then
        inst.AnimState:PlayAnimation("hit_bird")
        inst.AnimState:PushAnimation("flap")
        inst.SoundEmitter:PlaySound("dontstarve/birds/wingflap_cage")
        inst.AnimState:PushAnimation("idle_bird", true)
    else
        inst.AnimState:PlayAnimation("hit_idle")
        inst.AnimState:PushAnimation("idle")
    end
end


-- 测试是否可以放入鸟
local function testfn(inst, guy)
    return guy:HasTag("bird")
end

-- 建造完成时的处理
local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")  -- 播放放置动画
    inst.AnimState:PushAnimation("idle")  -- 转为空闲状态
    inst.SoundEmitter:PlaySound("dontstarve/common/craftable/birdcage_craft")  -- 播放建造声音
end

-- 睡眠和唤醒动画
local function GoToSleep(inst)
    if inst.components.occupiable:IsOccupied() then
        StopIdling(inst)
        inst.AnimState:PlayAnimation("sleep_pre")  -- 睡眠准备
        inst.AnimState:PushAnimation("sleep_loop", true)  -- 睡眠循环
    end
end

local function WakeUp(inst)
    if inst.components.occupiable:IsOccupied() then
        inst.AnimState:PlayAnimation("sleep_pst")  -- 睡眠结束
        inst.AnimState:PushAnimation("idle_bird", true)  -- 转为空闲
        StartIdling(inst)  -- 开始空闲行为
    end
end



local function fn(Sim)
    -- 创建实体
    local inst = CreateEntity()
    inst.entity:AddTransform()  -- 添加变换组件
    inst.entity:AddAnimState()  -- 添加动画状态
    inst.entity:AddSoundEmitter()  -- 添加声音发射器
    MakeObstaclePhysics(inst, .5 )  -- 设置物理碰撞
    
    -- 添加小地图图标
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "birdcage.png" )
    
    -- 设置动画
    inst.AnimState:SetBank("birdcage")  -- 动画库
    inst.AnimState:SetBuild("bird_cage")  -- 动画构建
    inst.AnimState:PlayAnimation("idle")  -- 初始动画
    
    inst.AnimState:Hide("HAT")  -- 隐藏帽子
    
    -- 添加标签和组件
    inst:AddTag("structure")  -- 结构标签
    inst:AddComponent("inspectable")  -- 可检查组件
    inst:AddComponent("lootdropper")  -- 掉落组件
    
    -- 可占用组件(用于放入鸟)
    inst:AddComponent("occupiable")
    inst.components.occupiable.occupytestfn = testfn
    inst.components.occupiable.onoccupied = onoccupied
    --inst.components.occupiable.onemptied = onemptied
    
    -- 可工作组件(锤击)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)    
    
    -- 交易组件
    --inst:AddComponent("trader")
    --inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    --inst.components.trader.onaccept = OnGetItemFromPlayer
    --inst.components.trader.onrefuse = OnRefuseItem
    --inst.components.trader:Disable()  -- 初始禁用
    
    MakeSnowCovered(inst, .01)  -- 雪覆盖效果
    
    -- 事件监听
    inst:ListenForEvent( "onbuilt", onbuilt)
    inst:ListenForEvent("gotosleep", function(inst) GoToSleep(inst) end)
    inst:ListenForEvent("onwakeup", function(inst) WakeUp(inst) end)
    
    return inst
end

-- 返回鸟笼预制体和放置器
return Prefab( "common/birdcage", fn, assets, prefabs),
        MakePlacer("common/birdcage_placer", "birdcage", "bird_cage", "idle")


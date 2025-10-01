
local func = {}

function func.Pigking(inst)
	MakeObstaclePhysics(inst, 1.4, .5)
	inst:AddComponent("container")
	local slotpos = {}
	for y = 2.5, -0.5, -1 do
		for x = 0, 2 do
			table.insert(slotpos, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
		end
	end
	local function itemtest(inst, item, slot)
		if item.prefab == "goldnugget"
		or (item.components.edible
			and item.components.edible.foodtype == "MEAT")
		then
			return true
		else
			if item.components.tradable == nil then
				return false
			end
		end
		return item.components.tradable.goldvalue > 0
	end
	inst.components.container.itemtestfn = itemtest
	inst.components.container:SetNumSlots(#slotpos)
	inst.components.container.widgetslotpos = slotpos
	inst.components.container.widgetanimbank = "ui_chester_shadow_3x4"
	inst.components.container.widgetanimbuild = "ui_chester_shadow_3x4"
	inst.components.container.widgetpos = Vector3(-125,125,0)
	inst.components.container.side_align_tip = 0
	inst.components.container.type = "pigkingitem"
	inst.components.container.widgetbuttoninfo =
		{
			text = "交易",
			position = Vector3(0, -175, 0),

			fn = function(inst)
				if GetClock():IsNight() then return end
				local item
				local num = 0
				for i=1, #slotpos do
					item = inst.components.container:GetItemInSlot(i)
					local stack = 1
					if item ~= nil then
						local gold = 0
						if item.components.edible and item.components.edible.foodtype == "MEAT" then
							gold = 1
						end
						if item.components.tradable and item.components.tradable.goldvalue > 0 then
							gold = item.components.tradable.goldvalue
						end
						if  gold > 0 then
							if item.components.stackable then
								stack = item.components.stackable:StackSize()
							end
							num = num + stack * gold
							inst.components.container:ConsumeByName(item.prefab, stack)
						end
					end
				end
				local item = nil
				for i=1, num do
					item = SpawnPrefab("goldnugget")
					inst.components.container:GiveItem(item)
				end
				if item then GetPlayer().SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold") end
			end,
			button_style = "white", 

		}
end

function func.birdcage(inst)
	MakeObstaclePhysics(inst, .5 )
	inst:AddComponent("container")
    -- 定义容器中物品槽的位置
    local slotpos = {}
    -- 使用双层循环创建3x4的网格布局(共12个槽位)
    for y = 2.5, -0.5, -1 do       -- y坐标从2.5到-0.5，步长-1(共4行)
        for x = 0, 2 do             -- x坐标从0到2(共3列)
            -- 计算每个槽位的具体位置，使用Vector3表示3D坐标
            table.insert(slotpos, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
        end
    end
	
    -- 定义物品测试函数，决定哪些物品可以放入容器
    local function itemtest(inst, item, slot)
        -- 允许放入金块
        if item.prefab == "goldnugget" then
            return true
        -- 或者是有食用组件且食物类型为肉类的物品
        elseif (item.components.edible and item.components.edible.foodtype == "MEAT") then
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
    
    -- 设置容器槽位数量为slotpos表的长度(12个)
    inst.components.container:SetNumSlots(#slotpos)
    -- 设置容器UI相关的属性
    inst.components.container.widgetslotpos = slotpos  -- 槽位位置
    inst.components.container.widgetanimbank = "ui_chester_shadow_3x4"  -- 动画库
    inst.components.container.widgetanimbuild = "ui_chester_shadow_3x4"  -- 动画构建
    inst.components.container.widgetpos = Vector3(-125,125,0)  -- 容器UI位置
    inst.components.container.side_align_tip = 0  -- 对齐方式
	inst.components.container.type = "birdcageitem"
	
	
 -- 定义交易按钮的属性和行为
    inst.components.container.widgetbuttoninfo = {
        text = "交易",  -- 按钮文本
        position = Vector3(0, -175, 0),  -- 按钮位置
        -- 按钮点击时的回调函数
        fn = function(inst)
            -- 如果是夜晚，不进行交易
            if GetClock():IsNight() then return end

            local item
            local num = 0  -- 计算总金块数量
            
            -- 遍历所有槽位
            for i=1, #slotpos do
                item = inst.components.container:GetItemInSlot(i)
                local stack = 1  -- 默认堆叠数为1
                
                if item ~= nil then
                    local egg = 0  -- 物品的金块价值
                    
                    -- 如果是肉类食物，价值1金块
                    if item.components.edible and item.components.edible.foodtype == "MEAT" then
                        egg = 1
                    end
                        
                    -- 如果物品有价值
                    if egg > 0 then
                        -- 如果有堆叠组件，获取堆叠数量
                        if item.components.stackable then
                            stack = item.components.stackable:StackSize()
                        end
                        
                        -- 计算总金块数 = 堆叠数 * 每单位价值
                        num = num + stack * egg
                        -- 从容器中消耗掉这些物品
                        inst.components.container:ConsumeByName(item.prefab, stack)
                    end
                end
            end
            
            local item = nil
            -- 根据计算出的金块数量，生成相应数量的金块放入容器
            for i=1, num do
                item = SpawnPrefab("bird_egg")  -- 生成金块
                inst.components.container:GiveItem(item)  -- 将金块放入容器
            end
            
            -- 如果有生成金块，播放音效
            if item then 
                GetPlayer().SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold") 
            end
        end,
        
        button_style = "white",  -- 按钮样式
    }
end



return func

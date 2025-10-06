require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/storeroom.zip"),
	Asset("ANIM", "anim/ui_chest_4x5.zip"),
	Asset("ANIM", "anim/ui_chest_5x8.zip"),
	Asset("ANIM", "anim/ui_chest_5x12.zip"),
	Asset("ANIM", "anim/ui_chest_5x16.zip"),
}

local STOREROOM_SLOTS = GetModConfigData("Slots", STOREROOM_WORK_DIR)
local STOREROOM_DESTROY = GetModConfigData("Destroyable", STOREROOM_WORK_DIR)

local function onopen(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	if GetSeasonManager() and GetSeasonManager().ground_snow_level > SNOW_THRESH then
		inst.AnimState:PlayAnimation("open_snow")
	else
		inst.AnimState:PlayAnimation("open")
	end
end

local function onclose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	if GetSeasonManager() and GetSeasonManager().ground_snow_level > SNOW_THRESH then
		inst.AnimState:PlayAnimation("closed_snow")
	else
		inst.AnimState:PlayAnimation("closed")
	end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.components.container:DropEverything()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	if GetSeasonManager() and GetSeasonManager().ground_snow_level > SNOW_THRESH then
		inst.AnimState:PlayAnimation("hit_snow")
		inst.AnimState:PushAnimation("closed_snow")
	else
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed")
	end
	inst.components.container:Close()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed")
end

local slotpos = {}
if STOREROOM_SLOTS == 20 then
	for y = 3, 0, -1 do
		for x = 0, 4 do
			table.insert(slotpos, Vector3(80*x-346*2+90, 80*y-100*2+130,0))
		end
	end
elseif STOREROOM_SLOTS == 40 then
	for y = 4, 0, -1 do
		for x = 0, 7 do
			table.insert(slotpos, Vector3(80*x-346*2+109, 80*y-100*2+42,0))
		end
	end
elseif STOREROOM_SLOTS == 60 then
	for y = 4, 0, -1 do
		for x = 0, 11 do
			table.insert(slotpos, Vector3(80*x-346*2+98, 80*y-100*2+42,0))
		end
	end
else
	for y = 4, 0, -1 do
		for x = 0, 15 do
			table.insert(slotpos, Vector3(80*x-346*2+91, 80*y-100*2+42,0))
		end
	end
end

local function fn(Sim)
	local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("storeroom.tex")

		MakeObstaclePhysics(inst, 1.2)

		inst:AddTag("icestoreroom")
		inst:AddTag("structure")

		inst.AnimState:SetBank("storeroom")
		inst.AnimState:SetBuild("storeroom")

		inst.AnimState:PlayAnimation("closed", true)

		inst:AddComponent("inspectable")
		inst:AddComponent("container")
		inst.components.container:SetNumSlots(#slotpos)

		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose

		inst.components.container.widgetslotpos = slotpos
		inst.components.container.side_align_tip = 160

		inst:AddComponent("lootdropper")

	-- 原有代码修改为：
if STOREROOM_DESTROY == "DestroyByAll" or STOREROOM_DESTROY == "DestroyByPlayer" then
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
end

-- 单独处理 DestroyByPlayer 的权限限制
if STOREROOM_DESTROY == "DestroyByPlayer" then
    inst.components.workable:SetOnFinishCallback(function(inst, worker)
        if worker and worker.components.playercontroller then
            onhammered(inst, worker)
        else
            -- 非玩家破坏时，重置工作进度并播放拒绝音效
            inst.components.workable:SetWorkLeft(inst.components.workable.workleft)
            inst.SoundEmitter:PlaySound("dontstarve/common/destroy_fail")
        end
    end)
end

    inst:ListenForEvent("snowcoverchange", function()
			if GetSeasonManager() and GetSeasonManager().ground_snow_level > SNOW_THRESH then
				inst.AnimState:PlayAnimation("closed_snow", true)
			else
				inst.AnimState:PlayAnimation("closed", true)
			end
		end, GetWorld())

	return inst
end

return Prefab( "common/cupboard", fn, assets),
	   MakePlacer("common/cupboard_placer", "storeroom", "storeroom", "closed")
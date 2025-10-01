local assets =
{
	Asset("ANIM", "anim/lamp_post2.zip"),    
    Asset("ANIM", "anim/lamp_post2_yotp_build.zip"),
	Asset( "IMAGE", "images/inventoryimages/lamppost.tex" ),
	Asset( "ATLAS", "images/inventoryimages/lamppost.xml" ),
}

TUNING.LAMPPOST_INTENSITY = 0.6

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("on")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    inst.AnimState:PushAnimation("idle", true)
    inst.Light:Enable(true)
	inst.Light:SetIntensity(0)
	inst.components.fader:Fade(0, TUNING.LAMPPOST_INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
    inst.AnimState:Show("FIRE")
    inst.AnimState:Show("GLOW")        
    inst.lighton = true	
end

local function fadeout(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("off")    
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")
	inst.components.fader:Fade(TUNING.LAMPPOST_INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
    inst.AnimState:Hide("FIRE")
    inst.AnimState:Hide("GLOW")        
    inst.lighton = false	
end

local function updatelight(inst)
    if GetClock():IsDusk() or GetClock():IsNight() then
        if not inst.lighton then
            inst:DoTaskInTime(math.random()*2, function() 
                fadein(inst)
            end)

        else            
            inst.Light:Enable(true)
            inst.Light:SetIntensity(TUNING.LAMPPOST_INTENSITY)
        end
    else
        if inst.lighton then
            inst:DoTaskInTime(math.random()*2, function() 
                fadeout(inst)
            end)            
        else
            inst.Light:Enable(false)
            inst.Light:SetIntensity(0)
        end
    end
end

local function onhammered(inst, worker)
    inst.SoundEmitter:KillSound("onsound")
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
    inst:DoTaskInTime(0.3, function() updatelight(inst) end)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst:DoTaskInTime(0, function() updatelight(inst) end)
end

local function fn(Sim)
	local inst = CreateEntity()
    local sound = inst.entity:AddSoundEmitter()

    inst:AddTag("LAMPPOST")
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
  

    local light = inst.entity:AddLight()
    inst.Light:SetIntensity(TUNING.LAMPPOST_INTENSITY)
    inst.Light:SetColour(197/255, 197/255, 10/255)
    inst.Light:SetFalloff( 0.9 )
    inst.Light:SetRadius( 5 )
    inst.Light:Enable(false)
    
    --inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("lamppost.tex")
	
    inst.AnimState:SetBank("lamp_post")
    inst.AnimState:SetBuild("lamp_post2_yotp_build")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:Hide("FIRE")
    inst.AnimState:Hide("GLOW")    

    inst.AnimState:SetRayTestOnBB(true);

    inst:AddTag("lightsource")

    inst:AddTag("city_hammerable")
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)    

    inst:AddComponent("fader")

    inst:ListenForEvent( "daytime", function()
        inst:DoTaskInTime(1/30, function() updatelight(inst) end)
    end, GetWorld())
    inst:ListenForEvent( "dusktime", function()
        inst:DoTaskInTime(1/30, function() updatelight(inst) end)
    end, GetWorld())

    inst:ListenForEvent("onbuilt", onbuilt)

    inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then 
                fadein(inst)
                inst.Light:Enable(true)
                inst.Light:SetIntensity(TUNING.LAMPPOST_INTENSITY)            
                inst.AnimState:Show("FIRE")
                inst.AnimState:Show("GLOW")        
                inst.lighton = true
            end
        end
    end

	return inst
end

return Prefab( "common/objects/lamppost", fn, assets),
MakePlacer("common/lamppost_placer", "lamp_post", "lamp_post2_yotp_build", "idle", false, false, true)


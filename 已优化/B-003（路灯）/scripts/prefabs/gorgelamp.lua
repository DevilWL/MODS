local assets =
{
	Asset("ANIM", "anim/quagmire_lamp_post.zip"), 	
	Asset( "IMAGE", "images/inventoryimages/gorgelamp.tex" ),
	Asset( "ATLAS", "images/inventoryimages/gorgelamp.xml" ),
}

TUNING.LAMPPOST_INTENSITY = 0.6

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    inst.AnimState:PushAnimation("idle", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")	
    inst.Light:Enable(true)
	inst.Light:SetIntensity(0)
	inst.components.fader:Fade(0, TUNING.LAMPPOST_INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
    inst.AnimState:Show("FIRE")
    inst.AnimState:Show("GLOW")        
    inst.lighton = true	
end

local function fadeout(inst)
    inst.components.fader:StopAll()   
    inst.AnimState:PushAnimation("full", true)
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
    inst.AnimState:PlayAnimation("full")
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
    inst.Light:SetColour(235/255, 235/255, 235/255)
    inst.Light:SetFalloff( 0.9 )
    inst.Light:SetRadius( 5 )
    inst.Light:Enable(false)
    
    --inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("gorgelamp.tex")
	
    inst.AnimState:SetBank("quagmire_lamp_post")
    inst.AnimState:SetBuild("quagmire_lamp_post")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")	

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

return Prefab( "common/objects/gorgelamp", fn, assets),
MakePlacer("common/gorgelamp_placer", "quagmire_lamp_post", "quagmire_lamp_post", "idle", false, false, true)


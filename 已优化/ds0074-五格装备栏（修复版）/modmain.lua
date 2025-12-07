-- Backpack and Amulet Mod by tehMug(wump)
-- Six Feet Under Update
-- 11.0 BIG UI change - Nightmare
-- 10.7 - Hunger - Amulet slot added - Thanks to kiopho
-- v10.5 tehMugwump for 'Powers'
-- v10.5 updated by tehMugwump for [Powers]
-- v10 updated by alks for "It's Not a Rock" update
-- v9 Updated by alks for 'Live Update'
-- v8 Updated by WrathOf for 'The End is Nigh' update
-- Discussion Thread: http://forums.kleientertainment.com/showthread.php?10462
-- originally by Fontonkonbonmon
-------------------------------------------------------------------------------
Assets =
{

    Asset("ATLAS", "images/newslots.xml"),
    Asset("IMAGE", "images/newslots.tex"),
    
}



function backpackpostinit(inst)
	inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.BACK
end

function amuletpostinit(inst)
	inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK
end

function inventorypostinit(component,inst)
	inst.components.inventory.numequipslots = 5
end

function gamepostinit()
	--print "asdf"
end
---------------- kiopho is totally to thanks for the following code! ---------------
local function amuletpostinit(inst)
	inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK
end

AddPrefabPostInit("amulet", amuletpostinit)
AddPrefabPostInit("blueamulet", amuletpostinit)
AddPrefabPostInit("purpleamulet", amuletpostinit)
AddPrefabPostInit("orangeamulet", amuletpostinit)
AddPrefabPostInit("greenamulet", amuletpostinit)
AddPrefabPostInit("yellowamulet", amuletpostinit)
--

local function resurrectableinit(inst)
	inst.CanResurrect = function (self)
		local player = GLOBAL.GetPlayer()
		local item = nil
		if self.inst.components.inventory then
			item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
		end
		
		if item and item.prefab == "amulet" then
			return true
		end

		local res = self:FindClosestResurrector()
		if res then
			return true
		end
	end

	inst.DoResurrect = function (self)
		local player = GLOBAL.GetPlayer()
		local item = nil
		self.inst:PushEvent("resurrect")
		if self.inst.components.inventory then
			item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
			if item and item.prefab == "amulet" then
				self.inst.sg:GoToState("amulet_rebirth")
				return true
			end
		end
	
		local res = self:FindClosestResurrector()
		if res and res.components.resurrector then
			res.components.resurrector:Resurrect(self.inst)
			return true
		end
	end

end


local function setFn(states, stateName, functionName, Fn)

	for k,v in pairs(states) do
		if(v.name == stateName) then
			v[functionName] = Fn
			break
		end
	end
	
end

local function editStateFn(SGname, stateName, functionName, Fn)

	 for k,v in pairs(GLOBAL.SGManager.instances) do	
		if(k.sg.name == SGname) then
			setFn(k.sg.states, stateName, functionName, Fn)
			break
		end
	 end
	 
end

local function newOnExit(inst)

	inst.components.hunger:SetPercent(2/3)
	inst.components.health:Respawn(TUNING.RESURRECT_HEALTH)
	        
	if inst.components.sanity then
		inst.components.sanity:SetPercent(.5)
	end
	
	local item = nil
	if inst.components.inventory then
		item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
	end
	if item and item.prefab == "amulet" then
		item = inst.components.inventory:RemoveItem(item)
	end
	
	if item then
		item:Remove()
		item.persists = false
	end

	inst.HUD:Show()
	GLOBAL.TheCamera:SetDefault()
	inst.components.playercontroller:Enable(true)
    inst.AnimState:ClearOverrideSymbol("FX")

end
--------------------------------------

AddComponentPostInit("inventory", inventorypostinit)

AddPrefabPostInit("backpack", backpackpostinit)
AddPrefabPostInit("krampus_sack", backpackpostinit)
AddPrefabPostInit("piggyback", backpackpostinit)
AddPrefabPostInit("thatchpack", backpackpostinit)
AddComponentPostInit("resurrectable", resurrectableinit)
AddPrefabPostInit("amulet", amuletpostinit)
AddPrefabPostInit("purpleamulet", amuletpostinit)
AddPrefabPostInit("blueamulet", amuletpostinit)
AddPrefabPostInit("orangeamulet", amuletpostinit)

AddSimPostInit(gamepostinit)


table.insert(GLOBAL.EQUIPSLOTS, "BACK")
GLOBAL.EQUIPSLOTS.BACK = "back"
table.insert(GLOBAL.EQUIPSLOTS, "NECK")
GLOBAL.EQUIPSLOTS.NECK = "neck"
AddSimPostInit(function() editStateFn("wilson", "amulet_rebirth" ,"onexit", newOnExit) end)

--//we are going to hotwire the PlayerHud:SetMainCharacter function to fix up the inventory widget to use our new stuff
--big thanks to @Kevin:
AddClassPostConstruct("screens/playerhud", function(self) 
    local oldfn = self.SetMainCharacter
    function self:SetMainCharacter(maincharacter)
        
        --//call the old version of the function
        oldfn(self, maincharacter)
        
        --//new equip slot adding API!
        self.controls.inv:AddEquipSlot(GLOBAL.EQUIPSLOTS.BACK, "images/newslots.xml", "back.tex")
        self.controls.inv:AddEquipSlot(GLOBAL.EQUIPSLOTS.NECK, "images/newslots.xml", "neck.tex")

--self.controls.inv:AddEquipSlot(GLOBAL.EQUIPSLOTS.BACK, "images/hud.xml", "equip_slot_body.tex")
--self.controls.inv:AddEquipSlot(GLOBAL.EQUIPSLOTS.NECK, "images/hud.xml", "equip_slot_body.tex")
        
        --//make the background fit the new images
 self.controls.inv.bg:SetScale(1.27,1,1)--上半部
 self.controls.inv.bgcover:SetScale(1.27,1,1)
          -- changed with Six Feet Under update

        --//open the backpack in its new location
        local bp = maincharacter.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK)
        if bp and bp.components.container then
            bp.components.container:Close()
            bp.components.container:Open(maincharacter)
        end
    end
end)

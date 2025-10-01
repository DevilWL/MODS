function vanilaPerishable(component)
	component.newUpdate = function (inst, dt)
		if inst.components.perishable then

			local modifier = 1
			local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
			if owner then
				if owner:HasTag("fridge") then
					modifier = TUNING.PERISH_FRIDGE_MULT
				elseif owner:HasTag("spoiler") then
					modifier = TUNING.PERISH_GROUND_MULT
----------------------------------
				elseif owner:HasTag("icestoreroom") then
					modifier = TUNING.PERISH_STOREROOM_MULT
				end
----------------------------------
			else
				modifier = TUNING.PERISH_GROUND_MULT
			end

			if _G.GetSeasonManager() and _G.GetSeasonManager():GetCurrentTemperature() < 0 then
				modifier = modifier * TUNING.PERISH_WINTER_MULT
			end

			modifier = modifier * TUNING.PERISH_GLOBAL_MULT

			local old_val = inst.components.perishable.perishremainingtime
			inst.components.perishable.perishremainingtime = inst.components.perishable.perishremainingtime - dt*modifier
			if math.floor(old_val*100) ~= math.floor(inst.components.perishable.perishremainingtime*100) then
				inst:PushEvent("perishchange", {percent = inst.components.perishable:GetPercent()})
			end

			--trigger the next callback
			if inst.components.perishable.perishremainingtime <= 0 then
				inst.components.perishable:Perish()
			end
		end

		--print("Perishable:Update is working")
	end

	component.LongUpdate = function(self, dt)
		component.newUpdate(self.inst, dt)

		--print("Perishable:LongUpdate is working")
	end

	component.StartPerishing = function(self)
		if self.updatetask then
			self.updatetask:Cancel()
			self.updatetask = nil
		end

		local dt = 10 + math.random()*_G.FRAMES*8

		if dt > 0 then
			self.updatetask = self.inst:DoPeriodicTask(dt, component.newUpdate, math.random()*2, dt)
		else
			component:newUpdate(self.inst, 0)
		end

		--print("Perishable:StartPerishing is working")
	end

end

AddComponentPostInit("perishable", vanilaPerishable)
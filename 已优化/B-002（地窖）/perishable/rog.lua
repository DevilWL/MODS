function rogPerishable(component)
	component.newUpdate = function (inst, dt)
		if inst.components.perishable then

			local modifier = 1
			local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
			if owner then
				if owner:HasTag("fridge") then
					if inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
						modifier = TUNING.PERISH_COLD_FROZEN_MULT
					else
						modifier = TUNING.PERISH_FRIDGE_MULT
					end
				elseif owner:HasTag("spoiler") then
					modifier = TUNING.PERISH_GROUND_MULT
----------------------------------
				elseif owner:HasTag("icestoreroom") then
					if inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
						modifier = TUNING.PERISH_COLD_FROZEN_MULT
					else
						modifier = TUNING.PERISH_STOREROOM_MULT
					end
----------------------------------
				end
			else
				modifier = TUNING.PERISH_GROUND_MULT
			end

			-- Cool off hot foods over time (faster if in a fridge)
			if inst.components.edible and inst.components.edible.temperaturedelta and inst.components.edible.temperaturedelta > 0 then
				if owner and owner:HasTag("fridge") then
					if not owner:HasTag("nocool") then
						inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - 1
					end
				elseif _G.GetSeasonManager() and _G.GetSeasonManager():GetCurrentTemperature() < TUNING.OVERHEAT_TEMP - 5 then
					inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - .25
				end
				if inst.components.edible.temperatureduration < 0 then inst.components.edible.temperatureduration = 0 end
			end

			local mm = _G.GetWorld().components.moisturemanager
			if mm:IsEntityWet(inst) then
				modifier = modifier * TUNING.PERISH_WET_MULT
			end

			if _G.GetSeasonManager() and _G.GetSeasonManager():GetCurrentTemperature() < 0 then
				if inst:HasTag("frozen") and not inst.components.perishable.frozenfiremult then
					modifier = TUNING.PERISH_COLD_FROZEN_MULT
				else
					modifier = modifier * TUNING.PERISH_WINTER_MULT
				end
			end

			if inst.components.perishable.frozenfiremult then
				modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
			end

			if _G.GetSeasonManager() and _G.GetSeasonManager():GetCurrentTemperature() > TUNING.OVERHEAT_TEMP then
				modifier = modifier * TUNING.PERISH_SUMMER_MULT
			end

			modifier = modifier * TUNING.PERISH_GLOBAL_MULT

			local old_val = inst.components.perishable.perishremainingtime
			local delta = dt or (10 + math.random()*FRAMES*8)
			inst.components.perishable.perishremainingtime = inst.components.perishable.perishremainingtime - delta*modifier
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
		if self.updatetask then
			component.newUpdate(self.inst, dt or 0)
			--print("Perishable:LongUpdate is working")
		end
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

AddComponentPostInit("perishable", rogPerishable)
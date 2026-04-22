if SERVER then
	util.AddNetworkString("Init_GSS")

	hook.Add("simfphysOnSpawn", "Simfphys_Willi302_GSS_Spawn_SERVER", function(v)
		local gss = GetCapability(v, "gss") or v.GSS
		if not gss then return end

		v.GSS = gss
		SetEntityCapability(v, "gss", gss)

		local rf = RecipientFilter()
		rf:AddAllPlayers()

		net.Start("Init_GSS")
			net.WriteEntity(v)
			net.WriteString(gss.Whine_Sound)
			net.WriteString(gss.Shift_Sound or "")
			net.WriteFloat(gss.Vol_Start)
			net.WriteFloat(gss.Vol_End)
			net.WriteFloat(gss.Vol_Max)
			net.WriteFloat(gss.Pitch_Mult)
			net.WriteTable(v.Gears or {})
		net.Send(rf)
	end)
end

if CLIENT then
	net.Receive("Init_GSS", function()
		local v = net.ReadEntity()
		if not IsValid(v) then return end

		local gss = {
			Whine_Sound = net.ReadString(),
			Shift_Sound = net.ReadString(),
			Vol_Start = net.ReadFloat(),
			Vol_End = net.ReadFloat(),
			Vol_Max = net.ReadFloat(),
			Pitch_Mult = net.ReadFloat(),
			Gears = net.ReadTable(),
		}

		v.GSS = gss
		SetEntityCapability(v, "gss", gss)
		v.gearwhine_sound = CreateSound(v, gss.Whine_Sound)
		v.oldgear = v:GetGear()
		v.gearfraction = 0
	end)

	hook.Add("EntityRemoved", "Simfphys_Willi302_GSS_Remove", function(v)
		if v:GetClass() ~= "gmod_sent_vehicle_fphysics_base" then return end
		if not v.GSS or not v.gearwhine_sound then return end
		v.gearwhine_sound:Stop()
	end)

	hook.Add("PostDrawTranslucentRenderables", "Simfphys_Willi302_GSS_Render", function()
		if not GetConVar("cl_simfphys_gearbox_sound_system"):GetBool() then return end

		for _, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
			local gss = GetCapability(v, "gss") or v.GSS
			if gss and v.gearwhine_sound then
				if v:GetGear() ~= v.oldgear then
				v.oldgear = v:GetGear()
				v.gearfraction = 0

				if gss.Shift_Sound ~= "" and v:GetGear() == 1 then
					v:EmitSound(gss.Shift_Sound, 80, 100, v:GetRPM() > 0 and 1 or 0)
				end
			else
				v.gearfraction = math.Clamp(v.gearfraction + 0.005, 0, 1)
			end

			v.gearwhine_mult = Lerp(math.ease.OutBounce(v.gearfraction), 0.5, 1)
			v.gearwhine_vol = math.Clamp((v:GetRPM() - gss.Vol_Start) / gss.Vol_End, 0, gss.Vol_Max)
				* math.Clamp(0.5 + v:GetThrottle() * 3, 0.5, 2)
				* (1 - v:GetClutch())
				* (v:GetGear() == 1 and 2 or 1)

			local gear_table = gss.Gears or v.Gears or {}
			local current_gear_ratio = gear_table[v:GetGear()] or 1
			if v:GetGear() > 1 then
				v.gearwhine_pitch = v:GetRPM() / 10 * current_gear_ratio * v.gearwhine_mult * gss.Pitch_Mult
			else
				v.gearwhine_pitch = v:GetRPM() / 5 * (-current_gear_ratio) * v.gearwhine_mult * gss.Pitch_Mult
			end

				v.gearwhine_sound:PlayEx(v.gearwhine_vol, v.gearwhine_pitch)
			end
		end
	end)
end

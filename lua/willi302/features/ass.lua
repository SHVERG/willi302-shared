if SERVER then
	util.AddNetworkString("Init_ASS")

	hook.Add("simfphysOnSpawn", "Simfphys_Willi302_ASS_Spawn_SERVER", function(v)
		local ass = GetCapability(v, "ass") or v.ASS
		if not ass then return end

		v.ASS = ass
		SetEntityCapability(v, "ass", ass)

		local rf = RecipientFilter()
		rf:AddAllPlayers()

		net.Start("Init_ASS")
			net.WriteEntity(v)
			net.WriteFloat(ass.Degree)
			net.WriteString(ass.Bone)
			net.WriteFloat(ass.Angle_P)
			net.WriteFloat(ass.Angle_Y)
			net.WriteFloat(ass.Angle_R)
		net.Send(rf)
	end)
end

if CLIENT then
	net.Receive("Init_ASS", function()
		local v = net.ReadEntity()
		if not IsValid(v) then return end

		local ass = {
			Degree = net.ReadFloat(),
			Bone = net.ReadString(),
			Angle_P = net.ReadFloat(),
			Angle_Y = net.ReadFloat(),
			Angle_R = net.ReadFloat(),
		}

		v.ASS = ass
		SetEntityCapability(v, "ass", ass)
	end)

	hook.Add("PostDrawTranslucentRenderables", "Simfphys_Willi302_ASS_Render", function()
		if not GetConVar("cl_simfphys_advanced_steering_enabled"):GetBool() then return end

		for _, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
			local ass = GetCapability(v, "ass") or v.ASS
			if ass then
				local degree = GetConVar("cl_simfphys_advanced_steering_degree"):GetInt()
			local degree_cust = -v:GetVehicleSteer() * (degree - ass.Degree) / 2

			if not v.advanced_steering_degree then
				v.advanced_steering_degree = 0
			end

			v.advanced_steering_degree = Lerp(
				1 - GetConVar("cl_simfphys_advanced_steering_smoothness"):GetFloat(),
				v.advanced_steering_degree,
				degree_cust
			)

				v:ManipulateBoneAngles(
					v:LookupBone(ass.Bone),
					Angle(
						v.advanced_steering_degree * ass.Angle_P,
						v.advanced_steering_degree * ass.Angle_Y,
						v.advanced_steering_degree * ass.Angle_R
					)
				)
			end
		end
	end)
end

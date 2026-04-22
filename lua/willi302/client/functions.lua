hook.Add("InitPostEntity", "Simfphys_Willi302_Routes_Ready", function()
	net.Start("Simfphys_Routes_Client_Ready")
	net.SendToServer()
end)

function InitLerpSubs(v) --- Smooth Submaterials Initialization
	if not v.sublights then return end

	for i, light in pairs(v.sublights) do
		if not v.sublights_mats then v.sublights_mats = {} end
		local string_data = file.Read("materials/" .. light.mat .. ".vmt", "GAME")
		v.sublights_mats[i] = CreateMaterial(light.id .. v:GetClass() .. v:EntIndex(), "VertexLitGeneric", util.KeyValuesToTable(string_data))
	end
end

hook.Add("PostDrawTranslucentRenderables", "Simfphys_Willi302_Submaterials", function()
	for _, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
		if v.sublights_mats then
			for i, light in pairs(v.sublights) do
			local mat = v.sublights_mats[i]

			mat:SetFloat("$detailblendfactor", (
					light.trigger == "fog" and v:GetFogLightsEnabled() or
					light.trigger == "brake" and v:GetIsBraking() or
					light.trigger == "light" and v:GetLightsEnabled() or
					light.trigger == "lamp" and v:GetLampsEnabled() or
					light.trigger == "rev" and v:GetGear() == 1 or
					light.trigger == "turn_r" and v.flashnum == 1 and v.signal_right or
					light.trigger == "turn_l" and v.flashnum == 1 and v.signal_left or
					light.trigger == "engine" and v:GetRPM() > 0
				) and
				math.Clamp(Lerp(light.fadein, mat:GetFloat("$detailblendfactor"), 2), 0, 1) or
				math.Clamp(Lerp(light.fadeout, mat:GetFloat("$detailblendfactor"), -1), 0, 1)
			)

				v:SetSubMaterial(light.id, "!" .. light.id .. v:GetClass() .. v:EntIndex())
			end
		end
	end
end)

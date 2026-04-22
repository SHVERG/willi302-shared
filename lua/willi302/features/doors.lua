if not SERVER then return end

local function get_doors_capability(v)
	return GetCapability(v, "doors") or v.Doors
end

hook.Add("PlayerButtonDown", "Simfphys_Willi302_Doors_KEY_DOWN", function(ply, key)
	if ply:GetSimfphys() == NULL then return end
	local v = ply:GetSimfphys()
	local doors = get_doors_capability(v)
	if not doors then return end

	if doors.Driver and key == GetConVar("cl_simfphys_bus_door_driver"):GetInt() then
		if doors.Driver.pos == 1.1 then
			doors.Driver.pos = -0.1
			v:EmitSound(doors.Driver.sound_close, 75, doors.Driver.pitch or 100)
		else
			doors.Driver.pos = 1.1
			v:EmitSound(doors.Driver.sound_open, 75, doors.Driver.pitch or 100)
		end
	end

	if doors.Front and key == GetConVar("cl_simfphys_bus_door_front"):GetInt() then
		if doors.Front.pos == 1.1 then
			doors.Front.pos = -0.1
			v:EmitSound(doors.Front.sound_close, 75, doors.Front.pitch or 100)
		else
			doors.Front.pos = 1.1
			v:EmitSound(doors.Front.sound_open, 75, doors.Front.pitch or 100)
		end
	end

	if doors.Middle and key == GetConVar("cl_simfphys_bus_door_middle"):GetInt() then
		if doors.Middle.pos == 1.1 then
			doors.Middle.pos = -0.1
			v:EmitSound(doors.Middle.sound_close, 75, doors.Middle.pitch or 100)
		else
			doors.Middle.pos = 1.1
			v:EmitSound(doors.Middle.sound_open, 75, doors.Middle.pitch or 100)
		end
	end

	if doors.Rear and key == GetConVar("cl_simfphys_bus_door_rear"):GetInt() then
		if doors.Rear.pos == 1.1 then
			doors.Rear.pos = -0.1
			v:EmitSound(doors.Rear.sound_close, 75, doors.Rear.pitch or 100)
		else
			doors.Rear.pos = 1.1
			v:EmitSound(doors.Rear.sound_open, 75, doors.Rear.pitch or 100)
		end
	end

	if key == GetConVar("cl_simfphys_bus_doors_open"):GetInt() then
		if doors.Front and doors.Front.pos == -0.1 then
			doors.Front.pos = 1.1
			v:EmitSound(doors.Front.sound_open, 75, doors.Front.pitch or 100)
		end
		if doors.Middle and doors.Middle.pos == -0.1 then
			doors.Middle.pos = 1.1
			v:EmitSound(doors.Middle.sound_open, 75, doors.Middle.pitch or 100)
		end
		if doors.Rear and doors.Rear.pos == -0.1 then
			doors.Rear.pos = 1.1
			v:EmitSound(doors.Rear.sound_open, 75, doors.Rear.pitch or 100)
		end
	end

	if key == GetConVar("cl_simfphys_bus_doors_close"):GetInt() then
		if doors.Front and doors.Front.pos == 1.1 then
			doors.Front.pos = -0.1
			v:EmitSound(doors.Front.sound_close, 75, doors.Front.pitch or 100)
		end
		if doors.Middle and doors.Middle.pos == 1.1 then
			doors.Middle.pos = -0.1
			v:EmitSound(doors.Middle.sound_close, 75, doors.Middle.pitch or 100)
		end
		if doors.Rear and doors.Rear.pos == 1.1 then
			doors.Rear.pos = -0.1
			v:EmitSound(doors.Rear.sound_close, 75, doors.Rear.pitch or 100)
		end
	end

	if doors ~= v.Doors then
		v.Doors = doors
	end
end)

hook.Add("Think", "Simfphys_Willi302_Doors_ANIMS", function()
	for _, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
		local doors = get_doors_capability(v)
		if doors then

			if doors.Driver then
			v:SetPoseParameter(doors.Driver.anim, Lerp(doors.Driver.speed, v:GetPoseParameter(doors.Driver.anim), doors.Driver.pos))
		end

		if doors.Front then
			v:SetPoseParameter(doors.Front.anim, Lerp(doors.Front.speed, v:GetPoseParameter(doors.Front.anim), doors.Front.pos))
		end

		if doors.Middle then
			v:SetPoseParameter(doors.Middle.anim, Lerp(doors.Middle.speed, v:GetPoseParameter(doors.Middle.anim), doors.Middle.pos))
		end

		if doors.Rear then
			v:SetPoseParameter(doors.Rear.anim, Lerp(doors.Rear.speed, v:GetPoseParameter(doors.Rear.anim), doors.Rear.pos))
		end

			if doors ~= v.Doors then
				v.Doors = doors
			end
		end
	end
end)

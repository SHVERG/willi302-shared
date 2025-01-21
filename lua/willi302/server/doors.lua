hook.Add("PlayerButtonDown", "Simfphys_Willi302_Doors_KEY_DOWN", function(ply, key) --- On/Off Routes Processing
	if ply:GetSimfphys() != NULL then
		local v = ply:GetSimfphys()
		if !v.Doors then return end
		
		if v.Doors.Driver and key == GetConVar( "cl_simfphys_bus_door_driver" ):GetInt() then
			if v.Doors.Driver.pos == 1.1 then
				v.Doors.Driver.pos = -0.1
				v:EmitSound(v.Doors.Driver.sound_close, 75, v.Doors.Driver.pitch or 100)
			else
				v.Doors.Driver.pos = 1.1
				v:EmitSound(v.Doors.Driver.sound_open, 75, v.Doors.Driver.pitch or 100)
			end
		end
		
		if v.Doors.Front and key == GetConVar( "cl_simfphys_bus_door_front" ):GetInt() then
			if v.Doors.Front.pos == 1.1 then
				v.Doors.Front.pos = -0.1
				v:EmitSound(v.Doors.Front.sound_close, 75, v.Doors.Front.pitch or 100)
			else
				v.Doors.Front.pos = 1.1
				v:EmitSound(v.Doors.Front.sound_open, 75, v.Doors.Front.pitch or 100)
			end
		end
		
		if v.Doors.Middle and key == GetConVar( "cl_simfphys_bus_door_middle" ):GetInt() then
			if v.Doors.Middle.pos == 1.1 then
				v.Doors.Middle.pos = -0.1
				v:EmitSound(v.Doors.Middle.sound_close, 75, v.Doors.Middle.pitch or 100)
			else
				v.Doors.Middle.pos = 1.1
				v:EmitSound(v.Doors.Middle.sound_open, 75, v.Doors.Middle.pitch or 100)
			end
		end
		
		if v.Doors.Rear and key == GetConVar( "cl_simfphys_bus_door_rear" ):GetInt() then
			if v.Doors.Rear.pos == 1.1 then
				v.Doors.Rear.pos = -0.1
				v:EmitSound(v.Doors.Rear.sound_close, 75, v.Doors.Rear.pitch or 100)
			else
				v.Doors.Rear.pos = 1.1
				v:EmitSound(v.Doors.Rear.sound_open, 75, v.Doors.Rear.pitch or 100)
			end
		end
		
		if key == GetConVar( "cl_simfphys_bus_doors_open" ):GetInt() then
			if v.Doors.Front and v.Doors.Front.pos == -0.1 then
				v.Doors.Front.pos = 1.1
				v:EmitSound(v.Doors.Front.sound_open, 75, v.Doors.Front.pitch or 100)
			end
			if v.Doors.Middle and v.Doors.Middle.pos == -0.1 then
				v.Doors.Middle.pos = 1.1
				v:EmitSound(v.Doors.Middle.sound_open, 75, v.Doors.Middle.pitch or 100)
			end
			if v.Doors.Rear and v.Doors.Rear.pos == -0.1 then
				v.Doors.Rear.pos = 1.1
				v:EmitSound(v.Doors.Rear.sound_open, 75, v.Doors.Rear.pitch or 100)
			end
		end
		
		if key == GetConVar( "cl_simfphys_bus_doors_close" ):GetInt() then
			if v.Doors.Front and v.Doors.Front.pos == 1.1 then
				v.Doors.Front.pos = -0.1
				v:EmitSound(v.Doors.Front.sound_close, 75, v.Doors.Front.pitch or 100)
			end
			if v.Doors.Middle and v.Doors.Middle.pos == 1.1 then
				v.Doors.Middle.pos = -0.1
				v:EmitSound(v.Doors.Middle.sound_close, 75, v.Doors.Middle.pitch or 100)
			end
			if v.Doors.Rear and v.Doors.Rear.pos == 1.1 then
				v.Doors.Rear.pos = -0.1
				v:EmitSound(v.Doors.Rear.sound_close, 75, v.Doors.Rear.pitch or 100)
			end
		end
	end
end)

hook.Add("Think", "Simfphys_Willi302_Doors_ANIMS", function()
	for k,v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
		if v.Doors then
			
			if v.Doors.Driver then
				v:SetPoseParameter(v.Doors.Driver.anim, Lerp(v.Doors.Driver.speed, v:GetPoseParameter(v.Doors.Driver.anim), v.Doors.Driver.pos))
			end
			
			if v.Doors.Front then
				v:SetPoseParameter(v.Doors.Front.anim, Lerp(v.Doors.Front.speed, v:GetPoseParameter(v.Doors.Front.anim), v.Doors.Front.pos))
			end
			
			if v.Doors.Middle then
				v:SetPoseParameter(v.Doors.Middle.anim, Lerp(v.Doors.Middle.speed, v:GetPoseParameter(v.Doors.Middle.anim), v.Doors.Middle.pos))
			end
			
			if v.Doors.Rear then
				v:SetPoseParameter(v.Doors.Rear.anim, Lerp(v.Doors.Rear.speed, v:GetPoseParameter(v.Doors.Rear.anim), v.Doors.Rear.pos))
			end
			
			
			
		end
	end
end)
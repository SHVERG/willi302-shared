hook.Add( "InitPostEntity", "Simfphys_Willi302_Routes_Ready", function()
	net.Start( "Simfphys_Routes_Client_Ready" )
	net.SendToServer()
end )

function InitLerpSubs(v) --- Smooth Submaterials Initialization
	if !v.sublights then return end
	
	for i, light in pairs(v.sublights) do
		if !v.sublights_mats then v.sublights_mats = {} end
		local string_data = file.Read( "materials/"..light.mat..".vmt", "GAME" )
		v.sublights_mats[i] = CreateMaterial( light.id..v:GetClass()..v:EntIndex(), "VertexLitGeneric", util.KeyValuesToTable( string_data ) )
	end
end

--- SERVER2CLIENT

hook.Add( "OnEntityCreated", "Simfphys_Willi302_Car_Spawned_CLIENT", function( v )
	if v:GetClass() == "gmod_sent_vehicle_fphysics_base" then
	-- Get ASS data from client
		net.Receive("Init_ASS", function()
			if v == net.ReadEntity() then
				v.ASS = {}
				v.ASS.Degree = net.ReadFloat()
				v.ASS.Bone = net.ReadString()
				v.ASS.Angle_P = net.ReadFloat()
				v.ASS.Angle_Y = net.ReadFloat()
				v.ASS.Angle_R = net.ReadFloat()
			end
		end)

	-- Get GSS data from client
		net.Receive("Init_GSS", function()
			if v == net.ReadEntity() then
				v.GSS = {}
				v.GSS.Whine_Sound = net.ReadString()
				v.GSS.Shift_Sound = net.ReadString()
				v.GSS.Vol_Start = net.ReadFloat()
				v.GSS.Vol_End = net.ReadFloat()
				v.GSS.Vol_Max = net.ReadFloat()
				v.GSS.Pitch_Mult = net.ReadFloat()
				v.GSS.Gears = net.ReadTable()
			end
			
			-- Create gear sound
			v.gearwhine_sound = CreateSound(v, v.GSS.Whine_Sound)
			v.oldgear = v:GetGear()
			v.gearfraction = 0
		end)
		
		-- Adding ASS params from list (for old ports)
		
		for k, car in pairs(vehs_steering) do
			if v:GetModel() == car.model then
				v.ASS = {}
				v.ASS.Degree = car.degree
				v.ASS.Bone = car.bone
				v.ASS.Angle_P = car.angle_p
				v.ASS.Angle_Y = car.angle_y
				v.ASS.Angle_R = car.angle_r
			end
		end
	end
end )

--- On Remove

hook.Add( "EntityRemoved", "Simfphys_Willi302_Car_Removed", function(v)
	if v:GetClass() == "gmod_sent_vehicle_fphysics_base" then
		if v.GSS then
			v.gearwhine_sound:Stop()
		end
	end
end)

--- Main Hook

hook.Add("PostDrawTranslucentRenderables", "Simfphys_Willi302_LightsAndStuff", function()
	
--- Routes ON/OFF
	
	net.Receive("Simfphys_Willi302_Shared_ON_OFF_Routes", function()
		v = net.ReadEntity()
		v.route_state = net.ReadInt(3)
	end)

--- Route Change Processing

	net.Receive("Simfphys_Change_Routes", function() 
		ent = net.ReadEntity()
		local route_type = net.ReadInt(3)
		if route_type == 0 then
			ent.route_num = net.ReadString()
		elseif route_type == 1 then
			ent.route_letter = net.ReadString()
		elseif route_type == 2 then
			ent.route1 = net.ReadString()
		else
			ent.route2 = net.ReadString()
		end
	end)
	
	for k, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
		
--- Smooth Submaterials
		
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
				
				v:SetSubMaterial(light.id, "!"..light.id..v:GetClass()..v:EntIndex())
			end
		end
		
--- Routes Visualization
		
		for m, veh in pairs(vehs_routes) do
			if v:GetModel():lower() == veh.model:lower() and v.route_state == 1 then
				for i, val in pairs(veh.nums) do
					cam.Start3D2D(v:LocalToWorld(val.pos),v:LocalToWorldAngles(val.ang), val.size )
						surface.SetDrawColor(255,255,255)
						draw.SimpleText( v.route_num or "--" , veh.nums_font, 0, 0, veh.color, val.align, TEXT_ALIGN_CENTER)
					cam.End3D2D()
				end

				for i, val in pairs(veh.letters) do
					cam.Start3D2D(v:LocalToWorld(val.pos),v:LocalToWorldAngles(val.ang), val.size )
						surface.SetDrawColor(255,255,255)
						draw.SimpleText( v.route_letter or "-" , veh.nums_font, 0, 0, veh.color, val.align, TEXT_ALIGN_CENTER)
					cam.End3D2D()
				end
				
				for i, val in pairs(veh.routes.first) do
					cam.Start3D2D(v:LocalToWorld(val.pos+Vector(0,0,val.size*45)),v:LocalToWorldAngles(val.ang), val.size )
						surface.SetDrawColor(255,255,255)
						draw.SimpleText( v.route1 or "Not in" , veh.routes_font, 0, 0, veh.color, val.align, TEXT_ALIGN_CENTER)
					cam.End3D2D()
				end

				for i, val in pairs(veh.routes.last) do
					cam.Start3D2D(v:LocalToWorld(val.pos+Vector(0,0,val.size*45)),v:LocalToWorldAngles(val.ang), val.size )
						surface.SetDrawColor(255,255,255)
						draw.SimpleText( v.route2 or "service" , veh.routes_font, 0, 0, veh.color, val.align, TEXT_ALIGN_CENTER)
					cam.End3D2D()
				end
			end
		end
		
--- Advanced Steering System
		
		if GetConVar("cl_simfphys_advanced_steering_enabled"):GetBool() then
			if v.ASS then
				local degree = GetConVar("cl_simfphys_advanced_steering_degree"):GetInt()
				local degree_cust = -v:GetVehicleSteer()*(degree - v.ASS.Degree)/2
				
				if !v.advanced_steering_degree then v.advanced_steering_degree = 0 end
				
				v.advanced_steering_degree = Lerp(1-GetConVar("cl_simfphys_advanced_steering_smoothness"):GetFloat(), v.advanced_steering_degree, degree_cust)
				
				v:ManipulateBoneAngles(v:LookupBone(v.ASS.Bone), Angle(v.advanced_steering_degree*v.ASS.Angle_P, v.advanced_steering_degree*v.ASS.Angle_Y, v.advanced_steering_degree*v.ASS.Angle_R))
			end
		end
		
--- Gearbox Sound System
		if GetConVar("cl_simfphys_gearbox_sound_system"):GetBool() then
			if v.GSS then
				if v:GetGear() != v.oldgear then
					v.oldgear = v:GetGear()
					v.gearfraction = 0
					if v.GSS.Shift_Sound != "" and v:GetGear() == 1 then
						--print("hrust")
						v:EmitSound(v.GSS.Shift_Sound, 80, 100, v:GetRPM() > 0 and 1 or 0)
					end
				else
					v.gearfraction = math.Clamp(v.gearfraction+0.005, 0, 1)
				end
				
				v.gearwhine_mult = Lerp(math.ease.OutBounce(v.gearfraction), 0.5, 1)
				
				v.gearwhine_vol = math.Clamp((v:GetRPM()-v.GSS.Vol_Start)/v.GSS.Vol_End, 0, v.GSS.Vol_Max)*math.Clamp(0.5+v:GetThrottle()*3, 0.5, 2)*(1-v:GetClutch())*(v:GetGear() == 1 and 2 or 1)
				
				if v:GetGear() > 1 then
					v.gearwhine_pitch = v:GetRPM()/10*v.GSS.Gears[v:GetGear()]*v.gearwhine_mult*v.GSS.Pitch_Mult
				else
					v.gearwhine_pitch = v:GetRPM()/5*(-v.GSS.Gears[v:GetGear()])*v.gearwhine_mult*v.GSS.Pitch_Mult
				end
				
				v.gearwhine_sound:PlayEx(v.gearwhine_vol, v.gearwhine_pitch)
			end
		end
	end
end )
local function IsPlayerBindKey( ply, key, cvar_name, default_key )
	if not IsValid(ply) then return false end

	local pressed_key = tonumber(key)
	if not pressed_key then return false end

	local bind_key = tonumber(ply:GetInfoNum(cvar_name, default_key))
	if not bind_key then
		bind_key = tonumber(default_key)
	end

	if not bind_key then return false end

	return pressed_key == bind_key
end

util.AddNetworkString("Simfphys_Change_Routes")
util.AddNetworkString("Simfphys_Routes_Menu")
util.AddNetworkString("Simfphys_Willi302_Shared_ON_OFF_Routes")
util.AddNetworkString("Simfphys_Routes_Client_Ready")

Willi302_BuildVehicleRecipients = Willi302_BuildVehicleRecipients or function( v, owner, include_pvs )
	local rf = RecipientFilter()
	
	if IsValid(owner) then
		rf:AddPlayer( owner )
	end
	
	if include_pvs and IsValid(v) then
		for _, watcher in ipairs(player.GetAll()) do
			if watcher != owner and watcher:TestPVS( v ) then
				rf:AddPlayer( watcher )
			end
		end
	end
	
	return rf
end

hook.Add("PlayerButtonDown", "Simfphys_Willi302_Routes_KEY_DOWN", function(ply, key) --- On/Off Routes Processing
	if IsPlayerBindKey( ply, key, "cl_simfphys_bus_routes_on", KEY_PAD_DECIMAL ) then
		if ply:GetSimfphys() != NULL then
			local v = ply:GetSimfphys()
			for m, veh in pairs(vehs_routes) do
				if v:GetModel() == veh.model then
					if v.route_state then
						v.route_state = ( v.route_state == 1 and 0 ) or 1
					else
						v.route_state = 1
					end
					
					local rf = Willi302_BuildVehicleRecipients( v, ply, true )
					
					net.Start("Simfphys_Willi302_Shared_ON_OFF_Routes")
						net.WriteEntity(v)
						net.WriteInt( v.route_state, 3 )
					net.Send(rf)
				end
			end
		end
	end
end)

local function ChangeRouteNum( v, str, actor )
	if not str then return end
	
	v.route_num = str
	
	local rf = Willi302_BuildVehicleRecipients( v, actor, true )
	
	net.Start("Simfphys_Change_Routes")
		net.WriteEntity(v)
		net.WriteInt( 0, 3 )
		net.WriteString( v.route_num )
	net.Send(rf)
end

local function ChangeRouteLetter( v, str, actor )
	if not str then return end
	
	v.route_letter = str
	
	local rf = Willi302_BuildVehicleRecipients( v, actor, true )
	
	net.Start("Simfphys_Change_Routes")
		net.WriteEntity(v)
		net.WriteInt( 1, 3 )
		net.WriteString( v.route_letter )
	net.Send(rf)
end

local function ChangeRoute1( v, str, actor )
	if not str then return end
	if str == "" then return end
	
	v.route1 = str
	
	local rf = Willi302_BuildVehicleRecipients( v, actor, true )
	
	net.Start("Simfphys_Change_Routes")
		net.WriteEntity(v)
		net.WriteInt( 2, 3 )
		net.WriteString( str )
	net.Send(rf)
end

local function ChangeRoute2( v, str, actor )
	if not str then return end
	
	if str == "" then return end
	
	v.route2 = str
	
	local rf = Willi302_BuildVehicleRecipients( v, actor, true )
	
	net.Start("Simfphys_Change_Routes")
		net.WriteEntity(v)
		net.WriteInt( 3, 3 )
		net.WriteString( str )
	net.Send(rf)
end

net.Receive( "Simfphys_Routes_Client_Ready", function( len, ply )
	for k, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
		for m, veh in pairs(vehs_routes) do
			if !v.route1 or !v.route2 or !v.route_num then return end
			
			local rf = Willi302_BuildVehicleRecipients( v, ply, true )
			
			net.Start("Simfphys_Willi302_Shared_ON_OFF_Routes")
				net.WriteEntity(v)
				net.WriteInt( v.route_state, 3 )
			net.Send( rf )
		
			net.Start("Simfphys_Change_Routes")
				net.WriteEntity(v)
				net.WriteInt( 0, 3 )
				net.WriteString( v.route_num )
			net.Send( rf )
			
			net.Start("Simfphys_Change_Routes")
				net.WriteEntity(v)
				net.WriteInt( 1, 3 )
				net.WriteString( v.route_letter )
			net.Send( rf )
			
			net.Start("Simfphys_Change_Routes")
				net.WriteEntity(v)
				net.WriteInt( 2, 3 )
				net.WriteString( v.route1 )
			net.Send( rf )
			
			net.Start("Simfphys_Change_Routes")
				net.WriteEntity(v)
				net.WriteInt( 3, 3 )
				net.WriteString( v.route2 )
			net.Send( rf )
		end
	end
end )

net.Receive( "Simfphys_Routes_Menu", function( len, ply )
	local v = net.ReadEntity()
	
	ChangeRouteNum( v, net.ReadString(), ply )
	ChangeRouteLetter( v, net.ReadString(), ply )
	ChangeRoute1( v, net.ReadString(), ply )
	ChangeRoute2( v, net.ReadString(), ply )
end )

util.AddNetworkString("Simfphys_Change_Routes")
util.AddNetworkString("Simfphys_Routes_Menu")
util.AddNetworkString("Simfphys_Willi302_Shared_ON_OFF_Routes")
util.AddNetworkString("Simfphys_Routes_Client_Ready")

hook.Add("PlayerButtonDown", "Simfphys_Willi302_Routes_KEY_DOWN", function(ply, key) --- On/Off Routes Processing
	if key == GetConVar( "cl_simfphys_bus_routes_on" ):GetInt() then
		if ply:GetSimfphys() != NULL then
			local v = ply:GetSimfphys()
			for m, veh in pairs(vehs_routes) do
				if v:GetModel() == veh.model then
					if v.route_state then
						v.route_state = ( v.route_state == 1 and 0 ) or 1
					else
						v.route_state = 1
					end
					
					local rf = RecipientFilter()
					rf:AddAllPlayers()
					
					net.Start("Simfphys_Willi302_Shared_ON_OFF_Routes")
						net.WriteEntity(v)
						net.WriteInt( v.route_state, 3 )
					net.Send(rf)
				end
			end
		end
	end
end)

local function ChangeRouteNum( v, str )
	if not str then return end
	
	v.route_num = str
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	
	net.Start("Simfphys_Change_Routes")
		net.WriteEntity(v)
		net.WriteInt( 0, 3 )
		net.WriteString( v.route_num )
	net.Send(rf)
end

local function ChangeRouteLetter( v, str )
	if not str then return end
	
	v.route_letter = str
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	local players = rf:GetPlayers()
	
	net.Start("Simfphys_Change_Routes")
		net.WriteEntity(v)
		net.WriteInt( 1, 3 )
		net.WriteString( v.route_letter )
	net.Send(rf)
end

local function ChangeRoute1( v, str )
	if not str then return end
	if str == "" then return end
	
	v.route1 = str
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	local players = rf:GetPlayers()
	
	net.Start("Simfphys_Change_Routes")
		net.WriteEntity(v)
		net.WriteInt( 2, 3 )
		net.WriteString( str )
	net.Send(rf)
end

local function ChangeRoute2( v, str )
	if not str then return end
	
	if str == "" then return end
	
	v.route2 = str
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	
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
			
			local rf = RecipientFilter()
			rf:AddAllPlayers()
			
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
	
	ChangeRouteNum( v, net.ReadString() )
	ChangeRouteLetter( v, net.ReadString() )
	ChangeRoute1( v, net.ReadString() )
	ChangeRoute2( v, net.ReadString() )
end )
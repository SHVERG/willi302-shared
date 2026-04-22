if SERVER then
	util.AddNetworkString("Simfphys_Change_Routes")
	util.AddNetworkString("Simfphys_Routes_Menu")
	util.AddNetworkString("Simfphys_Willi302_Shared_ON_OFF_Routes")
	util.AddNetworkString("Simfphys_Routes_Client_Ready")

	local function broadcast_route_state(v)
		local rf = RecipientFilter()
		rf:AddAllPlayers()

		net.Start("Simfphys_Willi302_Shared_ON_OFF_Routes")
			net.WriteEntity(v)
			net.WriteInt(v.route_state or 0, 3)
		net.Send(rf)
	end

	local function broadcast_route_value(v, route_type, value)
		local rf = RecipientFilter()
		rf:AddAllPlayers()

		net.Start("Simfphys_Change_Routes")
			net.WriteEntity(v)
			net.WriteInt(route_type, 3)
			net.WriteString(value)
		net.Send(rf)
	end

	local function ChangeRouteNum(v, str)
		if not str then return end
		v.route_num = str
		broadcast_route_value(v, 0, v.route_num)
	end

	local function ChangeRouteLetter(v, str)
		if not str then return end
		v.route_letter = str
		broadcast_route_value(v, 1, v.route_letter)
	end

	local function ChangeRoute1(v, str)
		if not str or str == "" then return end
		v.route1 = str
		broadcast_route_value(v, 2, str)
	end

	local function ChangeRoute2(v, str)
		if not str or str == "" then return end
		v.route2 = str
		broadcast_route_value(v, 3, str)
	end

	hook.Add("PlayerButtonDown", "Simfphys_Willi302_Routes_KEY_DOWN", function(ply, key)
		if key ~= GetConVar("cl_simfphys_bus_routes_on"):GetInt() then return end
		if ply:GetSimfphys() == NULL then return end

		local v = ply:GetSimfphys()
		if not HasCapability(v, "routes") then return end

		v.route_state = (v.route_state == 1 and 0) or 1
		broadcast_route_state(v)
	end)

	net.Receive("Simfphys_Routes_Client_Ready", function(_, _)
		for _, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
			if HasCapability(v, "routes") and v.route1 and v.route2 and v.route_num then
				broadcast_route_state(v)
			broadcast_route_value(v, 0, v.route_num)
			broadcast_route_value(v, 1, v.route_letter or "")
			broadcast_route_value(v, 2, v.route1)
				broadcast_route_value(v, 3, v.route2)
			end
		end
	end)

	net.Receive("Simfphys_Routes_Menu", function(_, _)
		local v = net.ReadEntity()
		if not IsValid(v) or not HasCapability(v, "routes") then return end

		ChangeRouteNum(v, net.ReadString())
		ChangeRouteLetter(v, net.ReadString())
		ChangeRoute1(v, net.ReadString())
		ChangeRoute2(v, net.ReadString())
	end)
end

if CLIENT then
	net.Receive("Simfphys_Willi302_Shared_ON_OFF_Routes", function()
		local v = net.ReadEntity()
		if not IsValid(v) then return end
		v.route_state = net.ReadInt(3)
	end)

	net.Receive("Simfphys_Change_Routes", function()
		local ent = net.ReadEntity()
		if not IsValid(ent) then return end

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

	local function draw_routes(v, route_capability)
		if v.route_state ~= 1 then return end

		for _, val in pairs(route_capability.nums or {}) do
			cam.Start3D2D(v:LocalToWorld(val.pos), v:LocalToWorldAngles(val.ang), val.size)
				surface.SetDrawColor(255, 255, 255)
				draw.SimpleText(v.route_num or "--", route_capability.nums_font, 0, 0, route_capability.color, val.align, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end

		for _, val in pairs(route_capability.letters or {}) do
			cam.Start3D2D(v:LocalToWorld(val.pos), v:LocalToWorldAngles(val.ang), val.size)
				surface.SetDrawColor(255, 255, 255)
				draw.SimpleText(v.route_letter or "-", route_capability.nums_font, 0, 0, route_capability.color, val.align, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end

		for _, val in pairs(route_capability.routes and route_capability.routes.first or {}) do
			cam.Start3D2D(v:LocalToWorld(val.pos + Vector(0, 0, val.size * 45)), v:LocalToWorldAngles(val.ang), val.size)
				surface.SetDrawColor(255, 255, 255)
				draw.SimpleText(v.route1 or "Not in", route_capability.routes_font, 0, 0, route_capability.color, val.align, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end

		for _, val in pairs(route_capability.routes and route_capability.routes.last or {}) do
			cam.Start3D2D(v:LocalToWorld(val.pos + Vector(0, 0, val.size * 45)), v:LocalToWorldAngles(val.ang), val.size)
				surface.SetDrawColor(255, 255, 255)
				draw.SimpleText(v.route2 or "service", route_capability.routes_font, 0, 0, route_capability.color, val.align, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end

	hook.Add("PostDrawTranslucentRenderables", "Simfphys_Willi302_Routes_Render", function()
		for _, v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
			local route_capability = GetCapability(v, "routes")
			if route_capability then
				draw_routes(v, route_capability)
			end
		end
	end)
end

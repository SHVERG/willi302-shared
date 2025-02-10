if SERVER then
	AddCSLuaFile("willi302/client/fonts.lua")
	AddCSLuaFile("willi302/client/functions.lua")
	AddCSLuaFile("willi302/client/menu.lua")
	AddCSLuaFile("willi302/vehs_routes.lua")
	AddCSLuaFile("willi302/vehs_steering.lua")
	
	include("willi302/server/routes.lua")
	include("willi302/server/doors.lua")
	include("willi302/server/advanced_steering_system.lua")
end
	
if CLIENT then
	include("willi302/client/fonts.lua")
	include("willi302/client/functions.lua")
	include("willi302/client/menu.lua")
end

include("willi302/vehs_routes.lua")
include("willi302/vehs_steering.lua")
if SERVER then
	include("willi302/server/routes.lua")
end
	
if CLIENT then
	AddCSLuaFile("willi302/client/functions")
	include("willi302/client/fonts.lua")
	include("willi302/client/functions.lua")
	include("willi302/client/menu.lua")
end

include("willi302/vehs_routes.lua")
include("willi302/vehs_steering.lua")

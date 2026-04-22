if SERVER then
	AddCSLuaFile("willi302/client/fonts.lua")
	AddCSLuaFile("willi302/client/menu.lua")
	AddCSLuaFile("willi302/features/ass.lua")
	AddCSLuaFile("willi302/features/doors.lua")
	AddCSLuaFile("willi302/features/gss.lua")
	AddCSLuaFile("willi302/features/routes.lua")
	AddCSLuaFile("willi302/features/smooth_subs.lua")
	AddCSLuaFile("willi302/shared/capabilities.lua")
	AddCSLuaFile("willi302/vehs_routes.lua")
	AddCSLuaFile("willi302/vehs_steering.lua")
end

if CLIENT then
	include("willi302/client/fonts.lua")
	include("willi302/client/menu.lua")
	include("willi302/features/smooth_subs.lua")
end

include("willi302/shared/capabilities.lua")
include("willi302/vehs_routes.lua")
include("willi302/vehs_steering.lua")

include("willi302/features/ass.lua")
include("willi302/features/doors.lua")
include("willi302/features/gss.lua")
include("willi302/features/routes.lua")

MigrateLegacyCapabilities()
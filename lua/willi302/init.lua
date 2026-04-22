if SERVER then
	AddCSLuaFile("willi302/client/fonts.lua")
	AddCSLuaFile("willi302/client/functions.lua")
	AddCSLuaFile("willi302/client/i18n/en.lua")
	AddCSLuaFile("willi302/client/i18n/ru.lua")
	AddCSLuaFile("willi302/client/menu.lua")
	AddCSLuaFile("willi302/shared/capabilities.lua")
	AddCSLuaFile("willi302/vehs_routes.lua")
	AddCSLuaFile("willi302/vehs_steering.lua")
	AddCSLuaFile("willi302/features/routes.lua")
	AddCSLuaFile("willi302/features/doors.lua")
	AddCSLuaFile("willi302/features/ass.lua")
	AddCSLuaFile("willi302/features/gss.lua")
end

include("willi302/shared/capabilities.lua")
include("willi302/vehs_routes.lua")
include("willi302/vehs_steering.lua")

MigrateLegacyCapabilities()

include("willi302/features/routes.lua")
include("willi302/features/doors.lua")
include("willi302/features/ass.lua")
include("willi302/features/gss.lua")

if CLIENT then
	include("willi302/client/fonts.lua")
	include("willi302/client/functions.lua")
	include("willi302/client/menu.lua")
end

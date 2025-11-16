util.AddNetworkString("Init_ASS")
util.AddNetworkString("Init_GSS")

hook.Add( "simfphysOnSpawn", "Simfphys_Willi302_Car_Spawned_SERVER", function( v )
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	
	if v.ASS then
		net.Start("Init_ASS")
			net.WriteEntity(v)
			net.WriteFloat(v.ASS.Degree)
			net.WriteString(v.ASS.Bone)
			net.WriteFloat(v.ASS.Angle_P)
			net.WriteFloat(v.ASS.Angle_Y)
			net.WriteFloat(v.ASS.Angle_R)
		net.Send(rf)
	end
	
	if v.GSS then
		net.Start("Init_GSS")
			net.WriteEntity(v)
			net.WriteString(v.GSS.Whine_Sound)
			net.WriteString(v.GSS.Shift_Sound or "")
			net.WriteFloat(v.GSS.Vol_Start)
			net.WriteFloat(v.GSS.Vol_End)
			net.WriteFloat(v.GSS.Vol_Max)
			net.WriteFloat(v.GSS.Pitch_Mult)
			net.WriteTable(v.Gears)
		net.Send(rf)
	end
end )